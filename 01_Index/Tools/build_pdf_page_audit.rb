#!/usr/bin/env ruby

require "date"
require "json"
require "pathname"
require "yaml"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
OUTPUT = ROOT.join("01_Index/PDF_Seitenaudit_Worklist.json")
PRIVATE_PREFIX = VaultSupport::PRIVATE_PREFIX

class MarkdownMetadata
  def self.read(text)
    parts = text.split(/^---\s*$\n?/, 3)
    return {} unless parts.length == 3

    YAML.safe_load(parts[1], permitted_classes: [Date, Time], aliases: true) || {}
  end
end

class PageLinkExtractor
  PDF_PAGE = %r{99_Originale/[^>\]\n`]+?\.pdf#page=(\d+)}

  def extract(text)
    links = []
    text.to_enum(:scan, PDF_PAGE).each do
      match = Regexp.last_match
      matched = match[0]
      page = match[1].to_i
      pdf_path = matched.sub(/#page=\d+\z/, "")
      links << [pdf_path, page]
    end
    links.uniq
  end
end

class SourcePageExtractor
  PAGE_HEADING = /^### Seite (\d+)\s*$/

  def extract(text)
    headings = []
    text.to_enum(:scan, PAGE_HEADING).each do
      match = Regexp.last_match
      headings << [match[1].to_i, match.begin(0), match.end(0)]
    end

    headings.each_with_index.map do |(page, _start, body_start), index|
      next_page_start = headings[index + 1]&.[](1) || text.length
      next_level_two = text.index(/^## [^#]/, body_start) || text.length
      body_end = [next_page_start, next_level_two].min
      section = text[body_start...body_end]
      blocks = section.scan(/```(?:text)?\s*\n(.*?)```/m).flatten
      extracted = blocks.join("\n").strip
      extracted = compact_fallback(section) if extracted.empty?
      {
        "page" => page,
        "source_section_chars" => section.length,
        "source_text" => extracted,
        "source_text_status" => status(section, extracted)
      }
    end
  end

  private

  def compact_fallback(section)
    section.lines
      .reject { |line| line.start_with?("> [!", "> ![[", "![[") }
      .map(&:strip)
      .reject(&:empty?)
      .join(" ")
  end

  def status(section, extracted)
    return "missing" if section.include?("Kein verwertbarer Text") && extracted.length < 80
    return "ocr" if section.match?(/OCRplus|OCR-Text|\[!ocr\]/i)
    return "weak" if extracted.length < 80

    "text"
  end
end

class ReferenceIndex
  def initialize(root, link_extractor: PageLinkExtractor.new)
    @root = root
    @link_extractor = link_extractor
  end

  def learning_modules
    build(
      Dir.glob(@root.join("02_Faecher/*/10_Lernordner/*/*.md").to_s),
      role: "module",
      title_key: "thema"
    )
  end

  def curated_topics
    paths = Dir.glob(@root.join("03_Themen/**/*.md").to_s)
      .reject { |path| path.include?("/Weiterleitungen/") || path.include?("/Visuell_geprueft/") }
      .reject { |path| File.basename(path) == "00_Kuratierte_Themen.md" }
    build(paths, role: "topic", title_key: "thema")
  end

  private

  def build(paths, role:, title_key:)
    index = Hash.new { |hash, key| hash[key] = [] }
    paths.sort.each do |absolute_path|
      text = File.read(absolute_path, encoding: "UTF-8")
      metadata = MarkdownMetadata.read(text)
      relative_path = Pathname.new(absolute_path).relative_path_from(@root).to_s
      title = metadata[title_key] || File.basename(relative_path, ".md")
      reference = { "title" => title, "path" => relative_path, "role" => role }
      @link_extractor.extract(text).each do |pdf_path, page|
        index[[pdf_path, page]] << reference unless index[[pdf_path, page]].include?(reference)
      end
    end
    index
  end
end

class AuditWorklistBuilder
  def initialize(root, page_extractor: SourcePageExtractor.new, reference_index: ReferenceIndex.new(root))
    @root = root
    @page_extractor = page_extractor
    @reference_index = reference_index
  end

  def build
    modules = @reference_index.learning_modules
    topics = @reference_index.curated_topics
    pages = source_paths.flat_map { |path| source_records(path, modules, topics) }
    {
      "schema_version" => 1,
      "scope" => "Alle aktiven, nichtprivaten Quell-PDFs; private Inhalte werden nicht gelesen.",
      "totals" => {
        "source_notes" => source_paths.length,
        "pages" => pages.length,
        "pages_with_modules" => pages.count { |page| !page["current_modules"].empty? },
        "pages_with_curated_topics" => pages.count { |page| !page["current_curated_topics"].empty? }
      },
      "audit_schema" => {
        "visual_checked" => "true erst nach Sichtprüfung der Originalseite",
        "primary_topic" => "genau ein kanonisches Hauptthema oder fragment/leer",
        "secondary_topics" => "nur direkt belegte Nebenthemen",
        "content_type" => "theorie|aufgabe|loesung|beispiel|formular|index|fragment|leer",
        "source_text_match" => "ok|partial|wrong_page|missing|ocr_error",
        "mapping_status" => "correct|overbroad|missing|mixed",
        "confidence" => "high|medium|low"
      },
      "pages" => pages
    }
  end

  private

  def source_paths
    @source_paths ||= Dir.glob(@root.join("02_Faecher/*/Quellen/*.md").to_s).sort
  end

  def source_records(absolute_path, modules, topics)
    text = File.read(absolute_path, encoding: "UTF-8")
    metadata = MarkdownMetadata.read(text)
    source_note = Pathname.new(absolute_path).relative_path_from(@root).to_s
    pdf_path = metadata.fetch("original_pfad")
    raise "private source in active catalog: #{pdf_path}" if pdf_path.start_with?(PRIVATE_PREFIX)

    @page_extractor.extract(text).map do |page_record|
      page = page_record.fetch("page")
      page_record.merge(
        "id" => "#{source_note.delete_suffix('.md')}#page=#{page}",
        "subject" => metadata["fach"],
        "source_note" => source_note,
        "pdf_path" => pdf_path,
        "current_modules" => modules[[pdf_path, page]],
        "current_curated_topics" => topics[[pdf_path, page]],
        "audit" => {
          "visual_checked" => false,
          "primary_topic" => nil,
          "secondary_topics" => [],
          "content_type" => nil,
          "source_text_match" => nil,
          "mapping_status" => nil,
          "recommended_modules" => [],
          "issues" => [],
          "confidence" => nil
        }
      )
    end
  end
end

worklist = AuditWorklistBuilder.new(ROOT).build
VaultSupport.write_json_if_changed(OUTPUT, worklist)
puts "Wrote #{OUTPUT.relative_path_from(ROOT)} (#{worklist.dig('totals', 'pages')} pages)."
