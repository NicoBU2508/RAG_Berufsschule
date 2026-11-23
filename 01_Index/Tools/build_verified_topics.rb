#!/usr/bin/env ruby

require "digest"
require "fileutils"
require "json"
require "pathname"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
AUDIT_PATH = VaultSupport::AUDIT_PATH
WORKLIST_PATH = ROOT.join("01_Index/PDF_Seitenaudit_Worklist.json")
TOPIC_ROOT = ROOT.join("03_Themen/Visuell_geprueft")
TOPIC_INDEX = ROOT.join("03_Themen/00_Kuratierte_Themen.md")
MAPPING_OUTPUT = VaultSupport::MAPPING_PATH
QUALITY_OUTPUT = ROOT.join("01_Index/KI_Quellenqualitaet.md")
AUDIT_MD_PATH = ROOT.join("01_Index/PDF_Seitenaudit.md")
BASELINE_MIN_ACTIVE_PAGES = 805

class PageDecision
  CORRECTED_OCR_IDS = [
    "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824#page=4",
    "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_AEuP_Stol#page=3",
    "02_Faecher/BGWP_Betriebswirtschaft/Quellen/ZusammenfassungBGWP#page=7"
  ].freeze

  attr_reader :page, :topics, :status, :reason

  def initialize(page:, topics:, status:, reason: nil, sensitive: false)
    @page = page
    @topics = topics.sort.uniq.freeze
    @status = status
    @reason = reason
    @sensitive = sensitive
  end

  def excluded?
    status == "excluded"
  end

  def supporting?
    status == "support_only"
  end

  def ocr_verified?
    CORRECTED_OCR_IDS.include?(page.fetch("id")) || page.dig("audit", "ocr_verified") == true
  end

  def quote_safe?
    !excluded? && !supporting? && !sensitive? && !ocr_verified? && page.dig("audit", "source_text_match") == "ok"
  end

  def effective_source_text_status
    return "redacted_summary" if sensitive?
    return "ocr_verified" if ocr_verified?

    page.dig("audit", "source_text_match")
  end

  def sensitive?
    @sensitive
  end
end

class ExclusionPolicy
  WHOLE_SOURCE_REASONS = {
    "IT_Sicherheit_Fachbegriffe.md" => "Export visuell nicht belastbar: sichtbar sind nur Überschriften; Definitionen liegen außerhalb der sichtbaren Seitenfläche",
    "IT_Sicherheit_Aufgabe_1_1.md" => "Exakte Seitendublette von IT_Sicherheit_Aufgabe_1.md, Seite 2",
    "IT_Sicherheit_Lernziele.md" => "Nur Index- und Lernhinweisseiten ohne eigenständigen fachlichen Lerninhalt"
  }.freeze

  PERSONAL_PAGES = {
    "JAVA_Java_Basics.md" => [1],
    "Stol_Wiki.md" => [1],
    "Englisch.md" => [1, 9],
    "Pug.md" => [1],
    "Reli_Notizen.md" => [1],
    "Untitled.md" => [1]
  }.freeze

  WEAK_PAGES = {
    "01_Algorithmus_Programm_Software_EVA.md" => [37],
    "BGWP.md" => [54],
    "Bgwp_schredl.md" => [20],
    "IT_Sicherheit_Lernziele.md" => [2],
    "Pug.md" => [16]
  }.freeze

  SUPPORT_ONLY_PAGES = {
    "01_Algorithmus_Programm_Software_EVA.md" => [11],
    "Deutsch.md" => [14],
    "Stol_Stol.md" => [5]
  }.freeze

  SENSITIVE_PAGES = {
    "Stol_Skript.md" => [17, 19, 22, 23, 24, 29],
    "Reli_Notizen.md" => [2]
  }.freeze

  INDEX_EVIDENCE_PAGES = {
    "Deutsch.md" => [15, 16],
    "Englisch.md" => [35, 36, 37]
  }.freeze

  def whole_source_reason(source_note, decisions = nil)
    if decisions
      return nil if decisions.any? { |decision| !decision.excluded? }

      reasons = decisions.map(&:reason).compact.uniq
      return reasons.first if reasons.length == 1
      return "Alle Seiten dieser Quellnotiz sind vom kanonischen KI-Quelltext ausgeschlossen"
    end

    WHOLE_SOURCE_REASONS[File.basename(source_note)]
  end

  def exclusion_reason(page)
    base = File.basename(page.fetch("source_note"))
    number = page.fetch("page")
    audit = page.fetch("audit")

    explicit = audit["exclusion_reason"].to_s.strip
    return explicit unless explicit.empty?

    replaced = audit["replaces_existing"] == true
    unless replaced
      return WHOLE_SOURCE_REASONS[base] if WHOLE_SOURCE_REASONS.key?(base)
      return "Personenbezogenes oder persönliches Bild/Fragment ohne Lernbezug" if PERSONAL_PAGES.fetch(base, []).include?(number)
      return "Fachfremder Urheberrechts-Einschub; Datenschutz und externe QR-Ziele nicht freigegeben" if base == "IT_Sicherheit_Skript_Wittmann.md" && (63..67).cover?(number)
    end

    return "Visuell leere Seite ohne Lerninhalt" if audit.fetch("content_type") == "leer"
    return "Reine Index-, Inhaltsverzeichnis- oder Metaseite; nur Navigation" if audit.fetch("content_type") == "index" && !INDEX_EVIDENCE_PAGES.fetch(base, []).include?(number)

    unless replaced
      return "Überlappende kürzere Wiki-Ausgabe; für Retrieval gilt die längere Ausgabe ab Seite 20" if base == "Stol_Wiki.md" && (3..19).cover?(number)
      return "Zu schwacher Titel-/Fragmentbeleg; nicht als alleinige Wissensevidenz verwendbar" if WEAK_PAGES.fetch(base, []).include?(number)
    end

    nil
  end

  def support_only?(page)
    page.dig("audit", "support_only") == true ||
      SUPPORT_ONLY_PAGES.fetch(File.basename(page.fetch("source_note")), []).include?(page.fetch("page"))
  end

  def sensitive_page?(page)
    page.dig("audit", "sensitive") == true ||
      SENSITIVE_PAGES.fetch(File.basename(page.fetch("source_note")), []).include?(page.fetch("page"))
  end
end

class TopicMapper
  ROOT_CLASSIFIED_SOURCES = %w[
    It_Elektro_Wild_01_AB_Ladung_Q.md
    It_Elektro_Wild_Zusammenfassung.md
    Otma_Netzwerkt.md
    Stol_Aufgabenblatt_mogliche_Losung.md
    Stol_Skript.md
    Stol_Zusammenfassung_260120_080521.md
  ].freeze

  CATCH_ALL_MODULES = [
    "Aufgaben Übungen und Lösungen",
    "Restseiten Originalbelege",
    "Betriebswirtschaft BGWP"
  ].freeze

  NORMALIZATIONS = {
    "Algorithmus und Programmablauf" => ["Algorithmus", "Programmablaufdarstellungen"],
    "Arrays und Sammlungen" => ["Arrays und Datenstrukturen"],
    "Begriffe Computerwelt Gitterraetsel" => ["Computergrundbegriffe"],
    "Das oder Dass" => ["das oder dass"],
    "Dokumentation Installation und Anpassung" => ["Softwareanpassung und Dokumentation"],
    "Einheiten Umrechnen" => ["SI-Vorsätze und Einheitenumrechnung"],
    "Elektrotechnik Rechenübungen" => ["Elektrotechnik-Rechenmethoden"],
    "EVA Prinzip" => ["EVA-Prinzip"],
    "Geschäftsbrief Anfrage Angebot" => ["Geschäftsbrief"],
    "IT Sicherheit" => ["IT-Sicherheit Grundlagen"],
    "IT Sicherheit Grundlagen" => ["IT-Sicherheit Grundlagen"],
    "IT Sicherheit Überblick" => ["IT-Sicherheit Grundlagen"],
    "Java Grundlagen" => ["Java-Grundlagen"],
    "Java Grundlagen und IDE" => ["Java-Grundlagen"],
    "Klassen Objekte Attribute" => ["Objektorientierung"],
    "Kryptografie Verschlüsselung Hash Signatur" => ["Kryptografie, Hash und Signatur"],
    "Methoden Parameter Rückgabewerte" => ["Methoden, Parameter und Rückgabewerte"],
    "Netzplan und Netzwerktechnik" => ["Netzwerktechnik und Netzplan"],
    "Organigramm und Liniensysteme" => ["Organisation im Betrieb"],
    "Ransomware und Malware" => ["Malware und Angriffe"],
    "Rechtschreibung Gross und Klein" => ["Groß- und Kleinschreibung"],
    "Risikoanalyse und Schutzbedarf" => ["Schutzbedarfsfeststellung"],
    "Scanner Random Benutzereingaben" => ["Eingaben und Zufallszahlen in Java"],
    "Sicherheitsprozess PDCA" => ["Sicherheitsmanagement und ISMS"],
    "Sicherheitsprozess PDCA und ISMS" => ["Sicherheitsmanagement und ISMS"],
    "Softwareentwicklung Vorgehensmodelle Scrum V-Modell" => ["Softwarelebenszyklus und Vorgehensmodelle"],
    "Softwarequalität Wartbarkeit Usability" => ["Softwarequalität und Wartbarkeit"],
    "Syntax und Code-Struktur" => ["Java-Syntax und Codestruktur"],
    "Unternehmen und betriebliche Funktionen" => ["Betrieb und Unternehmen"],
    "Unternehmenswiki Projektaufgaben" => ["Unternehmenswiki"],
    "Werkzeuge Debugging und IDE" => ["Entwicklungswerkzeuge und Debugging"]
  }.freeze

  def topics_for(page)
    audit = page.fetch("audit")
    recommended_topics = audit.fetch("recommended_topics", [])
    return normalize_all(recommended_topics) unless recommended_topics.empty?

    if ROOT_CLASSIFIED_SOURCES.include?(File.basename(page.fetch("source_note")))
      return root_topics(audit)
    end

    modules = audit.fetch("recommended_modules", []).reject { |name| CATCH_ALL_MODULES.include?(name) }
    topics = normalize_all(modules)
    topics = normalize_all([audit.fetch("primary_topic")]) if topics.empty?
    topics
  end

  private

  def root_topics(audit)
    names = if audit.fetch("primary_topic") == "Elektrotechnik-Prüfungstraining"
              audit.fetch("secondary_topics", [])
            else
              [audit.fetch("primary_topic")]
            end
    normalize_all(names)
  end

  def normalize_all(names)
    names.flat_map { |name| normalize(name) }.reject(&:empty?).uniq.sort
  end

  def normalize(name)
    cleaned = name.to_s.sub(/\s*\(neu\)\z/, "").strip
    NORMALIZATIONS.fetch(cleaned, [cleaned])
  end
end

class CategoryResolver
  VALID_CATEGORIES = %w[
    Anwendungsentwicklung
    Deutsch_Englisch_Kommunikation
    Elektrotechnik
    IT_Technik_und_Sicherheit
    Religion_Ethik
    Wirtschaft_und_Recht
  ].freeze

  AE_TOPICS = [
    "Algorithmus", "Arrays und Datenstrukturen", "Eingaben und Zufallszahlen in Java",
    "Entwicklungswerkzeuge und Debugging", "EVA-Prinzip", "Java-Grundlagen",
    "Java-Syntax und Codestruktur", "Methoden, Parameter und Rückgabewerte",
    "Objektorientierung", "Operatoren und Bedingungen", "Programm und Software",
    "Programmablaufdarstellungen", "Programmiersprachen und Übersetzer",
    "Rekursion und Iteration", "Schleifen", "Softwareanpassung und Dokumentation",
    "Softwarelebenszyklus und Vorgehensmodelle", "Softwarequalität und Wartbarkeit",
    "Suchalgorithmen", "Unternehmenswiki", "Variablen und Datentypen"
  ].freeze

  BASELINE_IT_TOPICS = [
    "BSI-Modellierung", "Backup und Datensicherung", "Binärzahlen",
    "Computergrundbegriffe", "Datenschutz und Rollen", "Exchange- und Outlook-Sicherheit",
    "Hochverfügbarkeit und Redundanz", "IPv4-Adressierung und Subnetting",
    "IT-Sicherheit Grundlagen", "Kryptografie, Hash und Signatur",
    "Malware und Angriffe", "Mobile Sicherheit", "Netzwerktechnik und Netzplan",
    "Physische Sicherheit und Infrastruktur", "Risikoanalyse",
    "SI- und IEC-Dateneinheiten", "Schutzbedarfsfeststellung",
    "Sicherheitsmanagement und ISMS", "Sicherheitsmanagement und Maßnahmen",
    "Strukturanalyse und Informationsverbund", "Umsetzungsplanung"
  ].freeze

  LANGUAGE_PATTERN = /(Applying|Business Communication|Company |Company Websites|Corporate Identity|Fremdwörter|Geschäftsbrief|Groß-|Introducing|IT Jobs|IT Vocabulary|Kommasetzung|Kommunikation|Making Phone|Ordering Technical|Projektmanagement Lastenheft|Reading Comprehension|Useful Phrases|das oder dass)/i
  RELIGION_PATTERN = /(Freiheit und Selbstbestimmung|Gewissen und Verantwortung|Karwoche|Nelson Mandela|Religion Ethik|Symbole und Glaube)/i
  ELECTRICAL_PATTERN = /(Elektr|Netzteil|Ohmsches|Spannung, Strom|Reihen-, Parallel|SI-Vorsätze und Einheitenumrechnung)/i
  BUSINESS_PATTERN = /(Angebotsvergleich|Ausbildung|Ausbildungsvertrag|Besitz, Eigentum|Betrieb und Unternehmen|Betriebsrat|Bezugskalkulation|Bundesurlaub|Beschaffungs|Elterngeld|Jugendarbeitsschutz|Kaufvertrag|Kündigung|Marktumfeld|Mutterschutz|Organisation im Betrieb|Produktionsfaktoren|Projektplanung|Rechtsformen|Schwerbehinderung|Tarifvertrag|Unternehmensrecht|Unternehmensziele|Wirtschaftlichkeit|Wirtschaftssektoren)/i

  def initialize(explicit_categories: {})
    @explicit = VaultSupport.category_registry.merge(explicit_categories || {})
    invalid = @explicit.reject { |_topic, category| VALID_CATEGORIES.include?(category) }
    unless invalid.empty?
      raise "Ungültige Themenkategorien: #{invalid.inspect}. Erlaubt: #{VALID_CATEGORIES.join(', ')}"
    end
  end

  def category(topic)
    return @explicit[topic] if @explicit.key?(topic)
    return "Anwendungsentwicklung" if AE_TOPICS.include?(topic)
    return "IT_Technik_und_Sicherheit" if BASELINE_IT_TOPICS.include?(topic)
    return "Deutsch_Englisch_Kommunikation" if topic.match?(LANGUAGE_PATTERN)
    return "Religion_Ethik" if topic.match?(RELIGION_PATTERN)
    return "Elektrotechnik" if topic.match?(ELECTRICAL_PATTERN)
    return "Wirtschaft_und_Recht" if topic.match?(BUSINESS_PATTERN)

    raise "Neues Thema '#{topic}' hat keine Kategorie. Bitte in 01_Index/Themen_Kategorien.json oder unter topic_categories im Import-Audit zuordnen (#{VALID_CATEGORIES.join(', ')})."
  end
end

class PathFactory
  def initialize(category_resolver: CategoryResolver.new)
    @category_resolver = category_resolver
  end

  def topic_path(topic)
    category = @category_resolver.category(topic)
    TOPIC_ROOT.join(category, "#{safe_filename(topic)}.md")
  end

  def category(topic)
    @category_resolver.category(topic)
  end

  def topic_id(topic)
    ascii = topic.unicode_normalize(:nfkd).encode("ASCII", invalid: :replace, undef: :replace, replace: "")
    slug = ascii.downcase.gsub(/[^a-z0-9]+/, ".").gsub(/\A\.|\.\z/, "")
    "vault.thema.visuell.#{slug}"
  end

  private

  def safe_filename(topic)
    topic.unicode_normalize(:nfc).gsub("/", " und ").delete(",").gsub(/[\\:*?\"<>|]/, "-").strip
  end
end

class FrontmatterEditor
  def update(text, values)
    lines = text.lines
    raise "Frontmatter fehlt" unless lines.first&.strip == "---"

    closing = lines.each_index.drop(1).find { |index| lines[index].strip == "---" }
    raise "Frontmatter ist nicht geschlossen" unless closing

    frontmatter = lines[1...closing]
    values.each_key { |key| remove_key(frontmatter, key) }
    values.each { |key, value| frontmatter << "#{key}: #{render(value)}\n" unless value.nil? }
    ([lines.first] + frontmatter + lines[closing..-1]).join
  end

  private

  def remove_key(lines, key)
    index = lines.index { |line| line.match?(/^#{Regexp.escape(key)}:/) }
    return unless index

    lines.delete_at(index)
    lines.delete_at(index) while lines[index]&.match?(/^\s+/)
  end

  def render(value)
    case value
    when String then JSON.generate(value)
    when TrueClass, FalseClass, Integer then value.to_s
    when Array then JSON.generate(value)
    else JSON.generate(value)
    end
  end
end

class SourceNoteSanitizer
  def sanitize(text, page_decisions)
    page_decisions.sort_by { |decision| decision.page.fetch("page") }.each do |decision|
      next unless decision.excluded?

      text = replace_page_section(text, decision)
    end
    text
  end

  private

  def replace_page_section(text, decision)
    number = decision.page.fetch("page")
    lines = text.lines
    start_index = lines.index { |line| line.strip == "### Seite #{number}" }
    raise "Seitenabschnitt fehlt: #{decision.page.fetch('source_note')} Seite #{number}" unless start_index

    end_index = ((start_index + 1)...lines.length).find do |index|
      lines[index].match?(/^### Seite \d+\s*$/) || lines[index].match?(/^## [^#]/)
    end || lines.length

    privacy = decision.reason.match?(/Personenbezogen|persönlich/i)
    kind = privacy ? "privacy" : "warning"
    heading = privacy ? "Personenbezogene Seite – vom KI-Quelltext ausgeschlossen" : "Vom kanonischen KI-Quelltext ausgeschlossen"
    replacement = [
      "### Seite #{number}\n",
      "\n",
      "> [!#{kind}] #{heading}\n",
      "> Grund: #{decision.reason}. Die Originalseite bleibt lokal erhalten, wird hier aber weder eingebettet noch als Lernwissen indexiert.\n",
      "\n"
    ]
    (lines[0...start_index] + replacement + lines[end_index..-1].to_a).join
  end
end

class SourceNoteRestorer
  def initialize(worklist_path: WORKLIST_PATH)
    worklist = JSON.parse(File.read(worklist_path, encoding: "UTF-8"))
    @pages = worklist.fetch("pages").to_h { |page| [page.fetch("id"), page] }
  end

  def restore(text, decisions)
    decisions.reject(&:excluded?).sort_by { |decision| decision.page.fetch("page") }.each do |decision|
      text = restore_page(text, decision) if sanitized_page?(text, decision.page.fetch("page"))
    end
    text
  end

  private

  def sanitized_page?(text, number)
    body = page_body(text, number)
    body && body.include?("Vom kanonischen KI-Quelltext ausgeschlossen")
  end

  def restore_page(text, decision)
    page = decision.page
    number = page.fetch("page")
    source_text = @pages.fetch(page.fetch("id")).fetch("source_text")
    raise "Archivierter Seitenquelltext enthält Codezaun: #{page.fetch('id')}" if source_text.include?("```")

    pdf_path = page.fetch("pdf_path")
    pdf_label = File.basename(pdf_path)
    replacement = <<~MARKDOWN
      ### Seite #{number}

      > [!referenz] Exakte Referenz
      > - PDF-Seite: [#{pdf_label} Seite #{number}](<#{pdf_path}#page=#{number}>)
      > - Obsidian-Einbettung: `![[#{pdf_path}#page=#{number}]]`

      > [!example]- Originalseite im PDF-Layout anzeigen
      > ![[#{pdf_path}#page=#{number}]]

      > [!verified] Quelltext aus der unveränderten Audit-Arbeitsliste wiederhergestellt
      > Die Seite war irrtümlich als reine Navigation gesperrt. Sichtprüfung und Teilreport bestätigen eigenständigen fachlichen Inhalt.

      #### Extrahierter Originaltext für Suche und KI

      ```text
      #{source_text.rstrip}
      ```

    MARKDOWN
    replace_page_body(text, number, replacement)
  end

  def page_body(text, number)
    match = text.match(/^### Seite #{number}\s*$\n(.*?)(?=^### Seite \d+\s*$|^## [^#]|\z)/m)
    match && match[1]
  end

  def replace_page_body(text, number, replacement)
    pattern = /^### Seite #{number}\s*$\n.*?(?=^### Seite \d+\s*$|^## [^#]|\z)/m
    raise "Zu restaurierender Seitenabschnitt fehlt: Seite #{number}" unless text.match?(pattern)

    text.sub(pattern, replacement)
  end
end

class SensitiveDataRedactor
  def redact(text, decisions)
    decisions.sort_by { |decision| decision.page.fetch("page") }.each do |decision|
      page = decision.page.fetch("page")
      text = transform_page(text, page) do |body|
        cleaned_body = body
          .gsub(/\n?> \[!ocr\] Kein verwertbarer Text auf dieser Seite\n> [^\n]*\n/m, "\n")
          .gsub(/\n?> \[!ocr\] OCRplus-Nachtrag integriert\n> [^\n]*\n/m, "\n")
        next cleaned_body if cleaned_body.include?("Datenschutzsichere Inhaltszusammenfassung")

        primary = decision.page.dig("audit", "primary_topic")
        secondary = decision.page.dig("audit", "secondary_topics").to_a.join(", ")
        topics = decision.topics.join(", ")
        safe_summary = <<~MARKDOWN
          #### Datenschutzsichere Inhaltszusammenfassung

          > [!privacy] Rohdaten aus diesem Seitenblock entfernt
          > Personen-, Firmen-, Kontakt-, Bank-, Register- und vergleichbare Identifikationsdaten sowie problematische unkontextualisierte Formulierungen werden nicht an KI-Systeme weitergegeben. Für Zahlen oder Layout ist die lokale Originalseite maßgeblich.

          - Visuell bestätigtes Hauptthema: **#{primary}**
          - Kanonische Themen: **#{topics}**
          - Ergänzende Einordnung: #{secondary.empty? ? "keine" : secondary}
          - Inhaltstyp: #{decision.page.dig("audit", "content_type")}
        MARKDOWN
        replaced = cleaned_body.sub(/#### [^\n]*(?:Suche und KI|OCR)[^\n]*\n\n```text\n.*?\n```/m, safe_summary.rstrip)
        raise "Sensitiver Originaltextblock fehlt: Seite #{page}" if replaced == cleaned_body

        replaced
      end
    end
    text
  end

  private

  def transform_page(text, number)
    lines = text.lines
    start_index = lines.index { |line| line.strip == "### Seite #{number}" }
    raise "Sensitiver Seitenabschnitt fehlt: Seite #{number}" unless start_index

    end_index = ((start_index + 1)...lines.length).find do |index|
      lines[index].match?(/^### Seite \d+\s*$/) || lines[index].match?(/^## [^#]/)
    end || lines.length
    body = lines[(start_index + 1)...end_index].join
    lines[0..start_index].join + yield(body) + lines[end_index..-1].to_a.join
  end
end

class SourceNoteWriter
  TABLE_HEADER = "| Thema | Prüfung | Seiten | Warum die Referenz sinnvoll ist |\n"
  TABLE_SEPARATOR = "|---|---|---:|---|\n"

  def initialize(path_factory:, policy:, frontmatter_editor: FrontmatterEditor.new, sanitizer: SourceNoteSanitizer.new, restorer: SourceNoteRestorer.new, redactor: SensitiveDataRedactor.new)
    @path_factory = path_factory
    @policy = policy
    @frontmatter_editor = frontmatter_editor
    @sanitizer = sanitizer
    @restorer = restorer
    @redactor = redactor
  end

  def write(source_note, decisions)
    path = ROOT.join(source_note)
    original = File.read(path, encoding: "UTF-8")
    whole_reason = @policy.whole_source_reason(source_note, decisions)
    text = replace_reference_table(original, source_note, decisions, whole_reason)
    text = @sanitizer.sanitize(text, decisions)
    text = @restorer.restore(text, decisions)
    sensitive_decisions = decisions.select(&:sensitive?)
    text = @redactor.redact(text, sensitive_decisions) unless whole_reason

    excluded_pages = decisions.select(&:excluded?).map { |decision| decision.page.fetch("page") }.sort
    support_pages = decisions.select(&:supporting?).map { |decision| decision.page.fetch("page") }.sort
    sensitive_pages = sensitive_decisions.map { |decision| decision.page.fetch("page") }.sort
    topic_count = decisions.flat_map(&:topics).uniq.length
    canonical_page_count = decisions.count { |decision| !decision.excluded? }
    text_status = effective_text_status(decisions, whole_reason)
    source_audit_date = decisions.map { |decision| VaultSupport.page_audit_date(decision.page) }.max
    values = {
      "seitenaudit" => "visuell_vollstaendig",
      "seitenaudit_datum" => source_audit_date,
      "kanonische_referenzen" => whole_reason.nil?,
      "kanonische_themen" => topic_count,
      "seiten_mit_kanonischem_thema" => canonical_page_count,
      "ki_exclude_seiten" => excluded_pages.empty? ? nil : excluded_pages,
      "ki_exclude_grund" => whole_reason || (excluded_pages.empty? ? nil : "Siehe vollständigen visuellen Seitenaudit und neutrale Sperrnotizen in den betroffenen Seitenabschnitten"),
      "ki_support_seiten" => support_pages.empty? ? nil : support_pages,
      "ki_sensitive_seiten" => sensitive_pages.empty? ? nil : sensitive_pages,
      "ki_exclude" => whole_reason ? true : nil,
      "duplikat_von" => File.basename(source_note) == "IT_Sicherheit_Aufgabe_1_1.md" ? "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1.md#Seite 2" : nil,
      "lernstatus" => learning_status(source_note, whole_reason),
      "textstatus" => text_status
    }
    text = text.sub(/^> - \*\*KI-Lesbarkeit:\*\*.*$/, "> - **KI-Lesbarkeit:** #{text_status}")
    text = text.sub(/^> - \*\*Aktive Lernquelle:\*\*.*$/, "> - **Aktive Lernquelle:** #{whole_reason ? 'nein – technisch ausgeschlossen' : 'ja'}")
    text = @frontmatter_editor.update(text, values)
    text = @frontmatter_editor.update(text, "textzeichen" => text.scan(/```text\n(.*?)\n```/m).sum { |match| match.first.length })
    VaultSupport.write_if_changed(path, text)
  end

  private

  def learning_status(source_note, whole_reason)
    base = File.basename(source_note)
    return "duplikat" if base == "IT_Sicherheit_Aufgabe_1_1.md" && whole_reason
    return "reparaturbedarf" if base == "IT_Sicherheit_Fachbegriffe.md" && whole_reason
    return "navigation_ohne_evidenz" if whole_reason

    "aktiv"
  end

  def replace_reference_table(text, source_note, decisions, whole_reason)
    lines = text.lines
    header_index = lines.index do |line|
      line.match?(/^\|\s*Thema\s*\|/) && line.include?("Prüfung") && line.include?("Seiten") && line.include?("Warum die Referenz sinnvoll ist")
    end
    raise "Referenztabelle fehlt: #{source_note}" unless header_index

    separator = lines[header_index + 1]
    raise "Unerwarteter Tabellenkopf: #{source_note}" unless separator&.start_with?("|") && separator.include?("---")

    end_index = header_index + 2
    end_index += 1 while lines[end_index]&.start_with?("|")
    prefix = lines[0...header_index].join
    suffix = lines[end_index..-1].to_a.join
    replacement = [TABLE_HEADER, TABLE_SEPARATOR] + reference_rows(decisions, whole_reason)
    updated = prefix + replacement.join + suffix
    raise "Prefix beim Tabellenersatz verändert: #{source_note}" unless updated.start_with?(prefix)
    raise "Suffix beim Tabellenersatz verändert: #{source_note}" unless updated.end_with?(suffix)

    updated
  end

  def reference_rows(decisions, whole_reason)
    return ["| _Keine kanonische Themenreferenz_ | – | – | #{escape(whole_reason)}. |\n"] if whole_reason

    grouped = Hash.new { |hash, key| hash[key] = [] }
    decisions.each do |decision|
      next if decision.excluded?

      decision.topics.each { |topic| grouped[topic] << decision }
    end
    grouped.sort.map do |topic, topic_decisions|
      relative = @path_factory.topic_path(topic).relative_path_from(ROOT).to_s.delete_suffix(".md")
      pages = VaultSupport.compact_ranges(topic_decisions.map { |decision| decision.page.fetch("page") })
      support = topic_decisions.count(&:supporting?)
      unsafe = topic_decisions.count { |decision| !decision.quote_safe? }
      note = "Visuell bestätigt auf #{topic_decisions.length} Seite(n)"
      note += "; #{support} Fragmentseite(n) nur unterstützend" if support.positive?
      note += "; bei #{unsafe} Seite(n) OCR/Original für exakte Zitate prüfen" if unsafe.positive?
      "| [[#{relative}\\|#{escape(topic)}]] | Prüfungsrahmen der Quelle | #{pages} | #{note}. |\n"
    end
  end

  def effective_text_status(decisions, whole_reason)
    return "kritisch: #{whole_reason}" if whole_reason

    included = decisions.reject(&:excluded?)
    counts = included.each_with_object(Hash.new(0)) { |decision, result| result[decision.effective_source_text_status] += 1 }
    details = %w[ok ocr_verified redacted_summary partial ocr_error missing].map { |key| "#{key}=#{counts[key]}" if counts[key].positive? }.compact
    prefix = counts.keys == ["ok"] ? "gut" : (counts["ok"].positive? ? "gemischt" : "eingeschränkt")
    "#{prefix}: visuell geprüft (#{details.join(', ')})"
  end

  def escape(text)
    text.to_s.gsub("|", "\\|")
  end
end

class TopicWriter
  def initialize(path_factory:, audit_date:)
    @path_factory = path_factory
    @audit_date = audit_date
  end

  def write(catalog)
    FileUtils.mkdir_p(TOPIC_ROOT)
    verify_owned_files!

    desired = {}
    catalog.sort.each do |topic, decisions|
      path = @path_factory.topic_path(topic)
      desired[path.to_s] = true
      VaultSupport.write_if_changed(path, topic_document(topic, decisions))
    end

    # Nur wirklich veraltete Themendateien löschen (iCloud-schonend, kein rm_rf!).
    Dir.glob(TOPIC_ROOT.join("**/*.md").to_s).each do |existing|
      File.delete(existing) unless desired.key?(existing)
    end
    Dir.glob(TOPIC_ROOT.join("*").to_s).select { |entry| File.directory?(entry) }.each do |dir|
      Dir.rmdir(dir) if Dir.children(dir).empty?
    end

    VaultSupport.write_if_changed(TOPIC_INDEX, topic_index(catalog))
  end

  private

  def verify_owned_files!
    files = Dir.glob(TOPIC_ROOT.join("**/*.md").to_s)
    unowned = files.reject { |path| File.read(path, encoding: "UTF-8").include?("generated_by: build_verified_topics.rb") }
    raise "Nicht-generierte Datei unter #{TOPIC_ROOT}: #{unowned.join(', ')}" unless unowned.empty?
  end

  def topic_document(topic, decisions)
    grouped = decisions.group_by { |decision| decision.page.fetch("source_note") }
    topic_date = decisions.map { |decision| VaultSupport.page_audit_date(decision.page) }.max
    rows = grouped.sort.map do |source_note, source_decisions|
      pages = VaultSupport.compact_ranges(source_decisions.map { |decision| decision.page.fetch("page") })
      pdf_path = source_decisions.first.page.fetch("pdf_path")
      first_page = source_decisions.map { |decision| decision.page.fetch("page") }.min
      types = source_decisions.map { |decision| decision.page.dig("audit", "content_type") }.uniq.sort.join(", ")
      unsafe = source_decisions.count { |decision| !decision.quote_safe? }
      quality = unsafe.zero? ? "Text für Zitate geeignet" : "#{unsafe} Seite(n): OCR/Original prüfen"
      source_link = source_note.delete_suffix(".md")
      label = File.basename(source_note, ".md")
      "| [[#{source_link}\\|#{label}]] | [#{pages}](<#{pdf_path}#page=#{first_page}>) | #{types} | #{quality} |"
    end.join("\n")
    category = @path_factory.category(topic)
    <<~MARKDOWN
      ---
      id: #{@path_factory.topic_id(topic)}
      typ: visuell_geprueftes_thema
      status: visuell_geprueft
      stand: #{topic_date}
      reviewed_on: #{topic_date}
      generated_by: build_verified_topics.rb
      rag_include: true
      canonical_evidence: false
      thema: #{JSON.generate(topic)}
      kategorie: #{category}
      quellen: #{grouped.length}
      seiten: #{decisions.length}
      tags:
        - ki_quelle
        - visuell_geprueft
        - thema
      ---

      # #{topic}

      Diese Themenseite wurde ausschließlich aus der vollständigen visuellen PDF-Seitenprüfung abgeleitet. Sie ordnet Belege ein; fachliche Aussagen müssen aus der verlinkten Quellnotiz stammen und bei OCR-, Layout-, Zahlen-, Code- oder Rechtsfragen am Original geprüft werden.

      ## Verifizierte Belege

      | Aktive Quellnotiz | PDF-Seiten | Inhaltstyp | Text-/Zitatstatus |
      |---|---:|---|---|
      #{rows}

      ## Belegregel für GPT

      - Nur die oben aufgeführten Seiten als Beleg für **#{topic}** verwenden.
      - Ausgeschlossene Seiten, alte Themenseiten und generierte Lernmodule nicht als Faktenquelle behandeln.
      - Bei „OCR/Original prüfen“ nicht wörtlich aus dem OCR-Text zitieren; die verlinkte PDF-Seite visuell kontrollieren.
      - Fragmentseiten sind höchstens unterstützend und dürfen keine Aussage allein tragen.
    MARKDOWN
  end

  def topic_index(catalog)
    grouped = catalog.keys.group_by { |topic| @path_factory.category(topic) }
    sections = grouped.sort.map do |category, topics|
      links = topics.sort.map do |topic|
        relative = @path_factory.topic_path(topic).relative_path_from(ROOT).to_s.delete_suffix(".md")
        "- [[#{relative}|#{topic}]]"
      end.join("\n")
      "## #{category.tr('_', ' ')}\n\n#{links}"
    end.join("\n\n")
    <<~MARKDOWN
      ---
      id: vault.themen.kuratierter-index
      typ: themenindex
      status: visuell_geprueft
      stand: #{@audit_date}
      reviewed_on: #{@audit_date}
      generated_by: build_verified_topics.rb
      ki_prioritaet: 1
      canonical_evidence: false
      rag_include: true
      tags:
        - navigation
        - ki_quelle
        - visuell_geprueft
        - themenindex
      ---

      # Visuell geprüfte Themen

      Dieser Index enthält **#{catalog.length} kanonische Themen**. Jede Zuordnung beruht auf der Sichtprüfung der konkreten PDF-Seite. Themenseiten navigieren; Quellnotiz und Original-PDF belegen.

      #{sections}

      ## Belegreihenfolge

      1. Thema hier auswählen.
      2. Verlinkte aktive Quellnotiz und genaue Seite öffnen.
      3. Für Zitate, Zahlen, Formeln, Code, Tabellen und Rechtsnormen das Original visuell prüfen.
    MARKDOWN
  end
end

class OutputWriter
  def initialize(path_factory:, policy:, audit_date:)
    @path_factory = path_factory
    @policy = policy
    @audit_date = audit_date
  end

  def write(audit, decisions, catalog)
    mapping = build_mapping(audit, decisions, catalog)
    VaultSupport.write_json_if_changed(MAPPING_OUTPUT, mapping)
    write_quality_report(audit, decisions, catalog)
    sync_audit_markdown(mapping.fetch("totals"))
    sync_category_registry(audit.fetch("topic_categories", {}))
  end

  private

  def build_mapping(audit, decisions, catalog)
    sources = decisions.group_by { |decision| decision.page.fetch("source_note") }.sort.to_h do |source_note, source_decisions|
      [source_note, {
        "pages" => source_decisions.length,
        "canonical_pages" => source_decisions.count { |decision| !decision.excluded? },
        "excluded_pages" => source_decisions.select(&:excluded?).map { |decision| decision.page.fetch("page") }.sort,
        "support_only_pages" => source_decisions.select(&:supporting?).map { |decision| decision.page.fetch("page") }.sort,
        "topics" => source_decisions.flat_map(&:topics).uniq.sort
      }]
    end
    topics = catalog.sort.to_h do |topic, topic_decisions|
      [topic, {
        "path" => @path_factory.topic_path(topic).relative_path_from(ROOT).to_s,
        "category" => @path_factory.category(topic),
        "pages" => topic_decisions.map { |decision| decision.page.fetch("id") }.sort
      }]
    end
    page_rows = decisions.map do |decision|
      {
        "id" => decision.page.fetch("id"),
        "status" => decision.status,
        "canonical_topics" => decision.topics,
        "source_text_status" => decision.effective_source_text_status,
        "quote_safe" => decision.quote_safe?,
        "exclusion_reason" => decision.reason
      }.reject { |_key, value| value.nil? }
    end
    {
      "schema_version" => 1,
      "audit_date" => @audit_date,
      "basis" => AUDIT_PATH.relative_path_from(ROOT).to_s,
      "privacy" => "Der private Notenbereich wurde nicht gelesen. Personenbilder in aktiven Quellen wurden aus indexierbaren Seitenblöcken entfernt.",
      "totals" => {
        "audited_active_pdfs" => audit.dig("totals", "active_pdfs"),
        "audited_active_pages" => decisions.length,
        "canonical_topics" => catalog.length,
        "canonical_evidence_pages" => decisions.count { |decision| decision.status == "evidence" },
        "support_only_pages" => decisions.count(&:supporting?),
        "excluded_active_pages" => decisions.count(&:excluded?),
        "proven_duplicate_pdfs" => audit.dig("totals", "visually_identical_duplicate_pdfs"),
        "proven_duplicate_pages" => audit.dig("totals", "visually_identical_duplicate_pages")
      },
      "sources" => sources,
      "topics" => topics,
      "pages" => page_rows
    }
  end

  def write_quality_report(audit, decisions, catalog)
    reason_rows = decisions.select(&:excluded?).group_by(&:reason).sort.map do |reason, rows|
      "| #{reason} | #{rows.length} |"
    end.join("\n")
    source_rows = decisions.group_by { |decision| decision.page.fetch("source_note") }.sort.map do |source_note, rows|
      excluded = rows.select(&:excluded?)
      next if excluded.empty?

      pages = VaultSupport.compact_ranges(excluded.map { |decision| decision.page.fetch("page") })
      "| `#{source_note}` | #{pages} |"
    end.compact.join("\n")
    category_rows = catalog.keys.group_by { |topic| @path_factory.category(topic) }.sort.map do |category, topics|
      "| #{category.tr('_', ' ')} | #{topics.length} |"
    end.join("\n")
    totals = audit.fetch("totals")
    VaultSupport.write_if_changed(QUALITY_OUTPUT, <<~MARKDOWN)
      ---
      id: vault.index.ki-quellenqualitaet
      typ: qualitaetsbericht
      status: abgeschlossen
      stand: #{@audit_date}
      rag_include: false
      tags:
        - seitenaudit
        - ki_qualitaet
        - datenschutz
      ---

      # KI-Quellenqualität nach vollständiger Sichtprüfung

      ## Ergebnis

      - **#{totals.fetch('nonprivate_pdfs_accounted_for')} nicht-private PDFs / #{totals.fetch('nonprivate_pages_accounted_for')} Seiten** vollständig berücksichtigt.
      - **#{totals.fetch('active_pdfs')} aktive PDFs / #{decisions.length} Seiten** seitenweise visuell geprüft.
      - **#{totals.fetch('visually_identical_duplicate_pdfs')} inaktive PDFs / #{totals.fetch('visually_identical_duplicate_pages')} Seiten** als pixelidentische Dubletten nachgewiesen.
      - **#{catalog.length} kanonische Themen** mit exakten Seitenbelegen erzeugt.
      - **#{decisions.count { |decision| decision.status == 'evidence' }} Evidenzseiten**, **#{decisions.count(&:supporting?)} nur unterstützende Fragmentseiten**, **#{decisions.count(&:excluded?)} ausgeschlossene aktive Seiten**.
      - Der private Notenbereich und seine PDF wurden nicht geöffnet, gerendert, geOCRt oder inhaltlich inventarisiert.

      ## Ausschlussgründe

      | Grund | Seiten |
      |---|---:|
      #{reason_rows}

      ## Betroffene aktive Quellen

      | Quellnotiz | Ausgeschlossene PDF-Seiten |
      |---|---:|
      #{source_rows}

      ## Themen nach Bereich

      | Bereich | Themen |
      |---|---:|
      #{category_rows}

      ## Technische Schutzwirkung

      - Referenztabellen verweisen nur noch auf `03_Themen/Visuell_geprueft/`.
      - Ausgeschlossene Seitenblöcke enthalten keine PDF-Einbettung und keinen extrahierten Inhalt mehr.
      - Ganze unbrauchbare oder doppelte Quellnotizen tragen `ki_exclude: true`.
      - Kontakt-, Bank- und vergleichbare Unterrichts-Beispieldaten werden in indexierbaren Texten redigiert.
      - Maschinenlesbare Details: [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>), [PDF_Seitenaudit.json](<PDF_Seitenaudit.json>).
    MARKDOWN
  end

  def sync_audit_markdown(mapping_totals)
    return unless AUDIT_MD_PATH.file?

    markdown = File.read(AUDIT_MD_PATH, encoding: "UTF-8")
    updated = VaultSupport.with_canonical_section(markdown, mapping_totals)
    VaultSupport.write_if_changed(AUDIT_MD_PATH, updated)
  end

  def sync_category_registry(import_categories)
    return if import_categories.empty? || !VaultSupport::CATEGORY_REGISTRY.file?

    registry = VaultSupport.read_json(VaultSupport::CATEGORY_REGISTRY)
    merged = registry.fetch("topics", {}).merge(import_categories).sort.to_h
    registry["topics"] = merged
    VaultSupport.write_json_if_changed(VaultSupport::CATEGORY_REGISTRY, registry)
  end
end

class Validator
  def initialize(policy:)
    @policy = policy
  end

  def validate_input!(audit, decisions, catalog, path_factory)
    raise "Mindestens #{BASELINE_MIN_ACTIVE_PAGES} aktive Seiten erwartet (gefunden: #{decisions.length})" if decisions.length < BASELINE_MIN_ACTIVE_PAGES
    raise "Nicht jede Seite wurde visuell geprüft" unless decisions.all? { |decision| decision.page.dig("audit", "visual_checked") == true }

    uncovered = decisions.reject(&:excluded?).select { |decision| decision.topics.empty? }
    raise "Nicht ausgeschlossene Seiten ohne Thema: #{uncovered.map { |decision| decision.page.fetch('id') }.join(', ')}" unless uncovered.empty?

    contaminated = decisions.select(&:excluded?).reject { |decision| decision.topics.empty? }
    raise "Ausgeschlossene Seiten tragen Themen" unless contaminated.empty?

    paths = catalog.keys.map { |topic| path_factory.topic_path(topic).to_s }
    raise "Kollision bei Themendateinamen" unless paths.uniq.length == paths.length
    raise "Audit-Gesamtzahl stimmt nicht" unless audit.dig("totals", "active_pages") == decisions.length
  end

  def validate_output!(audit, decisions, catalog, path_factory)
    raise "Mapping-Ausgabe fehlt" unless MAPPING_OUTPUT.file?
    raise "Qualitätsbericht fehlt" unless QUALITY_OUTPUT.file?
    raise "Themenindex fehlt" unless TOPIC_INDEX.file?

    catalog.each_key { |topic| raise "Themendatei fehlt: #{topic}" unless path_factory.topic_path(topic).file? }

    by_source = decisions.group_by { |decision| decision.page.fetch("source_note") }
    by_source.each do |source_note, source_decisions|
      text = File.read(ROOT.join(source_note), encoding: "UTF-8")
      expected_pages = source_decisions.length
      headings = text.scan(/^### Seite (\d+)\s*$/).flatten.map(&:to_i)
      raise "Seitenanker unvollständig: #{source_note}" unless headings.sort == (1..expected_pages).to_a

      table_section = text.split("## 🎯 Geprüfte und sinnvolle Referenzen", 2).fetch(1).split(/^## /, 2).first
      raise "Alte Lernordner-Referenz: #{source_note}" if table_section.include?("/10_Lernordner/")

      links = table_section.scan(/\[\[(03_Themen\/Visuell_geprueft\/[^\\|\]]+)/).flatten
      links.each { |link| raise "Fehlendes Themenziel: #{link}" unless ROOT.join("#{link}.md").file? }
      source_decisions.each do |decision|
        page = decision.page.fetch("page")
        body = page_body(text, page)
        if decision.excluded?
          raise "Ausgeschlossene Seite wird eingebettet: #{source_note} #{page}" if body.include?("![[")
        else
          expected = "#page=#{page}"
          raise "Kanonischer Seitenlink fehlt: #{source_note} #{page}" unless body.include?(expected)
        end
      end
    end
    mapping = JSON.parse(File.read(MAPPING_OUTPUT))
    raise "Mapping-Seitenzahl stimmt nicht" unless mapping.fetch("pages").length == audit.dig("totals", "active_pages")
  end

  private

  def page_body(text, number)
    match = text.match(/^### Seite #{number}\s*$\n(.*?)(?=^### Seite \d+\s*$|^## [^#]|\z)/m)
    raise "Seitenkörper fehlt: Seite #{number}" unless match

    match[1]
  end
end

audit = JSON.parse(File.read(AUDIT_PATH, encoding: "UTF-8"))
audit_date = VaultSupport.latest_audit_date(audit)
policy = ExclusionPolicy.new
mapper = TopicMapper.new
decisions = audit.fetch("pages").map do |page|
  reason = policy.exclusion_reason(page)
  status = reason ? "excluded" : (policy.support_only?(page) ? "support_only" : "evidence")
  topics = reason ? [] : mapper.topics_for(page)
  PageDecision.new(page: page, topics: topics, status: status, reason: reason, sensitive: policy.sensitive_page?(page))
end
catalog = Hash.new { |hash, key| hash[key] = [] }
decisions.each { |decision| decision.topics.each { |topic| catalog[topic] << decision } }
category_resolver = CategoryResolver.new(explicit_categories: audit.fetch("topic_categories", {}))
path_factory = PathFactory.new(category_resolver: category_resolver)
validator = Validator.new(policy: policy)
validator.validate_input!(audit, decisions, catalog, path_factory)

TopicWriter.new(path_factory: path_factory, audit_date: audit_date).write(catalog)
decisions.group_by { |decision| decision.page.fetch("source_note") }.each do |source_note, source_decisions|
  SourceNoteWriter.new(path_factory: path_factory, policy: policy).write(source_note, source_decisions)
end
OutputWriter.new(path_factory: path_factory, policy: policy, audit_date: audit_date).write(audit, decisions, catalog)
validator.validate_output!(audit, decisions, catalog, path_factory)

puts "Wrote #{catalog.length} verified topics; #{decisions.count(&:excluded?)} excluded and #{decisions.count(&:supporting?)} support-only pages."
