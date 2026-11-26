# RAG_Berufsschule

Erstelle am 20.06.26

Ein Wissens- und Lern-RAG für die Fachinformatiker-Ausbildung (AE) IHK Bayern, das Obsidian über automatisierte Python Scripte mit GoodNotes verbindet. Neue PDF-Mitschriften werden automatisch auf Duplikate geprüft, für KI-Assistenten aufbereitet und automatisch in Themenbereiche sowie Karteikarten eingeordnet und logisch aufbereitet. – ergänzt durch einen maßgeschneiderten KI-Lerncoach-Skill (`ap-lerncoach`) mit wissenschaftlichen Lernmethoden zur gezielten IHK-Prüfungsvorbereitung (**AP1** und **AP2**) sowie zum Lernen für Tests.

Nutzbar ist das RAG über alle in der IDE integrierten KI Agenten sowie alle die die Zugriff auf Lokale Datein auf deinem PC haben. Für die light Version Reicht es den aktuellen stand in eine ZIP zu packen und ihm einen Skill oder einem Agenten anzuhängen (wichtig dabei ist das dieser Skill mit enthalten ist KI-Lerncoach-Skill (`ap-lerncoach`)). Falls diese zu groß ist können auch nur die Themenbereche und Karteikarten gezipt werden, da diese in für KI gut lesbaren .md Format geschrieben sind und für die reine Funktionalität absolut ausreichen.

> **Stand (Audit 24.11.2026):** **49** kanonische Quellnotizen · **1.389** visuell geprüfte PDF-Seiten (**1.251** Belegseiten) · **139** kuratierte Themen · **139** Karteikarten-Decks (**860** Karten) · **191** freigegebene RAG-/Copilot-Dateien

---

## ✨ Kernfunktionen

- **Visuell geprüfte Wissensbasis & Quellenlayer**  
  Jede aktive PDF unter `99_Originale/` ist seitenweise (`### Seite N` + `#page=N`-Link) in `02_Faecher/<Fach>/Quellen/` abgebildet. Handschriftliche Notizen und Scans sind visuell geprüft und transkribiert; die fachliche Navigation erfolgt über **139 kuratierte Themen** in 6 Kategorien (`03_Themen/Visuell_geprueft/`).
- **Automatisierte GoodNotes-Import-Pipeline (`goodnotes-import`)**  
  `import_goodnotes.rb` scannt neue oder aktualisierte GoodNotes-PDFs in `00_Posteingang_GoodNotes/`, erkennt per SHA-256 und visuellem Seiten-Fingerprint automatisch Duplikate sowie erweiterte Notizbücher (`EXTENDED_NOTEBOOK`), rendert neue Seiten zur visuellen Prüfung (Swift/PDFKit) und aktualisiert anschließend alle Indizes, Themen, Allowlists und Validierungen in einem Lauf.
- **Fail-Closed RAG & Datenschutz**  
  KI-Systeme (z. B. Obsidian Copilot oder Agenten) greifen ausschließlich über `00_KI_QUELLENSTART.md` und eine exakte Positiv-Allowlist (`01_Index/Copilot_Allowlist.json`) auf geprüfte Inhalte zu. Private, doppelte oder leere Seiten (`ki_exclude_seiten`), alte Lernordner sowie `98_Archiv_nicht_lernen/` sind technisch ausgeschlossen; sensible Beispieldaten (`ki_sensitive_seiten`) werden abstrahiert.
- **KI-Lerncoach & Fast Retrieval (`ap-lerncoach`)**  
  Ein didaktischer Lern-Skill (Sokratisches Scaffolding, Active Recall, IHK-Operatoren, AP1/AP2-Priorisierung) mit dem lokalen Suchwerkzeug `vault_lookup.rb` (fail-closed Suche & Seitenextraktion in `< 150 ms` ohne Token-Ballast).
- **Karteikarten & Multi-Plattform-Export**  
  Alle 139 Themen sind als Karteikarten-Decks (`05_Karteikarten/`, 860 Karten) für **Obsidian Spaced Repetition** gepflegt und lassen sich per `sync_karteikarten.rb` für **Anki** und **NotebookLM** exportieren. Zusätzlich erzeugt `export_gemini_bundle.rb` 7 kompakte, datenschutzsichere Markdown-Pakete für **Gemini Skills / Google Drive**.
- **IHK-Prüfungsvorbereitung & Hybrid-Aufgabengenerator**  
  Strukturierte Lernplanung über IHK-AP1-Prüfungskatalog & Checkliste, AP1-Lernmatrix, AP2-Ausbauplan (`04_Pruefung/`) sowie eine automatisierte Import- und Analyse-Pipeline für **Original-IHK-Altklausuren + offizielle Lösungshinweise** (`06_Altklausuren/`, `import_altklausur.rb`, Skill `altklausur-import`), aus denen `ap-lerncoach` interaktive 1-nach-1-Aufgaben (Skript-Stil + IHK-Prüfungsstil) generiert.

---

## 📁 Projektstruktur

```text
├── 00_START.md                        # Einstieg für Lernende
├── 00_KI_QUELLENSTART.md              # Kanonischer Einstieg & Regeln für KI / RAG / Copilot
├── 00_WORKFLOW_NEUE_MITSCHRIFTEN.md   # Anleitung zur Integration neuer GoodNotes-PDFs
├── 00_Posteingang_GoodNotes/          # Lokaler Posteingang für neue PDFs (git-ignored)
├── 01_Index/
│   ├── Tools/                         # Ruby- & Swift-CLI-Pipeline (Import, Sync, Export, Checks)
│   └── Auditdaten/                    # Maschinenlesbare Audit- & Manifestdaten
├── 02_Faecher/                        # Fachordner (AE, BGWP, ITT, Deutsch, Englisch, PuG, Reli)
├── 03_Themen/
│   ├── 00_Kuratierte_Themen.md        # Index aller 139 visuell geprüften Themen
│   └── Visuell_geprueft/              # Themen in 6 kanonischen Kategorien
├── 04_Pruefung/                       # AP1-Katalog, Lernmatrix, AP2-Ausbauplan, Prüfungsmodus
├── 05_Karteikarten/                   # 139 Decks (860 Karten) + Gesamtindex
├── 06_Altklausuren/                   # Struktur & Workflow für AP1/AP2-Altklausuren
├── 98_Archiv_nicht_lernen/            # Duplikate & private Dokumente (Privatordner git-ignored)
├── 99_Originale/                      # Originale PDF-Mitschriften nach Fächern
├── .agents/skills/                    # Agent-Skills (ap-lerncoach, goodnotes-import, altklausur-import)
└── manifest.json                      # Aktueller Gesamtaudit- und Projektstatus
```
---

## 🔒 Datenschutz & Git-Hinweise

Die `.gitignore` schließt automatisch alle sensiblen und temporären Bereiche vom Repository aus:
- Private Noten/Dokumente (`**/Privat_Noten_nicht_fuer_KI/`)
- Ungeprüfte Posteingangs-PDFs (`00_Posteingang_GoodNotes/**`)
- Lokale Copilot-Zugangsdaten (`.obsidian/plugins/copilot/data.json`) und Workspace-Dateien
- Temporäre Import-/Review-Artefakte (`.import_review/`, `.DS_Store`)

Nach jedem PDF-Import in Obsidian einmal **`Copilot: Force reindex vault`** (`⌘P`) ausführen, damit neue Quellnotizen im lokalen RAG-Index verfügbar sind.

