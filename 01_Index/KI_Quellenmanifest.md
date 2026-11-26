---
id: vault.ki.quellenmanifest
typ: ki_quellenmanifest
status: generiert
stand: 2026-11-26
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

- Dateien insgesamt: **540**
- Stand: **2026-11-26**
- Generator: `ruby 01_Index/Tools/build_ki_manifest.rb`

| KI-Nutzung | Dateien |
|---|---:|
| `excluded` | 193 |
| `navigation` | 81 |
| `operational` | 25 |
| `primary` | 188 |
| `verify_only` | 53 |

| Rolle | Dateien |
|---|---:|
| `agent_customization` | 10 |
| `copilot_prompt` | 1 |
| `curated_topic` | 140 |
| `entrypoint` | 2 |
| `exam_archive` | 1 |
| `excluded_source_note` | 7 |
| `flashcard_index` | 141 |
| `import_inbox` | 2 |
| `learner_state` | 1 |
| `maintenance_tool` | 15 |
| `obsidian_configuration` | 16 |
| `original_pdf` | 53 |
| `private_or_archive` | 2 |
| `project_metadata` | 3 |
| `quality_or_navigation` | 70 |
| `source_note` | 46 |
| `subject_index` | 9 |
| `topic_index` | 1 |
| `unverified_exam_material` | 19 |
| `workflow_guide` | 1 |

## Retrieval-Profile

**Kompakt:** `entrypoint`, `topic_index`, `curated_topic` und `source_note`; Original-PDFs nur zur Verifikation. Dieses Profil hat die höchste Präzision.

**Diagnose:** Zusätzlich Qualitäts- und Navigationsdateien durchsuchen. Dadurch entstehen keine weiteren fachlichen Belege.

**Immer ausschließen:** Archiv/Privatbereich, Posteingang (`00_Posteingang_GoodNotes/`), `.obsidian`, Copilot-Prompts, Templates, alte Themen, generierte Lernmodule, ungeprüfte Prüfungsschichten und Quellnotizen mit `ki_exclude: true`.

## Quellenpriorität

1. aktive Quellnotiz für Text und genaue Seite
2. Original-PDF zur visuellen Prüfung

Die visuell geprüfte Themenseite dient davor als Retrieval-Navigation, nicht als eigenständiger Faktenbeleg.

Siehe auch [[00_KI_QUELLENSTART|KI-Quellenstart]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [[01_Index/PDF_Seitenaudit|vollständiger Seitenaudit]].
