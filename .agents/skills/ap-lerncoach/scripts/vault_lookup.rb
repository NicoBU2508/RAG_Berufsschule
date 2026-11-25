#!/usr/bin/env ruby
# frozen_string_literal: true

# Schnelle, fail-closed Quellensuche fuer den AP-Lerncoach-Skill.
# Liest ausschliesslich den visuell geprueften Index (01_Index/Themenreferenzen_Visuell_Geprueft.json)
# und die dort freigegebenen, nicht ausgeschlossenen Seiten aktiver Quellnotizen (02_Faecher/*/Quellen/*.md).
# Greift niemals auf 98_Archiv_nicht_lernen/, 00_Posteingang_GoodNotes/, 10_Lernordner/ oder .obsidian/ zu.

require "fileutils"
require "json"
require "open3"
require "optparse"
require "pathname"

ROOT = Pathname.new(__dir__).join("../../../..").cleanpath.realpath
MAPPING_PATH = ROOT.join("01_Index/Themenreferenzen_Visuell_Geprueft.json")
EXAM_MAPPING_PATH = ROOT.join("01_Index/Pruefungskatalog_Mapping.json")
CONFUSION_PAIRS_PATH = ROOT.join("01_Index/Verwechslungspaare.json")
MAX_PAGE_CHARS_DEFAULT = 2600

STOPWORDS = %w[
  der die das ein eine einer eines einem einen und oder aber als wie von vom zu zum zur
  in im am an auf aus bei mit nach ueber unter fuer vor durch um ist sind war wird werden
  was wer wo wann warum wieso weshalb welche welcher welches welchen welchem
  the a an of to in on at by for from with as is are be or and
].freeze

SYNONYMS = {
  "db" => %w[datenbank datenbanken sql],
  "dbms" => %w[datenbank datenbanksystem],
  "er" => %w[er-modell datenbankmodellierung entity kardinalitaet],
  "erm" => %w[er-modell datenbankmodellierung entity],
  "3nf" => %w[normalisierung datenbankmodellierung],
  "pk" => %w[primaerschluessel datenbankgrundlagen],
  "fk" => %w[fremdschluessel datenbankgrundlagen],
  "sql" => %w[sql select insert update delete aggregatfunktionen gruppierung],
  "join" => %w[sql select abfragen datenbank],
  "having" => %w[sql aggregatfunktionen gruppierung group],
  "groupby" => %w[sql aggregatfunktionen gruppierung],
  "oop" => %w[objektorientierung klassen objekte kapselung vererbung],
  "pap" => %w[programmablaufdarstellungen algorithmus],
  "nassi" => %w[programmablaufdarstellungen struktogramm],
  "struktogramm" => %w[programmablaufdarstellungen algorithmus],
  "pseudocode" => %w[algorithmus schleifen operatoren bedingungen],
  "trace" => %w[schreibtischtest schleifen algorithmus debugging],
  "schreibtischtest" => %w[trace schleifen algorithmus arrays debugging],
  "uml" => %w[uml-diagramme aktivitaetsdiagramm zustandsdiagramm use-case],
  "aktivitaetsdiagramm" => %w[uml-diagramme bpmn kontrollfluss],
  "bpmn" => %w[business process model notation gateway pool lane prozessmanagement],
  "epk" => %w[ereignisgesteuerte prozessketten prozessmanagement],
  "ipv4" => %w[ipv4 subnetting binaerzahlen netzwerk cidr],
  "ipv6" => %w[ipv6 hexadezimalsystem praefix fe80 slaac netzwerk],
  "slaac" => %w[ipv6 dhcpv6 link-local],
  "subnet" => %w[subnetting ipv4 netzwerk],
  "subnetting" => %w[ipv4 cidr netzadresse broadcast host],
  "cidr" => %w[subnetting ipv4 praefix],
  "osi" => %w[osi-schichtenmodell netzwerk tcp schicht],
  "tcp" => %w[osi-schichtenmodell netzwerk protokoll port],
  "udp" => %w[osi-schichtenmodell netzwerk protokoll port],
  "raid" => %w[raid-systeme speicher redundanz],
  "backup" => %w[datensicherung vollbackup inkrementell differenziell gvs],
  "gvs" => %w[backup datensicherung grossvater vater sohn],
  "dsgvo" => %w[datenschutz rollen personenbezogen tom avv meldepflicht],
  "tom" => %w[technische organisatorische massnahmen datenschutz],
  "avv" => %w[auftragsverarbeitung datenschutz dsgvo],
  "2fa" => %w[zwei-faktor authentifizierung mfa sicherheitsmanagement],
  "mfa" => %w[multi-faktor authentifizierung 2fa sicherheitsmanagement],
  "pdca" => %w[sicherheitsmanagement isms plan do check act],
  "bsi" => %w[grundschutz strukturanalyse schutzbedarf modellierung risikoanalyse],
  "cia" => %w[vertraulichkeit integritaet verfuegbarkeit schutzziele],
  "usv" => %w[usv-anlagen vfi vi vfd scheinleistung ueberbrueckung],
  "wirkungsgrad" => %w[netzteil 80 plus verlustleistung],
  "80plus" => %w[netzteil wirkungsgrad energie],
  "mib" => %w[si iec dateneinheiten binaer byte bit],
  "gib" => %w[si iec dateneinheiten binaer byte],
  "kib" => %w[si iec dateneinheiten binaer byte],
  "nwa" => %w[nutzwertanalyse angebotsvergleich gewichtung],
  "nutzwertanalyse" => %w[nwa angebotsvergleich kriterien gewichtung],
  "bezugskalkulation" => %w[listeneinkaufspreis rabatt skonto bezugskosten bezugspreis],
  "skonto" => %w[bezugskalkulation zieleinkaufspreis bareinkaufspreis],
  "bep" => %w[deckungsbeitrag gewinnschwelle break-even],
  "breakeven" => %w[deckungsbeitrag gewinnschwelle fixkosten],
  "amortisation" => %w[wirtschaftlichkeit anschaffungskosten einsparung],
  "tco" => %w[wirtschaftlichkeit gesamtkosten angebotsvergleich],
  "leasing" => %w[wirtschaftlichkeit kaufvertrag finanzierung],
  "faz" => %w[projektplanung netzplanmethode fez saz sez gesamtpuffer],
  "gp" => %w[gesamtpuffer freier puffer kritischer pfad netzplanmethode],
  "netzplan" => %w[projektplanung netzplanmethode kritischer pfad puffer],
  "smart" => %w[unternehmensziele projektmanagement spezifisch messbar],
  "bgb" => %w[kaufvertrag rechtsgeschaefte besitz eigentum maengel],
  "wiso" => %w[wirtschaft recht betrieb sozialversicherung arbeitsrecht],
  "bwl" => %w[betrieb unternehmen kalkulation deckungsbeitrag kaufvertrag],
  "lohn" => %w[lohn- gehaltsabrechnung sozialversicherung steuerklasse],
  "gehalt" => %w[lohn- gehaltsabrechnung sozialversicherung],
  "ohm" => %w[spannung strom widerstand ohmsches gesetz],
  "uri" => %w[spannung strom widerstand ohmsches gesetz],
  "ki" => %w[kuenstliche intelligenz prompting llm halluzination],
  "cloud" => %w[iaas paas saas virtualisierung],
  "iaas" => %w[cloud paas saas infrastruktur],
  "paas" => %w[cloud iaas saas plattform],
  "saas" => %w[cloud iaas paas software],
  "cps" => %w[cyberphysische systeme automatisierungspyramide],
  "iot" => %w[node-red iot-flows cyberphysische],
  "scrum" => %w[softwarelebenszyklus vorgehensmodelle wasserfall sprint],
  "wasserfall" => %w[softwarelebenszyklus vorgehensmodelle scrum phasen],
  "test" => %w[softwaretest testverfahren black-box white-box],
  "barrierefreiheit" => %w[barrierefreies arbeiten wcag bitv ergonomie],
  "wcag" => %w[barrierefreies arbeiten barrierefreiheit],
  "hex" => %w[hexadezimalsystem binaerzahlen],
  "binaer" => %w[binaerzahlen hexadezimalsystem ipv4],
  "lastenheft" => %w[projektmanagement lastenheft pflichtenheft auftraggeber],
  "pflichtenheft" => %w[projektmanagement lastenheft pflichtenheft auftragnehmer],
  "brief" => %w[geschaeftsbrief geschaeftsmail],
  "mail" => %w[geschaeftsmail geschaeftsbrief]
}.freeze

class VaultLookup
  BM25_K1 = 1.2
  BM25_B = 0.75

  def initialize
    abort "FEHLER: Index fehlt (#{MAPPING_PATH})" unless MAPPING_PATH.file?
    @data = JSON.parse(File.read(MAPPING_PATH, encoding: "UTF-8"))
    @sources = @data.fetch("sources")
    @topics = @data.fetch("topics")
    @pages_by_id = {}
    @data.fetch("pages").each { |p| @pages_by_id[p.fetch("id")] = p }
    @exam_topics = EXAM_MAPPING_PATH.file? ? JSON.parse(File.read(EXAM_MAPPING_PATH, encoding: "UTF-8")).fetch("topics", {}) : {}
    @confusion_clusters = CONFUSION_PAIRS_PATH.file? ? JSON.parse(File.read(CONFUSION_PAIRS_PATH, encoding: "UTF-8")).fetch("clusters", []) : []
    @source_cache = {}
    @bm25_index = nil
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

  def topic_exam(topic_name)
    nfc_name = topic_name.to_s.unicode_normalize(:nfc)
    entry = @exam_topics[nfc_name] || @exam_topics[topic_name.to_s]
    val = (entry && entry["pruefung"]).to_s.strip
    val.empty? ? "AP1/AP2" : val
  end

  def exam_badge(topic_name)
    case topic_exam(topic_name).upcase
    when "AP1" then "🟢 AP1"
    when "AP1/AP2" then "🟢 AP1+AP2"
    when "AP2" then "🔵 AP2"
    when "BS" then "⚪ BS"
    else topic_exam(topic_name)
    end
  end

  def exam_matches?(pruefung_val, exam_filter)
    return true if exam_filter.nil? || exam_filter.to_s.strip.empty? || exam_filter.to_s.casecmp("all").zero?

    val = pruefung_val.to_s.strip.upcase
    flt = exam_filter.to_s.strip.upcase
    case flt
    when "AP1"
      val == "AP1" || val == "AP1/AP2"
    when "AP1-ONLY", "AP1_ONLY"
      val == "AP1"
    when "AP2"
      val == "AP2" || val == "AP1/AP2"
    when "AP2-ONLY", "AP2_ONLY"
      val == "AP2"
    when "BS", "BERUFSSCHULE"
      val == "BS"
    else
      val.include?(flt)
    end
  end

  def topic_matches_exam?(topic_name, exam_filter)
    exam_matches?(topic_exam(topic_name), exam_filter)
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

  # ---------- BM25 & Fuzzy Index ----------

  def ensure_bm25_index!
    return @bm25_index if @bm25_index

    docs = []
    df = Hash.new(0)
    vocab = {}

    @topics.each_key do |t_name|
      tokenize(t_name).each { |tok| vocab[tok] = true if tok.length >= 3 }
    end
    SYNONYMS.each do |k, vals|
      vocab[k] = true if k.length >= 3
      vals.each { |v| tokenize(v).each { |tok| vocab[tok] = true if tok.length >= 3 } }
    end

    @sources.keys.sort.each do |source_rel|
      src = load_source(source_rel)
      next unless src

      source_base = source_rel.sub(/\.md\z/, "")
      src[:pages].each do |page_num, text|
        next if text.empty?

        page_id = "#{source_base}#page=#{page_num}"
        meta = @pages_by_id[page_id]
        next unless meta
        next if meta["status"] == "excluded"

        norm_text = normalize(text)
        tokens = norm_text.split(" ")
        next if tokens.empty?

        tf = Hash.new(0)
        tokens.each do |tok|
          tf[tok] += 1
          vocab[tok] = true if tok.length >= 4
        end
        tf.each_key { |tok| df[tok] += 1 }

        heading_norm = normalize(first_heading_preview(text, repeated_headers: src[:repeated_headers], max_len: 140))
        docs << {
          page_id: page_id,
          source_rel: source_rel,
          page_num: page_num,
          original_pdf: src[:original_pdf],
          meta: meta,
          text: text,
          norm_text: norm_text,
          heading_norm: heading_norm,
          tf: tf,
          dl: tokens.length
        }
      end
    end

    avg_dl = docs.empty? ? 1.0 : docs.sum { |d| d[:dl] }.to_f / docs.length
    trigram_map = Hash.new { |h, k| h[k] = [] }
    vocab.each_key do |word|
      trigrams_for(word).each { |tri| trigram_map[tri] << word }
    end

    @bm25_index = {
      docs: docs,
      df: df,
      n_docs: docs.length,
      avg_dl: avg_dl,
      vocab: vocab,
      trigram_map: trigram_map
    }
  end

  def trigrams_for(word)
    padded = "^#{word}$"
    return [padded] if padded.length < 3

    (0..(padded.length - 3)).map { |i| padded[i, 3] }.uniq
  end

  def damerau_levenshtein_bounded(a, b, max_dist)
    return 0 if a == b
    return max_dist + 1 if (a.length - b.length).abs > max_dist

    prev_prev = nil
    prev = (0..b.length).to_a
    (1..a.length).each do |i|
      curr = [i]
      row_min = i
      (1..b.length).each do |j|
        cost = a[i - 1] == b[j - 1] ? 0 : 1
        val = [
          prev[j] + 1,
          curr[j - 1] + 1,
          prev[j - 1] + cost
        ].min
        if i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]
          val = [val, prev_prev[j - 2] + 1].min
        end
        curr << val
        row_min = val if val < row_min
      end
      return max_dist + 1 if row_min > max_dist

      prev_prev = prev
      prev = curr
    end
    prev[b.length]
  end

  def fuzzy_correct_token(tok, idx)
    return nil if tok.length < 4 || idx[:vocab][tok] || SYNONYMS.key?(tok)

    q_tris = trigrams_for(tok)
    cand_hits = Hash.new(0)
    q_tris.each do |tri|
      idx[:trigram_map][tri].each { |w| cand_hits[w] += 1 }
    end

    max_dist = tok.length >= 7 ? 2 : 1
    best_word = nil
    best_score = -1.0

    cand_hits.each do |word, shared|
      next if (word.length - tok.length).abs > max_dist
      union_len = q_tris.length + trigrams_for(word).length - shared
      jaccard = union_len.positive? ? shared.to_f / union_len : 0.0
      next if jaccard < 0.28

      dist = damerau_levenshtein_bounded(tok, word, max_dist)
      next if dist > max_dist

      df_boost = Math.log10((idx[:df][word] || 1) + 2) * 0.05
      score = (max_dist + 1 - dist) * 2.0 + jaccard + df_boost
      if score > best_score
        best_score = score
        best_word = word
      end
    end

    best_word
  end

  def idf(term, idx)
    df = idx[:df][term] || 0
    return 0.0 if df <= 0

    n = idx[:n_docs].to_f
    Math.log(1.0 + ((n - df + 0.5) / (df + 0.5)))
  end

  # ---------- Subcommands ----------

  def cmd_list(category_filter = nil, exam_filter: nil)
    grouped = Hash.new { |h, k| h[k] = [] }
    cat_norm = category_filter ? normalize(category_filter) : nil

    @topics.each do |name, info|
      cat = info.fetch("category")
      next if cat_norm && !normalize(cat).include?(cat_norm)
      next unless topic_matches_exam?(name, exam_filter)
      grouped[cat] << [name, info.fetch("pages").length, exam_badge(name)]
    end

    if grouped.empty?
      puts "Keine passenden Themen fuer Kategorie='#{category_filter || 'alle'}' / Pruefung='#{exam_filter || 'alle'}' gefunden."
      puts "Gueltige Kategorien: #{@topics.values.map { |v| v['category'] }.uniq.sort.join(', ')}"
      return
    end

    total = grouped.values.sum(&:length)
    exam_note = exam_filter ? " · Filter: **#{exam_filter.upcase}**" : ""
    puts "# Kanonische Themen (#{total} von #{@topics.length}) · Stand #{@data['audit_date']}#{exam_note}"
    grouped.keys.sort.each do |cat|
      puts "\n## #{cat} (#{grouped[cat].length})"
      grouped[cat].sort_by(&:first).each do |name, count, badge|
        puts "- **#{name}** [#{badge}] (#{count} S.)"
      end
    end
  end

  def cmd_find(query, category_filter: nil, exam_filter: nil, limit: 8)
    raw_tokens = tokenize(query)
    abort "Bitte Suchbegriff angeben." if raw_tokens.empty?

    idx = ensure_bm25_index!
    key_tokens = raw_tokens.reject { |t| t.length < 2 || STOPWORDS.include?(t) }
    key_tokens = raw_tokens if key_tokens.empty?

    # 1. Tippfehler-Erkennung (Fuzzy-Fallback fuer unbekannte Terme)
    corrections = {}
    key_tokens.each do |tok|
      in_topic_substring = tok.length >= 4 && @topics.keys.any? { |k| normalize(k).include?(tok) }
      next if in_topic_substring

      fixed = fuzzy_correct_token(tok, idx)
      corrections[tok] = fixed if fixed && fixed != tok
    end

    effective_tokens = key_tokens.map { |t| corrections[t] || t }.uniq
    synonym_tokens = (expand_tokens(effective_tokens) - effective_tokens).reject { |t| t.length < 2 || STOPWORDS.include?(t) }

    phrase = normalize(effective_tokens.join(" "))
    cat_norm = category_filter ? normalize(category_filter) : nil

    # 2. Themennamen bewerten
    topic_scores = []
    @topics.each do |name, info|
      next if cat_norm && !normalize(info.fetch("category")).include?(cat_norm)
      next unless topic_matches_exam?(name, exam_filter)

      n_name = normalize(name)
      name_tokens = n_name.split(" ")
      score = 0.0
      score += 100.0 if n_name == phrase
      score += 55.0 if phrase.length >= 3 && n_name.include?(phrase)
      effective_tokens.each do |t|
        if name_tokens.include?(t)
          score += 32.0
        elsif t.length >= 3 && n_name.include?(t)
          score += 18.0
        end
      end
      synonym_tokens.each do |t|
        if name_tokens.include?(t)
          score += 14.0
        elsif t.length >= 3 && n_name.include?(t)
          score += 9.0
        end
      end

      topic_scores << [score, name, info] if score > 0
    end

    # 3. Fail-closed Okapi-BM25-Volltextsuche ueber freigegebene Seiten
    term_weights = {}
    effective_tokens.each { |t| term_weights[t] = corrections.value?(t) ? 0.9 : 1.0 }
    synonym_tokens.each { |t| term_weights[t] ||= 0.45 }

    page_hits = []
    idx[:docs].each do |doc|
      meta = doc[:meta]
      page_topics = meta.fetch("canonical_topics", [])
      if cat_norm
        topics_cats = page_topics.map { |t| @topics.dig(t, "category").to_s }
        next unless topics_cats.any? { |c| normalize(c).include?(cat_norm) }
      end
      if exam_filter
        next unless page_topics.any? { |t| topic_matches_exam?(t, exam_filter) }
      end

      bm25 = 0.0
      matched_primary = 0
      matched_any = 0

      term_weights.each do |term, weight|
        tf = doc[:tf][term] || 0
        if tf.zero? && term.length >= 4 && doc[:norm_text].include?(term)
          # Komposita-Teilworttreffer im Deutschen (z. B. "subnetz" in "subnetzmaske")
          bm25 += 1.6 * weight
          matched_any += 1
          matched_primary += 1 if weight >= 0.85
          next
        end
        next if tf.zero?

        term_idf = idf(term, idx)
        norm_len = 1.0 - BM25_B + BM25_B * (doc[:dl].to_f / idx[:avg_dl])
        tf_norm = (tf * (BM25_K1 + 1.0)) / (tf + BM25_K1 * norm_len)
        bm25 += term_idf * tf_norm * weight * 4.0
        matched_any += 1
        matched_primary += 1 if weight >= 0.85
      end

      phrase_hit = phrase.length >= 3 && doc[:norm_text].include?(phrase)
      next if matched_any.zero? && !phrase_hit

      # Bei mehrteiligen Anfragen ohne Phrasentreffer: sanfter Coverage-Bonus statt hartem Ausschluss
      if effective_tokens.length >= 2 && matched_primary.zero? && matched_any < 2 && !phrase_hit
        next
      end

      score = bm25
      score += 28.0 if phrase_hit
      if effective_tokens.length > 1 && matched_primary > 0
        coverage = matched_primary.to_f / effective_tokens.length
        score += coverage * 18.0
      end
      score += 8.0 if effective_tokens.any? { |t| t.length >= 3 && doc[:heading_norm].include?(t) }
      score += 4.0 if meta["status"] == "evidence"
      score += 2.5 if meta["quote_safe"]

      snippet_terms = effective_tokens + synonym_tokens.first(6)
      page_hits << {
        score: score.round(1),
        source_rel: doc[:source_rel],
        page_num: doc[:page_num],
        original_pdf: doc[:original_pdf],
        meta: meta,
        snippet: extract_snippet(doc[:text], snippet_terms)
      }
    end

    # Volltext-Treffer auf Themen rueckkoppeln
    topic_map = topic_scores.each_with_object({}) { |(sc, name, info), h| h[name] = [sc, name, info] }
    page_hits.sort_by { |h| -h[:score] }.first(24).each do |hit|
      hit[:meta].fetch("canonical_topics", []).each do |t_name|
        info = @topics[t_name]
        next unless info
        next if cat_norm && !normalize(info.fetch("category")).include?(cat_norm)
        next unless topic_matches_exam?(t_name, exam_filter)

        boost = [hit[:score] / 4.0, 18.0].min
        if topic_map[t_name]
          topic_map[t_name][0] += boost
        else
          topic_map[t_name] = [boost, t_name, info]
        end
      end
    end

    ranked_topics = topic_map.values.sort_by { |sc, name, _| [-sc, name] }.first(limit)
    ranked_pages = page_hits.sort_by { |h| [-h[:score], h[:source_rel], h[:page_num]] }.first(limit)

    exam_suffix = exam_filter ? " · Pruefungsfilter: #{exam_filter.upcase}" : ""
    puts "# Schnellsuche: \"#{query}\"#{exam_suffix}"
    unless corrections.empty?
      corr_str = corrections.map { |orig, fix| "\"#{orig}\" → \"#{fix}\"" }.join(", ")
      puts "> Fuzzy-Autokorrektur aktiv: #{corr_str}"
    end

    puts "\n## Passende kanonische Themen (#{ranked_topics.length})"
    if ranked_topics.empty?
      puts "- Keine direkten Themen-Treffer. Nutze `list` fuer alle #{@topics.length} Themen."
    else
      ranked_topics.each do |sc, name, info|
        puts "- **#{name}** [#{exam_badge(name)} | #{info['category']}] · #{info['pages'].length} S. · Score #{sc.round(1)}"
        puts "  Laden: `ruby .agents/skills/ap-lerncoach/scripts/vault_lookup.rb topic \"#{name}\" --compact`"
      end
    end

    puts "\n## Konkrete Belegseiten (#{ranked_pages.length} von #{page_hits.length} Treffern)"
    if ranked_pages.empty?
      puts "- Keine Volltext-Treffer in aktiven Quellseiten."
    else
      ranked_pages.each do |h|
        m = h[:meta]
        flags = [m["status"], m["source_text_status"], (m["quote_safe"] ? "zitatfaehig" : "Original pruefen"), "BM25 #{h[:score]}"].join(" | ")
        puts "- `#{File.basename(h[:source_rel], '.md')}` S. #{h[:page_num]} (#{flags})"
        puts "  Themen: #{m.fetch('canonical_topics', []).map { |t| "#{t} [#{topic_exam(t)}]" }.join(', ')}"
        puts "  PDF: `#{h[:original_pdf]}#page=#{h[:page_num]}`" unless h[:original_pdf].empty?
        puts "  Auszug: #{h[:snippet]}"
      end
    end
  end

  def extract_snippet(text, tokens, max_len: 170)
    lines = text.lines.map { |l| l.strip.gsub(/\s+/, " ") }.reject(&:empty?)
    best = lines.max_by do |l|
      nl = normalize(l)
      hits = tokens.count { |t| t.length >= 2 && nl.include?(t) }
      hits.zero? ? -1 : hits * 10 - [l.length / 40, 3].min
    end
    nl_best = best ? normalize(best) : ""
    chosen = tokens.any? { |t| t.length >= 2 && nl_best.include?(t) } ? best : lines.first.to_s
    chosen.length > max_len ? "#{chosen[0, max_len - 1]}…" : chosen
  end

  def resolve_topic(query)
    return [query, @topics[query]] if @topics.key?(query)

    q_norm = normalize(query)
    exact_norm = @topics.keys.find { |k| normalize(k) == q_norm }
    return [exact_norm, @topics[exact_norm]] if exact_norm

    matches = @topics.keys.select { |k| normalize(k).include?(q_norm) }
    return [matches.first, @topics[matches.first]] if matches.length == 1

    if matches.empty?
      idx = ensure_bm25_index!
      raw_toks = tokenize(query).map { |t| fuzzy_correct_token(t, idx) || t }
      q_toks = expand_tokens(raw_toks)
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
      matches.each { |m| puts "- #{m} [#{exam_badge(m)} | #{@topics[m]['category']}] (#{@topics[m]['pages'].length} S.)" }
      exit 2
    end
  end

  def cmd_topic(query, compact: false, max_pages: 6, page_filter: nil, source_filter: nil, term_query: nil, include_support: false, max_chars: MAX_PAGE_CHARS_DEFAULT)
    topic_name, info = resolve_topic(query)
    allowed_nums = page_filter ? parse_range_spec(page_filter) : nil
    src_norm = source_filter ? normalize(source_filter) : nil
    term_tokens = term_query ? expand_tokens(tokenize(term_query)) : nil

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

    exam_entry = @exam_topics[topic_name.unicode_normalize(:nfc)] || @exam_topics[topic_name] || {}
    puts "# Thema: #{topic_name}"
    puts "- Pruefungsfokus: **#{exam_badge(topic_name)}**#{exam_entry['hinweis'] ? " — #{exam_entry['hinweis']}" : ''}"
    puts "- Kategorie: `#{info['category']}`"
    puts "- Themenseite: `#{info['path']}`"
    puts "- Gefundene verifizierte Seiten: **#{entries.length}** (Gesamt im Thema: #{info['pages'].length})"

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

  def cmd_mix(query, exam_filter: nil, limit: 6)
    cat_match = @topics.values.map { |v| v["category"] }.uniq.find { |c| normalize(c) == normalize(query) || (query.length >= 6 && normalize(c).include?(normalize(query))) }
    if cat_match && !@topics.key?(query)
      list = @topics.select { |k, v| v["category"] == cat_match && topic_matches_exam?(k, exam_filter) }
                    .sort_by { |k, v| [-v["pages"].length, k] }
                    .first(limit)
      puts "# Interleaving-Pool fuer Kategorie: #{cat_match}#{exam_filter ? " (Filter: #{exam_filter.upcase})" : ''}"
      list.each { |name, info| puts "- **#{name}** [#{exam_badge(name)}] (#{info['pages'].length} S.)" }
      return
    end

    topic_name, info = resolve_topic(query)
    cat = info.fetch("category")
    own_sources = info.fetch("pages").map { |id| id.split("#page=", 2).first }.uniq

    puts "# Interleaving-Empfehlungen zu: #{topic_name} [#{exam_badge(topic_name)} | #{cat}]"
    puts "*(Diskriminativer Kontrast an IHK-Verwechslungsgrenzen: Brunmair & Richter 2019)*\n"

    # 1. Kuratierte kognitive Verwechslungspaare (auch kategorieuebergreifend!)
    matching_clusters = @confusion_clusters.select do |cl|
      Array(cl["topics"]).any? { |t| normalize(t) == normalize(topic_name) }
    end

    curated_partners = {}
    unless matching_clusters.empty?
      puts "## Kuratierte Verwechslungscluster (Prioritaet 1)"
      matching_clusters.each do |cl|
        partners = Array(cl["topics"]).reject { |t| normalize(t) == normalize(topic_name) }
                                      .select { |t| @topics.key?(t) && topic_matches_exam?(t, exam_filter) }
        next if partners.empty?

        puts "- **#{cl['title']}** [#{cl['pruefung']}]"
        puts "  - **Kontrast-Kern:** #{cl['contrast_focus']}"
        puts "  - **Diskriminationsfrage (zuerst klären!):** *#{cl['discrimination_question']}*"
        partners.each do |p_name|
          curated_partners[p_name] = true
          p_info = @topics[p_name]
          puts "  - Partner-Thema: **#{p_name}** [#{exam_badge(p_name)} | #{p_info['category']}] (#{p_info['pages'].length} S.)"
        end
      end
      puts ""
    end

    # 2. Ergaenzende Themen aus gemeinsamen Quellen / Wortstaemmen
    candidates = []
    @topics.each do |other_name, other_info|
      next if other_name == topic_name || curated_partners[other_name]
      next unless topic_matches_exam?(other_name, exam_filter)

      score = 0
      score += 30 if other_info["category"] == cat
      other_sources = other_info.fetch("pages").map { |id| id.split("#page=", 2).first }.uniq
      shared_sources = (own_sources & other_sources).length
      score += shared_sources * 20
      shared_words = (tokenize(topic_name) & tokenize(other_name)).reject { |w| STOPWORDS.include?(w) }
      score += shared_words.length * 25
      candidates << [score, other_name, other_info, shared_sources] if score > 0
    end

    remaining = [limit - curated_partners.length, 2].max
    ranked = candidates.sort_by { |sc, name, _, _| [-sc, name] }.first(remaining)
    unless ranked.empty?
      puts "## Weitere verwandte Themen im selben Kontext"
      ranked.each do |sc, name, o_info, shared_src|
        hint = shared_src > 0 ? " · #{shared_src} gemeinsame Quelle(n)" : ""
        puts "- **#{name}** [#{exam_badge(name)} | #{o_info['category']}] (#{o_info['pages'].length} S.#{hint}) · Relevanz #{sc}"
      end
    end
  end

  # Rendert freigegebene Originalseiten als PNG, damit die exakte Prüfungsnotation
  # (PAP-, EPK-, ER-, Netzplan-Symbole ...) als Bild gezeigt werden kann. Fail-closed:
  # nur Seiten aus dem visuell geprüften Index, nie ausgeschlossene Seiten.
  def cmd_render(source_query, range_spec, out_dir:, width: 1400)
    source_rel = resolve_source(source_query)
    src = load_source(source_rel)
    abort "Quellnotiz nicht lesbar: #{source_rel}" unless src
    abort "Keine Original-PDF in #{source_rel} hinterlegt." if src[:original_pdf].empty?

    pdf_path = ROOT.join(src[:original_pdf])
    abort "Original-PDF fehlt: #{src[:original_pdf]}" unless pdf_path.file?
    abort "FAIL-CLOSED: Pfad ausserhalb von 99_Originale/." unless src[:original_pdf].start_with?("99_Originale/")

    source_base = source_rel.sub(/\.md\z/, "")
    allowed = []
    parse_range_spec(range_spec).each do |num|
      meta = @pages_by_id["#{source_base}#page=#{num}"]
      if meta.nil? || meta["status"] == "excluded"
        warn "Seite #{num}: nicht freigegeben (#{meta ? 'ausgeschlossen' : 'nicht im Audit'}) – uebersprungen."
        next
      end
      allowed << num
    end
    abort "Keine freigegebenen Seiten zum Rendern." if allowed.empty?

    binary = ensure_render_binary!
    out = File.expand_path(out_dir)
    stdout, stderr, status = Open3.capture3(binary, pdf_path.to_s, out, allowed.join(","), width.to_s)
    abort "Rendern fehlgeschlagen:\n#{stderr}" unless status.success?

    pdf_bn = File.basename(src[:original_pdf])
    puts "# Gerenderte Originalseiten: `#{pdf_bn}` (#{src[:fach_label]}, #{src[:total_pages]} Seiten)"
    stdout.lines.map(&:strip).reject(&:empty?).each_with_index do |png, i|
      num = allowed[i]
      meta = @pages_by_id["#{source_base}#page=#{num}"]
      puts "- S. #{num} [#{meta['source_text_status']}]: `#{png}`"
      puts "  Einbetten: `![#{pdf_bn} S. #{num}](#{png})`"
    end
  end

  private

  RENDER_SOURCE = Pathname.new(__dir__).join("render_pdf_page.m")
  RENDER_BIN = Pathname.new("/tmp/ap_lerncoach_render/render_pdf_page")

  def ensure_render_binary!
    abort "render_pdf_page.m fehlt neben vault_lookup.rb" unless RENDER_SOURCE.file?
    return RENDER_BIN.to_s if RENDER_BIN.executable? && File.mtime(RENDER_BIN) >= File.mtime(RENDER_SOURCE)

    FileUtils.mkdir_p(RENDER_BIN.dirname)
    cmd = ["clang", "-fobjc-arc", "-framework", "Foundation", "-framework", "AppKit",
           "-framework", "PDFKit", RENDER_SOURCE.to_s, "-o", RENDER_BIN.to_s]
    _out, err, st = Open3.capture3(*cmd)
    abort "Kompilieren von render_pdf_page.m fehlgeschlagen:\n#{err}" unless st.success?
    RENDER_BIN.to_s
  end

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
      list [kategorie]                 Alle kanonischen Themen (optional nach Kategorie & Pruefung)
        --exam <AP1|AP2|BS>            Auf Pruefungsphase filtern (z. B. AP1 schliesst AP1 + AP1/AP2 ein)
      find "<suchbegriff>"             BM25-Volltextsuche + Synonym- & Tippfehler-Toleranz
        --category <cat>               Auf eine der 6 Kategorien eingrenzen
        --exam <AP1|AP2|BS>            Nur Themen/Belegseiten der gewaehlten Pruefung zeigen
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
      render "<quelle>" "<seiten>"     Freigegebene Originalseiten als PNG rendern (Pruefungsnotation zeigen)
        --out <ordner>                 Zielordner fuer PNGs (Standard: /tmp/ap_lerncoach_render/pages)
        --width <px>                   Bildbreite (Standard: 1400)
      mix "<thema_oder_kategorie>"     Kuratierte Verwechslungspaare & Partner-Themen fuer Interleaving
        --exam <AP1|AP2|BS>            Nur Partner-Themen der gewaehlten Pruefungsphase vorschlagen
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
  exam: nil,
  limit: 8,
  compact: false,
  max_pages: 6,
  pages: nil,
  source: nil,
  query: nil,
  include_support: false,
  max_chars: MAX_PAGE_CHARS_DEFAULT,
  out: "/tmp/ap_lerncoach_render/pages",
  width: 1400
}

parser = OptionParser.new do |o|
  o.on("--category CAT") { |v| opts[:category] = v }
  o.on("--exam EXAM") { |v| opts[:exam] = v }
  o.on("--limit N", Integer) { |v| opts[:limit] = v }
  o.on("--compact") { opts[:compact] = true }
  o.on("--max-pages N", Integer) { |v| opts[:max_pages] = v }
  o.on("--pages SPEC") { |v| opts[:pages] = v }
  o.on("--source SRC") { |v| opts[:source] = v }
  o.on("--query Q") { |v| opts[:query] = v }
  o.on("--include-support") { |v| opts[:include_support] = true }
  o.on("--max-chars N", Integer) { |v| opts[:max_chars] = v }
  o.on("--out DIR") { |v| opts[:out] = v }
  o.on("--width N", Integer) { |v| opts[:width] = v }
end
parser.parse!(ARGV)

lookup = VaultLookup.new

case cmd
when "list"
  lookup.cmd_list(ARGV.first || opts[:category], exam_filter: opts[:exam])
when "find"
  lookup.cmd_find(ARGV.join(" "), category_filter: opts[:category], exam_filter: opts[:exam], limit: opts[:limit])
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
when "render"
  abort "Verwendung: render \"<quelle>\" \"<seitenbereich>\" [--out <ordner>]" if ARGV.length < 2
  lookup.cmd_render(ARGV[0], ARGV[1], out_dir: opts[:out], width: opts[:width])
when "mix"
  lookup.cmd_mix(ARGV.join(" "), exam_filter: opts[:exam], limit: opts[:limit])
else
  warn "Unbekannter Befehl: #{cmd}"
  usage
  exit 1
end
