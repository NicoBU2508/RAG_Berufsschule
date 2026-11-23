#!/usr/bin/env ruby

require "date"
require "json"
require "pathname"
require_relative "lib/vault_support"

ROOT = VaultSupport::ROOT
WORKLIST = ROOT.join("01_Index/PDF_Seitenaudit_Worklist.json")
DUPLICATES = ROOT.join("01_Index/Auditdaten/PDF_Duplikatnachweis.json")
JSON_OUTPUT = ROOT.join("01_Index/PDF_Seitenaudit.json")
MARKDOWN_OUTPUT = ROOT.join("01_Index/PDF_Seitenaudit.md")
BASE_AUDIT_DATE = VaultSupport::BASE_AUDIT_DATE

BASE_REPORT_CANDIDATES = [
  [ROOT.join("01_Index/Auditdaten/PDF_Seitenaudit_Root.json")],
  [ROOT.join("01_Index/Auditdaten/PDF_Seitenaudit_AE_Allgemein.json"), Pathname.new("/private/tmp/pdf_deep_audit_ae.json")],
  [ROOT.join("01_Index/Auditdaten/PDF_Seitenaudit_BGWP_Sprachen.json"), Pathname.new("/private/tmp/pdf_deep_audit_bgwp_sprachen.json")],
  [ROOT.join("01_Index/Auditdaten/PDF_Seitenaudit_Sicherheit_Gesellschaft.json"), Pathname.new("/private/tmp/pdf_deep_audit_security_gesellschaft.json")]
].freeze

module NormalizedKey
  module_function

  def text(value)
    value.to_s.unicode_normalize(:nfc)
  end

  def page(source_note, page)
    [text(source_note), Integer(page)]
  end
end

class PageRange
  def self.expand(value)
    text = value.to_s.strip
    return [Integer(text)] unless text.include?("-")

    first, last = text.split("-", 2).map { |part| Integer(part) }
    raise "invalid descending page range: #{value}" if last < first

    (first..last).to_a
  end
end

class ReportLocator
  def locate(candidate_groups)
    base_paths = candidate_groups.map do |candidates|
      path = candidates.find(&:file?)
      raise "audit report missing; tried: #{candidates.join(', ')}" unless path

      path
    end
    base_paths + VaultSupport.import_report_paths
  end
end

class ReportReader
  FIELDS = %w[
    primary_topic secondary_topics content_type source_text_match mapping_status
    confidence recommended_modules recommended_topics issues
  ].freeze

  OPTIONAL_FIELDS = %w[
    audit_date exclusion_reason support_only sensitive ocr_verified replaces_existing
  ].freeze

  def read(path)
    data = JSON.parse(File.read(path, encoding: "UTF-8"))
    if data.key?("documents")
      read_root_report(data, path)
    elsif Array(data["pages"]).first.is_a?(Hash) && Array(data["pages"]).first.key?("audit")
      read_page_report(data, path)
    elsif data.key?("ranges")
      read_flat_range_report(data, path)
    elsif data.key?("pdfs")
      read_agent_report(data, path)
    else
      raise "unknown report schema: #{path}"
    end
  end

  private

  def read_root_report(data, path)
    records = {}
    data.fetch("documents").each do |document|
      source_note = nil
      document.fetch("ranges").each do |range|
        PageRange.expand(range.fetch("pages")).each do |page|
          key = [NormalizedKey.text(document.fetch("pdf_path")), page]
          add(records, key, audit_fields(range).merge(
            "pdf_path" => document.fetch("pdf_path"),
            "source_note" => source_note,
            "report" => relative_or_absolute(path)
          ))
        end
      end
    end
    { "records" => records, "findings" => root_findings(data, path), "topic_categories" => {} }
  end

  def read_agent_report(data, path)
    overrides = data.fetch("page_overrides", []).each_with_object({}) do |item, index|
      index[NormalizedKey.page(item.fetch("source_note"), item.fetch("page"))] = item.fetch("override")
    end
    records = {}
    data.fetch("pdfs").each do |document|
      source_note = document.fetch("source_note")
      document.fetch("ranges").each do |range|
        (Integer(range.fetch("start_page"))..Integer(range.fetch("end_page"))).each do |page|
          issues = Array(range["issues"]).dup
          override = overrides[NormalizedKey.page(source_note, page)]
          issues << override if override
          key = NormalizedKey.page(source_note, page)
          add(records, key, audit_fields(range).merge(
            "pdf_path" => document.fetch("pdf_path"),
            "source_note" => source_note,
            "issues" => issues,
            "report" => relative_or_absolute(path)
          ))
        end
      end
    end
    { "records" => records, "findings" => agent_findings(data, path), "topic_categories" => {} }
  end

  def read_flat_range_report(data, path)
    records = {}
    data.fetch("ranges").each do |range|
      (Integer(range.fetch("start_page"))..Integer(range.fetch("end_page"))).each do |page|
        key = NormalizedKey.page(range.fetch("source_note"), page)
        add(records, key, audit_fields(range).merge(
          "pdf_path" => range.fetch("pdf_path"),
          "source_note" => range.fetch("source_note"),
          "report" => relative_or_absolute(path)
        ))
      end
    end
    { "records" => records, "findings" => generic_findings(data, path), "topic_categories" => {} }
  end

  def read_page_report(data, path)
    is_import = VaultSupport.import_report?(path)
    default_replaces = data["replaces_existing"] == true
    records = {}
    data.fetch("pages").each do |page|
      if is_import
        problems = VaultSupport.import_page_problems(page)
        raise "Ungültiger Import-Audit (#{relative_or_absolute(path)}):\n  - #{problems.join("\n  - ")}" unless problems.empty?
      end
      key = NormalizedKey.page(page.fetch("source_note"), page.fetch("page"))
      fields = audit_fields(page.fetch("audit"))
      fields["replaces_existing"] = true if default_replaces && !fields.key?("replaces_existing")
      add(records, key, fields.merge(
        "pdf_path" => page.fetch("pdf_path"),
        "source_note" => page.fetch("source_note"),
        "report" => relative_or_absolute(path)
      ))
    end
    {
      "records" => records,
      "findings" => generic_findings(data, path),
      "topic_categories" => data.fetch("topic_categories", {})
    }
  end

  def audit_fields(range)
    base = FIELDS.each_with_object({}) do |field, result|
      value = range[field]
      value = [] if %w[secondary_topics recommended_modules recommended_topics issues].include?(field) && value.nil?
      result[field] = value
    end
    OPTIONAL_FIELDS.each do |field|
      value = range[field]
      next if value.nil? || (value.is_a?(String) && value.strip.empty?)

      base[field] = value
    end
    base
  end

  def add(records, key, value)
    raise "duplicate audited page in report: #{key.inspect}" if records.key?(key)

    records[key] = value
  end

  def root_findings(data, path)
    {
      "report" => relative_or_absolute(path),
      "scope" => data["scope"],
      "proposed_canonical_topics" => data.fetch("proposed_canonical_topics", []),
      "document_issues" => data.fetch("documents").map do |document|
        next if Array(document["global_issues"]).empty?

        { "pdf_path" => document["pdf_path"], "issues" => document["global_issues"] }
      end.compact
    }
  end

  def agent_findings(data, path)
    {
      "report" => relative_or_absolute(path),
      "audit_scope" => data["audit_scope"],
      "coverage" => data["coverage"],
      "text_issues" => data.fetch("text_issues", []),
      "mapping_issues" => data.fetch("mapping_issues", []),
      "canonical_topic_candidates" => data.fetch("canonical_topic_candidates", [])
    }
  end

  def generic_findings(data, path)
    {
      "report" => relative_or_absolute(path),
      "scope" => data["scope"],
      "coverage" => data["coverage"],
      "counts" => data["counts"] || data["summary"],
      "validation" => data["validation"] || data["range_coverage_proof"],
      "critical_findings" => data.fetch("critical_findings", []),
      "text_issues" => data["text_issues"] || data.fetch("text_repairs", []),
      "mapping_issues" => data["mapping_issues"] || data.fetch("mapping_replacements", []),
      "canonical_topic_candidates" => data["proposed_canonical_topics"] || data.fetch("new_canonical_topic_candidates", [])
    }
  end

  def relative_or_absolute(path)
    path.to_s.start_with?(ROOT.to_s) ? path.relative_path_from(ROOT).to_s : path.to_s
  end
end

class AuditCompiler
  def initialize(worklist, reports, duplicate_data)
    @worklist = worklist
    @reports = reports
    @duplicate_data = duplicate_data
  end

  def compile
    by_source, by_pdf, active_records = build_indexes
    used = Hash.new(0)
    pages = @worklist.fetch("pages").map do |page|
      source_key = NormalizedKey.page(page.fetch("source_note"), page.fetch("page"))
      pdf_key = [NormalizedKey.text(page.fetch("pdf_path")), page.fetch("page")]
      audit = by_source[source_key] || by_pdf[pdf_key]
      raise "page has no visual audit: #{source_key.inspect}" unless audit

      used[audit.object_id] += 1
      final_page(page, audit)
    end
    extra = active_records.reject { |record| used[record.object_id] == 1 }
    raise "unused or multiply used report records: #{extra.length}" unless extra.empty?

    audit_date = ([BASE_AUDIT_DATE] + pages.map { |page| page.dig("audit", "audit_date") }.compact).max
    topic_categories = @reports.each_with_object({}) do |report, merged|
      report.fetch("topic_categories", {}).each { |topic, category| merged[topic] = category }
    end

    result = {
      "schema_version" => 2,
      "audit_date" => audit_date,
      "scope" => "Alle #{pages.length} aktiven, nichtprivaten PDF-Seiten wurden visuell geprüft; private Inhalte blieben ungelesen.",
      "method" => "Jede aktive PDF-Seite wurde über vollständig gerenderte Kontaktbögen oder Einzelseiten bei Originaldetail visuell geprüft und mit Quelltext sowie bestehenden Modul-/Themenlinks verglichen.",
      "privacy" => "Der private Notenordner wurde nur als ausgeschlossener Pfad inventarisiert und nicht geöffnet.",
      "totals" => totals(pages),
      "duplicate_evidence" => @duplicate_data,
      "documents" => document_summaries(pages),
      "report_findings" => @reports.map { |report| report.fetch("findings") },
      "pages" => pages
    }
    result["topic_categories"] = topic_categories unless topic_categories.empty?
    result
  end

  private

  def build_indexes
    by_source = {}
    by_pdf = {}
    active = {}

    all_report_records.each do |record|
      pdf_key = [NormalizedKey.text(record.fetch("pdf_path")), record.fetch("page")]
      source_key = record["source_note"] ? NormalizedKey.page(record["source_note"], record.fetch("page")) : nil
      replaces = record["replaces_existing"] == true

      if source_key && by_source.key?(source_key) && !replaces
        raise "duplicate source key across reports: #{source_key.inspect}"
      end
      if by_pdf.key?(pdf_key) && !replaces
        raise "duplicate PDF key across reports: #{pdf_key.inspect}"
      end

      if replaces
        old_source = source_key ? by_source[source_key] : nil
        old_pdf = by_pdf[pdf_key]
        active.delete(old_source.object_id) if old_source
        active.delete(old_pdf.object_id) if old_pdf
      end

      by_source[source_key] = record if source_key
      by_pdf[pdf_key] = record
      active[record.object_id] = record
    end

    [by_source, by_pdf, active.values]
  end

  def all_report_records
    @all_report_records ||= @reports.flat_map do |report|
      report.fetch("records").map do |key, value|
        page = key.last
        value.merge("page" => page)
      end
    end
  end

  def final_page(page, audit)
    audit_payload = audit.slice(*ReportReader::FIELDS, *ReportReader::OPTIONAL_FIELDS).merge("visual_checked" => true)
    {
      "id" => page.fetch("id"),
      "subject" => page["subject"],
      "source_note" => page.fetch("source_note"),
      "pdf_path" => page.fetch("pdf_path"),
      "page" => page.fetch("page"),
      "source_text_status" => page.fetch("source_text_status"),
      "source_section_chars" => page.fetch("source_section_chars"),
      "previous_modules" => page.fetch("current_modules").map { |item| item.fetch("title") },
      "previous_curated_topics" => page.fetch("current_curated_topics").map { |item| item.fetch("title") },
      "audit" => audit_payload
    }
  end

  def totals(pages)
    audits = pages.map { |page| page.fetch("audit") }
    duplicate_totals = @duplicate_data.fetch("totals")
    private_pdfs = Dir.glob(ROOT.join(VaultSupport::PRIVATE_PREFIX, "**/*.pdf").to_s).length
    {
      "active_pdfs" => pages.map { |page| page.fetch("pdf_path") }.uniq.length,
      "active_pages" => pages.length,
      "visually_identical_duplicate_pdfs" => duplicate_totals.fetch("duplicate_pdfs"),
      "visually_identical_duplicate_pages" => duplicate_totals.fetch("duplicate_pages"),
      "nonprivate_pdfs_accounted_for" => pages.map { |page| page.fetch("pdf_path") }.uniq.length + duplicate_totals.fetch("duplicate_pdfs"),
      "nonprivate_pages_accounted_for" => pages.length + duplicate_totals.fetch("duplicate_pages"),
      "private_pdfs_unread" => private_pdfs,
      "source_text_match" => count(audits, "source_text_match"),
      "mapping_status_before_correction" => count(audits, "mapping_status"),
      "content_type" => count(audits, "content_type"),
      "confidence" => count(audits, "confidence")
    }
  end

  def count(records, field)
    records.each_with_object(Hash.new(0)) { |record, counts| counts[record[field] || "unspecified"] += 1 }.sort.to_h
  end

  def document_summaries(pages)
    pages.group_by { |page| [page.fetch("subject"), page.fetch("source_note"), page.fetch("pdf_path")] }.map do |(subject, source_note, pdf_path), records|
      audits = records.map { |record| record.fetch("audit") }
      {
        "subject" => subject,
        "source_note" => source_note,
        "pdf_path" => pdf_path,
        "pages" => records.length,
        "source_text_match" => count(audits, "source_text_match"),
        "mapping_status_before_correction" => count(audits, "mapping_status")
      }
    end.sort_by { |record| [record.fetch("subject").to_s, record.fetch("source_note")] }
  end
end

class MarkdownWriter
  def render(audit)
    totals = audit.fetch("totals")
    audit_date = audit.fetch("audit_date")
    rows = audit.fetch("documents").map do |document|
      text = compact_counts(document.fetch("source_text_match"))
      mappings = compact_counts(document.fetch("mapping_status_before_correction"))
      "| [[#{document.fetch('source_note').delete_suffix('.md')}|#{File.basename(document.fetch('source_note'), '.md')}]] | #{document.fetch('subject')} | #{document.fetch('pages')} | #{text} | #{mappings} |"
    end.join("\n")
    markdown = <<~MARKDOWN
      ---
      id: vault.audit.pdf-seiten
      typ: visueller_pdf_seitenaudit
      status: vollständig
      stand: #{audit_date}
      reviewed_on: #{audit_date}
      ki_prioritaet: 1
      tags:
        - ki_quelle
        - qualitaetssicherung
        - pdf_audit
      ---

      # Visueller PDF-Seitenaudit

      Alle **#{totals.fetch('active_pdfs')} aktiven nichtprivaten PDFs mit #{totals.fetch('active_pages')} Seiten** wurden vollständig visuell geprüft. Zusätzlich wurden **#{totals.fetch('visually_identical_duplicate_pdfs')} inaktive PDFs mit #{totals.fetch('visually_identical_duplicate_pages')} Seiten** vollständig gerendert und als pixelidentische Dubletten aktiver PDFs bestätigt. Damit sind **#{totals.fetch('nonprivate_pdfs_accounted_for')} nichtprivate PDFs und #{totals.fetch('nonprivate_pages_accounted_for')} Seiten** abgedeckt.

      > [!privacy] Bewusst ausgeschlossen
      > Die private Noten-PDF unter `98_Archiv_nicht_lernen/Privat_Noten_nicht_fuer_KI/` wurde nicht geöffnet, gerendert, gehasht oder inhaltlich gelesen.

      ## Methode

      Jede Seite wurde über vollständig gerenderte Kontaktbögen oder Einzelseiten bei Originaldetail gesichtet. Sichtinhalt, lokaler Quelltext, bisherige Modulreferenzen und kuratierte Themen wurden seitenweise verglichen. Das maschinenlesbare Ergebnis mit einer Zeile pro aktiver PDF-Seite steht in [[01_Index/PDF_Seitenaudit.json|PDF_Seitenaudit.json]].

      ## Gesamtbefund vor der Korrektur

      - Textabgleich: #{compact_counts(totals.fetch('source_text_match'))}
      - Themen-/Modulmapping: #{compact_counts(totals.fetch('mapping_status_before_correction'))}
      - Inhaltstypen: #{compact_counts(totals.fetch('content_type'))}
      - Prüfsicherheit: #{compact_counts(totals.fetch('confidence'))}

      ## Abdeckung nach Quelle

      | Quellnotiz | Fach | Seiten | Textabgleich | Mapping vor Korrektur |
      |---|---|---:|---|---|
      #{rows}

      ## Belegregel

      Der Audit bestätigt die semantische Zuordnung, ersetzt aber keine Originalquelle. Für Zahlen, Formeln, Tabellen, Rechtsnormen, Handschrift und OCR-unsichere Stellen immer die verlinkte PDF-Seite öffnen.
    MARKDOWN
    if VaultSupport::MAPPING_PATH.file?
      mapping_totals = VaultSupport.read_json(VaultSupport::MAPPING_PATH).fetch("totals")
      markdown = VaultSupport.with_canonical_section(markdown, mapping_totals)
    end
    markdown
  end

  private

  def compact_counts(counts)
    counts.map { |key, value| "`#{key}` #{value}" }.join(", ")
  end
end

paths = ReportLocator.new.locate(BASE_REPORT_CANDIDATES)
reports = paths.map { |path| ReportReader.new.read(path) }
worklist = JSON.parse(File.read(WORKLIST, encoding: "UTF-8"))
duplicate_data = JSON.parse(File.read(DUPLICATES, encoding: "UTF-8"))
audit = AuditCompiler.new(worklist, reports, duplicate_data).compile
VaultSupport.write_json_if_changed(JSON_OUTPUT, audit)
VaultSupport.write_if_changed(MARKDOWN_OUTPUT, MarkdownWriter.new.render(audit))
puts "Wrote #{JSON_OUTPUT.relative_path_from(ROOT)} and #{MARKDOWN_OUTPUT.relative_path_from(ROOT)} (#{audit.dig('totals', 'active_pages')} active pages)."
