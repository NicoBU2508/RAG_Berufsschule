#!/usr/bin/env ruby

require "digest"
require "json"
require "pathname"
require "uri"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
MAPPING_PATH = VaultSupport::MAPPING_PATH
COPILOT_PATH = ROOT.join(".obsidian/plugins/copilot/data.json")
OUTPUT_PATH = ROOT.join("01_Index/Copilot_Allowlist.json")
ENTRYPOINTS = [
  "00_KI_QUELLENSTART",
  "00_START",
  "03_Themen/00_Kuratierte_Themen"
].freeze
EXTRA_EXCLUSIONS = [
  "98_Archiv_nicht_lernen",
  "99_Originale",
  "00_Posteingang_GoodNotes",
  "04_Pruefung",
  "05_Karteikarten",
  "06_Altklausuren",
  ".agents",
  "IT_Sicherheit_Aufgabe_1_1.md",
  "IT_Sicherheit_Lernziele.md",
  "Stol_02_Unternehmenswiki_4_Block.md",
  "Stol_02_Unternehmenswiki_5_Block.md",
  "Stol_Wiki.md"
].freeze
OBSOLETE_EXCLUSIONS = [
  "03_Themen/Weiterleitungen",
  "03_Themen/Allgemein",
  "03_Themen/Anwendungsentwicklung",
  "03_Themen/Deutsch_Englisch_Kommunikation",
  "03_Themen/Elektrotechnik",
  "03_Themen/IT_Technik_und_Sicherheit",
  "03_Themen/Wirtschaft_und_Recht",
  "05_Templates",
  "07_Lernordner",
  "10_Lernordner"
].freeze
BASELINE_MINIMUM_FILES = 134

mapping = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
topic_paths = mapping.fetch("topics").values.map { |topic| topic.fetch("path").delete_suffix(".md") }
source_paths = mapping.fetch("sources").each_with_object([]) do |(path, source), selected|
  selected << path.delete_suffix(".md") if source.fetch("canonical_pages").positive?
end

paths = ENTRYPOINTS + topic_paths.sort + source_paths.sort
expected_count = ENTRYPOINTS.length + topic_paths.length + source_paths.length
raise "Allowlist enthält doppelte Pfade" unless paths.uniq.length == paths.length
raise "Allowlist-Anzahl inkonsistent: #{paths.length} != #{expected_count}" unless paths.length == expected_count
raise "Sicherheitsgrenze unterschritten: mindestens #{BASELINE_MINIMUM_FILES} Dateien erwartet, gefunden: #{paths.length}" if paths.length < BASELINE_MINIMUM_FILES
raise "Komma im Pfad ist mit dem Copilot-Listenformat nicht sicher" if paths.any? { |path| path.include?(",") }

missing = paths.reject { |path| ROOT.join("#{path}.md").file? }
raise "Allowlist-Ziele fehlen: #{missing.join(', ')}" unless missing.empty?

entries = paths.map { |path| "[[#{path}]]" }
new_inclusions = entries.join(", ")

copilot_raw = File.read(COPILOT_PATH, encoding: "UTF-8")
copilot = JSON.parse(copilot_raw)
copilot_changed = false

if copilot["qaInclusions"] != new_inclusions
  copilot["qaInclusions"] = new_inclusions
  copilot_changed = true
end

current_exclusions = copilot.fetch("qaExclusions", "").split(",").map(&:strip).reject(&:empty?)
filtered = current_exclusions.reject { |item| OBSOLETE_EXCLUSIONS.include?(URI.decode_www_form_component(item)) }
if filtered.length != current_exclusions.length
  current_exclusions = filtered
  copilot_changed = true
end
decoded_exclusions = current_exclusions.map { |item| URI.decode_www_form_component(item) }
EXTRA_EXCLUSIONS.each do |extra|
  next if decoded_exclusions.include?(extra)

  current_exclusions << extra
  decoded_exclusions << extra
  copilot_changed = true
end
if copilot_changed
  copilot["qaExclusions"] = current_exclusions.join(",")
  File.write(COPILOT_PATH, JSON.pretty_generate(copilot) + "\n")
end

audit = {
  "schema_version" => 1,
  "generated_on" => VaultSupport.latest_audit_date,
  "policy" => "exact_file_allowlist_fail_closed",
  "entries" => entries,
  "count" => entries.length,
  "sha256" => Digest::SHA256.hexdigest(entries.join("\n"))
}
VaultSupport.write_json_if_changed(OUTPUT_PATH, audit)

puts "Wrote exact Copilot allowlist with #{entries.length} verified Markdown files (#{topic_paths.length} topics, #{source_paths.length} sources)."
