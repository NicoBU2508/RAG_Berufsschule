---
typ: altklausur_bereich
---
# Altklausuren und Lösungen

> [!altklausur] Automatisierte Altklausur-Pipeline (`altklausur-import`)
> 1. PDFs von Prüfung + offizieller Lösung in [[06_Altklausuren/00_Posteingang/README|06_Altklausuren/00_Posteingang]] ablegen (oder im Chat anhängen).  
> 2. Über den Skill `altklausur-import` (`ruby 01_Index/Tools/import_altklausur.rb`) einlesen, visuell prüfen und nach Einzelaufgaben, Punkten, Operatoren & Erwartungshorizont strukturieren.  
> 3. `import_altklausur.rb apply` erzeugt automatisch `01_Index/Altklausuren_Index.json` (für den Aufgaben-Generator in `vault_lookup.rb tasks`), die Einzelanalysen unter `Aufgabenanalysen/` sowie [[04_Pruefung/Referenzmatrix Altklausuren|Referenzmatrix Altklausuren]] und [[04_Pruefung/Haeufigkeitsanalyse|Häufigkeitsanalyse]].

## Ordnerstruktur

- `00_Posteingang/` – Ablageort für neue Prüfungs- und Lösungs-PDFs vor der Analyse
- `AP1/` – Archivierte Original-Prüfungsbögen Teil 1
- `AP2/` – Archivierte Original-Prüfungsbögen Teil 2 (GA1, GA2, WiSo)
- `Loesungen/` – Zugehörige offizielle Lösungshinweise / Erwartungshorizonte
- `Aufgabenanalysen/` – Generierte Markdown-Analysen je Prüfung & Teilaufgabe
