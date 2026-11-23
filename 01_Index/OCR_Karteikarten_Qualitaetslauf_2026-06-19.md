---
typ: "qualitaetsbericht"
datum: "2026-06-19"
status: "karteikarten_und_ocr_bereinigt"
karteikarten_gesamt: 683
lernmodule_mit_karten: 104
lernmodule_ohne_karten: 25
ocr_schwache_karteikarten: 0
---

# OCR- und Karteikarten-Qualitätslauf 2026-06-19

## Ergebnis

- Aktive quellenbasierte Karteikarten: **683**
- Lernmodule mit Karten: **104 / 129**
- Lernmodule ohne Karten wegen fehlender, zu schwacher oder nur aufgabenartiger Quelle: **25 / 129**
- Karten aus OCR-Warnseiten: **0**
- Karten mit `Antwort::` außerhalb des Modul-Quelltexts: **0**
- Fehlende Markdown-/PDF-Ziele im Obsidian-Linkcheck: **0**

## Was geändert wurde

- Karten aus Aufgabenstellungen, Stationsseiten, Blattköpfen, Adressen, Footer-/Copyright-Resten und OCR-Fragmenten wurden entfernt.
- Jede aktive Karte nutzt jetzt `Antwort::` und denselben Wortlaut als `Beleg::`.
- Jede aktive Karte hat `OCR:: sicher`; OCR-Warnseiten bleiben im Lernmodul als Quelle sichtbar, erzeugen aber keine Lernkarten.
- Das Werkzeug `01_Index/Tools/ocr_pdf_pages.swift` liest zuerst eingebetteten PDF-Text und nutzt Vision-OCR nur als Fallback.

## Arbeitsregel

Karteikarten dürfen nur ergänzt werden, wenn die Antwort im jeweiligen Modultext oder in der verlinkten Original-PDF-Seite eindeutig belegbar ist. Wenn der OCR-Text unsicher ist, bleibt die Seite Referenzmaterial, aber keine Kartenquelle.
