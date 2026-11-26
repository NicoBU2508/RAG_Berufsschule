---
name: altklausur-import
description: >-
  Integriert Original-IHK-Abschlussprüfungen (AP1, AP2 GA1/GA2, WiSo) samt offiziellen
  Lösungshinweisen in 06_Altklausuren/ und 01_Index/Altklausuren_Index.json. Immer
  verwenden, wenn der Nutzer Altklausuren, Original-IHK-Prüfungen oder Prüfungs-Lösungen
  hochlädt, in 06_Altklausuren/00_Posteingang/ ablegt oder einbinden lassen möchte.
---

# Original-IHK-Altklausuren & Lösungen integrieren (`altklausur-import`)

Dieser Skill zerlegt hochgeladene **Original-IHK-Prüfungen + offizielle Lösungshinweise** visuell geprüft in strukturierte Einzelaufgaben (Punkte, IHK-Operator, Aufgabentyp, Erwartungshorizont, Prüfungsfallen, kanonische Themen & Skript-Belege), damit `ap-lerncoach` daraus passgenaue Hybrid- und Original-Trainingsaufgaben bauen kann.

## Sicherheits- & Qualitätsregeln (immer einhalten)

1. **Datenschutz:** Niemals persönliche Prüfungsbescheide, Einladungen mit Privatadresse/Prüflingsnummer oder `98_Archiv_nicht_lernen/` öffnen/importieren (`SKIP_PRIVATE`).
2. **Echte visuelle Seitenprüfung:** `visual_checked: true` darf erst gesetzt werden, nachdem die gerenderten Seitenbilder von Klausur **und** Lösung (`/tmp/ap_lernhelfer_altklausuren/review/<exam_id>/...`) mit `read_file` geprüft wurden (besonders wichtig bei Tabellen, Netzplänen, UML/BPMN, Code-Snippets und Punkteverteilungen!).
3. **Kanonisches Themen-Mapping:** Jede Teilaufgabe darf ausschließlich exakte Themennamen aus `ruby 01_Index/Tools/import_altklausur.rb topics` in `canonical_topics` verwenden. Keine Kommas in Dateinamen!
4. **Kanonische Fakten vs. Prüfungsmuster:** Fasse Handlungssituation, Aufgabenkern und offiziellen IHK-Erwartungshorizont präzise und strukturiert zusammen (inkl. Teilpunkten je Kriterium), damit der Lerncoach Antworten exakt nach IHK-Maßstab bewerten und typgleiche Variationsaufgaben konstruieren kann.

---

## Verbindlicher Ablauf (5 Schritte)

### Schritt 1: Posteingang scannen (`scan`)

Prüfe den Posteingang `06_Altklausuren/00_Posteingang/` (oder den vom Nutzer genannten Pfad):

```bash
ruby 01_Index/Tools/import_altklausur.rb scan
```

- `suggested_pairs` zeigt automatisch erkannte Paare aus **Klausur-PDF + Lösungs-PDF** samt erkanntem Prüfungstyp (`AP1`, `AP2_GA1`, `AP2_GA2`, `AP2_WiSo`), Jahr und Termin (`Fruehjahr`, `Sommer`, `Herbst`, `Winter`).
- Ist Prüfungstyp, Jahr oder Termin aus dem Dateinamen nicht eindeutig erkennbar, kurz die erste Seite prüfen oder den Nutzer fragen.

### Schritt 2: PDFs ablegen & Seiten rendern (`prepare`)

```bash
ruby 01_Index/Tools/import_altklausur.rb prepare "<klausur_pdf>" \
  --loesung "<loesung_pdf>" \
  --pruefung AP1 \
  --jahr 2025 \
  --termin Fruehjahr \
  --move
```

*(Hinweis: `--move` nur verwenden, wenn die PDFs aus `06_Altklausuren/00_Posteingang/` stammen. Wird eine Lösung erst später nachgereicht, denselben `prepare`-Befehl mit `--loesung` erneut ausführen – bestehende `tasks` bleiben erhalten!)*

### Schritt 3: Kanonische Themen & passende Skript-Seiten abrufen

```bash
ruby 01_Index/Tools/import_altklausur.rb topics
```

Nutze bei Bedarf `ruby .agents/skills/ap-lerncoach/scripts/vault_lookup.rb find "<begriff>"`, um zu jeder Prüfungsaufgabe auch die passende Quellnotiz + Seiten im Berufsschul-Skript (`quell_belege`) zu verknüpfen.

### Schritt 4: Klausur- & Lösungsseiten visuell prüfen und JSON befüllen

1. Lies `klausur_extract.json` / `loesung_extract.json` und prüfe die gerenderten PNGs unter `/tmp/ap_lernhelfer_altklausuren/review/<exam_id>/klausur/` sowie `.../loesung/` batchweise mit `read_file`.
2. Vervollständige `01_Index/Auditdaten/Altklausuren/<exam_id>.json`:
   - Setze `"visual_checked": true` und `"gesamt_punkte"` (i. d. R. `100`).
   - Lege für jede Teilaufgabe (`1a`, `1b`, `2a` …) einen Eintrag in `"tasks"` an:
     - `"aufgabe"`: z. B. `"1a"` oder `"HS3_b"`
     - `"punkte"`: exakte Punktzahl laut Prüfung (z. B. `8`)
     - `"operator"`: exakter IHK-Operator (z. B. `"Berechnen"`, `"Erläutern"`, `"Ermitteln"`, `"Entwickeln"`, `"Begründen"`)
     - `"aufgabentyp"`: eines von `code_trace`, `implementierung`, `berechnung`, `freitext`, `diagramm`, `sql`, `zuordnung`, `multiple_choice`
     - `"klausur_seiten"` / `"loesung_seiten"`: Array der PDF-Seitennummern (z. B. `[4, 5]`)
     - `"handlungsfeld_kontext"`: 1–2 Sätze zum Szenario
     - `"fragestellung_kurz"`: präzise Aufgabenanforderung (inkl. gegebener Strukturwerte/Signatur, sodass man den Aufgabentyp sofort versteht)
     - `"canonical_topics"`: 1–3 exakte Themen aus `import_altklausur.rb topics`
     - `"quell_belege"`: passende Skript-Belege, z. B. `[{"source_note": "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift.md", "pages": "16-20"}]`
     - `"erwartungshorizont_punkte"`: konkrete Bewertungskriterien aus den offiziellen Lösungshinweisen inkl. Teilpunkten (z. B. `["Netz-ID korrekt berechnet (2 P.)", "Rechenweg mit 2^n - 2 dokumentiert (2 P.)"]`)
     - `"typische_fallen"`: klassische Stolpersteine dieser Aufgabe (z. B. `["Byte statt Bit verwendet", "Off-by-One bei Schleifengrenze"]`)

### Schritt 5: Index, Aufgabenanalysen & Prüfungsmatrizen bauen (`apply`)

```bash
ruby 01_Index/Tools/import_altklausur.rb apply --clean-review
```

Dieser Befehl validiert alle Angaben, aktualisiert `01_Index/Altklausuren_Index.json` (ab sofort live in `vault_lookup.rb tasks` & `exams` verfügbar!), schreibt `06_Altklausuren/Aufgabenanalysen/<exam_id>.md`, aktualisiert `04_Pruefung/Referenzmatrix Altklausuren.md` sowie `04_Pruefung/Haeufigkeitsanalyse.md` und führt alle Vault-Validatoren aus.
