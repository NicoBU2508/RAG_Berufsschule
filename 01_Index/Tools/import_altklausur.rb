#!/usr/bin/env ruby
# frozen_string_literal: true

# Import- & Analyse-Pipeline fuer Original-IHK-Altklausuren + offizielle Loesungshinweise (06_Altklausuren/).
#
# Befehle:
#   ruby 01_Index/Tools/import_altklausur.rb scan [pfad]
#   ruby 01_Index/Tools/import_altklausur.rb prepare <klausur_pdf> [--loesung <loesung_pdf>] --pruefung <AP1|AP2_GA1|AP2_GA2|AP2_WiSo> --jahr <JJJJ> --termin <Fruehjahr|Sommer|Herbst|Winter> [--move]
#   ruby 01_Index/Tools/import_altklausur.rb topics
#   ruby 01_Index/Tools/import_altklausur.rb apply [--clean-review]
#
# Alle temporaeren Seiten-PNGs und OCR-Auszuege liegen unter /tmp/ap_lernhelfer_altklausuren/,
# damit iCloud Drive und Git sauber bleiben.

require "date"
require "digest"
require "fileutils"
require "json"
require "open3"
require "optparse"
require "pathname"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
INBOX_DIR = ROOT.join("06_Altklausuren/00_Posteingang")
ALTKLAUSUREN_DIR = ROOT.join("06_Altklausuren")
AUDIT_EXAM_DIR = ROOT.join("01_Index/Auditdaten/Altklausuren")
INDEX_OUTPUT_PATH = ROOT.join("01_Index/Altklausuren_Index.json")
ANALYSEN_DIR = ALTKLAUSUREN_DIR.join("Aufgabenanalysen")
REFERENZMATRIX_PATH = ROOT.join("04_Pruefung/Referenzmatrix Altklausuren.md")
HAEUFIGKEIT_PATH = ROOT.join("04_Pruefung/Haeufigkeitsanalyse.md")

TOOLS_DIR = ROOT.join("01_Index/Tools")
SWIFT_SOURCE = TOOLS_DIR.join("goodnotes_pdf_tool.swift")
SHARED_TOOL_TMP = Pathname.new("/tmp/ap_lernhelfer_import")
BINARY_PATH = SHARED_TOOL_TMP.join("bin/goodnotes_pdf_tool")
MODCACHE_PATH = SHARED_TOOL_TMP.join("modcache")
WORK_TMP = Pathname.new("/tmp/ap_lernhelfer_altklausuren")
REVIEW_ROOT = WORK_TMP.join("review")

PRIVACY_PATH_PATTERN = /(^|[\/_\-\s.])(noten|zeugnis|zeugnisse|privat|gehalt|kontoauszug|passwort|pin|tan)([\/_\-\s.]|$)/i
SOLUTION_NAME_PATTERN = /(loesung|lösung|loesungshinweis|lösungshinweis|musterloesung|musterlösung|erwartungshorizont|korrektur|bewertung)/i

VALID_PRUEFUNGEN = %w[AP1 AP2_GA1 AP2_GA2 AP2_WiSo AP2].freeze
VALID_TERMINE = %w[Fruehjahr Sommer Herbst Winter].freeze
VALID_AUFGABENTYPEN = %w[
  code_trace
  implementierung
  berechnung
  freitext
  diagramm
  sql
  zuordnung
  multiple_choice
].freeze

POST_SCRIPTS = %w[
  build_ki_manifest.rb
  validate_nonprivate_links.rb
  validate_verified_source_layer.rb
].freeze

module ExamPdfTool
  module_function

  def ensure_binary!
    needs_build = !BINARY_PATH.executable? || File.mtime(SWIFT_SOURCE) > File.mtime(BINARY_PATH)
    return BINARY_PATH.to_s unless needs_build

    FileUtils.mkdir_p(BINARY_PATH.dirname)
    FileUtils.mkdir_p(MODCACHE_PATH)
    cmd = [
      "swiftc", "-O",
      "-module-cache-path", MODCACHE_PATH.to_s,
      "-o", BINARY_PATH.to_s,
      SWIFT_SOURCE.to_s
    ]
    stdout, stderr, status = Open3.capture3(*cmd)
    unless status.success?
      abort "Fehler beim Kompilieren von #{SWIFT_SOURCE}:\n#{stdout}\n#{stderr}"
    end
    BINARY_PATH.to_s
  end

  def run(*args)
    binary = ensure_binary!
    stdout, stderr, status = Open3.capture3(binary, *args.map(&:to_s))
    unless status.success?
      abort "goodnotes_pdf_tool fehlgeschlagen (#{args.join(' ')}):\n#{stderr}"
    end
    JSON.parse(stdout)
  end
end

module ExamHelpers
  module_function

  def privacy_flagged?(path_str)
    VaultSupport.nfc(path_str.to_s).match?(PRIVACY_PATH_PATTERN)
  end

  def solution_file?(path_str)
    VaultSupport.nfc(File.basename(path_str.to_s)).match?(SOLUTION_NAME_PATTERN)
  end

  def normalize_pruefung(raw)
    s = raw.to_s.strip.upcase.gsub(/[\s\-]+/, "_")
    case s
    when "AP1" then "AP1"
    when "AP2_GA1", "GA1", "AP2_TEIL1" then "AP2_GA1"
    when "AP2_GA2", "GA2", "AP2_TEIL2" then "AP2_GA2"
    when "AP2_WISO", "WISO" then "AP2_WiSo"
    when "AP2" then "AP2"
    else
      abort "Ungueltige Pruefung '#{raw}'. Erlaubt: #{VALID_PRUEFUNGEN.join(', ')}"
    end
  end

  def normalize_termin(raw)
    s = VaultSupport.nfc(raw.to_s.strip).downcase
    return "Fruehjahr" if s.start_with?("fr") || s == "fj"
    return "Sommer" if s.start_with?("so")
    return "Herbst" if s.start_with?("he")
    return "Winter" if s.start_with?("wi")

    abort "Ungueltiger Termin '#{raw}'. Erlaubt: #{VALID_TERMINE.join(', ')}"
  end

  def infer_metadata_from_filename(path_str)
    bn = VaultSupport.nfc(File.basename(path_str.to_s, ".pdf"))
    down = bn.downcase
    pruefung = if down.include?("ap1")
                 "AP1"
               elsif down.include?("wiso")
                 "AP2_WiSo"
               elsif down.include?("ga1")
                 "AP2_GA1"
               elsif down.include?("ga2")
                 "AP2_GA2"
               elsif down.include?("ap2")
                 "AP2"
               end
    jahr = bn[/(20[123]\d)/, 1]&.to_i
    termin = if down.match?(/fruehjahr|frühjahr|\bfj\b/)
               "Fruehjahr"
             elsif down.include?("sommer")
               "Sommer"
             elsif down.include?("herbst")
               "Herbst"
             elsif down.include?("winter")
               "Winter"
             end
    {
      pruefung: pruefung,
      jahr: jahr,
      termin: termin,
      role: solution_file?(bn) ? "loesung" : "klausur"
    }
  end

  def sanitize_id(str)
    s = VaultSupport.nfc(str.to_s)
    { "ä" => "ae", "ö" => "oe", "ü" => "ue", "ß" => "ss", "Ä" => "Ae", "Ö" => "Oe", "Ü" => "Ue" }.each do |k, v|
      s = s.gsub(k, v)
    end
    s.gsub(/[^A-Za-z0-9_]+/, "_").gsub(/\A_+|_+\z/, "")
  end

  def existing_sha256_map
    return {} unless AUDIT_EXAM_DIR.directory?

    map = {}
    Dir.glob(AUDIT_EXAM_DIR.join("*.json").to_s).each do |p|
      data = VaultSupport.read_json(p)
      map[data["klausur_sha256"]] = data["exam_id"] if data["klausur_sha256"]
      map[data["loesung_sha256"]] = data["exam_id"] if data["loesung_sha256"]
    end
    map
  end
end

class AltklausurPipeline
  def cmd_scan(target = nil)
    FileUtils.mkdir_p(INBOX_DIR)
    search_root = target ? Pathname.new(target).expand_path : INBOX_DIR
    pdfs = if search_root.file?
             [search_root]
           elsif search_root.directory?
             Dir.glob(search_root.join("**/*.pdf").to_s).sort.map { |p| Pathname.new(p) }
           else
             abort "Pfad nicht gefunden: #{search_root}"
           end

    known_hashes = ExamHelpers.existing_sha256_map
    items = pdfs.map do |pdf|
      rel = pdf.to_s.start_with?(ROOT.to_s) ? pdf.relative_path_from(ROOT).to_s : pdf.to_s
      if ExamHelpers.privacy_flagged?(rel)
        { path: rel, status: "SKIP_PRIVATE" }
      else
        sha = Digest::SHA256.file(pdf).hexdigest
        info = ExamPdfTool.run("info", pdf.to_s)
        meta = ExamHelpers.infer_metadata_from_filename(pdf)
        status = known_hashes.key?(sha) ? "DUPLICATE_EXACT (#{known_hashes[sha]})" : "NEW"
        {
          path: rel,
          status: status,
          pages: info["page_count"],
          sha256: sha,
          inferred: meta
        }
      end
    end

    # Automatische Paarungs-Vorschlaege (Klausur + Loesung mit gleicher Pruefung/Jahr/Termin)
    new_items = items.select { |i| i[:status] == "NEW" }
    pairs = []
    klausuren = new_items.select { |i| i.dig(:inferred, :role) == "klausur" }
    loesungen = new_items.select { |i| i.dig(:inferred, :role) == "loesung" }
    klausuren.each do |k|
      ki = k[:inferred]
      next unless ki[:pruefung] && ki[:jahr]
      match_l = loesungen.find do |l|
        li = l[:inferred]
        li[:pruefung] == ki[:pruefung] && li[:jahr] == ki[:jahr] && (li[:termin].nil? || ki[:termin].nil? || li[:termin] == ki[:termin])
      end
      pairs << { klausur: k[:path], loesung: match_l[:path], pruefung: ki[:pruefung], jahr: ki[:jahr], termin: ki[:termin] } if match_l
    end

    puts JSON.pretty_generate({
      "scanned_path" => search_root.to_s,
      "pdf_count" => items.length,
      "suggested_pairs" => pairs,
      "files" => items
    })
  end

  def cmd_topics
    mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
    exam_reg = VaultSupport.exam_registry
    grouped = Hash.new { |h, k| h[k] = [] }
    mapping.fetch("topics").each do |name, info|
      badge = VaultSupport.exam_badge(VaultSupport.exam_for_topic(name, exam_reg))
      grouped[info.fetch("category")] << "#{name} [#{badge}]"
    end
    grouped.keys.sort.each do |cat|
      puts "## #{cat}"
      grouped[cat].sort.each { |line| puts "- #{line}" }
      puts ""
    end
  end

  def cmd_prepare(klausur_arg, pruefung:, jahr:, termin:, loesung_arg: nil, titel: nil, move: false, variant: nil)
    klausur_src = Pathname.new(klausur_arg).expand_path
    abort "Klausur-PDF fehlt: #{klausur_src}" unless klausur_src.file?
    abort "SKIP_PRIVATE: Pfad wirkt privat (#{klausur_src})" if ExamHelpers.privacy_flagged?(klausur_src)

    loesung_src = loesung_arg ? Pathname.new(loesung_arg).expand_path : nil
    if loesung_src
      abort "Loesungs-PDF fehlt: #{loesung_src}" unless loesung_src.file?
      abort "SKIP_PRIVATE: Pfad wirkt privat (#{loesung_src})" if ExamHelpers.privacy_flagged?(loesung_src)
    end

    norm_pruefung = ExamHelpers.normalize_pruefung(pruefung)
    norm_termin = ExamHelpers.normalize_termin(termin)
    jahr_i = jahr.to_i
    abort "Ungueltiges Pruefungsjahr: #{jahr}" unless (2015..2040).cover?(jahr_i)

    suffix = variant.to_s.strip.empty? ? "" : "_#{ExamHelpers.sanitize_id(variant)}"
    exam_id = ExamHelpers.sanitize_id("#{norm_pruefung}_#{jahr_i}_#{norm_termin}#{suffix}")
    target_subdir = norm_pruefung == "AP1" ? "AP1" : "AP2"

    klausur_dest_dir = ALTKLAUSUREN_DIR.join(target_subdir)
    loesung_dest_dir = ALTKLAUSUREN_DIR.join("Loesungen")
    FileUtils.mkdir_p(klausur_dest_dir)
    FileUtils.mkdir_p(loesung_dest_dir)
    FileUtils.mkdir_p(AUDIT_EXAM_DIR)

    klausur_dest = klausur_dest_dir.join("#{exam_id}_Aufgaben.pdf")
    place_pdf!(klausur_src, klausur_dest, move: move)

    loesung_dest = nil
    if loesung_src
      loesung_dest = loesung_dest_dir.join("#{exam_id}_Loesung.pdf")
      place_pdf!(loesung_src, loesung_dest, move: move)
    end

    review_dir = REVIEW_ROOT.join(exam_id)
    klausur_img_dir = review_dir.join("klausur")
    FileUtils.mkdir_p(klausur_img_dir)
    klausur_extract = ExamPdfTool.run("extract", klausur_dest.to_s, klausur_img_dir.to_s)
    File.write(review_dir.join("klausur_extract.json"), JSON.pretty_generate(klausur_extract) + "\n")

    loesung_extract = nil
    if loesung_dest
      loesung_img_dir = review_dir.join("loesung")
      FileUtils.mkdir_p(loesung_img_dir)
      loesung_extract = ExamPdfTool.run("extract", loesung_dest.to_s, loesung_img_dir.to_s)
      File.write(review_dir.join("loesung_extract.json"), JSON.pretty_generate(loesung_extract) + "\n")
    end

    audit_path = AUDIT_EXAM_DIR.join("#{exam_id}.json")
    existing = audit_path.file? ? VaultSupport.read_json(audit_path) : nil

    draft = {
      "schema_version" => 1,
      "exam_id" => exam_id,
      "pruefung" => norm_pruefung,
      "jahr" => jahr_i,
      "termin" => norm_termin,
      "titel" => titel || (existing && existing["titel"]) || "#{norm_pruefung.tr('_', ' ')} #{norm_termin} #{jahr_i}",
      "klausur_pdf" => klausur_dest.relative_path_from(ROOT).to_s,
      "klausur_sha256" => Digest::SHA256.file(klausur_dest).hexdigest,
      "klausur_seiten_gesamt" => klausur_extract["page_count"],
      "loesung_pdf" => loesung_dest ? loesung_dest.relative_path_from(ROOT).to_s : (existing && existing["loesung_pdf"]),
      "loesung_sha256" => loesung_dest ? Digest::SHA256.file(loesung_dest).hexdigest : (existing && existing["loesung_sha256"]),
      "loesung_seiten_gesamt" => loesung_extract ? loesung_extract["page_count"] : (existing && existing["loesung_seiten_gesamt"]),
      "gesamt_punkte" => (existing && existing["gesamt_punkte"]) || 100,
      "visual_checked" => false,
      "audit_date" => Date.today.strftime("%Y-%m-%d"),
      "review_paths" => {
        "klausur_images" => klausur_img_dir.to_s,
        "klausur_extract_json" => review_dir.join("klausur_extract.json").to_s,
        "loesung_images" => loesung_dest ? review_dir.join("loesung").to_s : nil,
        "loesung_extract_json" => loesung_dest ? review_dir.join("loesung_extract.json").to_s : nil
      }.compact,
      "tasks" => (existing && !Array(existing["tasks"]).empty?) ? existing["tasks"] : [
        {
          "aufgabe" => "1a",
          "punkte" => 6,
          "operator" => "Erläutern",
          "aufgabentyp" => "freitext",
          "klausur_seiten" => [1],
          "loesung_seiten" => loesung_dest ? [1] : [],
          "handlungsfeld_kontext" => "Kurze Zusammenfassung der Handlungssituation in eigenen Worten",
          "fragestellung_kurz" => "Präzise Zusammenfassung der Teilaufgabe",
          "canonical_topics" => [],
          "quell_belege" => [],
          "erwartungshorizont_punkte" => [
            "Bewertungskriterium 1 laut offizieller Lösung (X P.)"
          ],
          "typische_fallen" => []
        }
      ]
    }

    VaultSupport.write_json_if_changed(audit_path, draft)
    puts JSON.pretty_generate({
      "status" => "PREPARED",
      "exam_id" => exam_id,
      "audit_json" => audit_path.relative_path_from(ROOT).to_s,
      "klausur_pdf" => draft["klausur_pdf"],
      "klausur_pages" => draft["klausur_seiten_gesamt"],
      "loesung_pdf" => draft["loesung_pdf"],
      "loesung_pages" => draft["loesung_seiten_gesamt"],
      "review_dir" => review_dir.to_s
    })
  end

  def cmd_apply(clean_review: false)
    FileUtils.mkdir_p(AUDIT_EXAM_DIR)
    FileUtils.mkdir_p(ANALYSEN_DIR)

    mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
    valid_topics = mapping.fetch("topics").keys
    valid_sources = mapping.fetch("sources").keys

    exam_files = Dir.glob(AUDIT_EXAM_DIR.join("*.json").to_s).sort
    exams_out = []
    tasks_out = []
    errors = []

    exam_files.each do |path|
      data = VaultSupport.read_json(path)
      eid = data["exam_id"].to_s.strip
      errors << "#{path}: exam_id fehlt" if eid.empty?
      errors << "#{eid}: visual_checked muss true sein (erst alle Seitenbilder visuell pruefen!)" unless data["visual_checked"] == true
      errors << "#{eid}: pruefung ungueltig" unless VALID_PRUEFUNGEN.include?(data["pruefung"])
      errors << "#{eid}: klausur_pdf fehlt auf Disk (#{data['klausur_pdf']})" unless data["klausur_pdf"] && ROOT.join(data["klausur_pdf"]).file?
      if data["loesung_pdf"]
        errors << "#{eid}: loesung_pdf fehlt auf Disk (#{data['loesung_pdf']})" unless ROOT.join(data["loesung_pdf"]).file?
      end

      raw_tasks = Array(data["tasks"])
      errors << "#{eid}: keine Aufgaben (tasks) eingetragen" if raw_tasks.empty?

      raw_tasks.each_with_index do |t, idx|
        t_label = "#{eid} Aufg. #{t['aufgabe'] || idx + 1}"
        errors << "#{t_label}: aufgabe fehlt" if t["aufgabe"].to_s.strip.empty?
        errors << "#{t_label}: punkte muss > 0 sein" unless t["punkte"].to_f.positive?
        errors << "#{t_label}: operator fehlt" if t["operator"].to_s.strip.empty?
        errors << "#{t_label}: aufgabentyp ungueltig (#{t['aufgabentyp']}; erlaubt: #{VALID_AUFGABENTYPEN.join(', ')})" unless VALID_AUFGABENTYPEN.include?(t["aufgabentyp"].to_s)
        errors << "#{t_label}: fragestellung_kurz fehlt" if t["fragestellung_kurz"].to_s.strip.empty?
        errors << "#{t_label}: klausur_seiten leer" if Array(t["klausur_seiten"]).empty?

        ctopics = Array(t["canonical_topics"])
        errors << "#{t_label}: canonical_topics darf nicht leer sein" if ctopics.empty?
        ctopics.each do |ct|
          errors << "#{t_label}: unbekanntes Thema '#{ct}' (nutze `import_altklausur.rb topics`)" unless valid_topics.include?(ct)
        end

        Array(t["quell_belege"]).each do |qb|
          sn = qb["source_note"].to_s
          errors << "#{t_label}: unbekannte source_note '#{sn}'" unless valid_sources.include?(sn)
        end
      end
    end

    unless errors.empty?
      warn "FEHLER bei der Altklausur-Validierung (#{errors.length}):"
      errors.each { |e| warn "- #{e}" }
      exit 1
    end

    exam_files.each do |path|
      data = VaultSupport.read_json(path)
      eid = data.fetch("exam_id")
      analyse_rel = "06_Altklausuren/Aufgabenanalysen/#{eid}.md"

      exams_out << {
        "exam_id" => eid,
        "pruefung" => data.fetch("pruefung"),
        "jahr" => data.fetch("jahr"),
        "termin" => data.fetch("termin"),
        "titel" => data.fetch("titel"),
        "klausur_pdf" => data.fetch("klausur_pdf"),
        "loesung_pdf" => data["loesung_pdf"],
        "gesamt_punkte" => data.fetch("gesamt_punkte", 100),
        "aufgaben_anzahl" => data.fetch("tasks").length,
        "analyse_path" => analyse_rel
      }.compact

      data.fetch("tasks").each do |t|
        tid = ExamHelpers.sanitize_id("#{eid}_#{t.fetch('aufgabe')}")
        tasks_out << {
          "task_id" => tid,
          "exam_id" => eid,
          "pruefung" => data.fetch("pruefung"),
          "jahr" => data.fetch("jahr"),
          "termin" => data.fetch("termin"),
          "aufgabe" => t.fetch("aufgabe"),
          "punkte" => t.fetch("punkte"),
          "operator" => t.fetch("operator"),
          "aufgabentyp" => t.fetch("aufgabentyp"),
          "klausur_pdf" => data.fetch("klausur_pdf"),
          "klausur_seiten" => Array(t.fetch("klausur_seiten")),
          "loesung_pdf" => data["loesung_pdf"],
          "loesung_seiten" => Array(t["loesung_seiten"]),
          "handlungsfeld_kontext" => t["handlungsfeld_kontext"],
          "fragestellung_kurz" => t.fetch("fragestellung_kurz"),
          "canonical_topics" => Array(t.fetch("canonical_topics")),
          "quell_belege" => Array(t["quell_belege"]),
          "erwartungshorizont_punkte" => Array(t["erwartungshorizont_punkte"]),
          "typische_fallen" => Array(t["typische_fallen"]),
          "analyse_path" => analyse_rel
        }.compact
      end

      write_exam_analysis_markdown(data, mapping, ROOT.join(analyse_rel))
    end

    today = exam_files.empty? ? VaultSupport.latest_audit_date : Date.today.strftime("%Y-%m-%d")
    index_payload = {
      "schema_version" => 1,
      "updated_on" => today,
      "hinweis" => "Maschinenlesbarer Index aller visuell geprueften Original-IHK-Altklausuren und offiziellen Loesungshinweise aus 06_Altklausuren/. Wird automatisch von ruby 01_Index/Tools/import_altklausur.rb apply gepflegt.",
      "totals" => {
        "exams" => exams_out.length,
        "tasks" => tasks_out.length,
        "tasks_with_official_solution" => tasks_out.count { |t| t["loesung_pdf"] && !Array(t["erwartungshorizont_punkte"]).empty? }
      },
      "exams" => exams_out,
      "tasks" => tasks_out
    }
    VaultSupport.write_json_if_changed(INDEX_OUTPUT_PATH, index_payload)

    unless exams_out.empty?
      update_referenzmatrix(tasks_out, mapping)
      update_haeufigkeitsanalyse(tasks_out, mapping)
    end

    FileUtils.rm_rf(REVIEW_ROOT) if clean_review && REVIEW_ROOT.directory?

    POST_SCRIPTS.each do |script|
      script_path = TOOLS_DIR.join(script)
      out, err, st = Open3.capture3("ruby", script_path.to_s)
      unless st.success?
        abort "Nachgelagerter Check #{script} fehlgeschlagen:\n#{out}\n#{err}"
      end
      puts out.strip unless out.strip.empty?
    end

    puts "Altklausuren-Sync erfolgreich: #{exams_out.length} Pruefungen, #{tasks_out.length} Aufgaben in #{INDEX_OUTPUT_PATH.relative_path_from(ROOT)}."
  end

  private

  def place_pdf!(src, dest, move:)
    return if src.realpath == (dest.file? ? dest.realpath : Pathname.new(""))

    in_inbox = src.to_s.start_with?(INBOX_DIR.to_s)
    if move && in_inbox
      FileUtils.mv(src, dest)
    else
      FileUtils.cp(src, dest)
    end
  end

  def write_exam_analysis_markdown(data, mapping, out_path)
    eid = data.fetch("exam_id")
    klausur_pdf = data.fetch("klausur_pdf")
    loesung_pdf = data["loesung_pdf"]
    lines = []
    lines << "---"
    lines << "typ: aufgabenanalyse"
    lines << "exam_id: \"#{eid}\""
    lines << "pruefung: \"#{data.fetch('pruefung')}\""
    lines << "jahr: #{data.fetch('jahr')}"
    lines << "termin: \"#{data.fetch('termin')}\""
    lines << "punkte: #{data.fetch('gesamt_punkte', 100)}"
    lines << "status: visuell_geprueft"
    lines << "---"
    lines << "# Altklausur-Analyse: #{data.fetch('titel')}"
    lines << ""
    lines << "- **Klausur-PDF:** [#{File.basename(klausur_pdf)}](<#{klausur_pdf}>)"
    lines << "- **Offizielle Lösung:** [#{File.basename(loesung_pdf)}](<#{loesung_pdf}>)" if loesung_pdf
    lines << "- **Erfasste Teilaufgaben:** #{data.fetch('tasks').length} (#{data.fetch('gesamt_punkte', 100)} Punkte)"
    lines << ""

    data.fetch("tasks").each do |t|
      kp = Array(t["klausur_seiten"]).first || 1
      lp = Array(t["loesung_seiten"]).first || 1
      lines << "## Aufgabe #{t['aufgabe']} (#{t['punkte']} Punkte) · Operator: #{t['operator']}"
      lines << ""
      lines << "- **Aufgabentyp:** `#{t['aufgabentyp']}`"
      lines << "- **Klausur-Referenz:** [#{File.basename(klausur_pdf)} S. #{Array(t['klausur_seiten']).join(', ')}](<#{klausur_pdf}#page=#{kp}>)"
      lines << "- **Lösungs-Referenz:** [#{File.basename(loesung_pdf)} S. #{Array(t['loesung_seiten']).join(', ')}](<#{loesung_pdf}#page=#{lp}>)" if loesung_pdf && !Array(t["loesung_seiten"]).empty?

      topic_links = Array(t["canonical_topics"]).map do |ct|
        t_path = mapping.dig("topics", ct, "path").to_s.delete_suffix(".md")
        "[[#{t_path}|#{ct}]]"
      end
      lines << "- **Kanonische Themen:** #{topic_links.join(', ')}"

      unless Array(t["quell_belege"]).empty?
        q_links = Array(t["quell_belege"]).map do |qb|
          sn = qb.fetch("source_note").delete_suffix(".md")
          "[[#{sn}|#{File.basename(sn)}]] (S. #{qb['pages']})"
        end
        lines << "- **Skript-Belege im Vault:** #{q_links.join(', ')}"
      end

      lines << "- **Handlungssituation:** #{t['handlungsfeld_kontext']}" unless t["handlungsfeld_kontext"].to_s.strip.empty?
      lines << "- **Gefordert:** #{t['fragestellung_kurz']}"

      unless Array(t["erwartungshorizont_punkte"]).empty?
        lines << ""
        lines << "### Erwartungshorizont / Bewertungsmaßstab"
        Array(t["erwartungshorizont_punkte"]).each { |ep| lines << "- #{ep}" }
      end

      unless Array(t["typische_fallen"]).empty?
        lines << ""
        lines << "### Typische Prüfungsfallen"
        Array(t["typische_fallen"]).each { |tf| lines << "- #{tf}" }
      end
      lines << ""
    end

    VaultSupport.write_if_changed(out_path, lines.join("\n") + "\n")
  end

  def update_referenzmatrix(tasks, mapping)
    rows = tasks.map do |t|
      topic_links = Array(t["canonical_topics"]).map do |ct|
        tp = mapping.dig("topics", ct, "path").to_s.delete_suffix(".md")
        "[[#{tp}\\|#{ct}]]"
      end.join(", ")
      src_cell = if Array(t["quell_belege"]).empty?
                   "—"
                 else
                   Array(t["quell_belege"]).map do |qb|
                     sn = qb.fetch("source_note").delete_suffix(".md")
                     "[[#{sn}\\|#{File.basename(sn)}]]"
                   end.join(", ")
                 end
      pages_cell = Array(t["quell_belege"]).empty? ? "—" : Array(t["quell_belege"]).map { |qb| qb["pages"] }.join("; ")
      loes_cell = t["loesung_pdf"] ? "ja" : "nein"
      analyse_link = "[[#{t['analyse_path'].delete_suffix('.md')}\\|Analyse]]"
      "| #{t['pruefung']} | #{t['termin']} #{t['jahr']} | #{t['aufgabe']} | #{t['punkte']} | #{topic_links} | #{src_cell} | #{pages_cell} | #{loes_cell} | #{analyse_link} |"
    end.join("\n")

    md = <<~MARKDOWN
      ---
      typ: referenzmatrix
      status: aktiv
      ---
      # Referenzmatrix Altklausuren

      > [!altklausur] Automatisch gepflegt durch `import_altklausur.rb`
      > Jede importierte Original-IHK-Aufgabe ist hier mit Punktzahl, kanonischem Vault-Thema, Skript-Belegseiten und Einzelanalyse verknüpft.

      | Prüfung | Termin / Jahr | Aufgabe | Punkte | Thema | Quelle | PDF-Seite | Lösung vorhanden | Fehleranalyse |
      |---|---|---|---:|---|---|---|---|---|
      #{rows}
    MARKDOWN
    VaultSupport.write_if_changed(REFERENZMATRIX_PATH, md)
  end

  def update_haeufigkeitsanalyse(tasks, mapping)
    stats = Hash.new { |h, k| h[k] = { ap1: 0, ap2: 0, punkte: 0.0, last_seen: "" } }
    tasks.each do |t|
      is_ap1 = t["pruefung"] == "AP1"
      label = "#{t['jahr']} (#{t['termin']})"
      Array(t["canonical_topics"]).each do |ct|
        s = stats[ct]
        is_ap1 ? s[:ap1] += 1 : s[:ap2] += 1
        s[:punkte] += t["punkte"].to_f
        s[:last_seen] = [s[:last_seen], label].max
      end
    end

    rows = stats.sort_by { |ct, s| [-(s[:ap1] + s[:ap2]), -s[:punkte], ct] }.map do |ct, s|
      tp = mapping.dig("topics", ct, "path").to_s.delete_suffix(".md")
      "| [[#{tp}\\|#{ct}]] | #{s[:ap1]} | #{s[:ap2]} | #{s[:punkte].round(1)} | #{s[:last_seen]} |"
    end.join("\n")

    md = <<~MARKDOWN
      ---
      typ: haeufigkeitsanalyse
      status: aktiv
      ---
      # Häufigkeitsanalyse Original-IHK-Altklausuren

      > [!altklausur] Automatisch berechnet aus `01_Index/Altklausuren_Index.json`
      > Zeigt, wie oft und mit wie vielen Gesamtpunkten jedes kanonische Thema in deinen hochgeladenen Original-Prüfungen vorkam.

      | Thema | AP1 Aufgaben | AP2 Aufgaben | Summe Punkte | Letztes Auftreten |
      |---|---:|---:|---:|---|
      #{rows}
    MARKDOWN
    VaultSupport.write_if_changed(HAEUFIGKEIT_PATH, md)
  end
end

def usage
  puts <<~HELP
    Verwendung: ruby 01_Index/Tools/import_altklausur.rb <befehl> [optionen]

    Befehle:
      scan [pfad]                      Posteingang 06_Altklausuren/00_Posteingang/ scannen & Klausur+Loesung paaren
      topics                           Alle gueltigen kanonischen Vault-Themen fuer das Mapping auflisten
      prepare <klausur.pdf> [opt]      Klausur (und optional Loesung) ablegen, Seiten als PNG rendern & Audit-JSON anlegen
        --loesung <loesung.pdf>        Zugehoerige offizielle IHK-Loesungshinweise-PDF
        --pruefung <AP1|AP2_GA1|...>   Pruefungstyp (AP1, AP2_GA1, AP2_GA2, AP2_WiSo, AP2)
        --jahr <JJJJ>                  Pruefungsjahr (z. B. 2025)
        --termin <Fruehjahr|Herbst|..> Pruefungstermin (Fruehjahr, Sommer, Herbst, Winter)
        --titel "<Titel>"              Optionaler Anzeigetitel
        --variant "<Suffix>"           Optionaler Zusatz (z. B. Nachschreiber)
        --move                         Aus 06_Altklausuren/00_Posteingang/ verschieben statt kopieren
      apply [--clean-review]           Alle Altklausur-JSONs validieren, Index + Analysen + Matrizen bauen & pruefen
  HELP
end

if ARGV.empty? || %w[-h --help help].include?(ARGV.first)
  usage
  exit 0
end

cmd = ARGV.shift
opts = {
  loesung: nil,
  pruefung: nil,
  jahr: nil,
  termin: nil,
  titel: nil,
  variant: nil,
  move: false,
  clean_review: false
}

OptionParser.new do |o|
  o.on("--loesung PATH") { |v| opts[:loesung] = v }
  o.on("--pruefung TYPE") { |v| opts[:pruefung] = v }
  o.on("--jahr YEAR", Integer) { |v| opts[:jahr] = v }
  o.on("--termin TERM") { |v| opts[:termin] = v }
  o.on("--titel TITLE") { |v| opts[:titel] = v }
  o.on("--variant VAR") { |v| opts[:variant] = v }
  o.on("--move") { opts[:move] = true }
  o.on("--clean-review") { opts[:clean_review] = true }
end.parse!(ARGV)

pipeline = AltklausurPipeline.new

case cmd
when "scan"
  pipeline.cmd_scan(ARGV.first)
when "topics"
  pipeline.cmd_topics
when "prepare"
  abort "Bitte <klausur_pdf>, --pruefung, --jahr und --termin angeben." if ARGV.empty? || !opts[:pruefung] || !opts[:jahr] || !opts[:termin]
  pipeline.cmd_prepare(
    ARGV.first,
    pruefung: opts[:pruefung],
    jahr: opts[:jahr],
    termin: opts[:termin],
    loesung_arg: opts[:loesung],
    titel: opts[:titel],
    move: opts[:move],
    variant: opts[:variant]
  )
when "apply"
  pipeline.cmd_apply(clean_review: opts[:clean_review])
else
  warn "Unbekannter Befehl: #{cmd}"
  usage
  exit 1
end
