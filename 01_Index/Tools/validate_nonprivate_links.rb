#!/usr/bin/env ruby

require "json"
require "pathname"
require "uri"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
PRIVATE_PREFIX = VaultSupport::PRIVATE_PREFIX
OUTPUT = ROOT.join("01_Index/Linkvalidierung_Nichtprivat.json")
IGNORED_PREFIXES = [
  PRIVATE_PREFIX,
  ".git/",
  "Obsidian_Berufsschule/",
  ".import_review/"
].freeze

class FileIndex
  def initialize(paths)
    @exact = {}
    @basenames = Hash.new { |hash, key| hash[key] = [] }
    paths.each do |path|
      normalized = normalize(path)
      @exact[normalized] = true
      @basenames[normalize(File.basename(path, File.extname(path)))] << normalized
      @basenames[normalize(File.basename(path))] << normalized
    end
  end

  def resolve?(target, source_path, wiki: false)
    cleaned = clean(target)
    return true if cleaned.empty? || cleaned.start_with?("#", "^")

    candidates = [cleaned]
    candidates << "#{cleaned}.md" if File.extname(cleaned).empty?
    candidates << "#{cleaned}.pdf" if File.extname(cleaned).empty?
    source_dir = File.dirname(source_path)
    relative_candidates = candidates.map { |candidate| File.join(source_dir, candidate) }
    return true if (candidates + relative_candidates).any? { |candidate| @exact[normalize_path(candidate)] }

    return false unless wiki
    basename = File.basename(cleaned)
    !@basenames[normalize(basename)].empty? || !@basenames[normalize(File.basename(basename, File.extname(basename)))].empty?
  end

  private

  def clean(target)
    value = target.to_s.strip
    value = value[1...-1] if value.start_with?("<") && value.end_with?(">")
    value = URI.decode_www_form_component(value)
    value = value.split("\\|", 2).first.to_s
    value = value.split("|", 2).first.to_s
    value = value.split("#", 2).first.to_s
    value = value.split("^", 2).first.to_s
    value.sub(%r{\A\./}, "")
  rescue ArgumentError
    target.to_s.strip
  end

  def normalize_path(path)
    Pathname.new(path).cleanpath.to_s.sub(%r{\A\./}, "").unicode_normalize(:nfc)
  end

  def normalize(value)
    value.to_s.unicode_normalize(:nfc)
  end
end

all_paths = Dir.chdir(ROOT) do
  Dir.glob("**/*", File::FNM_DOTMATCH)
    .select { |path| File.file?(path) }
    .reject { |path| IGNORED_PREFIXES.any? { |prefix| path.start_with?(prefix) } || File.basename(path) == ".DS_Store" }
end
index = FileIndex.new(all_paths)
markdown_paths = all_paths.select { |path| File.extname(path).downcase == ".md" }
unresolved = []
counts = Hash.new(0)

markdown_paths.each do |path|
  text = File.read(ROOT.join(path), encoding: "UTF-8")
  searchable = text.gsub(/^```.*?^```\s*$/m, "").gsub(/`[^`\n]+`/, "")
  searchable.scan(/!?\[\[([^\]]+)\]\]/).each do |match|
    target = match.first
    counts["wiki_links"] += 1
    unresolved << { "source" => path, "kind" => "wiki", "target" => target } unless index.resolve?(target, path, wiki: true)
  end
  searchable.scan(/(?<!!)\[[^\]]*\]\((<[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)/).each do |match|
    target = match.first
    plain = target.start_with?("<") ? target[1...-1] : target
    next if plain.match?(%r{\A(?:https?://|mailto:|tel:|data:|file://)}) || plain.start_with?("#")
    counts["markdown_links"] += 1
    unresolved << { "source" => path, "kind" => "markdown", "target" => target } unless index.resolve?(target, path)
  end
end

report = {
  "schema_version" => 1,
  "validated_on" => VaultSupport.latest_audit_date,
  "scope" => "Alle nicht-privaten Markdown-Dateien; private Pfade wurden weder geöffnet noch gelesen",
  "markdown_files" => markdown_paths.length,
  "wiki_links" => counts["wiki_links"],
  "local_markdown_links" => counts["markdown_links"],
  "unresolved" => unresolved.length,
  "failures" => unresolved
}
VaultSupport.write_json_if_changed(OUTPUT, report)

if unresolved.empty?
  puts "PASS: #{markdown_paths.length} nicht-private Markdown-Dateien, #{counts['wiki_links']} Wiki- und #{counts['markdown_links']} lokale Markdown-Links auflösbar."
else
  warn "FAIL: #{unresolved.length} nicht auflösbare Links; Details in #{OUTPUT.relative_path_from(ROOT)}"
  exit 1
end
