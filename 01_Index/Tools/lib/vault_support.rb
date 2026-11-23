# Gemeinsame Hilfen für die Vault-Werkzeuge.
#
# Wichtig für iCloud Drive: Dateien werden nur geschrieben, wenn sich ihr
# Inhalt wirklich ändert, und Ordner werden nie komplett gelöscht und neu
# angelegt. Das verhindert iCloud-Konfliktkopien wie "Thema 2.md".

require "date"
require "fileutils"
require "json"
require "pathname"

module VaultSupport
  ROOT = Pathname.new(__dir__).join("../../..").cleanpath.realpath
  BASE_AUDIT_DATE = "2026-07-13"
  AUDIT_PATH = ROOT.join("01_Index/PDF_Seitenaudit.json")
  MAPPING_PATH = ROOT.join("01_Index/Themenreferenzen_Visuell_Geprueft.json")
  IMPORT_REPORT_DIR = ROOT.join("01_Index/Auditdaten/Import")
  CATEGORY_REGISTRY = ROOT.join("01_Index/Themen_Kategorien.json")
  PRIVATE_PREFIX = "98_Archiv_nicht_lernen/Privat_Noten_nicht_fuer_KI/"

  CONTENT_TYPES = %w[theorie aufgabe loesung beispiel formular index fragment leer].freeze
  TEXT_MATCHES = %w[ok partial wrong_page missing ocr_error].freeze
  CONFIDENCES = %w[high medium low].freeze

  module_function

  def write_if_changed(path, content)
    path = Pathname.new(path)
    return false if path.file? && File.read(path, encoding: "UTF-8") == content

    FileUtils.mkdir_p(path.dirname)
    File.write(path, content)
    true
  end

  def write_json_if_changed(path, data)
    write_if_changed(path, JSON.pretty_generate(data) + "\n")
  end

  def read_json(path)
    JSON.parse(File.read(path, encoding: "UTF-8"))
  end

  def relative(path)
    Pathname.new(path).relative_path_from(ROOT).to_s
  end

  def nfc(value)
    value.to_s.unicode_normalize(:nfc)
  end

  def import_report_paths
    Dir.glob(IMPORT_REPORT_DIR.join("*.json").to_s).sort.map { |path| Pathname.new(path) }
  end

  def import_reports
    import_report_paths.map { |path| [path, read_json(path)] }
  end

  def import_report?(path)
    Pathname.new(path).dirname.realdirpath == IMPORT_REPORT_DIR.realdirpath
  rescue Errno::ENOENT
    false
  end

  # Spätestes Prüfdatum aller Audit-Seiten (Basisaudit 2026-07-13 plus Importe).
  def latest_audit_date(audit = nil)
    audit ||= read_json(AUDIT_PATH) if AUDIT_PATH.file?
    dates = audit ? audit.fetch("pages", []).map { |page| page.dig("audit", "audit_date") }.compact : []
    ([BASE_AUDIT_DATE] + dates).max
  end

  def page_audit_date(page)
    page.dig("audit", "audit_date") || BASE_AUDIT_DATE
  end

  def category_registry
    return {} unless CATEGORY_REGISTRY.file?

    read_json(CATEGORY_REGISTRY).fetch("topics", {})
  end

  # Validiert einen Seiteneintrag aus einem Importbericht. Gibt Fehlertexte zurück.
  def import_page_problems(page)
    audit = page.fetch("audit", {})
    label = "#{page['source_note']} S.#{page['page']}"
    problems = []
    problems << "#{label}: visual_checked ist nicht true" unless audit["visual_checked"] == true
    problems << "#{label}: audit_date fehlt (JJJJ-MM-TT)" unless audit["audit_date"].to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)
    problems << "#{label}: content_type ungültig" unless CONTENT_TYPES.include?(audit["content_type"])
    problems << "#{label}: source_text_match ungültig" unless TEXT_MATCHES.include?(audit["source_text_match"])
    problems << "#{label}: confidence ungültig" unless CONFIDENCES.include?(audit["confidence"])
    topics = Array(audit["recommended_topics"])
    excluded = !audit["exclusion_reason"].to_s.strip.empty?
    auto_excluded = %w[leer index].include?(audit["content_type"])
    problems << "#{label}: weder Thema noch Ausschlussgrund" if topics.empty? && !excluded && !auto_excluded
    problems << "#{label}: Ausschlussgrund und Themen gleichzeitig gesetzt" if excluded && !topics.empty?
    problems << "#{label}: primary_topic fehlt" if !topics.empty? && audit["primary_topic"].to_s.strip.empty?
    problems
  end

  CANONICAL_SECTION_HEADING = "## Kanonische Schicht nach der Korrektur".freeze

  def canonical_section(totals)
    <<~MARKDOWN
      #{CANONICAL_SECTION_HEADING}

      - **#{totals.fetch('canonical_topics')} visuell geprüfte Themen**
      - **#{totals.fetch('canonical_evidence_pages')} direkte Evidenzseiten**
      - **#{totals.fetch('support_only_pages')} nur unterstützende Fragmentseiten**
      - **#{totals.fetch('excluded_active_pages')} ausgeschlossene aktive Seiten**
      - **296 alte Lernordner-Referenzen vollständig ersetzt**

      Die korrigierte Zuordnung steht in [[03_Themen/00_Kuratierte_Themen|Visuell geprüfte Themen]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>). Die Tabelle oben bleibt als dokumentierter Ausgangsbefund **vor** der Korrektur erhalten.

    MARKDOWN
  end

  # Fügt den Abschnitt vor "## Belegregel" ein oder ersetzt ihn.
  def with_canonical_section(markdown, totals)
    section = canonical_section(totals)
    if markdown.include?(CANONICAL_SECTION_HEADING)
      markdown.sub(/^#{Regexp.escape(CANONICAL_SECTION_HEADING)}\n.*?(?=^## )/m, section)
    else
      markdown.sub(/^## Belegregel$/, "#{section}## Belegregel")
    end
  end

  def compact_ranges(numbers)
    sorted = numbers.uniq.sort
    return "" if sorted.empty?

    output = []
    first = previous = sorted.first
    sorted.drop(1).each do |number|
      if number == previous + 1
        previous = number
      else
        output << (first == previous ? first.to_s : "#{first}–#{previous}")
        first = previous = number
      end
    end
    output << (first == previous ? first.to_s : "#{first}–#{previous}")
    output.join(", ")
  end
end
