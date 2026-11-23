#!/usr/bin/env ruby

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("../..").cleanpath.realpath
TARGETS = {
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824.md" => 4,
  "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_AEuP_Stol.md" => 3
}.freeze
BGWP_PATH = "02_Faecher/BGWP_Betriebswirtschaft/Quellen/ZusammenfassungBGWP.md"
NETZPLAN_PATH = "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Netzplan_251022_160116.md"

class FrontmatterFieldWriter
  def set(text, key, value)
    lines = text.lines
    closing = lines.each_index.drop(1).find { |index| lines[index].strip == "---" }
    raise "Frontmatter fehlt" unless lines.first&.strip == "---" && closing

    frontmatter = lines[1...closing]
    index = frontmatter.index { |line| line.start_with?("#{key}:") }
    if index
      frontmatter.delete_at(index)
      frontmatter.delete_at(index) while frontmatter[index]&.match?(/^\s+/)
    end
    frontmatter << "#{key}: #{JSON.generate(value)}\n"
    ([lines.first] + frontmatter + lines[closing..-1]).join
  end
end

class OcrAppendixMerger
  APPENDIX_HEADING = "## 🔎 OCR-Nachtrag für vorher kaum lesbare Seiten"

  def initialize(field_writer: FrontmatterFieldWriter.new)
    @field_writer = field_writer
  end

  def merge(path, page)
    text = File.read(path, encoding: "UTF-8")
    return false if !text.include?(APPENDIX_HEADING) && text.include?("Verifizierter OCR-Nachtrag für Suche")

    appendix_start = text.index(APPENDIX_HEADING)
    raise "OCR-Anhang fehlt: #{path}" unless appendix_start
    appendix = text[appendix_start..-1]
    ocr_match = appendix.match(/^### OCR Seite #{page}\s*$.*?^```text\s*$\n(.*?)^```\s*$/m)
    raise "OCR-Text für Seite #{page} fehlt: #{path}" unless ocr_match
    ocr_text = ocr_match[1].sub(/\n\z/, "")

    page_match = text.match(/^### Seite #{page}\s*$\n(.*?)(?=^## 🔎 OCR-Nachtrag)/m)
    raise "Kanonischer Seitenabschnitt #{page} fehlt: #{path}" unless page_match
    body = page_match[1]
    placeholder = /> \[!ocr\] Kein verwertbarer Text auf dieser Seite\n> .*?\n/m
    raise "Erwarteter OCR-Platzhalter fehlt: #{path}" unless body.match?(placeholder)
    replacement = <<~MARKDOWN
      #### Verifizierter OCR-Nachtrag für Suche

      > [!ocr] Aus dem bereits vorhandenen OCR-Anhang integriert
      > Der Text wurde der visuell geprüften PDF-Seite #{page} eindeutig zugeordnet. Wegen Scan-, Handschrift- und Codefehlern bleibt das Original für wörtliche Zitate maßgeblich.

      ```text
      #{ocr_text}
      ```
    MARKDOWN
    updated_body = body.sub(placeholder, replacement)
    updated = text.sub(page_match[0], "### Seite #{page}\n" + updated_body)
    updated = updated[0...updated.index(APPENDIX_HEADING)].rstrip + "\n"
    updated = @field_writer.set(updated, "ocr_nachtrag_integriert_seiten", [page])
    File.write(path, updated)
    true
  end

  def clean_bgwp(path)
    text = File.read(path, encoding: "UTF-8")
    changed = text.include?(APPENDIX_HEADING)
    text = text[0...text.index(APPENDIX_HEADING)].rstrip + "\n" if changed
    text = text.sub(
      "> [!ocr] OCR-/Scan-Hinweis\n> Diese Quelle besitzt keine verlässliche Textebene. Der **originale Inhalt und das Layout** sind über die PDF-Einbettungen pro Seite vollständig referenziert, aber für KI-Suche ist später eine manuelle/OCR-Nachbearbeitung sinnvoll.",
      "> [!ocr] Seitenbezogene OCR vollständig integriert\n> Alle sieben Seiten besitzen einen lokalen, eindeutig zugeordneten OCR-/Lesetext. Für wörtliche Zitate, Zahlen und Layout bleibt die visuell geprüfte Originalseite maßgeblich."
    )
    text = text.sub(
      "> [!warning] Teilweise neu auditiert\n> Der globale OCR-Nachtrag hatte Inhalte mehrerer Scan-Seiten fälschlich der PDF-Seite 7 zugerechnet. Für Seite 7 bleiben deshalb nur der allgemeine BGWP-Überblick, Marktumfeld/Marktformen und Wirtschaftssektoren als Zuordnungen bestehen. Die automatisch erzeugten Lernmodule müssen nach einer sauberen seitenweisen OCR später neu generiert werden.",
      "> [!success] Vollständig neu auditiert\n> Alle sieben Seiten sind visuell geprüft und seitenbezogen zugeordnet. Der redundante globale OCR-Anhang wurde entfernt; kanonisch sind ausschließlich die lokalen Seitenabschnitte und ihre geprüften Themenreferenzen."
    )
    text = @field_writer.set(text, "ocr_nachtrag_integriert_seiten", (1..7).to_a)
    text = @field_writer.set(text, "mapping_status", "vollstaendig_visuell_geprueft_und_kanonisch_zugeordnet")
    File.write(path, text)
    changed
  end

  def clean_netplan(path)
    text = File.read(path, encoding: "UTF-8")
    changed = text.include?(APPENDIX_HEADING)
    text = text[0...text.index(APPENDIX_HEADING)].rstrip + "\n" if changed
    text = text.sub(
      "> [!ocr] OCR-/Scan-Hinweis\n> Diese Quelle besitzt keine verlässliche Textebene. Der **originale Inhalt und das Layout** sind über die PDF-Einbettungen pro Seite vollständig referenziert, aber für KI-Suche ist später eine manuelle/OCR-Nachbearbeitung sinnvoll.",
      "> [!ocr] Seitenbezogene OCR integriert\n> Die vier fachlich nutzbaren Seiten besitzen jeweils einen lokalen OCRplus-Text. Für wörtliche Zitate, Zahlen und Layout bleibt die visuell geprüfte Originalseite maßgeblich; die Seiten 5–7 sind leer und ausgeschlossen."
    )
    text = @field_writer.set(text, "ocr_nachtrag_integriert_seiten", (1..4).to_a)
    text = @field_writer.set(text, "ocr_status", "seitenbezogen_integriert")
    File.write(path, text)
    changed
  end
end

merger = OcrAppendixMerger.new
changed = TARGETS.count do |relative_path, page|
  merger.merge(ROOT.join(relative_path), page)
end
changed += 1 if merger.clean_bgwp(ROOT.join(BGWP_PATH))
changed += 1 if merger.clean_netplan(ROOT.join(NETZPLAN_PATH))
puts "Merged #{changed} verified OCR appendix page(s)."
