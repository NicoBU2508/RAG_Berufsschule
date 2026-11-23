---
id: vault.workflow.neue-mitschriften
typ: workflow
status: aktiv
stand: 2026-11-23
rag_include: false
tags:
  - workflow
  - goodnotes
  - qualitaetssicherung
---

# 📥 Workflow: Neue GoodNotes-Mitschriften integrieren

Diese Anleitung beschreibt, wie neue oder erweiterte **GoodNotes-PDFs** sauber in deinen Vault integriert werden, sodass alle neuen Inhalte, Themen, Quellenlinks und die Obsidian-Copilot-Allowlist konsistent bleiben.

## 1. Deine Übergabe (zwei einfache Wege)

- **Weg A (Posteingang – empfohlen):** Exportiere dein GoodNotes-Notizbuch als PDF und lege es in [[00_Posteingang_GoodNotes/README|00_Posteingang_GoodNotes/]] ab. Schreib danach im Chat einfach: *„Integriere meine neuen GoodNotes-Mitschriften“*.
- **Weg B (Direkt im Chat):** Hänge die PDF direkt in den Chat an und sag kurz, zu welchem Fach sie gehört (oder lass es anhand des Inhalts automatisch zuordnen).

> [!tip] Tipp beim GoodNotes-Export
> Exportiere in GoodNotes als **PDF** (idealerweise *Bearbeitbar* / mit Textschicht). Reine Scans oder reine Handschrift funktionieren ebenfalls – bei der visuellen Prüfung wird fehlender Text direkt ergänzt.

> [!privacy] Datenschutz-Regel
> Lade niemals Noten, Zeugnisse, Gehaltsabrechnungen oder andere private Dokumente hoch. Der Import bricht bei verdächtigen Dateinamen automatisch ab; echte private Dokumente gehören lokal nach `98_Archiv_nicht_lernen/` (und sind per `.gitignore` ausgeschlossen).

---

## 2. Was bei der Integration passiert

1. **Prüfung auf Duplikate, Neuexporte & Notizbuch-Erweiterungen (`scan`):**
   - Du kannst einzelne PDFs **oder deinen kompletten GoodNotes-Ordner** (mit allen Unterordnern) in `00_Posteingang_GoodNotes/` ablegen.
   - Unveränderte alte PDFs werden per SHA-256 (`DUPLICATE_EXACT`) **und** per visuellem Seiten-Fingerprint (`DUPLICATE_VISUAL`) gegen alle Originale erkannt und übersprungen – selbst wenn GoodNotes neue Export-Zeitstempel gesetzt oder eine Datei umbenannt wurde.
   - Hast du ein **bestehendes GoodNotes-Notizbuch weitergeschrieben** (z. B. `BGWP.pdf` hat jetzt 62 statt 54 Seiten), erkennt das Tool die unveränderten Seiten 1–54 automatisch (`EXTENDED_NOTEBOOK`) und verarbeitet gezielt nur die neuen Seiten 55–62.
   - Ordner oder Dateien mit privaten Hinweisen im Pfad (z. B. `Noten/`, `Zeugnis`) werden als `SKIP_PRIVATE` gar nicht erst geöffnet.
   - Neue Dateien in bekannten Fach-Unterordnern (`AE/`, `BGWP/`, `ITT/`, `Deutsch/`, …) erhalten automatisch einen Fachvorschlag.
2. **Aufbereitung (`prepare`):**
   - Die Original-PDF wird sauber unter `99_Originale/Berufsschule/<Fach>/` abgelegt.
   - Unter `02_Faecher/<Fach>/Quellen/` wird die kanonische Quellnotiz mit `### Seite N`, exakten PDF-Links (`#page=N`), PDF-Einbettungen und extrahiertem Text angelegt bzw. erweitert.
   - Jede neue Seite wird temporär unter `/tmp/ap_lernhelfer_import/` als hochauflösendes Bild gerendert (außerhalb von iCloud Drive und Git).
3. **Seitenweise visuelle Prüfung (durch KI-Agent):**
   - Jede neue Seite wird visuell gesichtet.
   - Handschrift, Skizzen, Tabellen oder Scans ohne Textschicht werden direkt als geprüfte Transkription in der Quellnotiz ergänzt.
   - Bestehende kanonische Themen aus [[03_Themen/00_Kuratierte_Themen|00_Kuratierte_Themen]] werden bevorzugt wiederverwendet; wirklich neue Themen werden sauber benannt und einer der 6 Themenkategorien zugeordnet.
   - Leere Seiten, reine Deckblätter oder personenbezogene Seiten werden sauber ausgeschlossen (`exclusion_reason`) bzw. bei sensiblen Beispieldaten (z. B. IBAN/E-Mail in Übungsbriefen) datenschutzsicher abstrahiert (`sensitive: true`).
4. **Vollständiger Neuaufbau & Validierung (`apply`):**
   - Alle Indizes und Prüfdateien werden automatisch und iCloud-schonend neu erzeugt:
     - `01_Index/PDF_Seitenaudit.json` & `01_Index/PDF_Seitenaudit.md`
     - `03_Themen/Visuell_geprueft/**` & `03_Themen/00_Kuratierte_Themen.md`
     - `01_Index/Themenreferenzen_Visuell_Geprueft.json` & `01_Index/Themen_Kategorien.json`
     - `01_Index/KI_Quellenqualitaet.md` & `01_Index/Quellenmatrix.md`
     - `01_Index/KI_Dateiinventar.json` & `01_Index/KI_Quellenmanifest.md`
     - `01_Index/Copilot_Allowlist.json` & `.obsidian/plugins/copilot/data.json`
     - `manifest.json`
   - Abschließend laufen die Linkprüfung (`validate_nonprivate_links.rb`) und alle Konsistenzprüfungen (`validate_verified_source_layer.rb`).

---

## 3. Der eine manuelle Schritt danach in Obsidian

> [!important] Copilot neu indexieren
> Führe nach jedem abgeschlossenen Import in Obsidian einmal den Befehl **„Copilot: Force reindex vault“** aus (Command Palette `⌘P`), damit Obsidian Copilot die neu freigegebenen Quellnotizen und Themen sofort in seine Embeddings aufnimmt.

---

## 4. Übersicht: Fächer & Themenkategorien

| Kürzel | Fachordner (`02_Faecher/`) | Standard-PDF-Ordner (`99_Originale/`) |
|---|---|---|
| `ae` | `AE_Anwendungsentwicklung` | `99_Originale/Berufsschule/AE` |
| `bgwp` | `BGWP_Betriebswirtschaft` | `99_Originale/Berufsschule/BGWP` |
| `itt` | `ITT_IT_Technik` | `99_Originale/Berufsschule/ITT` |
| `deutsch` | `Deutsch` | `99_Originale/Berufsschule/Deutsch` |
| `englisch` | `Englisch` | `99_Originale/Berufsschule/Englisch` |
| `pug` | `PuG_Politik_und_Gesellschaft` | `99_Originale/Berufsschule/PUG` |
| `religion` | `Religion` | `99_Originale/Berufsschule/Religion` |
| `allgemein` | `Allgemein_Berufsschule` | `99_Originale/Berufsschule` |
| `vertretung` | `Vertretung` | `99_Originale/Berufsschule/Vertretung` |

**Kanonische Themenkategorien unter `03_Themen/Visuell_geprueft/`:**
- `Anwendungsentwicklung`
- `Deutsch_Englisch_Kommunikation`
- `Elektrotechnik`
- `IT_Technik_und_Sicherheit`
- `Religion_Ethik`
- `Wirtschaft_und_Recht`

---

## 5. Kurzreferenz für die Kommandozeile (optional)

```bash
# 1. Posteingang auf neue/erweiterte/doppelte PDFs prüfen
ruby 01_Index/Tools/import_goodnotes.rb scan

# 2a. Neue PDF vorbereiten (mit --move aus Posteingang verschieben)
ruby 01_Index/Tools/import_goodnotes.rb prepare 00_Posteingang_GoodNotes/Datei.pdf --fach ae --move

# 2b. Bestehendes GoodNotes-Notizbuch um neue Seiten erweitern
ruby 01_Index/Tools/import_goodnotes.rb prepare 00_Posteingang_GoodNotes/BGWP.pdf \
  --update-existing 02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP.md --move

# 3. Bestehende Themen anzeigen (zur konsistenten Benennung)
ruby 01_Index/Tools/import_goodnotes.rb topics

# 4. Nach ausgefülltem Import-Audit komplette Pipeline + Validierung starten
ruby 01_Index/Tools/import_goodnotes.rb apply --clean-review
```
