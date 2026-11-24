#!/usr/bin/env ruby
# frozen_string_literal: true

# Schnelle, fail-closed Quellensuche fuer den AP-Lerncoach-Skill.
# Liest ausschliesslich den visuell geprueften Index (01_Index/Themenreferenzen_Visuell_Geprueft.json)
# und die dort freigegebenen, nicht ausgeschlossenen Seiten aktiver Quellnotizen (02_Faecher/*/Quellen/*.md).
# Greift niemals auf 98_Archiv_nicht_lernen/, 00_Posteingang_GoodNotes/, 10_Lernordner/ oder .obsidian/ zu.

require "json"
require "optparse"
require "pathname"

ROOT = Pathname.new(__dir__).join("../../../..").cleanpath.realpath
MAPPING_PATH = ROOT.join("01_Index/Themenreferenzen_Visuell_Geprueft.json")
MAX_PAGE_CHARS_DEFAULT = 2600

STOPWORDS = %w[
  der die das ein eine einer eines einem einen und oder aber als wie von vom zu zum zur
  in im am an auf aus bei mit nach ueber unter fuer vor durch um ist sind war wird werden
  the a an of to in on at by for from with as is are be or and
].freeze

SYNONYMS = {
  "db" => %w[datenbank datenbanken sql],
  "dbms" => %w[datenbank datenbanksystem],
  "er" => %w[er-modell datenbankmodellierung entity],
  "erm" => %w[er-modell datenbankmodellierung entity],
  "3nf" => %w[normalisierung datenbankmodellierung],
  "sql" => %w[sql select insert update delete aggregatfunktionen gruppierung],
  "join" => %w[sql select abfragen datenbank],
  "having" => %w[sql aggregatfunktionen gruppierung group],
  "groupby" => %w[sql aggregatfunktionen gruppierung],
  "oop" => %w[objektorientierung klassen objekte uml],
  "pap" => %w[programmablaufdarstellungen algorithmus],
  "nassi" => %w[programmablaufdarstellungen struktogramm],
  "struktogramm" => %w[programmablaufdarstellungen algorithmus],
  "uml" => %w[uml-diagramme objektorientierung],
  "ipv4" => %w[ipv4 subnetting binaerzahlen netzwerk],
  "subnet" => %w[subnetting ipv4 netzwerk],
  "cidr" => %w[subnetting ipv4],
  "osi" => %w[osi-schichtenmodell netzwerk tcp],
  "tcp" => %w[osi-schichtenmodell netzwerk protokoll],
  "udp" => %w[osi-schichtenmodell netzwerk protokoll],
  "raid" => %w[raid-systeme speicher],
  "dsgvo" => %w[datenschutz rollen it-sicherheit],
  "pdca" => %w[sicherheitsprozess pdca it-sicherheit],
  "epk" => %w[ereignisgesteuerte prozessketten prozessmanagement],
  "bep" => %w[deckungsbeitrag gewinnschwelle],
  "breakeven" => %w[deckungsbeitrag gewinnschwelle],
  "bgb" => %w[kaufvertrag rechtsgeschaefte vertrag],
  "wiso" => %w[wirtschaft recht betrieb unternehmen grundgesetz personal],
  "bwl" => %w[betrieb unternehmen kalkulation deckungsbeitrag kaufvertrag],
  "lohn" => %w[lohn- gehaltsabrechnung personal],
  "gehalt" => %w[lohn- gehaltsabrechnung personal],
  "ohm" => %w[spannung strom widerstand elektrotechnik],
  "uri" => %w[spannung strom widerstand elektrotechnik],
  "ki" => %w[kuenstliche intelligenz prompting],
  "cps" => %w[cyberphysische systeme automatisierungspyramide],
  "iot" => %w[node-red iot-flows cyberphysische],
  "scrum" => %w[softwarelebenszyklus vorgehensmodelle],
  "test" => %w[softwaretest testverfahren softwarequalitaet],
  "hex" => %w[hexadezimalsystem binaerzahlen],
  "binaer" => %w[binaerzahlen hexadezimalsystem ipv4],
  "lastenheft" => %w[projektmanagement lastenheft pflichtenheft],
  "pflichtenheft" => %w[projektmanagement lastenheft pflichtenheft],
  "brief" => %w[geschaeftsbrief geschaeftsmail],
  "mail" => %w[geschaeftsmail geschaeftsbrief]
}.freeze

class VaultLookup
  def initialize
    abort "FEHLER: Index fehlt (#{MAPPING_PATH})" unless MAPPING_PATH.file?
    @data = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
    @sources = @data.fetch("sources")
    @topics = @data.fetch("topics")
    @pages_by_id = {}
    @data.fetch("pages").each { |p| @pages_by_id[p.fetch("id")] = p }
    @source_cache = {}
  end

  def normalize(str)
    s = str.to_s.unicode_normalize(:nfc).downcase
    s = s.gsub("ä", "ae").gsub("ö", "oe").gsub("ü", "ue").gsub("ß", "ss")
    s.gsub(/[^a-z0-9]+/, " ").strip
  end

  def tokenize(str)
    normalize(str).split(/\s+/).reject(&:empty?)
  end

  def expand_tokens(tokens)
    expanded = tokens.dup
    tokens.each do |tok|
      SYNONYMS.fetch(tok, []).each { |syn| expanded.concat(tokenize(syn)) }
    end
    expanded.uniq
  end

  def load_source(source_rel)
    return @source_cache[source_rel] if @source_cache.key?(source_rel)

    # Fail-closed: nur freigegebene Quellnotizen aus dem auditierten Index lesen
    return nil unless @sources.key?(source_rel)
    full_path = ROOT.join(source_rel)
    return nil unless full_path.file?

    raw = File.read(full_path, encoding: "UTF-8")
    original_pdf = raw[/^original_pfad:\s*"([^"]+)"/, 1] || ""
    fach_anzeige = raw[/^fach_anzeige:\s*"([^"]+)"/, 1] || raw[/^fach:\s*"([^"]+)"/, 1] || source_rel.split("/")[1].to_s
    total_pages = (raw[/^seiten:\s*(\d+)/, 1] || @sources.dig(source_rel, "pages") || 0).to_i
    lj = original_pdf[%r{/([12])_LJ/}, 1]
    fach_label = lj ? "#{fach_anzeige} (#{lj}. LJ)" : fach_anzeige
    pages = {}

    raw.scan(/^### Seite (\d+)\s*$\n(.*?)(?=^### Seite \d+\s*$|^## [^#]|\z)/m) do |num_str, body|
      pages[num_str.to_i] = extract_clean_page_text(body)
    end

    # Wiederholte Kopfzeilen einer Quelle erkennen (z. B. "SQL-Unternehmenswiki-LF1-Stand2026Sep16 33")
    first_line_counts = Hash.new(0)
    pages.each_value do |txt|
      fl = txt.lines.first.to_s.strip.sub(/\s+\d+\z/, "")
      first_line_counts[fl] += 1 if fl.length >= 6
    end
    repeated_headers = first_line_counts.select { |_, c| c >= 3 }.keys

    @source_cache[source_rel] = {
      original_pdf: original_pdf,
      fach_label: fach_label,
      total_pages: total_pages,
      pages: pages,
      repeated_headers: repeated_headers
    }
  end

  def extract_clean_page_text(body)
    return "" if body.include?("Vom kanonischen KI-Quelltext ausgeschlossen")

    chunks = []
    body.scan(/```text\n(.*?)```/m) do |m|
      txt = m[0].strip
      chunks << txt unless txt.empty?
    end

    if chunks.empty? && body.include?("Datenschutzsichere Inhaltszusammenfassung")
      summary_lines = body.lines.select { |l| l.start_with?("- ") }.map(&:strip)
      chunks << "[Datenschutzsichere Zusammenfassung]\n" + summary_lines.join("\n") unless summary_lines.empty?
    end

    if chunks.empty?
      ocr_lines = body.lines.select { |l| l.include?("[!ocr]") || l.start_with?("> ") }
                      .reject { |l| l.include?("Exakte Referenz") || l.include?("PDF-Seite:") || l.include?("Obsidian-Einbettung:") || l.include?("Originalseite im PDF-Layout") || l.include?("![[99_Originale/") }
                      .map(&:strip)
      chunks << ocr_lines.join("\n") unless ocr_lines.empty?
    end

    chunks.join("\n\n").strip
  end

  def parse_page_id(page_id)
    base, num = page_id.split("#page=", 2)
    ["#{base}.md", num.to_i]
  end

  def first_heading_preview(text, repeated_headers: [], max_len: 95)
    return "(kein Text extrahiert — Original-PDF prüfen)" if text.to_s.strip.empty?

    cleaned_lines = text.lines.map { |l| l.strip.gsub(/\s+/, " ") }.reject do |l|
      l.length < 4 ||
        l.match?(/\A\d+\z/) ||
        l.start_with?("[Datenschutzsichere") ||
        repeated_headers.any? { |rh| l.sub(/\s+\d+\z/, "") == rh }
    end
    line = cleaned_lines.first || text.lines.first.to_s.strip.gsub(/\s+/, " ")
    line.length > max_len ? "#{line[0, max_len - 1]}…" : line
  end

  def parse_range_spec(spec)
    pages = []
    spec.to_s.split(",").each do |part|
      part = part.strip
      next if part.empty?
      if part.include?("-")
        a, b = part.split("-", 2).map(&:to_i)
        pages.concat((a..b).to_a) if a > 0 && b >= a
      else
        n = part.to_i
        pages << n if n > 0
      end
    end
    pages.uniq.sort
  end

  def format_page_ranges(nums)
    sorted = nums.uniq.sort
    return "" if sorted.empty?

    ranges = []
    start_n = prev_n = sorted.first
    sorted[1..].each do |n|
      if n == prev_n + 1
        prev_n = n
      else
        ranges << (start_n == prev_n ? start_n.to_s : "#{start_n}-#{prev_n}")
        start_n = prev_n = n
      end
    end
    ranges << (start_n == prev_n ? start_n.to_s : "#{start_n}-#{prev_n}")
    ranges.join(", ")
  end

  def cmd_list(category_filter = nil)
    grouped = Hash.new { |h, k| h[k] = [] }
    cat_norm = category_filter ? normalize(category_filter) : nil

    @topics.each do |name, info|
      cat = info.fetch("category")
      next if cat_norm && !normalize(cat).include?(cat_norm)
      grouped[cat] << [name, info.fetch("pages").length]
    end

    if grouped.empty?
      puts "Keine Kategorie passend zu '#{category_filter}' gefunden."
      puts "Gueltige Kategorien: #{@topics.values.map { |v| v['category'] }.uniq.sort.join(', ')}"
      return
    end

    total = grouped.values.sum(&:length)
    puts "# Kanonische Themen (#{total} von #{@topics.length}) · Stand #{@data['audit_date']}"
    grouped.keys.sort.each do |cat|
      puts "\n## #{cat} (#{grouped[cat].length})"
      grouped[cat].sort_by(&:first).each do |name, count|
        puts "- #{name} (#{count} S.)"
      end
    end
  end

  def cmd_find(query, category_filter: nil, limit: 8)
    raw_tokens = tokenize(query)
    abort "Bitte Suchbegriff angeben." if raw_tokens.empty?

    exp_tokens = expand_tokens(raw_tokens)
    phrase = normalize(query)
    cat_norm = category_filter ? normalize(category_filter) : nil

    # 1. Themennamen bewerten
    topic_scores = []
    @topics.each do |name, info|
      next if cat_norm && !normalize(info.fetch("category")).include?(cat_norm)

      n_name = normalize(name)
      name_tokens = n_name.split(" ")
      score = 0
      score += 100 if n_name == phrase
      score += 55 if n_name.include?(phrase) && phrase.length >= 3
      raw_tokens.each do |t|
        if name_tokens.include?(t)
          score += 30
        elsif t.length >= 3 && n_name.include?(t)
          score += 18
        end
      end
      (exp_tokens - raw_tokens).each do |t|
        score += 9 if t.length >= 3 && n_name.include?(t)
      end

      topic_scores << [score, name, info] if score > 0
    end

    # 2. Fail-closed Volltextsuche in aktiven, nicht ausgeschlossenen Seiten
    key_tokens = raw_tokens.reject { |t| t.length < 2 || STOPWORDS.include?(t) }
    key_tokens = raw_tokens if key_tokens.empty?
    # Schneller Pre-Filter vor teurer Unicode-Normalisierung
    precheck_re = Regexp.union(key_tokens.map { |t| Regexp.new(Regexp.escape(t.gsub(/(ae|oe|ue|ss)/) { |m| m[0] }), Regexp::IGNORECASE) })

    page_hits = []
    @sources.keys.sort.each do |source_rel|
      src = load_source(source_rel)
      next unless src

      source_base = source_rel.sub(/\.md\z/, "")
      src[:pages].each do |page_num, text|
        next if text.empty?
        next unless text.match?(precheck_re)

        page_id = "#{source_base}#page=#{page_num}"
        meta = @pages_by_id[page_id]
        next unless meta
        next if meta["status"] == "excluded"

        if cat_norm
          topics_cats = meta.fetch("canonical_topics", []).map { |t| @topics.dig(t, "category").to_s }
          next unless topics_cats.any? { |c| normalize(c).include?(cat_norm) }
        end

        norm_text = normalize(text)
        score = 0
        phrase_hit = phrase.length >= 3 && norm_text.include?(phrase)
        score += 55 if phrase_hit

        matched_key = 0
        key_tokens.each do |t|
          cnt = norm_text.scan(/(?:^| )#{Regexp.escape(t)}/).length
          if cnt > 0
            matched_key += 1
            score += 14 + [cnt, 5].min * 2
          elsif t.length >= 4 && norm_text.include?(t)
            matched_key += 1
            score += 8
          end
        end
        next if matched_key == 0 && !phrase_hit
        next if key_tokens.length >= 2 && !phrase_hit && matched_key < key_tokens.length

        score += 20 if key_tokens.length > 1 && matched_key == key_tokens.length
        score += 6 if meta["status"] == "evidence"
        score += 4 if meta["quote_safe"]

        snippet = extract_snippet(text, key_tokens)
        page_hits << {
          score: score,
          source_rel: source_rel,
          page_num: page_num,
          original_pdf: src[:original_pdf],
          meta: meta,
          snippet: snippet
        }
      end
    end

    # Volltext-Treffer auf Themen rueckkoppeln, falls kein Themenname direkt traf
    topic_map = topic_scores.each_with_object({}) { |(sc, name, info), h| h[name] = [sc, name, info] }
    page_hits.sort_by { |h| -h[:score] }.first(20).each do |hit|
      hit[:meta].fetch("canonical_topics", []).each do |t_name|
        info = @topics[t_name]
        next unless info
        next if cat_norm && !normalize(info.fetch("category")).include?(cat_norm)
        boost = [hit[:score] / 4, 15].min
        if topic_map[t_name]
          topic_map[t_name][0] += boost
        else
          topic_map[t_name] = [boost, t_name, info]
        end
      end
    end

    ranked_topics = topic_map.values.sort_by { |sc, name, _| [-sc, name] }.first(limit)
    ranked_pages = page_hits.sort_by { |h| [-h[:score], h[:source_rel], h[:page_num]] }.first(limit)

    puts "# Schnellsuche: \"#{query}\""
    puts "\n## Passende kanonische Themen (#{ranked_topics.length})"
    if ranked_topics.empty?
      puts "- Keine direkten Themen-Treffer. Nutze `list` fuer alle 137 Themen."
    else
      ranked_topics.each do |sc, name, info|
        puts "- **#{name}** [#{info['category']}] · #{info['pages'].length} S. · Score #{sc}"
        puts "  Laden: `ruby .agents/skills/ap-lerncoach/scripts/vault_lookup.rb topic \"#{name}\" --compact`"
      end
    end

    puts "\n## Konkrete Belegseiten (#{ranked_pages.length} von #{page_hits.length} Treffern)"
    if ranked_pages.empty?
      puts "- Keine Volltext-Treffer in aktiven Quellseiten."
    else
      ranked_pages.each do |h|
        m = h[:meta]
        flags = [m["status"], m["source_text_status"], (m["quote_safe"] ? "zitatfaehig" : "Original pruefen")].join(" | ")
        puts "- `#{File.basename(h[:source_rel], '.md')}` S. #{h[:page_num]} (#{flags})"
        puts "  Themen: #{m.fetch('canonical_topics', []).join(', ')}"
        puts "  PDF: `#{h[:original_pdf]}#page=#{h[:page_num]}`" unless h[:original_pdf].empty?
        puts "  Auszug: #{h[:snippet]}"
      end
    end
  end

  def extract_snippet(text, tokens, max_len: 170)
    lines = text.lines.map { |l| l.strip.gsub(/\s+/, " ") }.reject(&:empty?)
    best = lines.find do |l|
      nl = normalize(l)
      tokens.any? { |t| t.length >= 2 && nl.include?(t) }
    end || lines.first.to_s
    best.length > max_len ? "#{best[0, max_len - 1]}…" : best
  end

  def resolve_topic(query)
    return [query, @topics[query]] if @topics.key?(query)

    q_norm = normalize(query)
    exact_norm = @topics.keys.find { |k| normalize(k) == q_norm }
    return [exact_norm, @topics[exact_norm]] if exact_norm

    matches = @topics.keys.select { |k| normalize(k).include?(q_norm) }
    return [matches.first, @topics[matches.first]] if matches.length == 1

    if matches.empty?
      q_toks = expand_tokens(tokenize(query))
      scored = @topics.keys.map do |k|
        nk = normalize(k)
        s = q_toks.count { |t| t.length >= 3 && nk.include?(t) }
        [s, k]
      end.select { |s, _| s > 0 }.sort_by { |s, k| [-s, k] }
      matches = scored.first(8).map(&:last)
    end

    if matches.empty?
      abort "Kein kanonisches Thema fuer '#{query}' gefunden. Nutze `find` oder `list`."
    else
      puts "Mehrere passende Themen fuer '#{query}':"
      matches.each { |m| puts "- #{m} [#{@topics[m]['category']}] (#{@topics[m]['pages'].length} S.)" }
      exit 2
    end
  end

  def cmd_topic(query, compact: false, max_pages: 6, page_filter: nil, source_filter: nil, term_query: nil, include_support: false, max_chars: MAX_PAGE_CHARS_DEFAULT)
    topic_name, info = resolve_topic(query)
    allowed_nums = page_filter ? parse_range_spec(page_filter) : nil
    src_norm = source_filter ? normalize(source_filter) : nil
    term_tokens = term_query ? tokenize(term_query) : nil

    entries = []
    info.fetch("pages").each do |page_id|
      meta = @pages_by_id[page_id]
      next unless meta
      next if meta["status"] == "excluded"
      next if meta["status"] == "support_only" && !include_support

      source_rel, page_num = parse_page_id(page_id)
      next if allowed_nums && !allowed_nums.include?(page_num)
      next if src_norm && !normalize(source_rel).include?(src_norm)

      src = load_source(source_rel)
      next unless src
      text = src[:pages][page_num].to_s

      term_score = 0
      if term_tokens && !term_tokens.empty?
        nt = normalize(text)
        term_score = term_tokens.count { |t| t.length >= 2 && nt.include?(t) }
        next if term_score == 0
      end

      entries << {
        source_rel: source_rel,
        page_num: page_num,
        original_pdf: src[:original_pdf],
        repeated_headers: src[:repeated_headers],
        meta: meta,
        text: text,
        term_score: term_score
      }
    end

    entries.sort_by! { |e| [e[:source_rel], e[:page_num]] }

    puts "# Thema: #{topic_name}"
    puts "- Kategorie: `#{info['category']}`"
    puts "- Themenseite: `#{info['path']}`"
    puts "- Gefundene verifizierte Seiten: **#{entries.length}** (Gesamt im Thema: #{info['pages'].length})"

    # Kompakte Quellen-Uebersicht immer oben anzeigen
    by_source = entries.group_by { |e| e[:source_rel] }
    puts "\n## Verifizierte Quellen & Seiten"
    by_source.each do |source_rel, list|
      pdf = list.first[:original_pdf]
      nums = format_page_ranges(list.map { |e| e[:page_num] })
      ocr_cnt = list.count { |e| !e[:meta]["quote_safe"] }
      ocr_note = ocr_cnt > 0 ? " · #{ocr_cnt} S. OCR/Original pruefen" : " · alle zitatfaehig"
      puts "- `#{source_rel}` · Seiten: **#{nums}**#{ocr_note}"
      puts "  Original-PDF: `#{pdf}`" unless pdf.empty?
    end

    if compact || entries.empty?
      puts "\n## Seiten-Index (kompakt)"
      entries.each do |e|
        m = e[:meta]
        flag = m["quote_safe"] ? "ok" : m["source_text_status"]
        sup = m["status"] == "support_only" ? ", support_only" : ""
        puts "- `#{File.basename(e[:source_rel], '.md')}` S. #{e[:page_num]} [#{flag}#{sup}]: #{first_heading_preview(e[:text], repeated_headers: e[:repeated_headers])}"
      end
      return
    end

    # Auswahl fuer Volltext-Ausgabe (Token-effizient begrenzt)
    selected = if term_tokens && !term_tokens.empty?
                 entries.sort_by { |e| [-e[:term_score], e[:meta]["quote_safe"] ? 0 : 1, e[:source_rel], e[:page_num]] }.first(max_pages)
               else
                 entries.first(max_pages)
               end
    selected.sort_by! { |e| [e[:source_rel], e[:page_num]] }

    if entries.length > selected.length
      puts "\n> Hinweis: Zeige #{selected.length} von #{entries.length} Seiten (Token-Limit). Alle Seiten per `--compact`, `--query \"Begriff\"`, `--pages \"10-15\"` oder `--max-pages #{entries.length}` abrufbar."
    end

    selected.each { |e| print_page_block(e, max_chars: max_chars) }
  end

  def resolve_source(source_query)
    return source_query if @sources.key?(source_query)

    q_norm = normalize(source_query.sub(/\.md\z/i, ""))
    exact = @sources.keys.find { |k| normalize(File.basename(k, ".md")) == q_norm }
    return exact if exact

    matches = @sources.keys.select { |k| normalize(k).include?(q_norm) }
    return matches.first if matches.length == 1

    if matches.empty?
      abort "FAIL-CLOSED: Quelle '#{source_query}' ist nicht im kanonischen Quellenindex (02_Faecher/*/Quellen/*.md)."
    else
      puts "Mehrere aktive Quellnotizen passen auf '#{source_query}':"
      matches.each { |m| puts "- #{m}" }
      exit 2
    end
  end

  def cmd_pages(source_query, range_spec, max_chars: MAX_PAGE_CHARS_DEFAULT)
    source_rel = resolve_source(source_query)
    src = load_source(source_rel)
    abort "Quellnotiz nicht lesbar: #{source_rel}" unless src

    nums = parse_range_spec(range_spec)
    abort "Ungueltiger Seitenbereich: #{range_spec}" if nums.empty?

    source_base = source_rel.sub(/\.md\z/, "")
    puts "# Auszug: `#{source_rel}` (Seiten #{format_page_ranges(nums)})"
    puts "- Original-PDF: `#{src[:original_pdf]}`" unless src[:original_pdf].empty?

    nums.each do |num|
      page_id = "#{source_base}#page=#{num}"
      meta = @pages_by_id[page_id]
      if !meta
        puts "\n### Seite #{num} [NICHT IM AUDIT]"
        next
      end
      if meta["status"] == "excluded"
        puts "\n### Seite #{num} [AUSGESCHLOSSEN — nicht verwenden]"
        puts "- Grund: #{meta['exclusion_reason']}" if meta["exclusion_reason"]
        next
      end
      print_page_block({
        source_rel: source_rel,
        page_num: num,
        original_pdf: src[:original_pdf],
        meta: meta,
        text: src[:pages][num].to_s
      }, max_chars: max_chars)
    end
  end

  def cmd_mix(query, limit: 6)
    # Findet verwandte / verwechselbare Themen fuer Interleaved Practice
    cat_match = @topics.values.map { |v| v["category"] }.uniq.find { |c| normalize(c).include?(normalize(query)) }
    if cat_match
      list = @topics.select { |_, v| v["category"] == cat_match }.sort_by { |k, v| [-v["pages"].length, k] }.first(limit)
      puts "# Interleaving-Pool fuer Kategorie: #{cat_match}"
      list.each { |name, info| puts "- **#{name}** (#{info['pages'].length} S.)" }
      return
    end

    topic_name, info = resolve_topic(query)
    cat = info.fetch("category")
    own_sources = info.fetch("pages").map { |id| id.split("#page=", 2).first }.uniq

    candidates = []
    @topics.each do |other_name, other_info|
      next if other_name == topic_name
      score = 0
      score += 30 if other_info["category"] == cat
      other_sources = other_info.fetch("pages").map { |id| id.split("#page=", 2).first }.uniq
      shared_sources = (own_sources & other_sources).length
      score += shared_sources * 20
      # Gemeinsame Wortstaemme im Titel (starker Hinweis auf verwechselbare Themen!)
      shared_words = (tokenize(topic_name) & tokenize(other_name)).reject { |w| %w[und der die das von in im zu fuer mit].include?(w) }
      score += shared_words.length * 25
      candidates << [score, other_name, other_info, shared_sources] if score > 0
    end

    ranked = candidates.sort_by { |sc, name, _, _| [-sc, name] }.first(limit)
    puts "# Interleaving-Empfehlungen zu: #{topic_name} [#{cat}]"
    puts "*(Wissenschaftlich wirksam bei verwechselbaren Themen: Brunmair & Richter 2019)*\n"
    ranked.each do |sc, name, o_info, shared_src|
      hint = shared_src > 0 ? " · #{shared_src} gemeinsame Quelle(n)" : ""
      puts "- **#{name}** [#{o_info['category']}] (#{o_info['pages'].length} S.#{hint}) · Relevanz #{sc}"
    end
  end

  private

  def print_page_block(entry, max_chars:)
    m = entry[:meta]
    text = entry[:text].to_s
    truncated = false
    if max_chars > 0 && text.length > max_chars
      text = text[0, max_chars].rstrip + "\n[... gekuerzt bei #{max_chars} Zeichen; mit --max-chars 0 vollstaendig laden ...]"
      truncated = true
    end

    quote_badge = m["quote_safe"] ? "zitatfaehig" : "OCR/Original pruefen (#{m['source_text_status']})"
    sup_badge = m["status"] == "support_only" ? " | NUR UNTERSTUETZEND (support_only)" : ""
    src_info = load_source(entry[:source_rel]) || {}
    fach_lbl = src_info[:fach_label] || entry[:source_rel].split("/")[1].to_s
    total_p = src_info[:total_pages].to_i
    pdf_bn = File.basename(entry[:original_pdf].to_s)
    page_of = total_p > 0 ? "Seite #{entry[:page_num]} von #{total_p}" : "Seite #{entry[:page_num]}"
    puts "\n### #{File.basename(entry[:source_rel], '.md')} · #{page_of}"
    puts "- Fach: **#{fach_lbl}** | PDF: `#{pdf_bn}` (#{page_of}) · Pfad: `#{entry[:original_pdf]}#page=#{entry[:page_num]}`"
    puts "- Quellnotiz: `#{entry[:source_rel]}` | Status: `#{m['status']}` | Text: `#{quote_badge}`#{sup_badge}"
    puts "- Themen: #{m.fetch('canonical_topics', []).join(', ')}"
    puts "```text"
    puts text.empty? ? "(Kein extrahierter Text — bitte Original-PDF pruefen)" : text
    puts "```"
    truncated
  end
end

def usage
  puts <<~HELP
    Verwendung: ruby .agents/skills/ap-lerncoach/scripts/vault_lookup.rb <befehl> [optionen]

    Befehle:
      list [kategorie]                 Alle 137 kanonischen Themen (optional nach Kategorie)
      find "<suchbegriff>"             Schnellsuche ueber Themennamen + aktive Quellseiten
        --category <cat>               Auf eine der 6 Kategorien eingrenzen
        --limit <n>                    Max. Treffer pro Liste (Standard: 8)
      topic "<thema>"                  Verifizierte Seiten eines Themas laden
        --compact                      Nur kompakte Seiten-Uebersicht (1 Zeile pro Seite)
        --query "<begriff>"            Nur Seiten im Thema mit diesem Begriff laden
        --pages "10-12,26"             Nur bestimmte Seitennummern laden
        --source "<name>"              Auf eine bestimmte Quellnotiz filtern
        --max-pages <n>                Max. Volltext-Seiten (Standard: 6)
        --max-chars <n>                Max. Zeichen je Seite (Standard: 2600, 0 = unbegrenzt)
        --include-support              Auch support_only-Seiten einbeziehen
      pages "<quelle>" "<bereich>"     Exakte Seiten aus einer aktiven Quellnotiz lesen
        --max-chars <n>                Max. Zeichen je Seite (Standard: 2600, 0 = unbegrenzt)
      mix "<thema_oder_kategorie>"     Verwechselbare Partner-Themen fuer Interleaving finden
        --limit <n>                    Anzahl Vorschlaege (Standard: 6)
  HELP
end

if ARGV.empty? || %w[-h --help help].include?(ARGV.first)
  usage
  exit 0
end

cmd = ARGV.shift
opts = {
  category: nil,
  limit: 8,
  compact: false,
  max_pages: 6,
  pages: nil,
  source: nil,
  query: nil,
  include_support: false,
  max_chars: MAX_PAGE_CHARS_DEFAULT
}

parser = OptionParser.new do |o|
  o.on("--category CAT") { |v| opts[:category] = v }
  o.on("--limit N", Integer) { |v| opts[:limit] = v }
  o.on("--compact") { opts[:compact] = true }
  o.on("--max-pages N", Integer) { |v| opts[:max_pages] = v }
  o.on("--pages SPEC") { |v| opts[:pages] = v }
  o.on("--source SRC") { |v| opts[:source] = v }
  o.on("--query Q") { |v| opts[:query] = v }
  o.on("--include-support") { opts[:include_support] = true }
  o.on("--max-chars N", Integer) { |v| opts[:max_chars] = v }
end
parser.parse!(ARGV)

lookup = VaultLookup.new

case cmd
when "list"
  lookup.cmd_list(ARGV.first || opts[:category])
when "find"
  lookup.cmd_find(ARGV.join(" "), category_filter: opts[:category], limit: opts[:limit])
when "topic"
  lookup.cmd_topic(
    ARGV.join(" "),
    compact: opts[:compact],
    max_pages: opts[:max_pages],
    page_filter: opts[:pages],
    source_filter: opts[:source],
    term_query: opts[:query],
    include_support: opts[:include_support],
    max_chars: opts[:max_chars]
  )
when "pages"
  abort "Verwendung: pages \"<quelle>\" \"<seitenbereich>\"" if ARGV.length < 2
  lookup.cmd_pages(ARGV[0], ARGV[1], max_chars: opts[:max_chars])
when "mix"
  lookup.cmd_mix(ARGV.join(" "), limit: opts[:limit])
else
  warn "Unbekannter Befehl: #{cmd}"
  usage
  exit 1
end
