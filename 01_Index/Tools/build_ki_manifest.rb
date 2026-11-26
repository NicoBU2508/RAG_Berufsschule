#!/usr/bin/env ruby

require "json"
require "pathname"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
JSON_OUTPUT = ROOT.join("01_Index/KI_Dateiinventar.json")
MARKDOWN_OUTPUT = ROOT.join("01_Index/KI_Quellenmanifest.md")
DUPLICATES_PATH = ROOT.join("01_Index/Auditdaten/PDF_Duplikatnachweis.json")
PRIVATE_PREFIX = VaultSupport::PRIVATE_PREFIX

def load_duplicate_pdfs_nfc
  if DUPLICATES_PATH.file?
    data = VaultSupport.read_json(DUPLICATES_PATH)
    return data.fetch("pairs", []).map { |pair| VaultSupport.nfc(pair.fetch("duplicate_pdf")) }
  end

  [
    "99_Originale/Berufsschule/AE/1_LJ/Anwendugse.pdf",
    "99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Aufgabe 1(1).pdf",
    "99_Originale/Berufsschule/Religion/1_LJ/Unbenanntes Notizbuch.pdf"
  ].map { |path| VaultSupport.nfc(path) }
end

DUPLICATE_PDFS_NFC = load_duplicate_pdfs_nfc.freeze

class FrontmatterReader
  MAX_LINES = 200

  def read(path, relative_path)
    return {} unless File.extname(path).downcase == ".md"
    return {} if relative_path.start_with?(PRIVATE_PREFIX)

    lines = []
    File.foreach(path).with_index do |line, index|
      return {} if index.zero? && line.strip != "---"
      break if index.positive? && line.strip == "---"
      break if index >= MAX_LINES
      lines << line if index.positive?
    end

    lines.each_with_object({}) do |line, metadata|
      match = line.match(/^([a-zA-Z_][a-zA-Z0-9_-]*):\s*(.*?)\s*$/)
      next unless match
      value = match[2].sub(/\A["']/, "").sub(/["']\z/, "")
      metadata[match[1]] = value unless value.empty?
    end
  rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
    {}
  end
end

class FileClassifier
  Classification = Struct.new(:role, :ai_use, :reason)

  def classify(path, metadata)
    return item("project_metadata", "excluded", "Projekt-, Git- und Auditmetadaten; kein fachlicher Lernbeleg") if %w[manifest.json .gitignore README.md].include?(path)
    return item("private_or_archive", "excluded", "Archiv, Duplikat oder ausdrücklich nicht für KI") if path.start_with?("98_Archiv_nicht_lernen/")
    return item("import_inbox", "excluded", "Posteingang für neue GoodNotes-PDFs; bis zum visuellen Audit ausgeschlossen") if path.start_with?("00_Posteingang_GoodNotes/")
    return item("import_inbox", "excluded", "Posteingang für neue IHK-Altklausuren & Lösungen; bis zur Aufgabenanalyse ausgeschlossen") if path.start_with?("06_Altklausuren/00_Posteingang/")
    return item("agent_customization", "operational", "Projekt-spezifische Agent-Anweisungen und Skills") if path.start_with?(".agents/")
    return item("obsidian_configuration", "excluded", "Lokale Konfiguration oder Plugin-Code") if path.start_with?(".obsidian/")
    return item("copilot_prompt", "excluded", "Arbeitsanweisung, kein Lernwissen") if path.start_with?("copilot/")
    return item("template", "excluded", "Unausgefüllter Platzhalter") if path.start_with?("05_Templates/")
    return item("topic_alias", "excluded", "Weiterleitung oder OCR-Fragment ohne kanonischen Inhalt") if path.start_with?("03_Themen/Weiterleitungen/")
    return item("duplicate_pdf", "excluded", "Vollständig gerendert und visuell pixelidentisch mit einer aktiven kanonischen PDF") if DUPLICATE_PDFS_NFC.include?(VaultSupport.nfc(path))
    return item("original_pdf", "verify_only", "Originalbeleg; bei OCR, Zahlen und Layout visuell prüfen") if path.start_with?("99_Originale/") && File.extname(path).downcase == ".pdf"
    return item("excluded_source_note", "excluded", "Quellnotiz ist als visuell unbrauchbar oder exakt doppelt technisch ausgeschlossen") if metadata["ki_exclude"] == "true"
    return item("source_note", "primary", "Aktive Quellnotiz mit extrahiertem Text und PDF-Seiten") if path.match?(%r{\A02_Faecher/[^/]+/Quellen/[^/]+\.md\z})
    return item("topic_index", "navigation", "Einstieg in die vollständig visuell geprüften Themen") if path == "03_Themen/00_Kuratierte_Themen.md"
    return item("curated_topic", "primary", "Visuell geprüfte Seiteneinordnung; fachlicher Beleg bleibt die Quellnotiz") if path.start_with?("03_Themen/Visuell_geprueft/") && metadata["status"] == "visuell_geprueft"
    return item("legacy_topic", "excluded", "Frühere Themeneinordnung ohne gleichwertige seitenweise Sichtprüfung") if path.start_with?("03_Themen/")
    return item("unverified_exam_material", "excluded", "Planungs- oder Prüfungsschicht ohne gleichwertige seitenweise Quellenprüfung") if path.start_with?("04_Pruefung/")
    return item("generated_learning_index", "excluded", "Automatisch erzeugter Themenordner-Index mit historisch zu breiten Zuordnungen") if path.include?("/10_Lernordner/") && metadata["typ"] == "index"
    return item("generated_learning_module", "excluded", "Automatisch aggregierte Lernschicht mit historisch zu breiten Seitenzuordnungen") if path.include?("/10_Lernordner/") && File.extname(path).downcase == ".md"
    return item("topic_hub", "navigation", "Verweisknoten ohne eigene Quelle") if metadata["typ"] == "themen_hub"
    return item("generated_vault_index", "navigation", "Großer Generierungsstand; nur zum Auffinden") if path == "00_Vault_Index_Vollständig.md"
    return item("entrypoint", "primary", "Kanonischer Einstieg und Quellenregeln") if path == "00_START.md" || path == "00_KI_QUELLENSTART.md"
    return item("workflow_guide", "navigation", "Leitfaden zur Integration neuer GoodNotes-Mitschriften") if path == "00_WORKFLOW_NEUE_MITSCHRIFTEN.md"
    return item("working_note", "excluded", "Lokale Tagesnotiz oder Canvas; kein kanonischer KI-Beleg") if path.match?(/\A\d{4}-\d{2}-\d{2}\.md\z/) || File.extname(path).downcase == ".canvas"
    return item("flashcard_index", "excluded", "Nicht gleichwertig visuell geprüfte Wiederholungsschicht") if path.start_with?("05_Karteikarten/")
    return item("exam_archive", "excluded", "Nicht gleichwertig visuell geprüfte Altklausurstruktur") if path.start_with?("06_Altklausuren/")
    return item("navigation_index", "navigation", "Fach- oder Gesamtübersicht") if path.start_with?("07_Lernordner/")
    return item("learner_state", "excluded", "Lokaler FSRS-Lernfortschritt und Denkfehler-Historie; keine Weitergabe an Cloud-RAG") if path == "01_Index/Lernstand.json"
    return item("maintenance_tool", "operational", "Lokales Prüf- oder Wartungswerkzeug") if path.start_with?("01_Index/Tools/")
    return item("quality_or_navigation", "navigation", "Index, Audit oder Qualitätsbericht") if path.start_with?("01_Index/")
    return item("subject_index", "navigation", "Fachnavigation") if path.match?(%r{\A02_Faecher/[^/]+/[^/]+\.md\z})
    return item("unclassified", "excluded", "Nicht klassifizierte Datei; fail-closed bis zur ausdrücklichen Prüfung")
  end

  private

  def item(role, ai_use, reason)
    Classification.new(role, ai_use, reason)
  end
end

class ManifestBuilder
  GENERATED_PATHS = [
    "01_Index/KI_Dateiinventar.json",
    "01_Index/KI_Quellenmanifest.md"
  ].freeze
  IGNORED_PREFIXES = [
    ".git/",
    "Obsidian_Berufsschule/",
    ".import_review/"
  ].freeze

  def initialize(root, reader: FrontmatterReader.new, classifier: FileClassifier.new)
    @root = root
    @reader = reader
    @classifier = classifier
  end

  def build
    audit_date = VaultSupport.latest_audit_date
    files = paths.map { |path| record(path) }
    {
      "schema_version" => 2,
      "audit_date" => audit_date,
      "privacy" => "Private Dateien wurden nur nach Existenz, Pfad, Typ und Größe inventarisiert; ihr Inhalt wurde nicht gelesen.",
      "retrieval_order" => ["curated_topic", "source_note", "original_pdf"],
      "evidence_order" => ["source_note", "original_pdf"],
      "retrieval_profiles" => retrieval_profiles,
      "totals" => totals(files),
      "files" => files
    }
  end

  private

  def paths
    Dir.chdir(@root) do
      Dir.glob("**/*", File::FNM_DOTMATCH)
        .select { |path| File.file?(path) }
        .reject { |path| IGNORED_PREFIXES.any? { |prefix| path.start_with?(prefix) } || File.basename(path) == ".DS_Store" }
        .reject { |path| path.start_with?("00_Posteingang_GoodNotes/") && path != "00_Posteingang_GoodNotes/README.md" }
        .reject { |path| path.start_with?("06_Altklausuren/00_Posteingang/") && path != "06_Altklausuren/00_Posteingang/README.md" }
        .sort
    end
  end

  def record(relative_path)
    absolute_path = @root.join(relative_path)
    metadata = @reader.read(absolute_path, relative_path)
    classification = @classifier.classify(relative_path, metadata)
    {
      "path" => relative_path,
      "extension" => extension(relative_path),
      "bytes" => GENERATED_PATHS.include?(relative_path) ? nil : File.size(absolute_path),
      "role" => classification.role,
      "ai_use" => classification.ai_use,
      "reason" => classification.reason,
      "typ" => metadata["typ"],
      "fach" => metadata["fach"],
      "thema" => metadata["thema"],
      "status" => metadata["status"]
    }.reject { |_key, value| value.nil? }
  end

  def extension(path)
    ext = File.extname(path).downcase.sub(".", "")
    ext.empty? ? "none" : ext
  end

  def totals(files)
    {
      "files" => files.length,
      "by_extension" => count_by(files, "extension"),
      "by_role" => count_by(files, "role"),
      "by_ai_use" => count_by(files, "ai_use")
    }
  end

  def count_by(files, key)
    files.each_with_object(Hash.new(0)) { |file, counts| counts[file.fetch(key)] += 1 }.sort.to_h
  end

  def retrieval_profiles
    {
      "compact" => {
        "use" => ["entrypoint", "topic_index", "curated_topic", "source_note"],
        "verify_with" => ["original_pdf"],
        "purpose" => "Hohe Präzision und wenig Duplikate"
      },
      "full" => {
        "add" => ["quality_or_navigation", "navigation_index", "workflow_guide"],
        "purpose" => "Diagnose und Navigation; keine zusätzlichen fachlichen Belege"
      },
      "always_exclude" => [
        "project_metadata", "private_or_archive", "import_inbox", "working_note",
        "obsidian_configuration", "copilot_prompt", "template", "topic_alias",
        "duplicate_pdf", "legacy_topic", "generated_learning_index",
        "generated_learning_module", "unverified_exam_material", "flashcard_index",
        "exam_archive", "learner_state", "excluded_source_note", "unclassified"
      ]
    }
  end
end

class ManifestWriter
  def initialize(json_output, markdown_output)
    @json_output = json_output
    @markdown_output = markdown_output
  end

  def write(manifest)
    VaultSupport.write_json_if_changed(@json_output, manifest)
    VaultSupport.write_if_changed(@markdown_output, markdown(manifest))
  end

  private

  def markdown(manifest)
    audit_date = manifest.fetch("audit_date")
    totals = manifest.fetch("totals")
    role_rows = totals.fetch("by_role").map { |role, count| "| `#{role}` | #{count} |" }.join("\n")
    use_rows = totals.fetch("by_ai_use").map { |use, count| "| `#{use}` | #{count} |" }.join("\n")
    <<~MARKDOWN
      ---
      id: vault.ki.quellenmanifest
      typ: ki_quellenmanifest
      status: generiert
      stand: #{audit_date}
      ki_prioritaet: 1
      tags:
        - ki_quelle
        - manifest
        - qualitaetssicherung
      ---

      # KI-Quellenmanifest

      Dieses Manifest klassifiziert jede Projektdatei nach ihrer Rolle für GPT-, RAG- und Obsidian-Copilot-Abfragen. Das vollständige maschinenlesbare Inventar steht in [KI_Dateiinventar.json](<KI_Dateiinventar.json>).

      > [!privacy] Datenschutz
      > Private Dateien wurden nur nach Existenz, Pfad, Typ und Größe inventarisiert. Ihr Inhalt wurde nicht gelesen und ist für KI-Systeme ausgeschlossen.

      ## Abdeckung

      - Dateien insgesamt: **#{totals.fetch("files")}**
      - Stand: **#{audit_date}**
      - Generator: `ruby 01_Index/Tools/build_ki_manifest.rb`

      | KI-Nutzung | Dateien |
      |---|---:|
      #{use_rows}

      | Rolle | Dateien |
      |---|---:|
      #{role_rows}

      ## Retrieval-Profile

      **Kompakt:** `entrypoint`, `topic_index`, `curated_topic` und `source_note`; Original-PDFs nur zur Verifikation. Dieses Profil hat die höchste Präzision.

      **Diagnose:** Zusätzlich Qualitäts- und Navigationsdateien durchsuchen. Dadurch entstehen keine weiteren fachlichen Belege.

      **Immer ausschließen:** Archiv/Privatbereich, Posteingang (`00_Posteingang_GoodNotes/`), `.obsidian`, Copilot-Prompts, Templates, alte Themen, generierte Lernmodule, ungeprüfte Prüfungsschichten und Quellnotizen mit `ki_exclude: true`.

      ## Quellenpriorität

      1. aktive Quellnotiz für Text und genaue Seite
      2. Original-PDF zur visuellen Prüfung

      Die visuell geprüfte Themenseite dient davor als Retrieval-Navigation, nicht als eigenständiger Faktenbeleg.

      Siehe auch [[00_KI_QUELLENSTART|KI-Quellenstart]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [[01_Index/PDF_Seitenaudit|vollständiger Seitenaudit]].
    MARKDOWN
  end
end

manifest = ManifestBuilder.new(ROOT).build
ManifestWriter.new(JSON_OUTPUT, MARKDOWN_OUTPUT).write(manifest)
puts "Wrote #{MARKDOWN_OUTPUT.relative_path_from(ROOT)} and #{JSON_OUTPUT.relative_path_from(ROOT)} (#{manifest.dig("totals", "files")} files)."
