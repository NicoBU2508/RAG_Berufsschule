#!/usr/bin/env ruby
# frozen_string_literal: true

# GoodNotes-Import-Pipeline für den Obsidian AP-Lernhelfer.
#
# Befehle:
#   ruby 01_Index/Tools/import_goodnotes.rb scan [pfad]
#   ruby 01_Index/Tools/import_goodnotes.rb prepare <pdf> --fach <FACH> [optionen]
#   ruby 01_Index/Tools/import_goodnotes.rb prepare <pdf> --update-existing <quellnotiz> [optionen]
#   ruby 01_Index/Tools/import_goodnotes.rb apply [--clean-review]
#   ruby 01_Index/Tools/import_goodnotes.rb topics
#
# Temporäre Render-Bilder, Fingerprint-Cache und das kompilierte Swift-Werkzeug
# liegen unter /tmp/ap_lernhelfer_import/, damit iCloud Drive und Git unbelastet bleiben.

require "date"
require "digest"
require "fileutils"
require "json"
require "open3"
require "optparse"
require "pathname"
require "yaml"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
INBOX_DIR = ROOT.join("00_Posteingang_GoodNotes")
ORIGINALS_DIR = ROOT.join("99_Originale")
TOOLS_DIR = ROOT.join("01_Index/Tools")
SWIFT_SOURCE = TOOLS_DIR.join("goodnotes_pdf_tool.swift")
WORK_TMP = Pathname.new("/tmp/ap_lernhelfer_import")
BINARY_PATH = WORK_TMP.join("bin/goodnotes_pdf_tool")
MODCACHE_PATH = WORK_TMP.join("modcache")
REVIEW_ROOT = WORK_TMP.join("review")
FP_CACHE_PATH = WORK_TMP.join("original_fingerprints.json")
MANIFEST_PATH = ROOT.join("manifest.json")
DUPLICATES_PATH = ROOT.join("01_Index/Auditdaten/PDF_Duplikatnachweis.json")

PRIVACY_PATH_PATTERN = /(^|[\/_\-\s.])(noten|zeugnis|zeugnisse|privat|gehalt|kontoauszug|passwort|pin|tan)([\/_\-\s.]|$)/i

FACH_CONFIG = {
  "AE_Anwendungsentwicklung" => {
    anzeige: "AE Anwendungsentwicklung",
    pdf_dir: "99_Originale/Berufsschule/AE",
    pruefung: "AP1, AP2",
    tag: "ae_anwendungsentwicklung",
    aliases: %w[ae anwendungsentwicklung java programmierung programmieren]
  },
  "Allgemein_Berufsschule" => {
    anzeige: "Allgemein Berufsschule",
    pdf_dir: "99_Originale/Berufsschule/Allgemein",
    pruefung: "AP1, AP2",
    tag: "allgemein_berufsschule",
    aliases: %w[allgemein berufsschule]
  },
  "BGWP_Betriebswirtschaft" => {
    anzeige: "BGWP Betriebswirtschaft",
    pdf_dir: "99_Originale/Berufsschule/BGWP",
    pruefung: "AP1, WiSo",
    tag: "bgwp_betriebswirtschaft",
    aliases: %w[bgwp bwl wirtschaft betriebswirtschaft]
  },
  "Deutsch" => {
    anzeige: "Deutsch",
    pdf_dir: "99_Originale/Berufsschule/Deutsch",
    pruefung: "AP1, WiSo",
    tag: "deutsch",
    aliases: %w[de deutsch]
  },
  "Englisch" => {
    anzeige: "Englisch",
    pdf_dir: "99_Originale/Berufsschule/Englisch",
    pruefung: "AP1, WiSo",
    tag: "englisch",
    aliases: %w[en englisch english]
  },
  "ITT_IT_Technik" => {
    anzeige: "ITT IT-Technik",
    pdf_dir: "99_Originale/Berufsschule/ITT",
    pruefung: "AP1, AP2",
    tag: "itt_it_technik",
    aliases: %w[itt it it_technik it-technik technik elektro elektrotechnik netzwerk sicherheit]
  },
  "PuG_Politik_und_Gesellschaft" => {
    anzeige: "PuG Politik und Gesellschaft",
    pdf_dir: "99_Originale/Berufsschule/PUG",
    pruefung: "AP1, WiSo",
    tag: "pug_politik_und_gesellschaft",
    aliases: %w[pug politik gesellschaft wiso sozialkunde]
  },
  "Religion" => {
    anzeige: "Religion",
    pdf_dir: "99_Originale/Berufsschule/Religion",
    pruefung: "WiSo",
    tag: "religion",
    aliases: %w[reli religion ethik]
  },
  "Vertretung" => {
    anzeige: "Vertretung",
    pdf_dir: "99_Originale/Berufsschule/Vertretung",
    pruefung: "AP1",
    tag: "vertretung",
    aliases: %w[vertretung]
  }
}.freeze

PIPELINE_SCRIPTS = %w[
  build_pdf_page_audit.rb
  compile_pdf_page_audit.rb
  build_verified_topics.rb
  build_copilot_allowlist.rb
  build_quellenmatrix.rb
  build_ki_manifest.rb
  sync_karteikarten.rb
  validate_nonprivate_links.rb
  validate_verified_source_layer.rb
].freeze

module PdfTool
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

module VisualMatch
  # Toleranz für winzige GoodNotes-Neuexport-Drift (Kompression/Antialiasing),
  # erkennt aber bereits kleine handschriftliche Ergänzungen als Änderung.
  MAX_MEAN_DIFF = 1.5
  PIXEL_CHANGE_THRESHOLD = 12
  MAX_CHANGED_PIXELS = 2

  module_function

  def same_page?(fp_a, fp_b)
    return false if fp_a.nil? || fp_b.nil? || fp_a.empty? || fp_b.empty?
    return true if fp_a == fp_b
    return false unless fp_a.length == fp_b.length

    bytes_a = [fp_a].pack("H*").bytes
    bytes_b = [fp_b].pack("H*").bytes
    total_diff = 0
    changed_pixels = 0

    bytes_a.each_with_index do |val_a, idx|
      diff = (val_a - bytes_b[idx]).abs
      total_diff += diff
      changed_pixels += 1 if diff > PIXEL_CHANGE_THRESHOLD
      return false if changed_pixels > MAX_CHANGED_PIXELS
    end

    (total_diff.to_f / bytes_a.length) <= MAX_MEAN_DIFF
  end

  def changed_prefix_pages(old_prints, new_prints)
    limit = [old_prints.length, new_prints.length].min
    (0...limit).each_with_object([]) do |idx, changed|
      changed << (idx + 1) unless same_page?(old_prints[idx], new_prints[idx])
    end
  end

  def overlap_ratio(old_prints, new_prints)
    limit = [old_prints.length, new_prints.length].min
    return 0.0 if limit.zero?

    matches = (0...limit).count { |idx| same_page?(old_prints[idx], new_prints[idx]) }
    matches.to_f / limit
  end
end

module Helpers
  module_function

  def resolve_fach(input)
    cleaned = input.to_s.strip
    return cleaned if FACH_CONFIG.key?(cleaned)

    down = cleaned.downcase
    match = FACH_CONFIG.find do |key, cfg|
      key.downcase == down || cfg[:aliases].include?(down)
    end
    return match.first if match

    abort "Unbekanntes Fach '#{input}'. Erlaubt: #{FACH_CONFIG.keys.join(', ')} (oder Kürzel wie ae, bgwp, itt, pug, deutsch, englisch, religion)."
  end

  def infer_fach_from_path(rel_or_abs_path)
    segments = VaultSupport.nfc(rel_or_abs_path.to_s).split("/").map(&:downcase)
    return "AE_Anwendungsentwicklung" if segments.any? { |s| s.match?(/\A(ae|aeup|java|anwendungsentwicklung)\z/) || s.include?("anwendungsentwicklung") }
    return "BGWP_Betriebswirtschaft" if segments.any? { |s| s.include?("bgwp") || s.include?("betriebswirtschaft") || s == "bwl" }
    return "ITT_IT_Technik" if segments.any? { |s| s.match?(/\A(itt|it-tech|fu-it)\b/) || s.include?("it sicherheit") || s.include?("elektro") || s.include?("netzwerk") || s == "otma" }
    return "Deutsch" if segments.any? { |s| s == "deutsch" }
    return "Englisch" if segments.any? { |s| s == "englisch" || s == "english" }
    return "PuG_Politik_und_Gesellschaft" if segments.any? { |s| s == "pug" || s.include?("politik") }
    return "Religion" if segments.any? { |s| s == "religion" || s == "reli" || s == "ethik" }
    return "Vertretung" if segments.any? { |s| s == "vertretung" }

    nil
  end

  def infer_lehrjahr_from_path(rel_or_abs_path)
    segments = VaultSupport.nfc(rel_or_abs_path.to_s).split("/")
    segments.each do |seg|
      match = seg.match(/\A([1-3])[._\-\s]?lj\z/i)
      return "#{match[1]}_LJ" if match
    end
    nil
  end

  def privacy_flagged?(path_str)
    VaultSupport.nfc(path_str.to_s).match?(PRIVACY_PATH_PATTERN)
  end

  def sanitize_note_name(raw)
    name = raw.to_s.unicode_normalize(:nfc).sub(/\.pdf\z/i, "")
    replacements = {
      "ä" => "ae", "ö" => "oe", "ü" => "ue", "ß" => "ss",
      "Ä" => "Ae", "Ö" => "Oe", "Ü" => "Ue"
    }
    replacements.each { |from, to| name = name.gsub(from, to) }
    name = name.unicode_normalize(:nfkd).encode("ASCII", invalid: :replace, undef: :replace, replace: "")
    name = name.gsub(/[^A-Za-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
    name.empty? ? "GoodNotes_Import_#{Date.today.strftime('%Y%m%d')}" : name
  end

  def sanitize_slug(raw)
    sanitize_note_name(raw).downcase
  end

  def escape_code_fences(text)
    text.to_s.gsub("```", "'''")
  end

  def read_frontmatter(path)
    text = File.read(path, encoding: "UTF-8")
    parts = text.split(/^---\s*$\n?/, 3)
    return {} unless parts.length == 3

    YAML.safe_load(parts[1], permitted_classes: [Date, Time], aliases: true) || {}
  end

  def source_by_pdf_nfc
    Dir.glob(ROOT.join("02_Faecher/*/Quellen/*.md").to_s).sort.each_with_object({}) do |path, index|
      meta = read_frontmatter(path)
      pdf = meta["original_pfad"]
      next unless pdf

      index[VaultSupport.nfc(pdf)] = {
        source_note: VaultSupport.relative(path),
        fach: meta["fach"],
        seiten: meta["seiten"].to_i,
        pdf_path: pdf
      }
    end
  end

  def known_duplicate_map_nfc
    return {} unless DUPLICATES_PATH.file?

    data = VaultSupport.read_json(DUPLICATES_PATH)
    data.fetch("pairs", []).each_with_object({}) do |pair, map|
      map[VaultSupport.nfc(pair.fetch("duplicate_pdf"))] = pair.fetch("canonical_pdf")
    end
  end

  def sha256(path)
    Digest::SHA256.file(path).hexdigest
  end

  def resolve_input_path(raw)
    path = Pathname.new(raw)
    return path.realpath if path.exist?

    in_root = ROOT.join(raw)
    return in_root.realpath if in_root.exist?

    in_inbox = INBOX_DIR.join(raw)
    return in_inbox.realpath if in_inbox.exist?

    abort "Datei oder Ordner nicht gefunden: #{raw}"
  end
end

class OriginalFingerprintStore
  def initialize
    @cache = load_cache
    @dirty = false
  end

  def load_all(originals)
    entries = originals.map do |abs_path|
      rel = VaultSupport.relative(abs_path)
      stat = File.stat(abs_path)
      cached = @cache[rel]
      if cached && cached["size"] == stat.size && cached["mtime"] == stat.mtime.to_i
        cached.merge("pdf" => rel)
      else
        fp = PdfTool.run("fingerprint", abs_path)
        record = {
          "size" => stat.size,
          "mtime" => stat.mtime.to_i,
          "sha256" => Helpers.sha256(abs_path),
          "page_count" => fp.fetch("page_count"),
          "fingerprints" => fp.fetch("fingerprints")
        }
        @cache[rel] = record
        @dirty = true
        record.merge("pdf" => rel)
      end
    end
    save_cache if @dirty
    entries
  end

  private

  def load_cache
    return {} unless FP_CACHE_PATH.file?

    JSON.parse(File.read(FP_CACHE_PATH, encoding: "UTF-8"))
  rescue JSON::ParserError
    {}
  end

  def save_cache
    FileUtils.mkdir_p(FP_CACHE_PATH.dirname)
    File.write(FP_CACHE_PATH, JSON.pretty_generate(@cache) + "\n")
  end
end

class Scanner
  def run(target = nil)
    pdfs = locate_pdfs(target)
    if pdfs.empty?
      puts "Keine neuen PDFs gefunden (Posteingang: #{INBOX_DIR.relative_path_from(ROOT)})."
      return
    end

    originals = Dir.glob(ORIGINALS_DIR.join("**/*.pdf").to_s).sort
    original_records = OriginalFingerprintStore.new.load_all(originals)
    original_by_sha = original_records.each_with_object({}) { |rec, map| map[rec.fetch("sha256")] = rec }
    source_map = Helpers.source_by_pdf_nfc
    duplicate_map = Helpers.known_duplicate_map_nfc

    results = pdfs.map do |pdf|
      analyze_pdf(pdf, original_records, original_by_sha, source_map, duplicate_map)
    end

    summary = results.each_with_object(Hash.new(0)) { |item, counts| counts[item.fetch("status")] += 1 }.sort.to_h
    puts JSON.pretty_generate({
      "inbox" => INBOX_DIR.relative_path_from(ROOT).to_s,
      "total" => results.length,
      "summary" => summary,
      "candidates" => results
    })
  end

  private

  def locate_pdfs(target)
    if target
      path = Helpers.resolve_input_path(target)
      return [path] if path.file?

      return Dir.glob(path.join("**/*.pdf").to_s).sort.map { |item| Pathname.new(item) }
    end

    return [] unless INBOX_DIR.directory?

    Dir.glob(INBOX_DIR.join("**/*.pdf").to_s).sort.map { |item| Pathname.new(item) }
  end

  def display_path(pdf)
    pdf.to_s.start_with?(ROOT.to_s) ? VaultSupport.relative(pdf) : pdf.to_s
  end

  def relative_inside_inbox(pdf)
    return pdf.relative_path_from(INBOX_DIR).to_s if pdf.to_s.start_with?(INBOX_DIR.to_s)

    pdf.basename.to_s
  end

  def analyze_pdf(pdf, original_records, original_by_sha, source_map, duplicate_map)
    rel_display = display_path(pdf)
    rel_in_inbox = relative_inside_inbox(pdf)

    # Datenschutz-Stopp VOR dem Öffnen/Rendern der PDF!
    if Helpers.privacy_flagged?(rel_in_inbox)
      return {
        "file" => rel_display,
        "basename" => pdf.basename.to_s,
        "privacy_warning" => true,
        "status" => "SKIP_PRIVATE",
        "reason" => "Ordner- oder Dateiname deutet auf private/sensible Daten hin – PDF wurde nicht geöffnet oder gerendert."
      }
    end

    digest = Helpers.sha256(pdf)
    if original_by_sha.key?(digest)
      matched = original_by_sha.fetch(digest)
      existing_pdf = matched.fetch("pdf")
      canonical_pdf = duplicate_map[VaultSupport.nfc(existing_pdf)] || existing_pdf
      return {
        "file" => rel_display,
        "basename" => pdf.basename.to_s,
        "pages" => matched.fetch("page_count"),
        "privacy_warning" => false,
        "status" => "DUPLICATE_EXACT",
        "matches_pdf" => existing_pdf,
        "canonical_pdf" => canonical_pdf,
        "matches_source_note" => source_map.dig(VaultSupport.nfc(canonical_pdf), :source_note)
      }
    end

    new_fp = PdfTool.run("fingerprint", pdf)
    new_prints = new_fp.fetch("fingerprints")
    pages = new_fp.fetch("page_count")

    # 1. Visuelle Übereinstimmung gegen ALLE Originale suchen (erkennt auch
    #    frische GoodNotes-Neuexporte mit anderem Zeitstempel, Unterordner und Umbenennungen!)
    best_match = find_best_visual_match(rel_in_inbox, pdf.basename.to_s, new_prints, original_records)

    if best_match
      rec = best_match[:record]
      existing_pdf = rec.fetch("pdf")
      canonical_pdf = duplicate_map[VaultSupport.nfc(existing_pdf)] || existing_pdf
      source_note = source_map.dig(VaultSupport.nfc(canonical_pdf), :source_note)
      old_prints = rec.fetch("fingerprints")
      old_count = old_prints.length
      changed = VisualMatch.changed_prefix_pages(old_prints, new_prints)

      if pages == old_count && changed.empty?
        return {
          "file" => rel_display,
          "basename" => pdf.basename.to_s,
          "pages" => pages,
          "privacy_warning" => false,
          "status" => "DUPLICATE_VISUAL",
          "match_type" => best_match[:reason],
          "matches_pdf" => existing_pdf,
          "canonical_pdf" => canonical_pdf,
          "matches_source_note" => source_note
        }
      end

      if pages > old_count && changed.empty?
        return {
          "file" => rel_display,
          "basename" => pdf.basename.to_s,
          "pages" => pages,
          "privacy_warning" => false,
          "status" => "EXTENDED_NOTEBOOK",
          "match_type" => best_match[:reason],
          "existing_pdf" => canonical_pdf,
          "existing_source_note" => source_note,
          "existing_pages" => old_count,
          "new_pages_from" => old_count + 1,
          "new_pages_count" => pages - old_count,
          "suggested_command" => source_note ? "ruby 01_Index/Tools/import_goodnotes.rb prepare \"#{rel_display}\" --update-existing \"#{source_note}\" --move" : nil
        }.compact
      end

      result = {
        "file" => rel_display,
        "basename" => pdf.basename.to_s,
        "pages" => pages,
        "privacy_warning" => false,
        "status" => "MODIFIED_EXISTING",
        "match_type" => best_match[:reason],
        "existing_pdf" => canonical_pdf,
        "existing_source_note" => source_note,
        "existing_pages" => old_count,
        "changed_prefix_pages" => changed
      }
      if pages > old_count
        result["new_pages_from"] = old_count + 1
        result["new_pages_count"] = pages - old_count
      end
      return result
    end

    suggested_fach = Helpers.infer_fach_from_path(rel_in_inbox)
    entry = {
      "file" => rel_display,
      "basename" => pdf.basename.to_s,
      "pages" => pages,
      "privacy_warning" => false,
      "status" => "NEW"
    }
    if suggested_fach
      entry["suggested_fach"] = suggested_fach
      entry["suggested_command"] = "ruby 01_Index/Tools/import_goodnotes.rb prepare \"#{rel_display}\" --fach #{suggested_fach} --move"
    end
    entry
  end

  def find_best_visual_match(rel_in_inbox, basename, new_prints, original_records)
    rel_norm = VaultSupport.nfc(rel_in_inbox).downcase
    base_norm = VaultSupport.nfc(basename).downcase

    # Kandidaten nach Priorität: exakter Pfad-Suffix, gleicher Dateiname, dann visueller Vollvergleich
    scored = original_records.map do |rec|
      old_prints = rec.fetch("fingerprints")
      next nil if old_prints.empty? || new_prints.empty?

      rec_norm = VaultSupport.nfc(rec.fetch("pdf")).downcase
      rec_base = VaultSupport.nfc(File.basename(rec.fetch("pdf"))).downcase
      path_suffix_match = rec_norm.end_with?("/#{rel_norm}") || rec_norm == "99_originale/#{rel_norm}"
      name_match = rec_base == base_norm

      # Schnellfilter für nicht-namensgleiche Dateien: Seite 1 (oder Seite 2 bei neuem Deckblatt) prüfen.
      # Einseitige PDFs nicht fälschlich gegen Seite 1 eines mehrseitigen fremden PDFs matchen (z.B. leeres Blatt).
      unless path_suffix_match || name_match
        next nil if [old_prints.length, new_prints.length].min == 1 && old_prints.length != new_prints.length

        first_hit = VisualMatch.same_page?(old_prints[0], new_prints[0]) ||
          (old_prints.length > 1 && new_prints.length > 1 && VisualMatch.same_page?(old_prints[1], new_prints[1]))
        next nil unless first_hit
      end

      overlap = VisualMatch.overlap_ratio(old_prints, new_prints)
      next nil unless path_suffix_match || name_match || overlap >= 0.7

      score = overlap * 100.0
      score += 10.0 if path_suffix_match
      score += 5.0 if name_match
      score += 2.0 if old_prints.length == new_prints.length

      reason = if path_suffix_match
                 "path_and_visual"
               elsif name_match
                 "filename_and_visual"
               else
                 "visual_content_match"
               end

      { record: rec, overlap: overlap, score: score, reason: reason }
    end.compact

    scored.max_by { |item| item[:score] }
  end
end

class Preparer
  def run(args)
    options = {
      move: false,
      allow_sensitive_name: false,
      replaces_existing: false
    }
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: import_goodnotes.rb prepare <pdf> [options]"
      opts.on("--fach FACH", "Zielfach (z.B. AE, BGWP, ITT, Deutsch, Englisch, PuG, Religion)") { |v| options[:fach] = v }
      opts.on("--pdf-dest REL_PATH", "Zielpfad der PDF unter 99_Originale/...") { |v| options[:pdf_dest] = v }
      opts.on("--note-name NAME", "Dateiname der Quellnotiz ohne .md (ohne Komma)") { |v| options[:note_name] = v }
      opts.on("--pruefung TEXT", "Prüfungsbezug, z.B. 'AP1, AP2'") { |v| options[:pruefung] = v }
      opts.on("--update-existing SOURCE_NOTE", "Bestehende Quellnotiz um neue Seiten erweitern") { |v| options[:update_existing] = v }
      opts.on("--from-page N", Integer, "Erste zu extrahierende Seite (Standard: 1 bzw. alt+1)") { |v| options[:from_page] = v }
      opts.on("--replaces-existing", "Ersetzt bestehende Audit-Einträge ab --from-page") { options[:replaces_existing] = true }
      opts.on("--move", "Quell-PDF aus Posteingang verschieben statt kopieren") { options[:move] = true }
      opts.on("--allow-sensitive-name", "Dateinamen-Sicherheitsprüfung bewusst übersteuern") { options[:allow_sensitive_name] = true }
    end
    remaining = parser.parse(args)
    abort parser.to_s if remaining.empty?

    input_pdf = Helpers.resolve_input_path(remaining.first)
    abort "Keine PDF-Datei: #{input_pdf}" unless input_pdf.extname.downcase == ".pdf"

    rel_for_privacy = input_pdf.to_s.start_with?(INBOX_DIR.to_s) ? input_pdf.relative_path_from(INBOX_DIR).to_s : input_pdf.basename.to_s
    if !options[:allow_sensitive_name] && Helpers.privacy_flagged?(rel_for_privacy)
      abort "Datenschutz-Stopp: Pfad '#{rel_for_privacy}' wirkt privat/sensibel. Niemals Noten oder private Daten in den KI-Vault importieren! Falls es sicherer Unterrichtsstoff ist, mit --allow-sensitive-name erneut aufrufen."
    end

    if options[:update_existing]
      prepare_update(input_pdf, options)
    else
      options[:fach] ||= Helpers.infer_fach_from_path(rel_for_privacy)
      abort "Bitte --fach angeben (oder --update-existing für ein bestehendes GoodNotes-Notizbuch)." unless options[:fach]
      prepare_new(input_pdf, options)
    end
  end

  private

  def prepare_new(input_pdf, options)
    fach = Helpers.resolve_fach(options[:fach])
    cfg = FACH_CONFIG.fetch(fach)

    lj = Helpers.infer_lehrjahr_from_path(input_pdf.to_s)
    default_dir = lj && cfg[:pdf_dir].start_with?("99_Originale/Berufsschule") ? File.join(cfg[:pdf_dir], lj) : cfg[:pdf_dir]
    dest_rel = options[:pdf_dest] || File.join(default_dir, input_pdf.basename.to_s)
    abort "--pdf-dest muss unter 99_Originale/ liegen" unless dest_rel.start_with?("99_Originale/")
    abort "Dateipfad darf kein Komma enthalten: #{dest_rel}" if dest_rel.include?(",")

    dest_abs = ROOT.join(dest_rel)
    if dest_abs.file? && dest_abs.realpath != input_pdf.realpath
      abort "Ziel-PDF existiert bereits: #{dest_rel}. Für ein aktualisiertes Notizbuch bitte --update-existing nutzen oder --pdf-dest anpassen."
    end

    note_base = Helpers.sanitize_note_name(options[:note_name] || input_pdf.basename.to_s)
    abort "Notizname darf kein Komma enthalten: #{note_base}" if note_base.include?(",")

    source_note_rel = "02_Faecher/#{fach}/Quellen/#{note_base}.md"
    source_note_abs = ROOT.join(source_note_rel)
    abort "Quellnotiz existiert bereits: #{source_note_rel}. Bitte --note-name anders wählen oder --update-existing nutzen." if source_note_abs.file?

    place_pdf(input_pdf, dest_abs, move: options[:move])

    slug = "#{Date.today.strftime('%Y%m%d')}_#{Helpers.sanitize_slug(note_base)}"
    review_dir = REVIEW_ROOT.join(slug)
    FileUtils.rm_rf(review_dir)
    extracted = PdfTool.run("extract", dest_abs, review_dir, 1)
    pages = extracted.fetch("pages")
    page_count = extracted.fetch("page_count")
    abort "PDF enthält keine Seiten: #{dest_rel}" if page_count.zero?

    pruefung = options[:pruefung] || cfg[:pruefung]
    title = input_pdf.basename(".pdf").to_s.tr("_", " ")
    markdown = build_new_source_note(
      fach: fach,
      cfg: cfg,
      title: title,
      pdf_rel: dest_rel,
      page_count: page_count,
      pruefung: pruefung,
      pages: pages
    )
    FileUtils.mkdir_p(source_note_abs.dirname)
    File.write(source_note_abs, markdown)

    audit_path = write_import_audit_draft(
      slug: slug,
      source_note_rel: source_note_rel,
      pdf_rel: dest_rel,
      pages: pages,
      replaces_existing: false
    )
    review_manifest = write_review_manifest(review_dir, source_note_rel, dest_rel, audit_path, pages)

    print_prepare_summary(
      mode: "NEW",
      source_note_rel: source_note_rel,
      pdf_rel: dest_rel,
      audit_path: audit_path,
      review_manifest: review_manifest,
      pages: pages
    )
  end

  def prepare_update(input_pdf, options)
    source_note_rel = options[:update_existing].sub(%r{\A\./}, "")
    source_note_abs = ROOT.join(source_note_rel)
    abort "Bestehende Quellnotiz nicht gefunden: #{source_note_rel}" unless source_note_abs.file?

    meta = Helpers.read_frontmatter(source_note_abs)
    dest_rel = meta.fetch("original_pfad")
    dest_abs = ROOT.join(dest_rel)
    old_page_count = meta.fetch("seiten").to_i

    info = PdfTool.run("info", input_pdf)
    new_page_count = info.fetch("page_count")
    start_page = options[:from_page] || (old_page_count + 1)

    if !options[:replaces_existing] && new_page_count <= old_page_count
      abort "Neue PDF hat #{new_page_count} Seiten, bestehende Quelle hat bereits #{old_page_count} Seiten. Falls bestehende Seiten ersetzt werden sollen, --from-page N --replaces-existing verwenden."
    end

    if dest_abs.file? && dest_abs.realpath != input_pdf.realpath && !options[:replaces_existing] && start_page == old_page_count + 1
      old_fp = PdfTool.run("fingerprint", dest_abs).fetch("fingerprints")
      new_fp = PdfTool.run("fingerprint", input_pdf).fetch("fingerprints")
      changed = VisualMatch.changed_prefix_pages(old_fp, new_fp)
      unless changed.empty?
        warn "WARNUNG: Frühere Seiten #{VaultSupport.compact_ranges(changed)} weichen visuell vom bisherigen Original ab! Prüfe diese Seiten ggf. ebenfalls mit --from-page #{changed.first} --replaces-existing."
      end
    end

    place_pdf(input_pdf, dest_abs, move: options[:move])

    slug = "#{Date.today.strftime('%Y%m%d')}_#{Helpers.sanitize_slug(File.basename(source_note_rel, '.md'))}_s#{start_page}_#{new_page_count}"
    review_dir = REVIEW_ROOT.join(slug)
    FileUtils.rm_rf(review_dir)
    extracted = PdfTool.run("extract", dest_abs, review_dir, start_page)
    pages = extracted.fetch("pages")
    abort "Keine Seiten ab Seite #{start_page} extrahiert." if pages.empty?

    update_source_note_pages(source_note_abs, dest_rel, new_page_count, pages)

    audit_path = write_import_audit_draft(
      slug: slug,
      source_note_rel: source_note_rel,
      pdf_rel: dest_rel,
      pages: pages,
      replaces_existing: options[:replaces_existing] || start_page <= old_page_count
    )
    review_manifest = write_review_manifest(review_dir, source_note_rel, dest_rel, audit_path, pages)

    print_prepare_summary(
      mode: "UPDATE (Seiten #{start_page}–#{new_page_count}, vorher #{old_page_count})",
      source_note_rel: source_note_rel,
      pdf_rel: dest_rel,
      audit_path: audit_path,
      review_manifest: review_manifest,
      pages: pages
    )
  end

  def place_pdf(input_pdf, dest_abs, move:)
    FileUtils.mkdir_p(dest_abs.dirname)
    return if dest_abs.file? && dest_abs.realpath == input_pdf.realpath

    if move
      FileUtils.mv(input_pdf, dest_abs)
    else
      FileUtils.cp(input_pdf, dest_abs)
    end
  end

  def best_text_for(page_record)
    layer = page_record.fetch("text_layer", "").strip
    ocr = page_record.fetch("ocr_text", "").strip
    if layer.length >= 25
      [:text_layer, layer]
    elsif ocr.length >= 25
      [:ocr, ocr]
    elsif !layer.empty?
      [:weak_layer, layer]
    elsif !ocr.empty?
      [:weak_ocr, ocr]
    else
      [:empty, ""]
    end
  end

  def render_page_section(pdf_rel, page_record)
    number = page_record.fetch("page")
    pdf_label = File.basename(pdf_rel)
    kind, text = best_text_for(page_record)
    safe_text = Helpers.escape_code_fences(text)

    body = case kind
           when :text_layer
             <<~TEXT
               #### Extrahierter Originaltext für Suche und KI

               ```text
               #{safe_text}
               ```
             TEXT
           when :ocr
             <<~TEXT
               > [!ocr] Lokale OCR-Erkennung (Vision)
               > Text aus lokaler Bilderkennung; Zahlen, Formeln, Code und Handschrift bei der Sichtprüfung am Original verifizieren.

               #### OCR-Text für Suche und KI

               ```text
               #{safe_text}
               ```
             TEXT
           when :weak_layer, :weak_ocr
             <<~TEXT
               > [!ocr] Kurzer/unsicherer Rohtext – bei Sichtprüfung prüfen oder ergänzen
               > Auf dieser Seite wurde nur wenig maschinenlesbarer Text erkannt. Bei Handschrift, Skizzen oder Scans den Inhalt aus der Sichtprüfung ergänzen.

               #### Extrahierter Originaltext für Suche und KI

               ```text
               #{safe_text}
               ```
             TEXT
           else
             <<~TEXT
               > [!ocr] Kein verwertbarer Text auf dieser Seite erkannt
               > Vermutlich Handschrift, Scan oder leere Seite. Bei der visuellen Prüfung entweder verifizierte Transkription ergänzen oder die Seite als leer/ausgeschlossen markieren.

               #### Extrahierter Originaltext für Suche und KI

               ```text
               ```
             TEXT
           end

    <<~MARKDOWN
      ### Seite #{number}

      > [!referenz] Exakte Referenz
      > - PDF-Seite: [#{pdf_label} Seite #{number}](<#{pdf_rel}#page=#{number}>)
      > - Obsidian-Einbettung: `![[#{pdf_rel}#page=#{number}]]`

      > [!example]- Originalseite im PDF-Layout anzeigen
      > ![[#{pdf_rel}#page=#{number}]]

      #{body.rstrip}
    MARKDOWN
  end

  def build_new_source_note(fach:, cfg:, title:, pdf_rel:, page_count:, pruefung:, pages:)
    pdf_label = File.basename(pdf_rel)
    page_sections = pages.map { |record| render_page_section(pdf_rel, record) }.join("\n")
    <<~MARKDOWN
      ---
      typ: quelle
      fach: #{JSON.generate(fach)}
      fach_anzeige: #{JSON.generate(cfg[:anzeige])}
      original_pfad: #{JSON.generate(pdf_rel)}
      seiten: #{page_count}
      pruefung: #{JSON.generate(pruefung)}
      cssclasses:
        - lernquelle
      tags:
        - berufsschule
        - quelle
        - #{cfg[:tag]}
      seitenaudit: "ausstehend"
      lernstatus: "import_entwurf"
      textstatus: "wird nach Sichtprüfung gesetzt"
      ---
      # 📄 #{title}
      > [!quelle] Quellenstatus
      > - **Fach:** [[02_Faecher/#{fach}/#{fach}|#{cfg[:anzeige]}]]
      > - **Original-PDF:** [#{pdf_label}](<#{pdf_rel}>)
      > - **Seiten:** #{page_count}
      > - **KI-Lesbarkeit:** wird nach Sichtprüfung gesetzt
      > - **Aktive Lernquelle:** Entwurf – Sichtprüfung ausstehend

      ## 🎯 Geprüfte und sinnvolle Referenzen

      | Thema | Prüfung | Seiten | Warum die Referenz sinnvoll ist |
      |---|---|---:|---|
      | _Ausstehende Sichtprüfung_ | – | – | Wird nach dem visuellen Seitenaudit automatisch erzeugt. |

      ## 🧠 Lernstruktur

      > [!tip] So lernst du mit dieser Quelle
      > 1. Lies erst die Überschriften und Seitenreferenzen.
      > 2. Öffne bei Unsicherheit immer die originale PDF-Seite.
      > 3. Verknüpfe spätere Altklausur-Aufgaben nur mit konkreten Seiten, nicht nur mit der ganzen Datei.

      ## 🧱 Originalgetreue Seitenstruktur mit exakter PDF-Referenz

      #{page_sections}
    MARKDOWN
  end

  def update_source_note_pages(source_note_abs, pdf_rel, new_page_count, pages)
    text = File.read(source_note_abs, encoding: "UTF-8")
    text = text.sub(/^seiten:\s*\d+\s*$/, "seiten: #{new_page_count}")
    text = text.sub(/^> - \*\*Seiten:\*\*.*$/, "> - **Seiten:** #{new_page_count}")

    pages.each do |record|
      number = record.fetch("page")
      section = render_page_section(pdf_rel, record)
      pattern = /^### Seite #{number}\s*$\n.*?(?=^### Seite \d+\s*$|^## [^#]|\z)/m
      if text.match?(pattern)
        text = text.sub(pattern, "#{section}\n")
      else
        text = "#{text.rstrip}\n\n#{section}"
      end
    end

    File.write(source_note_abs, text)
  end

  def write_import_audit_draft(slug:, source_note_rel:, pdf_rel:, pages:, replaces_existing:)
    FileUtils.mkdir_p(VaultSupport::IMPORT_REPORT_DIR)
    audit_path = VaultSupport::IMPORT_REPORT_DIR.join("#{slug}.json")
    today = Date.today.iso8601

    draft = {
      "schema_version" => 1,
      "scope" => "GoodNotes-Import: #{source_note_rel} (Seiten #{pages.first.fetch('page')}–#{pages.last.fetch('page')})",
      "replaces_existing" => replaces_existing,
      "topic_categories" => {},
      "pages" => pages.map do |record|
        kind, text = best_text_for(record)
        {
          "source_note" => source_note_rel,
          "pdf_path" => pdf_rel,
          "page" => record.fetch("page"),
          "audit" => {
            "visual_checked" => false,
            "audit_date" => today,
            "primary_topic" => nil,
            "secondary_topics" => [],
            "recommended_topics" => [],
            "content_type" => nil,
            "source_text_match" => (kind == :text_layer && text.length >= 60 ? "ok" : nil),
            "mapping_status" => "missing",
            "confidence" => "high",
            "issues" => [],
            "exclusion_reason" => nil,
            "support_only" => false,
            "sensitive" => false,
            "ocr_verified" => false
          }
        }
      end
    }
    File.write(audit_path, JSON.pretty_generate(draft) + "\n")
    audit_path
  end

  def write_review_manifest(review_dir, source_note_rel, pdf_rel, audit_path, pages)
    manifest_path = review_dir.join("review.json")
    payload = {
      "source_note" => source_note_rel,
      "pdf_path" => pdf_rel,
      "audit_draft" => VaultSupport.relative(audit_path),
      "pages" => pages.map do |record|
        kind, text = best_text_for(record)
        {
          "page" => record.fetch("page"),
          "image" => record.fetch("image"),
          "text_source" => kind.to_s,
          "text_chars" => text.length,
          "ocr_confidence" => record["ocr_confidence"],
          "ocr_error" => record["ocr_error"],
          "preview" => text[0, 240]
        }.compact
      end
    }
    File.write(manifest_path, JSON.pretty_generate(payload) + "\n")
    manifest_path
  end

  def print_prepare_summary(mode:, source_note_rel:, pdf_rel:, audit_path:, review_manifest:, pages:)
    puts "=== GoodNotes-Import vorbereitet (#{mode}) ==="
    puts "Original-PDF:    #{pdf_rel}"
    puts "Quellnotiz:      #{source_note_rel}"
    puts "Audit-Entwurf:   #{VaultSupport.relative(audit_path)}"
    puts "Review-Manifest: #{review_manifest}"
    puts "Seitenbilder (#{pages.length}):"
    pages.each do |record|
      kind, text = best_text_for(record)
      puts "  - Seite #{record.fetch('page')}: #{record.fetch('image')} [#{kind}, #{text.length} Zeichen]"
    end
    puts
    puts "Nächster Schritt:"
    puts "1. Jedes Seitenbild visuell prüfen (und bei Handschrift/Scan ggf. Transkription in #{source_note_rel} ergänzen)."
    puts "2. Bestehende Themen mit 'ruby 01_Index/Tools/import_goodnotes.rb topics' prüfen."
    puts "3. #{VaultSupport.relative(audit_path)} ausfüllen (visual_checked: true, recommended_topics, ggf. topic_categories)."
    puts "4. 'ruby 01_Index/Tools/import_goodnotes.rb apply --clean-review' ausführen."
  end
end

class Applier
  def run(args)
    clean_review = args.include?("--clean-review")
    validate_import_audits!

    PIPELINE_SCRIPTS.each do |script|
      puts "==> #{script}"
      script_path = TOOLS_DIR.join(script)
      stdout, stderr, status = Open3.capture3("ruby", script_path.to_s)
      puts stdout unless stdout.strip.empty?
      unless status.success?
        warn stderr unless stderr.strip.empty?
        abort "Pipeline gestoppt bei #{script}"
      end
    end

    update_root_manifest!

    if clean_review && REVIEW_ROOT.directory?
      FileUtils.rm_rf(REVIEW_ROOT)
      puts "Temporäre Review-Bilder bereinigt: #{REVIEW_ROOT}"
    end

    puts
    puts "FERTIG: Alle kanonischen Themen, Indizes, Quellenmatrix, KI-Manifest und Copilot-Allowlist wurden aktualisiert und validiert."
    puts "WICHTIG in Obsidian: Einmal 'Copilot: Force reindex vault' ausführen, damit Obsidian Copilot die neuen Dateien indexiert."
  end

  private

  def validate_import_audits!
    problems = []
    VaultSupport.import_reports.each do |path, data|
      rel = VaultSupport.relative(path)
      Array(data["pages"]).each do |page|
        VaultSupport.import_page_problems(page).each { |msg| problems << "#{rel}: #{msg}" }
      end
    end
    return if problems.empty?

    abort "Import-Audits noch unvollständig – bitte zuerst abschließen:\n  - #{problems.join("\n  - ")}"
  end

  def update_root_manifest!
    return unless MANIFEST_PATH.file?

    manifest = VaultSupport.read_json(MANIFEST_PATH)
    audit = VaultSupport.read_json(VaultSupport::AUDIT_PATH)
    mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
    allowlist = VaultSupport.read_json(ROOT.join("01_Index/Copilot_Allowlist.json"))

    audit_totals = audit.fetch("totals")
    mapping_totals = mapping.fetch("totals")
    canonical_sources = mapping.fetch("sources").count { |_path, src| src.fetch("canonical_pages").positive? }
    excluded_sources = mapping.fetch("sources").length - canonical_sources

    manifest["last_full_audit"] = VaultSupport.latest_audit_date(audit)
    manifest["active_sources"] = audit_totals.fetch("active_pdfs")
    manifest["canonical_source_notes"] = canonical_sources
    manifest["excluded_source_notes"] = excluded_sources
    manifest["duplicate_sources_deactivated"] = audit_totals.fetch("visually_identical_duplicate_pdfs")
    manifest["private_sources_removed_from_learning_flow"] = audit_totals.fetch("private_pdfs_unread")
    manifest["nonprivate_pdfs_accounted_for"] = audit_totals.fetch("nonprivate_pdfs_accounted_for")
    manifest["nonprivate_pdf_pages_accounted_for"] = audit_totals.fetch("nonprivate_pages_accounted_for")
    manifest["active_pdf_pages_visually_audited"] = audit_totals.fetch("active_pages")
    manifest["canonical_evidence_pages"] = mapping_totals.fetch("canonical_evidence_pages")
    manifest["support_only_pages"] = mapping_totals.fetch("support_only_pages")
    manifest["excluded_active_pages"] = mapping_totals.fetch("excluded_active_pages")
    manifest["topics_curated"] = mapping_totals.fetch("canonical_topics")
    manifest["copilot_exact_allowlist_files"] = allowlist.fetch("count")

    VaultSupport.write_json_if_changed(MANIFEST_PATH, manifest)
  end
end

def list_topics
  mapping = VaultSupport.read_json(VaultSupport::MAPPING_PATH)
  grouped = Hash.new { |hash, key| hash[key] = [] }
  mapping.fetch("topics").each do |topic, info|
    grouped[info.fetch("category")] << topic
  end
  grouped.sort.each do |category, topics|
    puts "## #{category} (#{topics.length})"
    topics.sort.each { |topic| puts "  - #{topic}" }
  end
end

command = ARGV.shift
case command
when "scan"
  Scanner.new.run(ARGV.first)
when "prepare"
  Preparer.new.run(ARGV)
when "apply"
  Applier.new.run(ARGV)
when "topics"
  list_topics
else
  puts <<~HELP
    GoodNotes-Import-Werkzeug für den Obsidian AP-Lernhelfer

    Befehle:
      ruby 01_Index/Tools/import_goodnotes.rb scan [pfad]
      ruby 01_Index/Tools/import_goodnotes.rb prepare <pdf> --fach <FACH> [--move] [--note-name NAME] [--pruefung TEXT]
      ruby 01_Index/Tools/import_goodnotes.rb prepare <pdf> --update-existing <quellnotiz> [--move] [--from-page N] [--replaces-existing]
      ruby 01_Index/Tools/import_goodnotes.rb apply [--clean-review]
      ruby 01_Index/Tools/import_goodnotes.rb topics
  HELP
  exit(command.nil? || %w[-h --help help].include?(command) ? 0 : 1)
end
