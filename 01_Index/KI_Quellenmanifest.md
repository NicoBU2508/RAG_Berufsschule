---
id: vault.ki.quellenmanifest
typ: ki_quellenmanifest
status: generiert
stand: 2026-07-13
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

- Dateien insgesamt: **619**
- Stand: **2026-07-13**
- Generator: `ruby 01_Index/Tools/build_ki_manifest.rb`

| KI-Nutzung | Dateien |
|---|---:|
| `excluded` | 377 |
| `navigation` | 65 |
| `operational` | 11 |
| `primary` | 133 |
| `verify_only` | 33 |

| Rolle | Dateien |
|---|---:|
| `copilot_prompt` | 15 |
| `curated_topic` | 101 |
| `duplicate_pdf` | 3 |
| `entrypoint` | 2 |
| `exam_archive` | 1 |
| `excluded_source_note` | 3 |
| `flashcard_index` | 1 |
| `generated_learning_index` | 9 |
| `generated_learning_module` | 129 |
| `generated_vault_index` | 1 |
| `legacy_topic` | 30 |
| `maintenance_tool` | 11 |
| `navigation_index` | 10 |
| `obsidian_configuration` | 14 |
| `original_pdf` | 33 |
| `private_or_archive` | 5 |
| `project_metadata` | 1 |
| `quality_or_navigation` | 35 |
| `source_note` | 30 |
| `subject_index` | 18 |
| `template` | 3 |
| `topic_alias` | 146 |
| `topic_index` | 1 |
| `unverified_exam_material` | 17 |

## Retrieval-Profile

**Kompakt:** `entrypoint`, `topic_index`, `curated_topic` und `source_note`; Original-PDFs nur zur Verifikation. Dieses Profil hat die höchste Präzision.

**Diagnose:** Zusätzlich Qualitäts- und Navigationsdateien durchsuchen. Dadurch entstehen keine weiteren fachlichen Belege.

**Immer ausschließen:** Archiv/Privatbereich, `.obsidian`, Copilot-Prompts, Templates, alte Themen, generierte Lernmodule, ungeprüfte Prüfungsschichten und Quellnotizen mit `ki_exclude: true`.

## Quellenpriorität

1. aktive Quellnotiz für Text und genaue Seite
2. Original-PDF zur visuellen Prüfung

Die visuell geprüfte Themenseite dient davor als Retrieval-Navigation, nicht als eigenständiger Faktenbeleg.

Siehe auch [[00_KI_QUELLENSTART|KI-Quellenstart]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [[01_Index/PDF_Seitenaudit|vollständiger Seitenaudit]].
