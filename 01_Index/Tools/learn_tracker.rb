#!/usr/bin/env ruby
# frozen_string_literal: true

# Persistentes FSRS-4.5-Lerngedaechtnis & Hypercorrection-Fehlerregister fuer ap-lerncoach.
#
# Speichert ausschliesslich lokalen Lernfortschritt in:
#   - 01_Index/Lernstand.json (ai_use: excluded im KI-Manifest)
#   - 04_Pruefung/Fehlerjournal_und_Denkfehler.md (Obsidian-Uebersicht fuer Tag +1 / Tag +7 Pretests)
#   - 04_Pruefung/Lernstand_Dashboard.md (Obsidian-Fortschritts-Cockpit)
#
# Verwendung:
#   ruby 01_Index/Tools/learn_tracker.rb [sync]
#   ruby 01_Index/Tools/learn_tracker.rb briefing [--exam AP1|AP2|BS] [--limit 3] [--as-of YYYY-MM-DD] [--json]
#   ruby 01_Index/Tools/learn_tracker.rb record [--topic "<Thema>"] [--card "<id>"] --grade <1..4> [--confidence <1..3>] [--bloom <1..6>]
#   ruby 01_Index/Tools/learn_tracker.rb record --batch "card-01:3,card-02:1:3,card-03:4"
#   ruby 01_Index/Tools/learn_tracker.rb log-error --topic "<Thema>" --mistake "<Ich dachte X>" --correct "<Es gilt Y>" [--confidence 3] [--type Rechenfalle] [--card "<id>"] [--confused-with "<Partner>"]
#   ruby 01_Index/Tools/learn_tracker.rb resolve-error <ERR-ID> (--pass | --fail) [--as-of YYYY-MM-DD]
#   ruby 01_Index/Tools/learn_tracker.rb set-exam --target <AP1|AP2> [--date YYYY-MM-DD]
#   ruby 01_Index/Tools/learn_tracker.rb status [--exam AP1|AP2|BS] [--json]

require "date"
require "json"
require "optparse"
require "pathname"
require "yaml"
require_relative "lib/vault_support"

module FSRS45
  # Offizielle Open-Source-Standardgewichte (FSRS-4.5 / FSRS-5 Kurzzeit-Erweiterung), Ziel-Retention R = 0.90
  W = [
    0.4072, 1.1829, 3.1262, 15.4722,
    7.2102, 0.5316, 1.0651, 0.0234,
    1.6160, 0.1544, 1.0824, 1.9813,
    0.0953, 0.2975, 2.2042, 0.2407,
    2.9466, 0.5034, 0.6567
  ].freeze

  DECAY = -0.5
  FACTOR = 19.0 / 81.0 # Erfuellt R(t = S, S) = 0.90 exakt

  module_function

  def retrievability(elapsed_days, stability)
    return 1.0 if elapsed_days <= 0
    s = [stability.to_f, 0.1].max
    ((1.0 + FACTOR * (elapsed_days.to_f / s))**DECAY)
  end

  def clamp_d(d)
    [[d.to_f, 1.0].max, 10.0].min
  end

  def init_difficulty(grade)
    clamp_d(W[4] - Math.exp(W[5] * (grade - 1)) + 1.0)
  end

  def init_stability(grade)
    W[grade - 1]
  end

  def next_difficulty(d, grade)
    d0_easy = init_difficulty(4)
    delta = -W[6] * (grade - 3)
    d_prime = d + delta * ((10.0 - d) / 9.0)
    clamp_d(W[7] * d0_easy + (1.0 - W[7]) * d_prime)
  end

  def review(prev_state, grade, today_date)
    g = [[grade.to_i, 1].max, 4].min
    reps = (prev_state && prev_state["reps"]).to_i
    lapses = (prev_state && prev_state["lapses"]).to_i

    if reps.zero? || prev_state.nil? || prev_state["stability"].to_f <= 0
      s = init_stability(g)
      d = init_difficulty(g)
      lapses += 1 if g == 1
      interval = initial_interval_days(g, s)
    else
      s_old = prev_state["stability"].to_f
      d_old = prev_state["difficulty"].to_f
      last_date = parse_date(prev_state["last_review"]) || today_date
      elapsed = [(today_date - last_date).to_i, 0].max
      r = retrievability(elapsed, s_old)
      d = next_difficulty(d_old, g)

      if g == 1
        lapses += 1
        s = W[11] * (d**-W[12]) * (((s_old + 1.0)**W[13]) - 1.0) * Math.exp(W[14] * (1.0 - r))
        s = [[s, 0.4].max, s_old * 0.7].min
        interval = 1
      elsif elapsed.zero?
        # Gleicher Tag (Kurzzeit-Wiederholung ohne kuenstliche Stabilitaetsexplosion)
        s = s_old * Math.exp(W[17] * (g - 3 + W[18]))
        s = [s, 0.5].max
        interval = g == 2 ? 1 : [s.round, 1].max
      else
        hard_penalty = g == 2 ? W[15] : 1.0
        easy_bonus = g == 4 ? W[16] : 1.0
        inc = Math.exp(W[8]) * (11.0 - d) * (s_old**-W[9]) * (Math.exp(W[10] * (1.0 - r)) - 1.0) * hard_penalty * easy_bonus
        s = s_old * (1.0 + inc)
        interval = case g
                   when 2 then [1, (s * 0.85).round].max
                   when 3 then [2, s.round].max
                   when 4 then [4, s.round].max
                   else 1
                   end
      end
    end

    due = today_date + interval
    {
      "stability" => s.round(2),
      "difficulty" => d.round(2),
      "reps" => reps + 1,
      "lapses" => lapses,
      "interval_days" => interval,
      "last_review" => today_date.strftime("%Y-%m-%d"),
      "due_date" => due.strftime("%Y-%m-%d"),
      "last_grade" => g
    }
  end

  def initial_interval_days(grade, stability)
    case grade
    when 1 then 1
    when 2 then 1
    when 3 then [stability.round, 3].max
    when 4 then [stability.round, 10].max
    else 1
    end
  end

  def parse_date(str)
    return nil if str.to_s.strip.empty?

    Date.parse(str.to_s)
  rescue ArgumentError
    nil
  end
end

class LearnTracker
  ROOT = VaultSupport::ROOT
  STATE_PATH = VaultSupport::LERNSTAND_PATH
  JOURNAL_MD_PATH = ROOT.join("04_Pruefung/Fehlerjournal_und_Denkfehler.md")
  DASHBOARD_MD_PATH = ROOT.join("04_Pruefung/Lernstand_Dashboard.md")
  CARDS_ROOT = ROOT.join("05_Karteikarten")
  CARDS_STATUS_PATH = ROOT.join("01_Index/Karteikarten_Status.json")

  ERROR_TYPES = %w[Konzept Rechenfalle IHK-Operator Einheit Syntax Verwechslung].freeze

  def initialize
    abort "FEHLER: Themenindex fehlt (#{VaultSupport::MAPPING_PATH})" unless VaultSupport::MAPPING_PATH.file?
    @mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
    @topics = @mapping.fetch("topics")
    @exam_registry = VaultSupport.exam_registry
    @card_lookup = nil
  end

  def run(argv)
    cmd = argv.first && !argv.first.start_with?("-") ? argv.shift : "sync"
    case cmd
    when "sync", "init"
      cmd_sync(argv)
    when "briefing"
      cmd_briefing(argv)
    when "record"
      cmd_record(argv)
    when "log-error"
      cmd_log_error(argv)
    when "resolve-error"
      cmd_resolve_error(argv)
    when "set-exam"
      cmd_set_exam(argv)
    when "status"
      cmd_status(argv)
    when "-h", "--help", "help"
      print_help
    else
      abort "Unbekannter Befehl: #{cmd}\nNutze --help für eine Übersicht."
    end
  end

  # ---------- Subcommands ----------

  def cmd_sync(argv)
    as_of = Date.today
    OptionParser.new do |o|
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
    end.parse!(argv)

    state = load_state
    save_all!(state, as_of)
    puts "Lernstand & Journale synchronisiert (#{STATE_PATH.relative_path_from(ROOT)}, #{JOURNAL_MD_PATH.relative_path_from(ROOT)}, #{DASHBOARD_MD_PATH.relative_path_from(ROOT)})."
  end

  def cmd_set_exam(argv)
    target = nil
    exam_date = nil
    clear_date = false

    OptionParser.new do |o|
      o.on("--target EXAM", "Aktuelles Prüfungsziel (AP1 oder AP2)") { |v| target = v.strip.upcase }
      o.on("--date DATE", "Geplantes Prüfungsdatum (YYYY-MM-DD)") { |v| exam_date = Date.parse(v).strftime("%Y-%m-%d") }
      o.on("--clear-date", "Prüfungsdatum zurücksetzen") { clear_date = true }
    end.parse!(argv)

    state = load_state
    state["exam_target"] = target if target && !target.empty?
    state["exam_date"] = exam_date if exam_date
    state["exam_date"] = nil if clear_date
    save_all!(state, Date.today)
    puts "Prüfungsziel gespeichert: Ziel=#{state['exam_target']} · Datum=#{state['exam_date'] || 'nicht gesetzt'}"
  end

  def cmd_briefing(argv)
    exam_filter = nil
    limit = 3
    as_of = Date.today
    as_json = false

    OptionParser.new do |o|
      o.on("--exam EXAM", "Prüfungsfokus (Standard aus Lernstand.json, z. B. AP1)") { |v| exam_filter = v }
      o.on("--limit N", Integer, "Anzahl Top-Wiederholungsthemen (Standard: 3)") { |v| limit = v }
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
      o.on("--json", "Als JSON ausgeben") { as_json = true }
    end.parse!(argv)

    state = load_state
    target_exam = (exam_filter || state["exam_target"] || "AP1").to_s.upcase
    report = build_briefing_data(state, target_exam: target_exam, limit: limit, today: as_of)

    if as_json
      puts JSON.pretty_generate(report)
      return
    end

    puts "# 🧠 Lerncoach-Briefing (#{as_of.strftime('%Y-%m-%d')} · Fokus: #{target_exam})"
    days_left_str = report[:days_until_exam] ? " · **Countdown: #{report[:days_until_exam]} Tage bis #{state['exam_date']}**" : ""
    puts "- **Fortschritt (#{target_exam}):** **#{report[:practiced_topics]}/#{report[:total_exam_topics]}** Themen geübt · **#{report[:practiced_cards]}/#{report[:total_exam_cards]}** Karten im FSRS-Gedächtnis (**#{report[:due_cards_count]}** heute fällig)#{days_left_str}"

    if report[:due_errors].any?
      puts "\n## 🔴 1. Heute fällige Hypercorrection-Pretests (#{report[:due_errors].length} von #{report[:open_errors_count]} offenen Denkfehlern)"
      report[:due_errors].first(3).each do |err|
        hc = err["hypercorrection"] ? "⚡ **SICHER FALSCH (Sicherheit 3)**" : "Sicherheit #{err['confidence'] || '-'}"
        stage_lbl = err["stage"].to_i.zero? ? "Tag +1 Pretest" : "Tag +7 Langzeit-Check"
        puts "- **`#{err['id']}` · #{err['topic']}** (#{stage_lbl} · #{hc} · Typ: `#{err['error_type']}`)"
        puts "  - *Denkfehler damals:* #{err['mistake']}"
        puts "  - *Korrektes Prinzip:* #{err['correct_principle']}"
        puts "  - *Nach Abfrage buchen:* `ruby 01_Index/Tools/learn_tracker.rb resolve-error #{err['id']} --pass` (oder `--fail`)"
      end
    elsif report[:open_errors_count].positive?
      puts "\n- 🟢 **Denkfehler-Register:** Keine Pretests heute fällig (#{report[:open_errors_count]} geplant für spätere Tage)."
    end

    if report[:due_topics].any?
      puts "\n## 🟡 2. Top-#{report[:due_topics].length} fällige Wiederholungsthemen heute (FSRS)"
      report[:due_topics].each do |t|
        overdue_lbl = t[:overdue_days].positive? ? "#{t[:overdue_days]}d überfällig" : "heute fällig"
        puts "- **#{t[:topic]}** [#{t[:badge]}] — Abrufwahrscheinlichkeit **#{(t[:retrievability] * 100).round}%** (#{overdue_lbl} · Stabilität #{t[:stability]}d · Fehlversuche #{t[:lapses]})"
      end
    else
      puts "\n- 🟢 **FSRS-Wiederholungen:** Heute sind keine bereits gelernten #{target_exam}-Themen überfällig!"
    end

    if report[:exam_risk_topics].any?
      puts "\n## ⚠️ Prüfungs-Prognose (< 85% Erinnerung am Prüfungstag #{state['exam_date']})"
      report[:exam_risk_topics].first(3).each do |rt|
        puts "- **#{rt[:topic]}** → prognostizierte Erinnerung am Prüfungstag: **#{(rt[:exam_r] * 100).round}%** (vor Prüfung nochmals auffrischen)"
      end
    end

    if report[:due_topics].length < limit && report[:recommended_new_topics].any?
      puts "\n## 🎯 3. Empfohlene neue #{target_exam}-Kernthemen (noch unberührt)"
      report[:recommended_new_topics].each do |nt|
        puts "- **#{nt[:topic]}** [#{nt[:badge]} | #{nt[:category]}] — #{nt[:pages]} Quellseiten#{nt[:hinweis] ? " · *#{nt[:hinweis]}*" : ''}"
      end
    end

    if report[:pending_deck_updates].positive?
      puts "\n- ⚠️ **Karteikarten-Hinweis:** #{report[:pending_deck_updates]} Deck(s) haben neue PDF-Seiten (`sync_karteikarten.rb status --pending`)."
    end
    puts "\n- **Fällige Karten abfragen:** `ruby 01_Index/Tools/sync_karteikarten.rb drill all --exam #{target_exam} --due --front-only --limit 10`"
  end

  def cmd_record(argv)
    topic_query = nil
    card_id = nil
    grade = nil
    confidence = nil
    bloom = nil
    batch_spec = nil
    mistake = nil
    correct = nil
    error_type = "Konzept"
    confused_with = nil
    as_of = Date.today

    OptionParser.new do |o|
      o.on("--topic TOPIC", "Kanonisches Thema") { |v| topic_query = v }
      o.on("--card CARD_ID", "Karten-ID aus 05_Karteikarten/") { |v| card_id = v.strip }
      o.on("--grade N", Integer, "FSRS-Bewertung: 1=Nochmal, 2=Schwer, 3=Gut, 4=Leicht") { |v| grade = v }
      o.on("--confidence N", Integer, "Sicherheit vor Auflösung: 1=geraten, 2=unsicher, 3=sicher") { |v| confidence = v }
      o.on("--bloom N", Integer, "Erreichte Bloom-Stufe (1..6)") { |v| bloom = v }
      o.on("--batch SPEC", "Mehrere Karten auf einmal: 'id1:3,id2:1:3,id3:4' (id:grade[:confidence])") { |v| batch_spec = v }
      o.on("--mistake TEXT", "Optionaler Denkfehler (legt Eintrag im Fehlerjournal an)") { |v| mistake = v.strip }
      o.on("--correct TEXT", "Korrektes Prinzip zum Denkfehler") { |v| correct = v.strip }
      o.on("--type TYPE", "Fehlertyp (#{ERROR_TYPES.join('|')})") { |v| error_type = v.strip }
      o.on("--confused-with TOPIC", "Verwechseltes Partner-Thema") { |v| confused_with = v.strip }
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
    end.parse!(argv)

    state = load_state

    if batch_spec
      recorded = process_batch_cards!(state, batch_spec, as_of)
      save_all!(state, as_of)
      puts "Batch gespeichert (#{recorded.length} Karten aktualisiert):"
      recorded.each do |r|
        puts "  - #{r[:card_id]} (#{r[:topic]}): Bewertung #{r[:grade]} → nächste Fälligkeit #{r[:due_date]} (Stabilität #{r[:stability]}d)"
      end
      return
    end

    abort "Bitte --grade <1..4> angeben (1=Nochmal, 2=Schwer, 3=Gut, 4=Leicht)." unless grade && (1..4).cover?(grade)
    abort "Bitte --topic \"<Thema>\" und/oder --card \"<card-id>\" angeben." if topic_query.to_s.strip.empty? && card_id.to_s.strip.empty?

    canonical_topic = nil
    if card_id && !card_id.empty?
      card_meta = lookup_card(card_id)
      abort "Karten-ID '#{card_id}' nicht unter 05_Karteikarten/ gefunden." unless card_meta
      canonical_topic = card_meta[:thema]
      card_state = update_card_fsrs!(state, card_id, canonical_topic, grade, confidence, as_of)
    end

    canonical_topic ||= resolve_topic!(topic_query)
    topic_state = update_topic_fsrs!(state, canonical_topic, grade, confidence, bloom, as_of, from_single_card: !card_id.nil?)

    logged_err = nil
    if mistake && !mistake.empty?
      corr_text = correct.to_s.empty? ? "Siehe kanonische Quellseiten zu #{canonical_topic}." : correct
      conf_Partner = confused_with && !confused_with.empty? ? resolve_topic_soft(confused_with) : nil
      logged_err = upsert_error!(
        state,
        topic: canonical_topic,
        card_id: card_id,
        mistake: mistake,
        correct_principle: corr_text,
        confidence: confidence || (grade <= 2 ? 2 : 1),
        error_type: error_type,
        confused_with: conf_Partner,
        today: as_of
      )
    end

    save_all!(state, as_of)

    if card_id
      puts "FSRS gespeichert: Karte `#{card_id}` (#{canonical_topic}) · Bewertung #{grade} → fällig am **#{card_state['due_date']}** (S=#{card_state['stability']}d, D=#{card_state['difficulty']})"
    else
      puts "FSRS gespeichert: Thema **#{canonical_topic}** · Bewertung #{grade} → fällig am **#{topic_state['due_date']}** (S=#{topic_state['stability']}d, D=#{topic_state['difficulty']})"
    end
    if logged_err
      puts "Denkfehler protokolliert: `#{logged_err['id']}` (Hypercorrection=#{logged_err['hypercorrection']}) → Pretest fällig am **#{logged_err['due_date']}**"
    elsif grade <= 2 && confidence == 3
      puts "💡 Hinweis: Hohe Sicherheit (3) bei falscher Antwort erkannt! Nutze `log-error --topic \"#{canonical_topic}\" --mistake \"...\" --correct \"...\" --confidence 3`, um den Hypercorrection-Pretest für Tag +1/+7 anzulegen."
    end
  end

  def cmd_log_error(argv)
    topic_query = nil
    card_id = nil
    mistake = nil
    correct = nil
    confidence = 3
    error_type = "Konzept"
    confused_with = nil
    as_of = Date.today

    OptionParser.new do |o|
      o.on("--topic TOPIC", "Kanonisches Thema (Pflicht)") { |v| topic_query = v }
      o.on("--mistake TEXT", "Konkreter Denkfehler, z. B. 'Hostanzahl mit 2^n statt 2^n - 2 berechnet'") { |v| mistake = v.strip }
      o.on("--correct TEXT", "Korrektes Prinzip + kurzes Warum") { |v| correct = v.strip }
      o.on("--confidence N", Integer, "Sicherheit 1..3 (3 = sicher falsch -> Hypercorrection!)") { |v| confidence = v }
      o.on("--type TYPE", "Fehlertyp (#{ERROR_TYPES.join('|')})") { |v| error_type = v.strip }
      o.on("--card CARD_ID", "Optionale Karten-ID") { |v| card_id = v.strip }
      o.on("--confused-with TOPIC", "Optionales verwechseltes Partner-Thema") { |v| confused_with = v.strip }
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
    end.parse!(argv)

    if (topic_query.nil? || topic_query.strip.empty?) && card_id && !card_id.empty?
      cm = lookup_card(card_id)
      topic_query = cm[:thema] if cm
    end

    abort "Bitte --topic \"<Thema>\", --mistake \"...\" und --correct \"...\" angeben." if topic_query.to_s.empty? || mistake.to_s.empty? || correct.to_s.empty?

    canonical_topic = resolve_topic!(topic_query)
    partner = confused_with && !confused_with.empty? ? resolve_topic_soft(confused_with) : nil

    state = load_state
    err = upsert_error!(
      state,
      topic: canonical_topic,
      card_id: card_id,
      mistake: mistake,
      correct_principle: correct,
      confidence: [[confidence.to_i, 1].max, 3].min,
      error_type: error_type,
      confused_with: partner,
      today: as_of
    )
    save_all!(state, as_of)

    hc_tag = err["hypercorrection"] ? "⚡ HYPERCORRECTION (Sicherheit 3)" : "Sicherheit #{err['confidence']}"
    puts "Denkfehler gespeichert: **#{err['id']}** · #{canonical_topic} [#{hc_tag}]"
    puts "  Pretest geplant für: **#{err['due_date']}** (Tag +1 → danach Tag +7)"
  end

  def cmd_resolve_error(argv)
    passed = nil
    as_of = Date.today

    OptionParser.new do |o|
      o.on("--pass", "Pretest erfolgreich gelöst (rückt vor auf Tag +7 bzw. Gemeistert)") { passed = true }
      o.on("--fail", "Erneut gestolpert (zurück auf Tag +1)") { passed = false }
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
    end.parse!(argv)

    err_id = argv.shift.to_s.strip.upcase
    abort "Verwendung: resolve-error <ERR-ID> (--pass | --fail)" if err_id.empty? || passed.nil?

    state = load_state
    err = state["errors"].find { |e| e["id"].to_s.upcase == err_id }
    abort "Fehler-ID '#{err_id}' nicht in #{STATE_PATH.relative_path_from(ROOT)} gefunden." unless err

    today_str = as_of.strftime("%Y-%m-%d")
    err["history"] ||= []
    if passed
      current_stage = err["stage"].to_i
      if current_stage.zero?
        err["stage"] = 1
        err["status"] = "open"
        err["due_date"] = (as_of + 7).strftime("%Y-%m-%d")
        err["history"] << { "date" => today_str, "result" => "pass_day1", "next_due" => err["due_date"] }
        msg = "Tag-+1-Check bestanden! Nächster Langzeit-Check (Tag +7) am **#{err['due_date']}**."
      else
        err["stage"] = 2
        err["status"] = "mastered"
        err["due_date"] = nil
        err["mastered_on"] = today_str
        err["history"] << { "date" => today_str, "result" => "mastered_day7" }
        msg = "🎉 Tag-+7-Check bestanden! Denkfehler `#{err['id']}` gilt jetzt als **dauerhaft gemeistert**."
      end
    else
      err["stage"] = 0
      err["status"] = "open"
      err["lapses"] = err["lapses"].to_i + 1
      err["due_date"] = (as_of + 1).strftime("%Y-%m-%d")
      err["history"] << { "date" => today_str, "result" => "fail", "next_due" => err["due_date"] }
      msg = "Noch unsicher — `#{err['id']}` bleibt aktiv und wird morgen (**#{err['due_date']}**, Tag +1) erneut geprüft."
    end
    err["updated_on"] = today_str

    save_all!(state, as_of)
    puts msg
  end

  def cmd_status(argv)
    exam_filter = nil
    as_json = false
    as_of = Date.today

    OptionParser.new do |o|
      o.on("--exam EXAM", "Auf Prüfung filtern (AP1, AP2, BS)") { |v| exam_filter = v }
      o.on("--as-of DATE", "Referenzdatum (YYYY-MM-DD)") { |v| as_of = Date.parse(v) }
      o.on("--json", "Als JSON ausgeben") { as_json = true }
    end.parse!(argv)

    state = load_state
    target = (exam_filter || state["exam_target"] || "AP1").to_s.upcase
    report = build_briefing_data(state, target_exam: target, limit: 10, today: as_of)
    if as_json
      puts JSON.pretty_generate(report)
      return
    end

    puts "# 📊 Lernstand-Übersicht (Stand #{as_of.strftime('%Y-%m-%d')} · Fokus #{target})"
    puts "- Geübte Themen (#{target}): **#{report[:practiced_topics]} / #{report[:total_exam_topics]}**"
    puts "- Geübte Karten (#{target}): **#{report[:practiced_cards]} / #{report[:total_exam_cards]}** (heute fällig: **#{report[:due_cards_count]}**)"
    puts "- Offene Denkfehler: **#{report[:open_errors_count]}** (heute fällig: **#{report[:due_errors].length}**) · Gemeistert: **#{report[:mastered_errors_count]}**"
  end

  private

  # ---------- State Management ----------

  def load_state
    if STATE_PATH.file?
      data = VaultSupport.read_json(STATE_PATH)
      data["schema_version"] ||= 1
      data["exam_target"] ||= "AP1"
      data["topics"] ||= {}
      data["cards"] ||= {}
      data["errors"] ||= []
      data
    else
      {
        "schema_version" => 1,
        "updated_on" => Date.today.strftime("%Y-%m-%d"),
        "exam_target" => "AP1",
        "exam_date" => nil,
        "topics" => {},
        "cards" => {},
        "errors" => []
      }
    end
  end

  def save_all!(state, today_date)
    state["updated_on"] = today_date.strftime("%Y-%m-%d")
    state["topics"] = state["topics"].sort.to_h
    state["cards"] = state["cards"].sort.to_h
    VaultSupport.write_json_if_changed(STATE_PATH, state)
    VaultSupport.write_if_changed(JOURNAL_MD_PATH, render_error_journal_md(state, today_date))
    VaultSupport.write_if_changed(DASHBOARD_MD_PATH, render_dashboard_md(state, today_date))
  end

  def update_card_fsrs!(state, card_id, canonical_topic, grade, confidence, today_date)
    prev = state["cards"][card_id]
    updated = FSRS45.review(prev, grade, today_date)
    updated["thema"] = canonical_topic
    updated["last_confidence"] = confidence if confidence
    state["cards"][card_id] = updated
    updated
  end

  def update_topic_fsrs!(state, canonical_topic, grade, confidence, bloom, today_date, from_single_card: false)
    prev = state["topics"][canonical_topic]
    # Wenn bereits am selben Tag ueber eine andere Karte desselben Themas aktualisiert wurde,
    # mitteln wir sanft ueber die Karten des Themas statt die Themen-Reps 10x hochzuzaehlen.
    if from_single_card
      topic_cards = state["cards"].values.select { |c| c["thema"] == canonical_topic }
      unless topic_cards.empty?
        avg_s = (topic_cards.sum { |c| c["stability"].to_f } / topic_cards.length).round(2)
        avg_d = (topic_cards.sum { |c| c["difficulty"].to_f } / topic_cards.length).round(2)
        earliest_due = topic_cards.map { |c| c["due_date"] }.compact.min
        total_lapses = topic_cards.sum { |c| c["lapses"].to_i }
        entry = (prev || {}).dup
        entry["stability"] = avg_s
        entry["difficulty"] = avg_d
        entry["reps"] = [entry["reps"].to_i, 1].max
        entry["lapses"] = total_lapses
        entry["last_review"] = today_date.strftime("%Y-%m-%d")
        entry["due_date"] = earliest_due || (today_date + 1).strftime("%Y-%m-%d")
        entry["last_grade"] = grade
        entry["cards_practiced"] = topic_cards.length
        apply_confidence_and_bloom!(entry, grade, confidence, bloom)
        state["topics"][canonical_topic] = entry
        return entry
      end
    end

    updated = FSRS45.review(prev, grade, today_date)
    updated["mastery_bloom_max"] = prev["mastery_bloom_max"] if prev && prev["mastery_bloom_max"]
    updated["confidence_checks"] = prev["confidence_checks"].to_i if prev
    updated["high_conf_errors"] = prev["high_conf_errors"].to_i if prev
    updated["cards_practiced"] = prev["cards_practiced"].to_i if prev
    apply_confidence_and_bloom!(updated, grade, confidence, bloom)
    state["topics"][canonical_topic] = updated
    updated
  end

  def apply_confidence_and_bloom!(entry, grade, confidence, bloom)
    if bloom && (1..6).cover?(bloom) && grade >= 3
      entry["mastery_bloom_max"] = [entry["mastery_bloom_max"].to_i, bloom].max
    end
    if confidence && (1..3).cover?(confidence)
      entry["confidence_checks"] = entry["confidence_checks"].to_i + 1
      entry["last_confidence"] = confidence
      if confidence == 3 && grade <= 2
        entry["high_conf_errors"] = entry["high_conf_errors"].to_i + 1
      end
    end
  end

  def process_batch_cards!(state, batch_spec, today_date)
    results = []
    batch_spec.split(",").each do |item|
      parts = item.strip.split(":")
      next if parts.length < 2

      c_id = parts[0].strip
      g = parts[1].to_i
      conf = parts[2] ? parts[2].to_i : nil
      next unless (1..4).cover?(g)

      meta = lookup_card(c_id)
      abort "Karten-ID '#{c_id}' in --batch nicht gefunden." unless meta

      c_state = update_card_fsrs!(state, c_id, meta[:thema], g, conf, today_date)
      update_topic_fsrs!(state, meta[:thema], g, conf, nil, today_date, from_single_card: true)
      results << {
        card_id: c_id,
        topic: meta[:thema],
        grade: g,
        due_date: c_state["due_date"],
        stability: c_state["stability"]
      }
    end
    results
  end

  def upsert_error!(state, topic:, card_id:, mistake:, correct_principle:, confidence:, error_type:, confused_with:, today:)
    norm_mistake = normalize(mistake)
    existing = state["errors"].find do |e|
      e["status"] == "open" &&
        e["topic"] == topic &&
        ((card_id && !card_id.empty? && e["card_id"] == card_id) || normalize(e["mistake"]) == norm_mistake)
    end

    today_str = today.strftime("%Y-%m-%d")
    due_str = (today + 1).strftime("%Y-%m-%d")

    if existing
      existing["updated_on"] = today_str
      existing["mistake"] = mistake
      existing["correct_principle"] = correct_principle
      existing["confidence"] = [existing["confidence"].to_i, confidence].max
      existing["hypercorrection"] = existing["confidence"].to_i >= 3
      existing["error_type"] = error_type if error_type && !error_type.empty?
      existing["confused_with"] = confused_with if confused_with
      existing["stage"] = 0
      existing["lapses"] = existing["lapses"].to_i + 1
      existing["due_date"] = due_str
      existing["history"] ||= []
      existing["history"] << { "date" => today_str, "result" => "logged_again", "next_due" => due_str }
      return existing
    end

    next_num = state["errors"].map { |e| e["id"].to_s[/\d+/].to_i }.max.to_i + 1
    err_id = format("ERR-%03d", next_num)
    entry = {
      "id" => err_id,
      "created_on" => today_str,
      "updated_on" => today_str,
      "topic" => topic,
      "pruefung" => VaultSupport.exam_for_topic(topic, @exam_registry),
      "card_id" => (card_id && !card_id.empty? ? card_id : nil),
      "confused_with" => confused_with,
      "error_type" => ERROR_TYPES.include?(error_type) ? error_type : "Konzept",
      "confidence" => confidence,
      "hypercorrection" => confidence >= 3,
      "mistake" => mistake,
      "correct_principle" => correct_principle,
      "stage" => 0,
      "status" => "open",
      "lapses" => 1,
      "due_date" => due_str,
      "history" => [
        { "date" => today_str, "result" => "created", "next_due" => due_str }
      ]
    }
    state["errors"] << entry
    entry
  end

  # ---------- Briefing & Analytics ----------

  def build_briefing_data(state, target_exam:, limit:, today:)
    all_cards_map = ensure_card_lookup!
    exam_topics = @topics.keys.select { |t| VaultSupport.exam_matches?(VaultSupport.exam_for_topic(t, @exam_registry), target_exam) }
    exam_cards = all_cards_map.values.select { |c| VaultSupport.exam_matches?(c[:pruefung], target_exam) }

    practiced_topics = exam_topics.count { |t| state["topics"].key?(t) }
    practiced_cards = exam_cards.count { |c| state["cards"].key?(c[:id]) }

    due_cards = exam_cards.select do |c|
      cs = state["cards"][c[:id]]
      cs && cs["due_date"] && cs["due_date"] <= today.strftime("%Y-%m-%d")
    end

    open_errors = state["errors"].select do |e|
      e["status"] == "open" && VaultSupport.exam_matches?(e["pruefung"] || VaultSupport.exam_for_topic(e["topic"], @exam_registry), target_exam)
    end
    due_errors = open_errors.select { |e| e["due_date"].to_s <= today.strftime("%Y-%m-%d") }
                            .sort_by { |e| [e["hypercorrection"] ? 0 : 1, e["due_date"].to_s, -e["lapses"].to_i] }

    mastered_errors_count = state["errors"].count { |e| e["status"] == "mastered" }

    due_topics = []
    exam_risk_topics = []
    exam_date = FSRS45.parse_date(state["exam_date"])
    days_until_exam = exam_date && exam_date > today ? (exam_date - today).to_i : nil

    exam_topics.each do |t_name|
      ts = state["topics"][t_name]
      next unless ts

      due_d = FSRS45.parse_date(ts["due_date"]) || today
      last_d = FSRS45.parse_date(ts["last_review"]) || today
      elapsed = [(today - last_d).to_i, 0].max
      r_now = FSRS45.retrievability(elapsed, ts["stability"])
      pruefung = VaultSupport.exam_for_topic(t_name, @exam_registry)

      if due_d <= today
        overdue = (today - due_d).to_i
        # AP1-Kernthemen leicht vor AP1/AP2 priorisieren
        prio_bonus = pruefung == "AP1" ? 0.05 : 0.0
        urgency = (1.0 - r_now) + (overdue * 0.04) + (ts["lapses"].to_i * 0.06) + prio_bonus
        due_topics << {
          topic: t_name,
          badge: VaultSupport.exam_badge(pruefung),
          stability: ts["stability"],
          difficulty: ts["difficulty"],
          lapses: ts["lapses"].to_i,
          due_date: ts["due_date"],
          overdue_days: overdue,
          retrievability: r_now.round(3),
          urgency: urgency.round(3)
        }
      end

      if days_until_exam
        elapsed_at_exam = [(exam_date - last_d).to_i, 0].max
        r_exam = FSRS45.retrievability(elapsed_at_exam, ts["stability"])
        if r_exam < 0.85
          exam_risk_topics << { topic: t_name, exam_r: r_exam.round(3), stability: ts["stability"] }
        end
      end
    end

    due_topics.sort_by! { |t| [-t[:urgency], t[:topic]] }
    exam_risk_topics.sort_by! { |t| [t[:exam_r], t[:topic]] }

    untouched = exam_topics.reject { |t| state["topics"].key?(t) }.map do |t_name|
      pruefung = VaultSupport.exam_for_topic(t_name, @exam_registry)
      reg_info = @exam_registry[VaultSupport.nfc(t_name)] || @exam_registry[t_name] || {}
      hinweis = reg_info["hinweis"]
      pages_cnt = @topics.dig(t_name, "pages")&.length.to_i
      top10_boost = hinweis.to_s.include?("Top-10-Punktegarant") ? 100 : 0
      ap1_core_boost = pruefung == "AP1" ? 30 : 10
      {
        topic: t_name,
        category: @topics.dig(t_name, "category"),
        badge: VaultSupport.exam_badge(pruefung),
        pages: pages_cnt,
        hinweis: hinweis,
        score: top10_boost + ap1_core_boost + [pages_cnt, 30].min
      }
    end.sort_by { |x| [-x[:score], x[:topic]] }

    pending_updates = if CARDS_STATUS_PATH.file?
                        VaultSupport.read_json(CARDS_STATUS_PATH).dig("totals", "decks_update_noetig").to_i
                      else
                        0
                      end

    {
      date: today.strftime("%Y-%m-%d"),
      exam_target: target_exam,
      exam_date: state["exam_date"],
      days_until_exam: days_until_exam,
      total_exam_topics: exam_topics.length,
      practiced_topics: practiced_topics,
      total_exam_cards: exam_cards.length,
      practiced_cards: practiced_cards,
      due_cards_count: due_cards.length,
      open_errors_count: open_errors.length,
      mastered_errors_count: mastered_errors_count,
      pending_deck_updates: pending_updates,
      due_errors: due_errors,
      due_topics: due_topics.first(limit),
      exam_risk_topics: exam_risk_topics,
      recommended_new_topics: untouched.first(3)
    }
  end

  # ---------- Markdown Generators ----------

  def render_error_journal_md(state, today_date)
    today_str = today_date.strftime("%Y-%m-%d")
    errors = state["errors"] || []
    open_errs = errors.select { |e| e["status"] == "open" }
                      .sort_by { |e| [e["due_date"].to_s, e["hypercorrection"] ? 0 : 1, e["id"].to_s] }
    mastered_errs = errors.select { |e| e["status"] == "mastered" }
                          .sort_by { |e| [-(e["mastered_on"].to_s.delete("-").to_i), e["id"].to_s] }

    due_now = open_errs.count { |e| e["due_date"].to_s <= today_str }
    hc_count = open_errs.count { |e| e["hypercorrection"] }

    lines = [
      "---",
      "typ: fehlerjournal",
      "stand: #{today_str}",
      "rag_include: false",
      "canonical_evidence: false",
      "tags:",
      "  - pruefung",
      "  - hypercorrection",
      "  - fehlerjournal",
      "---",
      "# 🎯 Denkfehler- & Hypercorrection-Register",
      "",
      "> [!IMPORTANT] Wissenschaftliches Prinzip (Hypercorrection-Effekt — Butterfield & Metcalfe, 2001)",
      "> Fehler, die du mit **hoher Sicherheit (`3 = sicher`)** begehst, werden im Gehirn besonders tief korrigiert — **wenn** der Kontrast (*„Ich dachte X → tatsächlich gilt Y“*) sofort festgehalten und verzögert an **Tag +1** sowie **Tag +7** aktiv ohne Hilfe abgefragt wird.",
      "",
      "## Status-Überblick",
      "",
      "- **Offene Denkfehler aktiv im Training:** **#{open_errs.length}** *(davon ⚡ **#{hc_count}** Hypercorrection-Fälle · 🔴 **#{due_now}** heute zum Pretest fällig)*",
      "- **Dauerhaft überwundene Denkfehler (Tag +1 & Tag +7 bestanden):** **#{mastered_errs.length}**",
      "- **Verknüpftes FSRS-Cockpit:** [[04_Pruefung/Lernstand_Dashboard|📊 Lernstand-Dashboard öffnen]]",
      ""
    ]

    lines << "## 🔴 Aktive Denkfehler (Wiederholungs-Queue Tag +1 / Tag +7)"
    lines << ""
    if open_errs.empty?
      lines << "_Aktuell keine offenen Denkfehler eingetragen. Sobald im Quiz, Rechentraining oder Karteikarten-Drill ein Denkfehler auftritt, trägt der `ap-lerncoach` ihn hier automatisch für deinen Tag-+1- und Tag-+7-Pretest ein._"
      lines << ""
    else
      lines << "| ID | Thema | Typ | Sicherheit | Mein Denkfehler (*„Ich dachte …“*) | Korrektes Prinzip (*„Es gilt …“*) | Stufe & Nächster Check |"
      lines << "|---|---|---|---|---|---|---|"
      open_errs.each do |e|
        t_info = @topics[e["topic"]]
        topic_cell = t_info ? "[[#{t_info['path'].delete_suffix('.md')}\\|#{escape_md(e['topic'])}]]" : escape_md(e["topic"])
        if e["confused_with"] && @topics[e["confused_with"]]
          p_path = @topics[e["confused_with"]]["path"].delete_suffix(".md")
          topic_cell += " *(vs. [[#{p_path}\\|#{escape_md(e['confused_with'])}]])*"
        end
        conf_cell = e["hypercorrection"] ? "⚡ **3 (Sicher!)**" : "#{e['confidence'] || '-'}"
        stage_lbl = e["stage"].to_i.zero? ? "Stufe 1 (Tag +1)" : "Stufe 2 (Tag +7)"
        due_flag = e["due_date"].to_s <= today_str ? "🔴 **#{e['due_date']} (FÄLLIG)**" : "🟡 #{e['due_date']}"
        lines << "| `#{e['id']}` | #{topic_cell} | `#{e['error_type']}` | #{conf_cell} | #{escape_md(e['mistake'])} | #{escape_md(e['correct_principle'])} | #{stage_lbl}<br>#{due_flag} |"
      end
      lines << ""
    end

    unless mastered_errs.empty?
      lines << "## 🟢 Überwundene Denkfehler (Gemeistert nach Tag +1 & Tag +7)"
      lines << ""
      lines << "| ID | Thema | Ehemaliger Denkfehler | Verankertes Prinzip | Gemeistert am |"
      lines << "|---|---|---|---|---|"
      mastered_errs.each do |e|
        t_info = @topics[e["topic"]]
        topic_cell = t_info ? "[[#{t_info['path'].delete_suffix('.md')}\\|#{escape_md(e['topic'])}]]" : escape_md(e["topic"])
        lines << "| `#{e['id']}` | #{topic_cell} | #{escape_md(e['mistake'])} | #{escape_md(e['correct_principle'])} | ✅ #{e['mastered_on']} |"
      end
      lines << ""
    end

    lines << "## CLI-Schnellbefehle (für Coach & Terminal)"
    lines << ""
    lines << "```bash"
    lines << "# Morgendliches Session-Briefing (zeigt fällige Pretests + Top-3 FSRS-Themen):"
    lines << "ruby 01_Index/Tools/learn_tracker.rb briefing --exam AP1"
    lines << ""
    lines << "# Neuen Denkfehler eintragen:"
    lines << "ruby 01_Index/Tools/learn_tracker.rb log-error --topic \"IPv4-Adressierung und Subnetting\" --mistake \"Hostanzahl mit 2^n berechnet\" --correct \"2^n - 2 (Netz-ID & Broadcast abziehen)\" --confidence 3 --type Rechenfalle"
    lines << ""
    lines << "# Pretest-Ergebnis verbuchen (Tag +1 -> Tag +7 -> Gemeistert):"
    lines << "ruby 01_Index/Tools/learn_tracker.rb resolve-error ERR-001 --pass"
    lines << "```"
    lines << ""
    lines.join("\n")
  end

  def render_dashboard_md(state, today_date)
    today_str = today_date.strftime("%Y-%m-%d")
    target = (state["exam_target"] || "AP1").to_s.upcase
    brief = build_briefing_data(state, target_exam: target, limit: 8, today: today_date)

    lines = [
      "---",
      "typ: lernstand_dashboard",
      "stand: #{today_str}",
      "aktueller_fokus: #{target}",
      "rag_include: false",
      "canonical_evidence: false",
      "tags:",
      "  - pruefung",
      "  - fsrs",
      "  - dashboard",
      "---",
      "# 📊 Persistentes FSRS-Lernstand-Cockpit",
      "",
      "> [!ap1] Gedächtnis-Status (Fokus: **#{target}**#{state['exam_date'] ? " · Prüfungstermin: **#{state['exam_date']}**" : ''})",
      "> - **Themen aktiv im Gedächtnis:** **#{brief[:practiced_topics]} / #{brief[:total_exam_topics]}** #{target}-Themen",
      "> - **Karteikarten mit FSRS-Intervall:** **#{brief[:practiced_cards]} / #{brief[:total_exam_cards]}** Karten *(heute fällig: **#{brief[:due_cards_count]}**)*",
      "> - **Denkfehler-Training:** **#{brief[:open_errors_count]}** aktiv *(heute fällig: **#{brief[:due_errors].length}**)* · **#{brief[:mastered_errors_count]}** gemeistert → [[04_Pruefung/Fehlerjournal_und_Denkfehler|🎯 Fehlerjournal öffnen]]",
      ""
    ]

    lines << "## 🟡 Heute fällige Wiederholungen"
    lines << ""
    if brief[:due_topics].empty? && brief[:due_errors].empty?
      lines << "_Aktuell sind keine #{target}-Wiederholungen oder Fehler-Pretests überfällig._"
      lines << ""
    else
      brief[:due_errors].each do |e|
        lines << "- 🔴 **Pretest `#{e['id']}` (#{e['topic']}):** #{e['mistake']} *(fällig: #{e['due_date']})*"
      end
      brief[:due_topics].each do |t|
        t_info = @topics[t[:topic]]
        link = t_info ? "[[#{t_info['path'].delete_suffix('.md')}|#{t[:topic]}]]" : t[:topic]
        lines << "- 🟡 **#{link}** (#{t[:badge]}) — Erinnerung ca. **#{(t[:retrievability] * 100).round}%** · Stabilität **#{t[:stability]} Tage** · fällig seit `#{t[:due_date]}`"
      end
      lines << ""
    end

    practiced_rows = state["topics"].sort_by { |k, v| [v["due_date"].to_s, k] }
    lines << "## 🧠 Gelernte Themen im FSRS-Gedächtnis (#{practiced_rows.length})"
    lines << ""
    if practiced_rows.empty?
      lines << "_Noch keine Lernsession aufgezeichnet. Starte im Chat einfach ein Quiz, eine Übung oder den Karteikarten-Modus – der `ap-lerncoach` speichert deinen Fortschritt hier automatisch._"
      lines << ""
    else
      lines << "| Thema | Prüfung | Stabilität (S) | Schwierigkeit (D) | Durchgänge | Bloom-Max | Nächste Fälligkeit |"
      lines << "|---|---|---:|---:|---:|---|---:|"
      practiced_rows.each do |t_name, ts|
        t_info = @topics[t_name]
        link = t_info ? "[[#{t_info['path'].delete_suffix('.md')}\\|#{escape_md(t_name)}]]" : escape_md(t_name)
        ex = VaultSupport.exam_badge(VaultSupport.exam_for_topic(t_name, @exam_registry))
        bloom_lbl = ts["mastery_bloom_max"] ? "Stufe #{ts['mastery_bloom_max']}" : "–"
        due_lbl = ts["due_date"].to_s <= today_str ? "🔴 **#{ts['due_date']}**" : "🟢 #{ts['due_date']}"
        lines << "| #{link} | #{ex} | #{ts['stability']} d | #{ts['difficulty']} | #{ts['reps']} *(Fehl: #{ts['lapses']})* | #{bloom_lbl} | #{due_lbl} |"
      end
      lines << ""
    end

    lines.join("\n")
  end

  # ---------- Helpers ----------

  def ensure_card_lookup!
    return @card_lookup if @card_lookup

    @card_lookup = {}
    return @card_lookup unless CARDS_ROOT.directory?

    Dir.glob(CARDS_ROOT.join("**/*.md").to_s).sort.each do |abs_path|
      rel = VaultSupport.relative(abs_path)
      next if rel == "05_Karteikarten/00_Karteikarten_Index.md"

      raw = File.read(abs_path, encoding: "UTF-8")
      next unless raw.start_with?("---\n")
      parts = raw.split(/^---\s*$\n?/, 3)
      next unless parts.length == 3

      fm = begin
        YAML.safe_load(parts[1], permitted_classes: [Date])
      rescue ArgumentError
        YAML.safe_load(parts[1], [Date])
      end
      next unless fm && fm["typ"].to_s == "karteikarten_deck"

      thema = fm["thema"].to_s.strip
      deck_exam = fm["pruefung"].to_s.strip
      deck_exam = VaultSupport.exam_for_topic(thema, @exam_registry) if deck_exam.empty?

      parts[2].scan(/<!--\s*card-id:\s*([^|]+?)(?:\s*\|\s*typ:\s*([^|]+?))?(?:\s*\|\s*pruefung:\s*([^>]+?))?\s*-->/) do |m|
        cid = m[0].strip
        pruef = (m[2] || deck_exam).strip
        @card_lookup[cid] = { id: cid, thema: thema, pruefung: pruef, deck_path: rel }
      end
    end
    @card_lookup
  end

  def lookup_card(card_id)
    ensure_card_lookup![card_id]
  end

  def normalize(str)
    s = str.to_s.unicode_normalize(:nfc).downcase
    s = s.gsub("ä", "ae").gsub("ö", "oe").gsub("ü", "ue").gsub("ß", "ss")
    s.gsub(/[^a-z0-9]+/, " ").strip
  end

  def resolve_topic!(query)
    found = resolve_topic_soft(query)
    return found if found

    abort "Thema '#{query}' nicht in den #{@topics.length} kanonischen Themen gefunden."
  end

  def resolve_topic_soft(query)
    q = query.to_s.strip
    return q if @topics.key?(q)

    qn = normalize(q)
    exact = @topics.keys.find { |k| normalize(k) == qn }
    return exact if exact

    partial = if qn.length <= 4
                @topics.keys.select { |k| normalize(k).match?(/(?:\A|\s)#{Regexp.escape(qn)}(?:\s|\z)/) }
              else
                @topics.keys.select { |k| normalize(k).include?(qn) }
              end
    return partial.first if partial.length == 1

    nil
  end

  def escape_md(text)
    text.to_s.gsub("|", "\\|").gsub(/\r?\n/, " ").strip
  end

  def print_help
    puts <<~HELP
      Persistentes FSRS-Lerngedächtnis & Hypercorrection-Register (ap-lerncoach)

      Befehle:
        ruby 01_Index/Tools/learn_tracker.rb [sync]
        ruby 01_Index/Tools/learn_tracker.rb briefing [--exam AP1|AP2|BS] [--limit 3] [--json]
        ruby 01_Index/Tools/learn_tracker.rb record [--topic "<Thema>"] [--card "<id>"] --grade <1..4> [--confidence <1..3>] [--bloom <1..6>]
        ruby 01_Index/Tools/learn_tracker.rb record --batch "card-01:3,card-02:1:3,card-03:4"
        ruby 01_Index/Tools/learn_tracker.rb log-error --topic "<Thema>" --mistake "<Denkfehler>" --correct "<Prinzip>" [--confidence 3] [--type Rechenfalle]
        ruby 01_Index/Tools/learn_tracker.rb resolve-error <ERR-ID> (--pass | --fail)
        ruby 01_Index/Tools/learn_tracker.rb set-exam --target <AP1|AP2> [--date YYYY-MM-DD]
        ruby 01_Index/Tools/learn_tracker.rb status [--exam AP1|AP2|BS] [--json]
    HELP
  end
end

LearnTracker.new.run(ARGV)
