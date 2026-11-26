#!/usr/bin/env ruby

require "date"
require "pathname"
require "yaml"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
OUTPUT = ROOT.join("01_Index/Quellenmatrix.md")

SourceRecord = Struct.new(:path, :label, :fach_dir, :subject, :pages, :text_status, :topic_links, keyword_init: true)

class SourceNoteReader
  REFERENCE_HEADING = "## 🎯 Geprüfte und sinnvolle Referenzen"

  def read(path, root)
    text = File.read(path, encoding: "UTF-8")
    metadata = frontmatter(text)
    relative_path = Pathname.new(path).relative_path_from(root).to_s
    fach_dir = relative_path.split("/")[1]
    SourceRecord.new(
      path: relative_path.delete_suffix(".md"),
      label: File.basename(relative_path, ".md"),
      fach_dir: fach_dir,
      subject: metadata.fetch("fach_anzeige", metadata.fetch("fach", fach_dir)),
      pages: metadata.fetch("seiten", "?"),
      text_status: metadata.fetch("textstatus", "nicht angegeben"),
      topic_links: reference_links(text)
    )
  end

  private

  def frontmatter(text)
    parts = text.split(/^---\s*$\n?/, 3)
    raise "Frontmatter fehlt" unless parts.length == 3

    YAML.safe_load(parts[1], permitted_classes: [Date, Time], aliases: true) || {}
  end

  def reference_links(text)
    section = text.split(REFERENCE_HEADING, 2)[1]&.split(/^## /, 2)&.first.to_s
    section.lines.each_with_object([]) do |line, links|
      match = line.match(/^\| (\[\[.+?\]\]) \|/)
      links << match[1] if match
    end.uniq
  end
end

class SourceMatrixBuilder
  def initialize(root, reader: SourceNoteReader.new)
    @root = root
    @reader = reader
  end

  def build
    records = source_paths.map { |path| @reader.read(path, @root) }
    invalid_links = records.flat_map(&:topic_links).reject { |link| link.start_with?("[[03_Themen/Visuell_geprueft/") }
    raise "Nicht-kanonische Themenlinks in Quellen: #{invalid_links.join(', ')}" unless invalid_links.empty?

    excluded_count = records.count { |record| record.topic_links.empty? }
    rows = records.sort_by { |record| [record.subject, record.label] }.map { |record| row(record) }.join("\n")
    subject_docs = build_subject_indexes(records)
    [records.length, document(rows, records.length, excluded_count), subject_docs]
  end

  private

  def build_subject_indexes(records)
    audit_date = VaultSupport.latest_audit_date
    records.group_by(&:fach_dir).sort.to_h do |fach_dir, list|
      subject_title = list.first.subject
      sorted = list.sort_by(&:label)
      rows = sorted.map do |rec|
        topics = rec.topic_links.empty? ? "_keine Zuordnung (ausgeschlossen)_" : rec.topic_links.join(", ")
        "| [[#{rec.path}\\|#{rec.label}]] | #{rec.pages} | #{rec.text_status} | #{topics} |"
      end.join("\n")
      out_path = @root.join("02_Faecher", fach_dir, "#{fach_dir}.md")
      doc = <<~MARKDOWN
        ---
        typ: fach_index
        fach: "#{fach_dir}"
        status: "visuell_geprueft"
        stand: #{audit_date}
        rag_include: false
        ---
        # #{subject_title}

        > [!info] Fachübersicht
        > Automatisch erzeugte Übersicht der seitenweise visuell geprüften Quellnotizen dieses Fachs und ihrer kanonischen Themen unter `03_Themen/Visuell_geprueft/`.

        ## Quellen (#{sorted.length})

        | Quelle | Seiten | Status | Kanonische Themen |
        |---|---:|---|---|
        #{rows}
      MARKDOWN
      [out_path, doc]
    end
  end

  def source_paths
    Dir.glob(@root.join("02_Faecher/*/Quellen/*.md").to_s)
  end

  def row(record)
    topics = record.topic_links.empty? ? "_keine Zuordnung_" : record.topic_links.join(", ")
    "| [[#{record.path}\\|#{record.label}]] | #{record.subject} | #{record.pages} | #{record.text_status} | #{topics} |"
  end

  def document(rows, total_count, excluded_count)
    audit_date = VaultSupport.latest_audit_date
    <<~MARKDOWN
      ---
      id: vault.index.quellenmatrix
      typ: quellenmatrix
      status: generiert_aus_aktiven_quellnotizen
      stand: #{audit_date}
      reviewed_on: #{audit_date}
      rag_include: false
      tags:
        - index
        - quellen
        - qualitaetssicherung
      ---

      # Quellenmatrix

      Diese Matrix wird direkt aus den **#{total_count} seitenweise auditierten Quellnotizen** und ihren korrigierten Referenztabellen erzeugt. Jeder Themenlink muss auf `03_Themen/Visuell_geprueft/` zeigen; der Generator bricht bei alten Lernordner- oder Legacy-Themenlinks ab. #{excluded_count} technisch ausgeschlossene Quellnotiz(en) besitzen bewusst keine Themenzuordnung.

      - Generator: `ruby 01_Index/Tools/build_quellenmatrix.rb`
      - Stand: **#{audit_date}**
      - Fachlicher Beleg: Quellnotiz und konkrete PDF-Seite; die Themenseite dient nur der Einordnung.

      | Quelle | Fach | Seiten | Textstatus | Referenzierte Themen |
      |---|---|---:|---|---|
      #{rows}
    MARKDOWN
  end
end

count, content, subject_docs = SourceMatrixBuilder.new(ROOT).build
VaultSupport.write_if_changed(OUTPUT, content)
subject_docs.each { |path, doc| VaultSupport.write_if_changed(path, doc) }
puts "Wrote #{OUTPUT.relative_path_from(ROOT)} (#{count} source notes) and #{subject_docs.length} subject indexes."
