#!/usr/bin/env ruby

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("../..").cleanpath.realpath
AUDIT_PATH = ROOT.join("01_Index/PDF_Seitenaudit.json")
MAPPING_PATH = ROOT.join("01_Index/Themenreferenzen_Visuell_Geprueft.json")
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
      "validated_on" => "2026-07-13",
      "status" => errors.empty? ? "pass" : "fail",
      "checks_passed" => checks.length,
      "checks_failed" => errors.length,
      "checks" => checks + errors
    }
    File.write(OUTPUT_PATH, JSON.pretty_generate(output) + "\n")
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

audit = JSON.parse(File.read(AUDIT_PATH, encoding: "UTF-8"))
mapping = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
inventory = JSON.parse(File.read(INVENTORY_PATH, encoding: "UTF-8"))
copilot = JSON.parse(File.read(COPILOT_PATH, encoding: "UTF-8"))
validation = Validation.new

audit_pages = audit.fetch("pages")
mapping_pages = mapping.fetch("pages")
totals = mapping.fetch("totals")

validation.assert("36 nicht-private PDFs erfasst", audit.dig("totals", "nonprivate_pdfs_accounted_for") == 36)
validation.assert("902 nicht-private PDF-Seiten erfasst", audit.dig("totals", "nonprivate_pages_accounted_for") == 902)
validation.assert("33 aktive PDFs visuell geprüft", audit.dig("totals", "active_pdfs") == 33)
validation.assert("805 aktive Seiten visuell geprüft", audit_pages.length == 805 && audit_pages.all? { |page| page.dig("audit", "visual_checked") == true })
validation.assert("jede aktive Audit-Seite eindeutig", audit_pages.map { |page| page.fetch("id") }.uniq.length == 805)
validation.assert("3 PDF-Dubletten nachgewiesen", totals.fetch("proven_duplicate_pdfs") == 3)
validation.assert("97 Dublettenseiten nachgewiesen", totals.fetch("proven_duplicate_pages") == 97)
validation.assert("private PDF ungelesen", audit.dig("totals", "private_pdfs_unread") == 1)

status_counts = mapping_pages.each_with_object(Hash.new(0)) { |page, counts| counts[page.fetch("status")] += 1 }
validation.assert("kanonische Seitenbilanz 805", mapping_pages.length == 805 && status_counts.values.sum == 805, status_counts.inspect)
validation.assert("713 direkte Evidenzseiten", status_counts["evidence"] == 713, status_counts.inspect)
validation.assert("3 Support-Seiten", status_counts["support_only"] == 3, status_counts.inspect)
validation.assert("89 ausgeschlossene aktive Seiten", status_counts["excluded"] == 89, status_counts.inspect)
validation.assert("Ausschlüsse tragen keine Themen", mapping_pages.select { |page| page["status"] == "excluded" }.all? { |page| page.fetch("canonical_topics").empty? })
validation.assert("jede zugelassene Seite hat Thema", mapping_pages.reject { |page| page["status"] == "excluded" }.all? { |page| !page.fetch("canonical_topics").empty? })
validation.assert("Audit und Mapping deckungsgleich", audit_pages.map { |page| page.fetch("id") }.sort == mapping_pages.map { |page| page.fetch("id") }.sort)
validation.assert("101 kanonische Themen", mapping.fetch("topics").length == 101)
validation.assert("3 OCR-Korrekturen registriert", mapping_pages.count { |page| page["source_text_status"] == "ocr_verified" } == 3)
validation.assert("7 sensible Seiten abstrahiert", mapping_pages.count { |page| page["source_text_status"] == "redacted_summary" } == 7)

wittmann_prefix = "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page="
risk_wittmann = mapping.dig("topics", "Risikoanalyse", "pages").grep(/^#{Regexp.escape(wittmann_prefix)}/)
protection_wittmann = mapping.dig("topics", "Schutzbedarfsfeststellung", "pages").grep(/^#{Regexp.escape(wittmann_prefix)}/)
validation.assert("Risikoanalyse nur Wittmann S.48–57", risk_wittmann == (48..57).map { |page| "#{wittmann_prefix}#{page}" }, risk_wittmann.inspect)
validation.assert("Schutzbedarf enthält Wittmann S.17–23", ((17..23).map { |page| "#{wittmann_prefix}#{page}" } - protection_wittmann).empty?, protection_wittmann.inspect)

topic_paths = mapping.fetch("topics").values.map { |topic| topic.fetch("path") }
existing_topic_paths = Dir.glob(ROOT.join("03_Themen/Visuell_geprueft/**/*.md").to_s).map { |path| Pathname.new(path).relative_path_from(ROOT).to_s }.sort
validation.assert("alle und nur kanonische Themendateien vorhanden", topic_paths.sort == existing_topic_paths)
validation.assert("alle Themendateien visuell markiert", existing_topic_paths.all? { |path| File.read(ROOT.join(path), encoding: "UTF-8").include?("status: visuell_geprueft") })
index_text = File.read(ROOT.join("03_Themen/00_Kuratierte_Themen.md"), encoding: "UTF-8")
validation.assert("Themenindex enthält 101 Ziele", index_text.scan(/\[\[03_Themen\/Visuell_geprueft\//).length == 101)

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
    elsif mapped.fetch("status") != "excluded"
      source_errors << "#{source_note}: PDF-Link S.#{page.fetch('page')}" unless body.include?("#page=#{page.fetch('page')}")
    end
  end
  normalized_expected = expected_rows.transform_values { |numbers| numbers.uniq.sort }
  source_errors << "#{source_note}: Referenztabelle weicht vom Mapping ab" unless table_rows == normalized_expected
end
validation.assert("33 Quellen vollständig und exakt umgebaut", source_groups.length == 33 && source_errors.empty?, source_errors.first(20).join("; "))

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
validation.assert("7 datenschutzsichere Seitenzusammenfassungen", source_groups.keys.sum { |path| File.read(ROOT.join(path), encoding: "UTF-8").scan("#### Datenschutzsichere Inhaltszusammenfassung").length } == 7)
sensitive_page_17 = page_reader.body(sensitive_text, 17).to_s
validation.assert("keine widersprüchlichen OCR-Hinweise auf sensibler S.17", !sensitive_page_17.include?("Kein verwertbarer Text auf dieser Seite") && !sensitive_page_17.include?("OCRplus-Nachtrag integriert"))

required_exclusions = [
  "98_Archiv_nicht_lernen", "99_Originale", "03_Themen/Weiterleitungen", "03_Themen/Allgemein",
  "03_Themen/Anwendungsentwicklung", "03_Themen/Deutsch_Englisch_Kommunikation", "03_Themen/Elektrotechnik",
  "03_Themen/IT_Technik_und_Sicherheit", "03_Themen/Wirtschaft_und_Recht", "04_Pruefung",
  "IT_Sicherheit_Fachbegriffe.md", "IT_Sicherheit_Aufgabe_1_1.md", "IT_Sicherheit_Lernziele.md"
]
expected_allowlist = ["00_KI_QUELLENSTART", "00_START", "03_Themen/00_Kuratierte_Themen"] +
  topic_paths.map { |path| path.delete_suffix(".md") }.sort +
  mapping.fetch("sources").each_with_object([]) { |(path, source), selected| selected << path.delete_suffix(".md") if source.fetch("canonical_pages").positive? }.sort
expected_allowlist = expected_allowlist.map { |path| "[[#{path}]]" }
actual_allowlist = copilot.fetch("qaInclusions").split(",").map(&:strip)
allowlist_audit = JSON.parse(File.read(ALLOWLIST_AUDIT_PATH, encoding: "UTF-8"))
copilot_safety = copilot["autoAddActiveContentToContext"] == false &&
  copilot["passMarkdownImages"] == false && copilot["enableAutonomousAgent"] == false &&
  copilot["enableRecentConversations"] == false && copilot["enableSavedMemory"] == false &&
  copilot["autoAcceptEdits"] == false && required_exclusions.all? { |item| copilot.fetch("qaExclusions").include?(item) } &&
  actual_allowlist == expected_allowlist && expected_allowlist.length == 134 &&
  allowlist_audit.fetch("entries") == expected_allowlist && allowlist_audit.fetch("count") == 134 &&
  !copilot.fetch("userSystemPrompt").empty?
validation.assert("Copilot-Dateiallowlist und Sicherheitsmodus gehärtet", copilot_safety, "Ist: #{actual_allowlist.length}; Soll: #{expected_allowlist.length}")

files = inventory.fetch("files")
verified_topics = files.select { |file| file.fetch("path").start_with?("03_Themen/Visuell_geprueft/") }
legacy_topics = files.select { |file| file.fetch("path").start_with?("03_Themen/") && !file.fetch("path").start_with?("03_Themen/Visuell_geprueft/") && file.fetch("path") != "03_Themen/00_Kuratierte_Themen.md" }
learning_modules = files.select { |file| file.fetch("path").include?("/10_Lernordner/") }
private_files = files.select { |file| file.fetch("path").start_with?("98_Archiv_nicht_lernen/") }
validation.assert("Manifest: 101 geprüfte Themen primär", verified_topics.length == 101 && verified_topics.all? { |file| file["role"] == "curated_topic" && file["ai_use"] == "primary" })
validation.assert("Manifest: alte Themen ausgeschlossen", legacy_topics.all? { |file| file["ai_use"] == "excluded" })
validation.assert("Manifest: alle Lernmodule ausgeschlossen", learning_modules.all? { |file| file["ai_use"] == "excluded" })
validation.assert("Manifest: Privatbereich ausgeschlossen", !private_files.empty? && private_files.all? { |file| file["ai_use"] == "excluded" })
validation.assert("Manifest: 30 aktive und 3 ausgeschlossene Quellen", files.count { |file| file["role"] == "source_note" } == 30 && files.count { |file| file["role"] == "excluded_source_note" } == 3)
validation.assert("Manifest: Belegreihenfolge Quelle vor PDF", inventory.fetch("evidence_order") == ["source_note", "original_pdf"])
validation.assert("Manifest: PDF-Dubletten immer ausgeschlossen", files.select { |file| file["role"] == "duplicate_pdf" }.length == 3 && files.select { |file| file["role"] == "duplicate_pdf" }.all? { |file| file["ai_use"] == "excluded" })
validation.assert("Manifest: keine unbekannte Datei", files.none? { |file| file["role"] == "unclassified" } && inventory.dig("retrieval_profiles", "always_exclude").include?("unclassified"))

matrix = File.read(ROOT.join("01_Index/Quellenmatrix.md"), encoding: "UTF-8")
validation.assert("Quellenmatrix nur mit geprüften Themen", !matrix.include?("/10_Lernordner/") && !matrix.match?(/\[\[03_Themen\/(?!Visuell_geprueft\/)/))
link_report = JSON.parse(File.read(LINK_REPORT_PATH, encoding: "UTF-8"))
validation.assert("alle nicht-privaten lokalen Referenzen auflösbar", link_report.fetch("unresolved") == 0 && link_report.fetch("markdown_files") >= 543, link_report.inspect)

validation.finish!
puts "PASS: #{validation.checks.length} Abschlussprüfungen; 805 aktive und 97 Dublettenseiten vollständig nachgewiesen."
