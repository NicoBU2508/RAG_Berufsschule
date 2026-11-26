#!/usr/bin/env ruby

require "json"
require "pathname"
require "uri"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
AUDIT_PATH = VaultSupport::AUDIT_PATH
MAPPING_PATH = VaultSupport::MAPPING_PATH
INVENTORY_PATH = ROOT.join("01_Index/KI_Dateiinventar.json")
COPILOT_PATH = ROOT.join(".obsidian/plugins/copilot/data.json")
OUTPUT_PATH = ROOT.join("01_Index/Abschlussvalidierung_Visuelle_Quellen.json")
LINK_REPORT_PATH = ROOT.join("01_Index/Linkvalidierung_Nichtprivat.json")
ALLOWLIST_AUDIT_PATH = ROOT.join("01_Index/Copilot_Allowlist.json")

class Validation
  attr_reader :checks, :errors

  def initialize
    @checks = []
    @errors = []
  end

  def assert(name, condition, details = nil)
    if condition
      @checks << { "name" => name, "status" => "pass", "details" => details }.compact
    else
      @errors << { "name" => name, "status" => "fail", "details" => details }.compact
    end
  end

  def finish!
    output = {
      "schema_version" => 1,
      "validated_on" => VaultSupport.latest_audit_date,
      "status" => errors.empty? ? "pass" : "fail",
      "checks_passed" => checks.length,
      "checks_failed" => errors.length,
      "checks" => checks + errors
    }
    VaultSupport.write_json_if_changed(OUTPUT_PATH, output)
    return if errors.empty?

    warn errors.map { |error| "FAIL #{error['name']}: #{error['details']}" }.join("\n")
    exit 1
  end
end

class SourceTableParser
  def parse(text)
    section = text.split("## 🎯 Geprüfte und sinnvolle Referenzen", 2)[1]&.split(/^## /, 2)&.first.to_s
    rows = {}
    section.each_line do |line|
      match = line.match(/^\| \[\[(03_Themen\/Visuell_geprueft\/.*?)\\\|(.*?)\]\] \| .*? \| ([^|]+?) \|/)
      next unless match
      rows[match[2]] = expand_ranges(match[3].strip)
    end
    [section, rows]
  end

  private

  def expand_ranges(value)
    value.split(",").flat_map do |part|
      bounds = part.strip.split(/[–-]/).map(&:to_i)
      bounds.length == 2 ? (bounds[0]..bounds[1]).to_a : bounds
    end.sort
  end
end

class SourcePageReader
  def body(text, number)
    match = text.match(/^### Seite #{number}\s*$\n(.*?)(?=^### Seite \d+\s*$|^## [^#]|\z)/m)
    match && match[1]
  end
end

def copilot_has_active_system_prompt?(copilot)
  return true unless copilot["userSystemPrompt"].to_s.strip.empty?

  Dir.glob(ROOT.join("copilot/system-prompts/*.md").to_s).any? do |path|
    text = File.read(path, encoding: "UTF-8")
    body = text.sub(/\A---\s*\n.*?\n---\s*\n/m, "").strip
    !body.empty?
  end
end

audit = JSON.parse(File.read(AUDIT_PATH, encoding: "UTF-8"))
mapping = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
inventory = JSON.parse(File.read(INVENTORY_PATH, encoding: "UTF-8"))
copilot = JSON.parse(File.read(COPILOT_PATH, encoding: "UTF-8"))
validation = Validation.new

audit_pages = audit.fetch("pages")
mapping_pages = mapping.fetch("pages")
totals = mapping.fetch("totals")
audit_totals = audit.fetch("totals")

all_original_pdfs = Dir.glob(ROOT.join("99_Originale/**/*.pdf").to_s).length
all_source_notes = Dir.glob(ROOT.join("02_Faecher/*/Quellen/*.md").to_s).sort
private_pdfs = Dir.glob(ROOT.join(VaultSupport::PRIVATE_PREFIX, "**/*.pdf").to_s).length

expected_active_pdfs = audit_totals.fetch("active_pdfs")
expected_active_pages = audit_totals.fetch("active_pages")
expected_dup_pdfs = audit_totals.fetch("visually_identical_duplicate_pdfs")
expected_dup_pages = audit_totals.fetch("visually_identical_duplicate_pages")
expected_nonprivate_pdfs = expected_active_pdfs + expected_dup_pdfs
expected_nonprivate_pages = expected_active_pages + expected_dup_pages

duplicate_proof = JSON.parse(File.read(ROOT.join("01_Index/Auditdaten/PDF_Duplikatnachweis.json"), encoding: "UTF-8"))
proven_removed_dups = duplicate_proof.fetch("pairs", [])
dups_still_on_disk = proven_removed_dups.select { |pair| ROOT.join(pair.fetch("duplicate_pdf")).file? }

validation.assert("alle nicht-privaten Original-PDFs erfasst", audit_totals.fetch("nonprivate_pdfs_accounted_for") == all_original_pdfs && all_original_pdfs == expected_nonprivate_pdfs, "Disk: #{all_original_pdfs}; Audit: #{audit_totals['nonprivate_pdfs_accounted_for']}")
validation.assert("nicht-private Seitenbilanz konsistent", audit_totals.fetch("nonprivate_pages_accounted_for") == expected_nonprivate_pages && expected_nonprivate_pages >= 805)
validation.assert("alle aktiven Quellnotizen auditiert", expected_active_pdfs == all_source_notes.length && expected_active_pdfs >= 33, "Disk: #{all_source_notes.length}; Audit: #{expected_active_pdfs}")
validation.assert("alle aktiven Seiten visuell geprüft", audit_pages.length == expected_active_pages && expected_active_pages >= 805 && audit_pages.all? { |page| page.dig("audit", "visual_checked") == true })
validation.assert("jede aktive Audit-Seite eindeutig", audit_pages.map { |page| page.fetch("id") }.uniq.length == audit_pages.length)
validation.assert("PDF-Dubletten verifiziert bereinigt", proven_removed_dups.length >= 3 && dups_still_on_disk.empty? && totals.fetch("proven_duplicate_pdfs") == expected_dup_pdfs)
validation.assert("Dublettenseiten-Nachweis konsistent", duplicate_proof.dig("totals", "proven_removed_duplicate_pages").to_i >= 97 && totals.fetch("proven_duplicate_pages") == expected_dup_pages)
validation.assert("private PDF ungelesen", audit_totals.fetch("private_pdfs_unread") == private_pdfs)

status_counts = mapping_pages.each_with_object(Hash.new(0)) { |page, counts| counts[page.fetch("status")] += 1 }
validation.assert("kanonische Seitenbilanz konsistent", mapping_pages.length == expected_active_pages && status_counts.values.sum == expected_active_pages, status_counts.inspect)
validation.assert("Evidenzseiten gezählt", status_counts["evidence"] == totals.fetch("canonical_evidence_pages") && status_counts["evidence"] >= 713, status_counts.inspect)
validation.assert("Support-Seiten gezählt", status_counts["support_only"] == totals.fetch("support_only_pages") && status_counts["support_only"] >= 3, status_counts.inspect)
validation.assert("ausgeschlossene Seiten gezählt", status_counts["excluded"] == totals.fetch("excluded_active_pages"), status_counts.inspect)
validation.assert("Ausschlüsse tragen keine Themen", mapping_pages.select { |page| page["status"] == "excluded" }.all? { |page| page.fetch("canonical_topics").empty? })
validation.assert("jede zugelassene Seite hat Thema", mapping_pages.reject { |page| page["status"] == "excluded" }.all? { |page| !page.fetch("canonical_topics").empty? })
validation.assert("Audit und Mapping deckungsgleich", audit_pages.map { |page| page.fetch("id") }.sort == mapping_pages.map { |page| page.fetch("id") }.sort)

topic_count = mapping.fetch("topics").length
validation.assert("kanonische Themen vorhanden", topic_count == totals.fetch("canonical_topics") && topic_count >= 101, "Themen: #{topic_count}")
validation.assert("OCR-Korrekturen registriert", mapping_pages.count { |page| page["source_text_status"] == "ocr_verified" } >= 3)
validation.assert("sensible Seiten abstrahiert", mapping_pages.count { |page| page["source_text_status"] == "redacted_summary" } >= 7)

wittmann_prefix = "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page="
risk_wittmann = mapping.dig("topics", "Risikoanalyse", "pages").grep(/^#{Regexp.escape(wittmann_prefix)}/)
protection_wittmann = mapping.dig("topics", "Schutzbedarfsfeststellung", "pages").grep(/^#{Regexp.escape(wittmann_prefix)}/)
validation.assert("Risikoanalyse nur Wittmann S.48–57", risk_wittmann == (48..57).map { |page| "#{wittmann_prefix}#{page}" }, risk_wittmann.inspect)
validation.assert("Schutzbedarf enthält Wittmann S.17–23", ((17..23).map { |page| "#{wittmann_prefix}#{page}" } - protection_wittmann).empty?, protection_wittmann.inspect)

topic_paths = mapping.fetch("topics").values.map { |topic| topic.fetch("path") }
existing_topic_paths = Dir.glob(ROOT.join("03_Themen/Visuell_geprueft/**/*.md").to_s).map { |path| Pathname.new(path).relative_path_from(ROOT).to_s }.sort
validation.assert("alle und nur kanonische Themendateien vorhanden", topic_paths.sort == existing_topic_paths, "Mapping: #{topic_paths.length}; Disk: #{existing_topic_paths.length}")
validation.assert("alle Themendateien visuell markiert", existing_topic_paths.all? { |path| File.read(ROOT.join(path), encoding: "UTF-8").include?("status: visuell_geprueft") })
index_text = File.read(ROOT.join("03_Themen/00_Kuratierte_Themen.md"), encoding: "UTF-8")
validation.assert("Themenindex enthält alle kanonischen Ziele", index_text.scan(/\[\[03_Themen\/Visuell_geprueft\//).length == topic_count)

mapping_by_id = mapping_pages.to_h { |page| [page.fetch("id"), page] }
table_parser = SourceTableParser.new
page_reader = SourcePageReader.new
source_groups = audit_pages.group_by { |page| page.fetch("source_note") }
source_errors = []

source_groups.each do |source_note, pages|
  text = File.read(ROOT.join(source_note), encoding: "UTF-8")
  expected_numbers = (1..pages.length).to_a
  headings = text.scan(/^### Seite (\d+)\s*$/).flatten.map(&:to_i).sort
  source_errors << "#{source_note}: Seitenanker" unless headings == expected_numbers
  source_errors << "#{source_note}: Audit-Metadaten" unless text.include?("seitenaudit: \"visuell_vollstaendig\"")
  section, table_rows = table_parser.parse(text)
  source_errors << "#{source_note}: alter Lernordnerlink" if section.include?("/10_Lernordner/")
  source_errors << "#{source_note}: Legacy-Themenlink" if section.match?(/\[\[03_Themen\/(?!Visuell_geprueft\/)/)

  expected_rows = Hash.new { |hash, key| hash[key] = [] }
  pages.each do |page|
    mapped = mapping_by_id.fetch(page.fetch("id"))
    mapped.fetch("canonical_topics").each { |topic| expected_rows[topic] << page.fetch("page") }
    body = page_reader.body(text, page.fetch("page"))
    source_errors << "#{source_note}: fehlender Body S.#{page.fetch('page')}" unless body
    next unless body
    if mapped.fetch("status") == "excluded"
      source_errors << "#{source_note}: Embed auf Ausschluss S.#{page.fetch('page')}" if body.include?("![[")
    else
      source_errors << "#{source_note}: PDF-Link S.#{page.fetch('page')}" unless body.include?("#page=#{page.fetch('page')}")
    end
  end
  normalized_expected = expected_rows.transform_values { |numbers| numbers.uniq.sort }
  source_errors << "#{source_note}: Referenztabelle weicht vom Mapping ab" unless table_rows == normalized_expected
end
validation.assert("alle Quellen vollständig und exakt umgebaut", source_groups.length == all_source_notes.length && source_errors.empty?, source_errors.first(20).join("; "))

ocr_files = {
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824.md" => 4,
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_AEuP_Stol.md" => 3
}
ocr_ok = ocr_files.all? do |path, page|
  text = File.read(ROOT.join(path), encoding: "UTF-8")
  !text.include?("## 🔎 OCR-Nachtrag") && text.include?("ocr_nachtrag_integriert_seiten: [#{page}]") && text.include?("Verifizierter OCR-Nachtrag für Suche")
end
validation.assert("AE-OCR-Anhänge lokal integriert", ocr_ok)
bgwp_ocr = File.read(ROOT.join("02_Faecher/BGWP_Betriebswirtschaft/Quellen/ZusammenfassungBGWP.md"), encoding: "UTF-8")
validation.assert(
  "BGWP-OCR eindeutig seitenbezogen",
  !bgwp_ocr.include?("## 🔎 OCR-Nachtrag") &&
    bgwp_ocr.include?("ocr_nachtrag_integriert_seiten: [1,2,3,4,5,6,7]") &&
    bgwp_ocr.include?("mapping_status: \"vollstaendig_visuell_geprueft_und_kanonisch_zugeordnet\"")
)
netzplan_ocr = File.read(ROOT.join("02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Netzplan_251022_160116.md"), encoding: "UTF-8")
validation.assert(
  "Netzplan-OCR nur lokal integriert",
  !netzplan_ocr.include?("## 🔎 OCR-Nachtrag") &&
    netzplan_ocr.include?("ocr_nachtrag_integriert_seiten: [1,2,3,4]") &&
    netzplan_ocr.include?("ocr_status: \"seitenbezogen_integriert\"") &&
    netzplan_ocr.scan("#### OCRplus-Text für Suche und KI").length == 4
)
validation.assert("keine globalen OCR-Anhänge in Quellen", source_groups.keys.none? { |path| File.read(ROOT.join(path), encoding: "UTF-8").include?("## 🔎 OCR-Nachtrag") })

sensitive_text = File.read(ROOT.join("02_Faecher/ITT_IT_Technik/Quellen/Stol_Skript.md"), encoding: "UTF-8")
sensitive_patterns = [/[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}/i, /IBAN:\s*DE\d/i, /Telefon:\s*[+\d]/i, /Telefax:\s*[+\d]/i, /USt-IdNr/i]
validation.assert("sensible Unterrichts-Rohdaten nicht indexierbar", sensitive_patterns.none? { |pattern| sensitive_text.match?(pattern) })
expected_sensitive = mapping_pages.count { |page| page["source_text_status"] == "redacted_summary" }
actual_sensitive = source_groups.keys.sum { |path| File.read(ROOT.join(path), encoding: "UTF-8").scan("#### Datenschutzsichere Inhaltszusammenfassung").length }
validation.assert("datenschutzsichere Seitenzusammenfassungen vollständig", actual_sensitive == expected_sensitive && actual_sensitive >= 7, "Ist: #{actual_sensitive}; Soll: #{expected_sensitive}")
sensitive_page_17 = page_reader.body(sensitive_text, 17).to_s
validation.assert("keine widersprüchlichen OCR-Hinweise auf sensibler S.17", !sensitive_page_17.include?("Kein verwertbarer Text auf dieser Seite") && !sensitive_page_17.include?("OCRplus-Nachtrag integriert"))

required_exclusions = [
  "98_Archiv_nicht_lernen", "99_Originale", "00_Posteingang_GoodNotes", "04_Pruefung",
  "05_Karteikarten", "06_Altklausuren", ".agents",
  "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1_1.md",
  "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Lernziele.md",
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_4_Block.md",
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_5_Block.md",
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Wiki.md"
]
active_canonical_sources = mapping.fetch("sources").each_with_object([]) do |(path, source), selected|
  selected << path.delete_suffix(".md") if source.fetch("canonical_pages").positive?
end.sort
excluded_source_count = mapping.fetch("sources").length - active_canonical_sources.length
expected_allowlist = (["00_KI_QUELLENSTART", "00_START", "03_Themen/00_Kuratierte_Themen"] +
  topic_paths.map { |path| path.delete_suffix(".md") }.sort +
  active_canonical_sources).map { |path| "#{path}.md" }
actual_allowlist = copilot.fetch("qaInclusions").split(",").map(&:strip)
allowlist_audit = JSON.parse(File.read(ALLOWLIST_AUDIT_PATH, encoding: "UTF-8"))
decoded_qa_exclusions = URI.decode_www_form_component(copilot.fetch("qaExclusions", ""))
missing_exclusions = required_exclusions.reject { |item| decoded_qa_exclusions.include?(item) }
prompt_ok = copilot_has_active_system_prompt?(copilot)
no_broken_path_wikilinks = actual_allowlist.none? { |item| item.match?(/\A\[\[.*\/.*\]\]\z/) }

copilot_safety = copilot["autoAddActiveContentToContext"] == false &&
  copilot["passMarkdownImages"] == false && copilot["enableAutonomousAgent"] == false &&
  copilot["enableRecentConversations"] == false && copilot["enableSavedMemory"] == false &&
  copilot["autoAcceptEdits"] == false && missing_exclusions.empty? &&
  no_broken_path_wikilinks &&
  actual_allowlist == expected_allowlist &&
  allowlist_audit.fetch("entries") == expected_allowlist &&
  allowlist_audit.fetch("count") == expected_allowlist.length &&
  prompt_ok
validation.assert(
  "Copilot-Dateiallowlist und Sicherheitsmodus gehärtet",
  copilot_safety,
  "Ist: #{actual_allowlist.length}; Soll: #{expected_allowlist.length}; fehlende Exclusions: #{missing_exclusions.inspect}; Prompt aktiv: #{prompt_ok}"
)

files = inventory.fetch("files")
verified_topics = files.select { |file| file.fetch("path").start_with?("03_Themen/Visuell_geprueft/") }
legacy_topics = files.select { |file| file.fetch("path").start_with?("03_Themen/") && !file.fetch("path").start_with?("03_Themen/Visuell_geprueft/") && file.fetch("path") != "03_Themen/00_Kuratierte_Themen.md" }
learning_modules = files.select { |file| file.fetch("path").include?("/10_Lernordner/") }
private_files = files.select { |file| file.fetch("path").start_with?("98_Archiv_nicht_lernen/") }
unclassified_files = files.select { |file| file["role"] == "unclassified" }.map { |file| file.fetch("path") }

validation.assert("Manifest: geprüfte Themen primär", verified_topics.length == topic_count && verified_topics.all? { |file| file["role"] == "curated_topic" && file["ai_use"] == "primary" })
validation.assert("Manifest: keine alten Themen vorhanden", legacy_topics.empty?)
validation.assert("Manifest: keine alten Lernmodule vorhanden", learning_modules.empty?)
validation.assert("Manifest: Privatbereich ausgeschlossen", !private_files.empty? && private_files.all? { |file| file["ai_use"] == "excluded" })
validation.assert("Manifest: aktive und ausgeschlossene Quellen konsistent", files.count { |file| file["role"] == "source_note" } == active_canonical_sources.length && files.count { |file| file["role"] == "excluded_source_note" } == excluded_source_count)
validation.assert("Manifest: Belegreihenfolge Quelle vor PDF", inventory.fetch("evidence_order") == ["source_note", "original_pdf"])
validation.assert("Manifest: keine PDF-Dubletten mehr im Vault", files.select { |file| file["role"] == "duplicate_pdf" }.length == expected_dup_pdfs)
validation.assert("Manifest: keine unbekannte Datei", unclassified_files.empty? && inventory.dig("retrieval_profiles", "always_exclude").include?("unclassified"), unclassified_files.inspect)

matrix = File.read(ROOT.join("01_Index/Quellenmatrix.md"), encoding: "UTF-8")
validation.assert("Quellenmatrix nur mit geprüften Themen", !matrix.include?("/10_Lernordner/") && !matrix.match?(/\[\[03_Themen\/(?!Visuell_geprueft\/)/))
link_report = JSON.parse(File.read(LINK_REPORT_PATH, encoding: "UTF-8"))
validation.assert("alle nicht-privaten lokalen Referenzen auflösbar", link_report.fetch("unresolved") == 0 && link_report.fetch("markdown_files") >= 350, link_report.inspect)

validation.finish!
puts "PASS: #{validation.checks.length} Abschlussprüfungen; #{expected_active_pages} aktive Seiten (#{topic_count} Themen, #{expected_allowlist.length} Copilot-Dateien) und #{expected_dup_pages} Dublettenseiten vollständig nachgewiesen."
