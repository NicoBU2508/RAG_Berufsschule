#!/usr/bin/env ruby

require "digest"
require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("../..").cleanpath.realpath
MAPPING_PATH = ROOT.join("01_Index/Themenreferenzen_Visuell_Geprueft.json")
COPILOT_PATH = ROOT.join(".obsidian/plugins/copilot/data.json")
OUTPUT_PATH = ROOT.join("01_Index/Copilot_Allowlist.json")
ENTRYPOINTS = [
  "00_KI_QUELLENSTART",
  "00_START",
  "03_Themen/00_Kuratierte_Themen"
].freeze

mapping = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
topic_paths = mapping.fetch("topics").values.map { |topic| topic.fetch("path").delete_suffix(".md") }
source_paths = mapping.fetch("sources").each_with_object([]) do |(path, source), selected|
  selected << path.delete_suffix(".md") if source.fetch("canonical_pages").positive?
end

paths = ENTRYPOINTS + topic_paths.sort + source_paths.sort
raise "Allowlist enthält doppelte Pfade" unless paths.uniq.length == paths.length
raise "Erwartet wurden 134 freigegebene Dateien, gefunden: #{paths.length}" unless paths.length == 134
raise "Komma im Pfad ist mit dem Copilot-Listenformat nicht sicher" if paths.any? { |path| path.include?(",") }

missing = paths.reject { |path| ROOT.join("#{path}.md").file? }
raise "Allowlist-Ziele fehlen: #{missing.join(', ')}" unless missing.empty?

entries = paths.map { |path| "[[#{path}]]" }
copilot = JSON.parse(File.read(COPILOT_PATH, encoding: "UTF-8"))
copilot["qaInclusions"] = entries.join(", ")
File.write(COPILOT_PATH, JSON.pretty_generate(copilot) + "\n")

audit = {
  "schema_version" => 1,
  "generated_on" => "2026-07-13",
  "policy" => "exact_file_allowlist_fail_closed",
  "entries" => entries,
  "count" => entries.length,
  "sha256" => Digest::SHA256.hexdigest(entries.join("\n"))
}
File.write(OUTPUT_PATH, JSON.pretty_generate(audit) + "\n")

puts "Wrote exact Copilot allowlist with #{entries.length} verified Markdown files."
