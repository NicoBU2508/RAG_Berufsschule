#!/usr/bin/env ruby
# frozen_string_literal: true

# Synchronisiert, prueft und exportiert visuell belegte Karteikarten unter 05_Karteikarten/.
#
# Verwendung:
#   ruby 01_Index/Tools/sync_karteikarten.rb [sync]
#   ruby 01_Index/Tools/sync_karteikarten.rb status [--pending] [--category KATEGORIE] [--json]
#   ruby 01_Index/Tools/sync_karteikarten.rb init-deck "<Thema>"
#   ruby 01_Index/Tools/sync_karteikarten.rb refresh-meta "<Thema>"
#   ruby 01_Index/Tools/sync_karteikarten.rb drill "<Thema|Kategorie|all>" [--shuffle] [--limit N] [--json]
#   ruby 01_Index/Tools/sync_karteikarten.rb export-anki [--out /pfad/zum/ordner]
#   ruby 01_Index/Tools/sync_karteikarten.rb export-notebooklm [--out /pfad/zum/ordner]
#
# Sicherheits- und iCloud-Garantien:
# - Kanonische Themenbasis ist ausschliesslich 01_Index/Themenreferenzen_Visuell_Geprueft.json.
# - Greift niemals auf 98_Archiv_nicht_lernen/, 00_Posteingang_GoodNotes/ oder .obsidian/ zu.
# - Schreibt Dateien im Vault nur bei echter inhaltlicher Aenderung (VaultSupport.write_if_changed).

require "cgi"
require "date"
require "digest"
require "fileutils"
require "json"
require "optparse"
require "pathname"
require "yaml"
require_relative "lib/vault_support"

class KarteikartenManager
  ROOT = VaultSupport::ROOT
  CARDS_ROOT = ROOT.join("05_Karteikarten")
  INDEX_PATH = CARDS_ROOT.join("00_Karteikarten_Index.md")
  STATUS_JSON_PATH = ROOT.join("01_Index/Karteikarten_Status.json")

  DEFAULT_ANKI_OUT = Pathname.new("/tmp/ap_lernhelfer_exports/anki")
  DEFAULT_NOTEBOOKLM_OUT = Pathname.new("/tmp/ap_lernhelfer_exports/notebooklm")

  CATEGORY_ORDER = %w[
    Anwendungsentwicklung
    IT_Technik_und_Sicherheit
    Wirtschaft_und_Recht
    Elektrotechnik
    Deutsch_Englisch_Kommunikation
    Religion_Ethik
  ].freeze

  CATEGORY_LABELS = {
    "Anwendungsentwicklung" => "Anwendungsentwicklung",
    "IT_Technik_und_Sicherheit" => "IT-Technik und Sicherheit",
    "Wirtschaft_und_Recht" => "Wirtschaft und Recht",
    "Elektrotechnik" => "Elektrotechnik",
    "Deutsch_Englisch_Kommunikation" => "Deutsch, Englisch und Kommunikation",
    "Religion_Ethik" => "Religion und Ethik"
  }.freeze

  NOTEBOOKLM_FILES = {
    "Anwendungsentwicklung" => "01_Anwendungsentwicklung_Karteikarten.md",
    "IT_Technik_und_Sicherheit" => "02_IT_Technik_und_Sicherheit_Karteikarten.md",
    "Wirtschaft_und_Recht" => "03_Wirtschaft_und_Recht_Karteikarten.md",
    "Elektrotechnik" => "04_Elektrotechnik_Karteikarten.md",
    "Deutsch_Englisch_Kommunikation" => "05_Deutsch_Englisch_Kommunikation_Karteikarten.md",
    "Religion_Ethik" => "06_Religion_Ethik_Karteikarten.md"
  }.freeze

  def initialize
    abort "FEHLER: Mapping fehlt (#{VaultSupport::MAPPING_PATH})" unless VaultSupport::MAPPING_PATH.file?

    @mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
    @audit_date = @mapping.fetch("audit_date", VaultSupport.latest_audit_date)
    @topics = @mapping.fetch("topics")
  end

  def run(argv)
    cmd = argv.first && !argv.first.start_with?("-") ? argv.shift : "sync"
    case cmd
    when "sync"
      cmd_sync
    when "status"
      cmd_status(argv)
    when "init-deck"
      cmd_init_deck(argv)
    when "refresh-meta"
      cmd_refresh_meta(argv)
    when "drill"
      cmd_drill(argv)
    when "export-anki"
      cmd_export_anki(argv)
    when "export-notebooklm"
      cmd_export_notebooklm(argv)
    when "-h", "--help", "help"
      print_help
    else
      abort "Unbekannter Befehl: #{cmd}\nNutze --help für eine Übersicht."
    end
  end

  # ---------- Subcommands ----------

  def cmd_sync
    state = analyze_state
    status_written = VaultSupport.write_json_if_changed(STATUS_JSON_PATH, state)
    index_written = VaultSupport.write_if_changed(INDEX_PATH, build_index_markdown(state))

    t = state["totals"]
    puts "Karteikarten-Sync abgeschlossen (Stand #{@audit_date}):"
    puts "  Decks vorhanden: #{t['decks_total']} / #{t['canonical_topics']} Themen (#{t['cards_total']} Karten)"
    puts "  Aktuell: #{t['decks_aktuell']} | Update nötig: #{t['decks_update_noetig']} | Fehlend: #{t['topics_ohne_deck']}"
    if t["decks_update_noetig"].positive?
      puts "  ⚠️  Update nötig für:"
      state["decks_update_noetig"].each do |entry|
        puts "     - #{entry['thema']} (+#{entry['neue_seiten'].length} neue / -#{entry['entfernte_seiten'].length} entfernte Seiten)"
      end
    end
    puts "  Dateien aktualisiert: #{[status_written ? 'Karteikarten_Status.json' : nil, index_written ? '00_Karteikarten_Index.md' : nil].compact.join(', ').then { |s| s.empty? ? 'keine (unverändert)' : s }}"
  end

  def cmd_status(argv)
    only_pending = false
    category_filter = nil
    as_json = false

    OptionParser.new do |o|
      o.on("--pending", "Nur Decks mit Update-Bedarf und fehlende Themen anzeigen") { only_pending = true }
      o.on("--category CAT", "Nach Kategorie filtern") { |v| category_filter = v }
      o.on("--json", "Als JSON ausgeben") { as_json = true }
    end.parse!(argv)

    state = analyze_state
    if as_json
      puts JSON.pretty_generate(state)
      return
    end

    t = state["totals"]
    puts "# Karteikarten-Status (Quellenstand #{@audit_date})"
    puts "- Kanonische Themen: **#{t['canonical_topics']}**"
    puts "- Decks vorhanden: **#{t['decks_total']}** (**#{t['cards_total']}** Karten gesamt)"
    puts "- Aktuell: **#{t['decks_aktuell']}** · Update nötig: **#{t['decks_update_noetig']}** · Noch ohne Deck: **#{t['topics_ohne_deck']}**"

    updates = filter_by_cat(state["decks_update_noetig"], category_filter)
    unless updates.empty?
      puts "\n## Update nötig (neue/geänderte Quellseiten)"
      updates.each do |d|
        puts "- **#{d['thema']}** (`#{d['kategorie']}`) → `#{d['deck_path']}` (#{d['karten_anzahl']} Karten)"
        d["neue_seiten"].each { |p| puts "  + NEU: `#{p}`" }
        d["entfernte_seiten"].each { |p| puts "  - ENTFERNT: `#{p}`" }
      end
    end

    unless only_pending
      aktuell = filter_by_cat(state["decks_aktuell"], category_filter)
      unless aktuell.empty?
        puts "\n## Aktuelle Decks (#{aktuell.length})"
        aktuell.each do |d|
          puts "- **#{d['thema']}** (`#{d['kategorie']}`) · #{d['karten_anzahl']} Karten · #{d['quellseiten_anzahl']} Quellseiten · `#{d['deck_path']}`"
        end
      end
    end

    missing = filter_by_cat(state["topics_ohne_deck"], category_filter)
    unless missing.empty?
      puts "\n## Noch ohne Deck (#{missing.length})"
      missing.group_by { |m| m["kategorie"] }.each do |cat, items|
        puts "### #{cat} (#{items.length})"
        items.each { |m| puts "- #{m['thema']} (#{m['quellseiten_anzahl']} S.)" }
      end
    end
  end

  def cmd_init_deck(argv)
    query = argv.join(" ").strip
    abort "Bitte Thema angeben: init-deck \"<Thema>\"" if query.empty?

    topic_name, info = resolve_topic!(query)
    deck_rel = deck_rel_for(info)
    deck_abs = ROOT.join(deck_rel)

    if deck_abs.file?
      puts "Deck existiert bereits: #{deck_rel}"
      return
    end

    pages = info.fetch("pages", []).map(&:to_s).sort
    hash = pages_fingerprint(pages)
    category = info.fetch("category")
    tag_slug = "#{slugify(category)}/#{slugify(topic_name)}"
    topic_link = info.fetch("path").sub(/\.md\z/, "")
    today = Date.today.strftime("%Y-%m-%d")

    content = <<~MARKDOWN
      ---
      typ: karteikarten_deck
      thema: #{topic_name.to_json}
      kategorie: #{category}
      thema_quelle: #{info.fetch('path').to_json}
      stand_karten: #{today}
      stand_quelle: #{@audit_date}
      quellseiten_anzahl: #{pages.length}
      quellseiten_hash: #{hash}
      quellseiten:
      #{pages.map { |p| "  - #{p.to_json}" }.join("\n")}
      rag_include: false
      canonical_evidence: false
      tags:
        - karteikarten
        - flashcards/#{tag_slug}
      ---

      # 🗂️ Karteikarten: #{topic_name}

      > [!tip] Quellenbasis
      > Alle Karten basieren ausschließlich auf [[#{topic_link}|#{topic_name}]] (**#{pages.length} visuell geprüfte Seiten**).

      ---

      <!-- card-id: #{slugify(topic_name)}-01 | typ: definition | pruefung: AP1/AP2 -->
      **Frage hier eintragen**
      ?
      Antwort hier eintragen.
      *Quelle: Fach · `Datei.pdf` S. X (von N) · [[Quellnotiz]]*
    MARKDOWN

    VaultSupport.write_if_changed(deck_abs, content)
    puts "Deck-Gerüst angelegt: #{deck_rel}"
    puts "Quellseiten: #{pages.length} (Hash: #{hash})"
  end

  def cmd_refresh_meta(argv)
    query = argv.join(" ").strip
    abort "Bitte Thema angeben: refresh-meta \"<Thema>\"" if query.empty?

    topic_name, info = resolve_topic!(query)
    deck_rel = deck_rel_for(info)
    deck_abs = ROOT.join(deck_rel)
    abort "Deck nicht gefunden: #{deck_rel}" unless deck_abs.file?

    raw = File.read(deck_abs, encoding: "UTF-8")
    fm, body = split_frontmatter(raw)
    abort "Ungültiges Frontmatter in #{deck_rel}" unless fm

    pages = info.fetch("pages", []).map(&:to_s).sort
    hash = pages_fingerprint(pages)
    today = Date.today.strftime("%Y-%m-%d")

    fm["thema"] = topic_name
    fm["kategorie"] = info.fetch("category")
    fm["thema_quelle"] = info.fetch("path")
    fm["stand_karten"] = today
    fm["stand_quelle"] = @audit_date
    fm["quellseiten_anzahl"] = pages.length
    fm["quellseiten_hash"] = hash
    fm["quellseiten"] = pages
    fm["rag_include"] = false
    fm["canonical_evidence"] = false

    updated_body = body.sub(/\(\*\*\d+ visuell geprüfte Seiten\*\*\)/, "(**#{pages.length} visuell geprüfte Seiten**)")
    rebuilt = dump_frontmatter(fm) + updated_body
    VaultSupport.write_if_changed(deck_abs, rebuilt)
    puts "Metadaten aktualisiert: #{deck_rel} (#{pages.length} Seiten, Hash #{hash})"
    cmd_sync
  end

  def cmd_drill(argv)
    shuffle = false
    limit = nil
    as_json = false

    OptionParser.new do |o|
      o.on("--shuffle", "Karten zufällig mischen") { shuffle = true }
      o.on("--limit N", Integer, "Maximal N Karten ausgeben") { |v| limit = v }
      o.on("--json", "Strukturiertes JSON ausgeben") { as_json = true }
    end.parse!(argv)

    target = argv.join(" ").strip
    abort "Bitte Thema, Kategorie oder 'all' angeben." if target.empty?

    decks = collect_all_decks
    matched = if target.casecmp("all").zero?
                decks
              else
                q = target.downcase
                decks.select do |d|
                  d[:thema].downcase == q ||
                    d[:kategorie].downcase == q ||
                    d[:thema].downcase.include?(q) ||
                    d[:kategorie].downcase.include?(q)
                end
              end

    if matched.empty?
      puts "Keine fertigen Karteikarten-Decks für '#{target}' gefunden."
      puts "Tipp: Mit `init-deck \"#{target}\"` + `vault_lookup.rb topic \"#{target}\"` zuerst Karten aus den visuell geprüften Quellen erstellen."
      exit 0
    end

    cards = matched.flat_map { |d| d[:cards] }
    cards = cards.shuffle if shuffle
    cards = cards.first(limit) if limit && limit.positive?

    if as_json
      puts JSON.pretty_generate({ target: target, count: cards.length, cards: cards })
      return
    end

    puts "# Drill-Set: #{target} (#{cards.length} Karten aus #{matched.length} Deck(s))"
    cards.each_with_index do |c, idx|
      puts "\n## Karte #{idx + 1}/#{cards.length} [#{c[:id]}] · #{c[:thema]} (#{c[:typ]} | #{c[:pruefung]})"
      puts "**Q:** #{c[:front]}"
      puts "**A:** #{c[:back]}"
      puts "**Quelle:** #{c[:source]}" unless c[:source].empty?
    end
  end

  def cmd_export_anki(argv)
    out_dir = DEFAULT_ANKI_OUT
    OptionParser.new do |o|
      o.on("--out DIR", "Zielordner für Anki-TSV-Dateien") { |v| out_dir = Pathname.new(v).expand_path }
    end.parse!(argv)

    decks = collect_all_decks
    all_cards = decks.flat_map { |d| d[:cards] }
    if all_cards.empty?
      puts "Keine Karteikarten unter 05_Karteikarten/ vorhanden – Anki-Export übersprungen."
      return
    end

    FileUtils.mkdir_p(out_dir)
    written = []

    # 1. Gesamt-Export
    master_path = out_dir.join("AP_Lernhelfer_Alle_Karten.tsv")
    written << master_path.basename.to_s if VaultSupport.write_if_changed(master_path, build_anki_tsv(all_cards))

    # 2. Export pro Kategorie
    all_cards.group_by { |c| c[:kategorie] }.each do |cat, cards|
      file_path = out_dir.join("AP_Lernhelfer_#{cat}.tsv")
      written << file_path.basename.to_s if VaultSupport.write_if_changed(file_path, build_anki_tsv(cards))
    end

    # 3. Kurze Import-Anleitung
    readme_path = out_dir.join("README_ANKI_IMPORT.txt")
    readme = <<~TEXT
      Anki-Import (AP-Lernhelfer)
      ===========================
      1. In Anki: Datei -> Importieren -> "AP_Lernhelfer_Alle_Karten.tsv" (oder eine Fachdatei) auswählen.
      2. Anki erkennt die Kopfzeilen (#separator:tab, #html:true, #deck column:5, #tags column:6) automatisch.
      3. Feldzuordnung prüfen (Notiztyp mit 4 Feldern empfohlen: ID, Vorderseite, Rückseite, Quelle — oder Standard-Einfach: ID + Vorderseite mappen):
         - Spalte 1: Karten-ID (stabil -> Updates überschreiben bestehende Karten ohne Lernfortschritt zu verlieren!)
         - Spalte 2: Vorderseite (Frage)
         - Spalte 3: Rückseite (Antwort + Quelle)
         - Spalte 4: Quelle (separat)
         - Spalte 5: Stapelname (AP-Lernhelfer::<Kategorie>::<Thema>)
         - Spalte 6: Schlagwörter (Tags)
      4. Bei "Vorhandene Notizen": "Aktualisieren, wenn erstes Feld übereinstimmt" wählen.
    TEXT
    written << readme_path.basename.to_s if VaultSupport.write_if_changed(readme_path, readme)

    puts "Anki-Export abgeschlossen → #{out_dir}"
    puts "  Karten exportiert: #{all_cards.length} aus #{decks.length} Deck(s)"
    puts "  Aktualisierte Dateien: #{written.empty? ? 'keine (unverändert)' : written.join(', ')}"
  end

  def cmd_export_notebooklm(argv)
    out_dir = DEFAULT_NOTEBOOKLM_OUT
    OptionParser.new do |o|
      o.on("--out DIR", "Zielordner für NotebookLM-Karteikarten-Pakete") { |v| out_dir = Pathname.new(v).expand_path }
    end.parse!(argv)

    decks = collect_all_decks
    if decks.empty?
      puts "Keine Karteikarten unter 05_Karteikarten/ vorhanden – NotebookLM-Export übersprungen."
      return
    end

    FileUtils.mkdir_p(out_dir)
    written = []

    by_cat = decks.group_by { |d| d[:kategorie] }
    by_cat.each do |cat, cat_decks|
      filename = NOTEBOOKLM_FILES.fetch(cat, "#{cat}_Karteikarten.md")
      content = build_notebooklm_markdown(cat, cat_decks)
      written << filename if VaultSupport.write_if_changed(out_dir.join(filename), content)
    end

    overview = build_notebooklm_overview(decks)
    written << "00_Karteikarten_Uebersicht_NotebookLM.md" if VaultSupport.write_if_changed(out_dir.join("00_Karteikarten_Uebersicht_NotebookLM.md"), overview)

    puts "NotebookLM-Export abgeschlossen → #{out_dir}"
    puts "  Decks exportiert: #{decks.length} (#{decks.sum { |d| d[:cards].length }} Karten)"
    puts "  Aktualisierte Dateien: #{written.empty? ? 'keine (unverändert)' : written.join(', ')}"
  end

  private

  # ---------- Analysis & Parsing ----------

  def analyze_state
    decks_by_path = {}
    collect_all_decks.each { |d| decks_by_path[d[:deck_path]] = d }

    decks_aktuell = []
    decks_update_noetig = []
    topics_ohne_deck = []
    matched_paths = {}

    @topics.sort_by { |name, info| [CATEGORY_ORDER.index(info["category"]) || 99, name.downcase] }.each do |topic_name, info|
      cat = info.fetch("category")
      deck_rel = deck_rel_for(info)
      current_pages = info.fetch("pages", []).map(&:to_s).sort
      current_hash = pages_fingerprint(current_pages)

      deck = decks_by_path[deck_rel]
      if deck
        matched_paths[deck_rel] = true
        deck_pages = Array(deck[:quellseiten]).map(&:to_s).sort
        deck_hash = deck[:quellseiten_hash].to_s

        neue = current_pages - deck_pages
        entfernte = deck_pages - current_pages
        entry = {
          "thema" => topic_name,
          "kategorie" => cat,
          "deck_path" => deck_rel,
          "thema_quelle" => info.fetch("path"),
          "karten_anzahl" => deck[:cards].length,
          "quellseiten_anzahl" => current_pages.length,
          "stand_karten" => deck[:stand_karten],
          "stand_quelle" => @audit_date,
          "quellseiten_hash_aktuell" => current_hash,
          "quellseiten_hash_deck" => deck_hash,
          "neue_seiten" => neue,
          "entfernte_seiten" => entfernte
        }

        if deck_hash == current_hash && neue.empty? && entfernte.empty?
          decks_aktuell << entry
        else
          decks_update_noetig << entry
        end
      else
        topics_ohne_deck << {
          "thema" => topic_name,
          "kategorie" => cat,
          "thema_quelle" => info.fetch("path"),
          "erwarteter_deck_pfad" => deck_rel,
          "quellseiten_anzahl" => current_pages.length
        }
      end
    end

    verwaiste_decks = decks_by_path.reject { |path, _| matched_paths[path] }.values.map do |d|
      {
        "thema" => d[:thema],
        "kategorie" => d[:kategorie],
        "deck_path" => d[:deck_path],
        "karten_anzahl" => d[:cards].length
      }
    end

    cards_total = (decks_aktuell + decks_update_noetig).sum { |d| d["karten_anzahl"] } +
                  verwaiste_decks.sum { |d| d["karten_anzahl"] }

    {
      "schema_version" => 1,
      "stand_quelle" => @audit_date,
      "totals" => {
        "canonical_topics" => @topics.length,
        "decks_total" => decks_aktuell.length + decks_update_noetig.length,
        "decks_aktuell" => decks_aktuell.length,
        "decks_update_noetig" => decks_update_noetig.length,
        "topics_ohne_deck" => topics_ohne_deck.length,
        "verwaiste_decks" => verwaiste_decks.length,
        "cards_total" => cards_total
      },
      "decks_update_noetig" => decks_update_noetig,
      "decks_aktuell" => decks_aktuell,
      "topics_ohne_deck" => topics_ohne_deck,
      "verwaiste_decks" => verwaiste_decks
    }
  end

  def collect_all_decks
    return [] unless CARDS_ROOT.directory?

    Dir.glob(CARDS_ROOT.join("**/*.md").to_s).sort.map do |abs_path|
      rel = VaultSupport.relative(abs_path)
      next if rel == "05_Karteikarten/00_Karteikarten_Index.md"

      parse_deck(Pathname.new(abs_path), rel)
    end.compact
  end

  def parse_deck(abs_path, rel_path)
    raw = File.read(abs_path, encoding: "UTF-8")
    fm, body = split_frontmatter(raw)
    return nil unless fm && fm["typ"].to_s == "karteikarten_deck"

    thema = fm["thema"].to_s.strip
    kategorie = fm["kategorie"].to_s.strip
    cards = parse_cards(body, thema: thema, kategorie: kategorie, deck_path: rel_path)

    {
      thema: thema,
      kategorie: kategorie,
      deck_path: rel_path,
      stand_karten: fm["stand_karten"].to_s,
      stand_quelle: fm["stand_quelle"].to_s,
      quellseiten_hash: fm["quellseiten_hash"].to_s,
      quellseiten: Array(fm["quellseiten"]),
      cards: cards
    }
  end

  def parse_cards(body, thema:, kategorie:, deck_path:)
    cards = []
    # Jede Karte startet mit <!-- card-id: ... --> und enthaelt eine ?-Trennlinie
    blocks = body.split(/(?=<!--\s*card-id:)/)
    blocks.each do |block|
      next unless block.lstrip.start_with?("<!--")

      header_match = block.match(/\A<!--\s*card-id:\s*([^|]+?)(?:\s*\|\s*typ:\s*([^|]+?))?(?:\s*\|\s*pruefung:\s*([^>]+?))?\s*-->\s*\n(.*)\z/m)
      next unless header_match

      card_id = header_match[1].strip
      typ = (header_match[2] || "wissen").strip
      pruefung = (header_match[3] || "AP1/AP2").strip
      content = header_match[4].sub(/\n---\s*\z/m, "").strip

      parts = content.split(/^\?\s*$/, 2)
      next unless parts.length == 2

      front = parts[0].strip
      back_lines = parts[1].strip.lines.map(&:rstrip)
      source = ""
      if back_lines.last&.match?(/\A\*Quelle:.*\*\z/)
        source = back_lines.pop.sub(/\A\*Quelle:\s*/, "").sub(/\*\z/, "").strip
      end
      back = back_lines.join("\n").strip

      cards << {
        id: card_id,
        typ: typ,
        pruefung: pruefung,
        thema: thema,
        kategorie: kategorie,
        deck_path: deck_path,
        front: front,
        back: back,
        source: source
      }
    end
    cards
  end

  # ---------- Index & Export Builders ----------

  def build_index_markdown(state)
    t = state["totals"]
    lines = []
    lines << "---"
    lines << "typ: karteikarten_index"
    lines << "stand: #{@audit_date}"
    lines << "rag_include: false"
    lines << "canonical_evidence: false"
    lines << "---"
    lines << "# 🗂️ Karteikarten Index"
    lines << ""
    lines << "> [!tip] Single Source of Truth"
    lines << "> Alle Karteikarten unter `05_Karteikarten/` basieren ausschließlich auf den **visuell geprüften Themen** (`03_Themen/Visuell_geprueft/`). Sie funktionieren direkt mit **Obsidian Spaced Repetition**, dem **Antigravity Karteikarten-Modus** sowie per Export mit **Anki** und **NotebookLM**."
    lines << ""
    lines << "## Überblick (Stand #{@audit_date})"
    lines << ""
    lines << "- **Aktive Decks:** **#{t['decks_total']}** von **#{t['canonical_topics']}** kanonischen Themen (**#{t['cards_total']}** Karten gesamt)"
    lines << "- **Aktuell:** #{t['decks_aktuell']} · **Update nötig (neue PDF-Seiten):** #{t['decks_update_noetig']} · **Noch ohne Deck:** #{t['topics_ohne_deck']}"
    lines << ""
    lines << "### Schnellbefehle"
    lines << ""
    lines << "```bash"
    lines << "ruby 01_Index/Tools/sync_karteikarten.rb status --pending"
    lines << "ruby 01_Index/Tools/sync_karteikarten.rb export-anki"
    lines << "ruby 01_Index/Tools/sync_karteikarten.rb export-notebooklm"
    lines << "```"
    lines << ""

    unless state["decks_update_noetig"].empty?
      lines << "## ⚠️ Decks mit Update-Bedarf (neue Quellseiten)"
      lines << ""
      lines << "| Thema | Kategorie | Deck | Neue Seiten |"
      lines << "|---|---|---|---:|"
      state["decks_update_noetig"].each do |d|
        link = d["deck_path"].sub(/\.md\z/, "")
        lines << "| #{d['thema']} | #{d['kategorie']} | [[#{link}\\|Deck öffnen]] | +#{d['neue_seiten'].length} / -#{d['entfernte_seiten'].length} |"
      end
      lines << ""
    end

    all_active = (state["decks_aktuell"] + state["decks_update_noetig"]).sort_by { |d| [CATEGORY_ORDER.index(d["kategorie"]) || 99, d["thema"].downcase] }
    lines << "## Aktive Karteikarten-Decks"
    lines << ""
    if all_active.empty?
      lines << "_Noch keine Decks angelegt._"
      lines << ""
    else
      all_active.group_by { |d| d["kategorie"] }.each do |cat, decks|
        lines << "### #{CATEGORY_LABELS.fetch(cat, cat)}"
        lines << ""
        decks.each do |d|
          link = d["deck_path"].sub(/\.md\z/, "")
          badge = d["neue_seiten"].empty? && d["entfernte_seiten"].empty? ? "🟢 aktuell" : "🟡 Update nötig"
          lines << "- [[#{link}|#{d['thema']}]] — **#{d['karten_anzahl']} Karten** (#{d['quellseiten_anzahl']} Quellseiten · #{badge})"
        end
        lines << ""
      end
    end

    lines << "## Noch ohne Karteikarten-Deck (#{t['topics_ohne_deck']})"
    lines << ""
    lines << "> [!note] Schrittweiser Aufbau"
    lines << "> Neue Decks entstehen gezielt nach Prüfungsrelevanz (AP1/AP2) oder direkt im **Antigravity Karteikarten-Modus** aus den jeweiligen visuell geprüften Themen."
    lines << ""
    state["topics_ohne_deck"].group_by { |m| m["kategorie"] }.each do |cat, items|
      lines << "### #{CATEGORY_LABELS.fetch(cat, cat)} (#{items.length})"
      lines << ""
      items.each do |m|
        topic_link = m["thema_quelle"].sub(/\.md\z/, "")
        lines << "- [[#{topic_link}|#{m['thema']}]] (#{m['quellseiten_anzahl']} S.)"
      end
      lines << ""
    end

    lines << "## Historische Lernordner-Karten (Archiv)"
    lines << ""
    lines << "> [!warning] Nicht mehr gepflegt"
    lines << "> Die früheren automatisch erzeugten Karten in den `10_Lernordner/`-Dateien (Stand 2026-06-19) beruhen auf ungeprüften Keyword-Zuordnungen und werden nicht mehr aktiv verwendet."
    lines << ""

    lines.join("\n")
  end

  def build_anki_tsv(cards)
    lines = [
      "#separator:tab",
      "#html:true",
      "#deck column:5",
      "#tags column:6"
    ]
    cards.each do |c|
      deck_name = "AP-Lernhelfer::#{CATEGORY_LABELS.fetch(c[:kategorie], c[:kategorie])}::#{c[:thema]}"
      front_html = markdown_to_anki_html(c[:front])
      source_clean = strip_wikilinks(c[:source])
      back_html = markdown_to_anki_html(c[:back])
      back_with_source = source_clean.empty? ? back_html : "#{back_html}<br><br><small><i>Quelle: #{CGI.escapeHTML(source_clean)}</i></small>"
      tags = [
        "ap_lernhelfer",
        slugify(c[:kategorie]),
        slugify(c[:thema]),
        "typ_#{slugify(c[:typ])}"
      ].join(" ")

      row = [c[:id], front_html, back_with_source, source_clean, deck_name, tags].map { |field| sanitize_tsv(field) }
      lines << row.join("\t")
    end
    lines.join("\n") + "\n"
  end

  def build_notebooklm_markdown(cat, decks)
    label = CATEGORY_LABELS.fetch(cat, cat)
    lines = [
      "# Karteikarten-Paket: #{label}",
      "",
      "- **Stand Quellen:** #{@audit_date}",
      "- **Decks:** #{decks.length} · **Karten gesamt:** #{decks.sum { |d| d[:cards].length }}",
      "- **Hinweis:** Alle Fragen und Antworten stammen ausschließlich aus visuell geprüften Berufsschul-Unterlagen.",
      ""
    ]
    decks.sort_by { |d| d[:thema].downcase }.each do |d|
      lines << "## #{d[:thema]} (#{d[:cards].length} Karten)"
      lines << ""
      d[:cards].each_with_index do |c, idx|
        lines << "### #{idx + 1}. #{c[:front].gsub(/\*\*/, '')}"
        lines << ""
        lines << "**Antwort:** #{c[:back]}"
        lines << ""
        lines << "**Typ:** #{c[:typ]} · **Prüfung:** #{c[:pruefung]} · **Quelle:** #{strip_wikilinks(c[:source])}" unless c[:source].empty?
        lines << ""
      end
    end
    lines.join("\n")
  end

  def build_notebooklm_overview(decks)
    lines = [
      "# AP-Lernhelfer – Karteikarten-Übersicht für NotebookLM",
      "",
      "- **Quellenstand:** #{@audit_date}",
      "- **Aktive Decks:** #{decks.length}",
      "- **Karten gesamt:** #{decks.sum { |d| d[:cards].length }}",
      "",
      "## Enthaltene Themen",
      ""
    ]
    decks.sort_by { |d| [CATEGORY_ORDER.index(d[:kategorie]) || 99, d[:thema].downcase] }.each do |d|
      lines << "- **#{d[:thema]}** (#{CATEGORY_LABELS.fetch(d[:kategorie], d[:kategorie])}) — #{d[:cards].length} Karten"
    end
    lines.join("\n") + "\n"
  end

  # ---------- Helpers ----------

  def resolve_topic!(query)
    return [query, @topics[query]] if @topics.key?(query)

    q = query.downcase
    exact_ci = @topics.find { |name, _| name.downcase == q }
    return exact_ci if exact_ci

    partial = @topics.select { |name, _| name.downcase.include?(q) }
    return partial.first if partial.length == 1

    if partial.length > 1
      abort "Mehrdeutiges Thema '#{query}'. Treffer:\n  - #{partial.keys.join("\n  - ")}"
    end
    abort "Thema '#{query}' nicht in 01_Index/Themenreferenzen_Visuell_Geprueft.json gefunden."
  end

  def deck_rel_for(topic_info)
    topic_info.fetch("path").sub(%r{\A03_Themen/Visuell_geprueft/}, "05_Karteikarten/")
  end

  def pages_fingerprint(pages)
    Digest::SHA256.hexdigest(pages.map(&:to_s).sort.join("\n"))[0, 12]
  end

  def filter_by_cat(list, category_filter)
    return list unless category_filter

    q = category_filter.downcase
    list.select { |item| item["kategorie"].to_s.downcase.include?(q) }
  end

  def split_frontmatter(raw)
    return [nil, raw] unless raw.start_with?("---\n")

    parts = raw.split(/^---\s*$\n?/, 3)
    return [nil, raw] unless parts.length == 3

    parsed = begin
      YAML.safe_load(parts[1], permitted_classes: [Date])
    rescue ArgumentError
      YAML.safe_load(parts[1], [Date])
    end
    [parsed, parts[2]]
  end

  def dump_frontmatter(fm)
    yaml = YAML.dump(fm).sub(/\A---\s*\n/, "")
    "---\n#{yaml}---\n"
  end

  def slugify(str)
    str.to_s
       .downcase
       .gsub("ä", "ae").gsub("ö", "oe").gsub("ü", "ue").gsub("ß", "ss")
       .gsub(/[^a-z0-9]+/, "-")
       .gsub(/\A-+|-+\z/, "")
  end

  def strip_wikilinks(text)
    text.to_s.gsub(/\[\[([^\]|]+)\|([^\]]+)\]\]/, '\2').gsub(/\[\[([^\]]+)\]\]/, '\1')
  end

  def markdown_to_anki_html(text)
    escaped = CGI.escapeHTML(strip_wikilinks(text))
    escaped
      .gsub(/\*\*(.+?)\*\*/, '<b>\1</b>')
      .gsub(/`([^`]+)`/, '<code>\1</code>')
      .gsub(/\*(.+?)\*/, '<i>\1</i>')
      .gsub("\n", "<br>")
  end

  def sanitize_tsv(text)
    text.to_s.gsub("\t", " ").gsub(/\r?\n/, "<br>").strip
  end

  def print_help
    puts <<~HELP
      Karteikarten-Sync & Export für den Obsidian AP-Lernhelfer

      Befehle:
        ruby 01_Index/Tools/sync_karteikarten.rb [sync]
        ruby 01_Index/Tools/sync_karteikarten.rb status [--pending] [--category KATEGORIE] [--json]
        ruby 01_Index/Tools/sync_karteikarten.rb init-deck "<Thema>"
        ruby 01_Index/Tools/sync_karteikarten.rb refresh-meta "<Thema>"
        ruby 01_Index/Tools/sync_karteikarten.rb drill "<Thema|Kategorie|all>" [--shuffle] [--limit N] [--json]
        ruby 01_Index/Tools/sync_karteikarten.rb export-anki [--out /pfad]
        ruby 01_Index/Tools/sync_karteikarten.rb export-notebooklm [--out /pfad]
    HELP
  end
end

KarteikartenManager.new.run(ARGV)
