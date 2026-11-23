---
id: vault.audit.themen-referenzen-gpt.2026-07-13
typ: gesamtaudit
status: abgeschlossen
stand: 2026-07-13
reviewed_on: 2026-07-13
rag_include: false
ki_prioritaet: navigation
tags:
  - audit
  - qualitaetssicherung
  - themen
  - referenzen
  - rag
---

# Gesamtaudit: Themen, Referenzen und GPT-Quellenstruktur

## Urteil

Der Vault besitzt jetzt eine belastbare, schlanke GPT-Quellenschicht. Kanonisch sind ausschließlich die visuell geprüften Themen, die dort verlinkten bereinigten Quellnotiz-Seiten und das jeweilige Original-PDF zur lokalen Kontrolle. Frühere automatisch aggregierte Lernordner, alte Themen, Prüfungsmaterialien und Gesamtindizes bleiben als Lern- oder Navigationshilfen erhalten, werden aber nicht mehr als fachliche KI-Belege indexiert.

## Vollständig geprüfter Umfang

- **36 nicht-private PDFs / 902 Seiten** vollständig berücksichtigt.
- **33 aktive PDFs / 805 Seiten** seitenweise visuell geprüft; jede Seite genau einmal.
- **3 inaktive PDFs / 97 Seiten** vollständig gerendert und als pixelidentische Dubletten aktiver PDFs nachgewiesen.
- **33/33 aktive Quellnotizen / 805 Seitenabschnitte** strukturell kontrolliert.
- Der private Notenbereich und seine PDF wurden nicht geöffnet, gerendert, geOCRt oder inhaltlich gelesen.

Die Detailbelege stehen in [[01_Index/PDF_Seitenaudit|PDF-Seitenaudit]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und der maschinenlesbaren Datei [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>).

## Themenaudit und Korrekturen

- Aus der Sichtprüfung wurden **101 sinnvolle kanonische Themen** erzeugt.
- **713 Seiten** dienen als direkte Themenevidenz.
- **3 Fragmentseiten** sind ausdrücklich nur unterstützend und dürfen keine Aussage allein belegen.
- **89 aktive Seiten** wurden ausgeschlossen: leere, reine Index-, private, doppelte, fachfremde, zu schwache oder visuell nicht belastbare Seiten.
- Fünf zunächst zu pauschal als Index eingeordnete Inhaltsseiten wurden wiederhergestellt: Deutsch S. 15–16 und Englisch S. 35–37.
- Wittmann S. 17–23 belegen ausschließlich die Schutzbedarfsfeststellung; Risikoanalyse ist dort auf S. 48–57 begrenzt.
- Die 34 Seiten des fehlerhaften Fachbegriffe-Exports bleiben bis zu einem reparierten sichtbaren Export vollständig ausgeschlossen.
- Bei `Stol_Wiki.md` wird nur die längere Ausgabe verwendet; der persönliche/blanke Vorspann und die überlappende kürzere Ausgabe sind aus dem indexierbaren Quelltext entfernt.
- Die exakte Aufgabe-1-Seitendublette ist als ganze Quellnotiz technisch ausgeschlossen.
- Die getrennten OCR-Anhänge wurden ihren kanonischen Seiten zugeordnet; redundante globale Anhänge in AE, BGWP und dem IT-Sicherheits-Netzplan wurden entfernt.

## Referenzaudit und Korrekturen

Vor der Korrektur enthielten die 33 Quellen-Referenztabellen **296 technisch auflösbare, aber semantisch überholte Links** ausschließlich auf generierte `10_Lernordner`. Diese Tabellen wurden vollständig ersetzt:

- jede Zeile verweist jetzt ausschließlich auf `03_Themen/Visuell_geprueft/`;
- Seitenbereiche stammen direkt aus dem visuellen Audit, nicht aus Dateinamen, Stichwortsuche oder alten Links;
- Ausschlussseiten erscheinen in keiner Themenzeile;
- OCR-/Zitatgrenzen und nur unterstützende Fragmente sind pro Referenz sichtbar;
- `build_quellenmatrix.rb` bricht künftig bei jedem nicht-kanonischen Themenpräfix ab.

## Eignung als GPT-/RAG-Quelle

Die kompakte Retrieval-Reihenfolge lautet:

1. visuell geprüfte Themenseite zur Navigation;
2. aktive, nicht ausgeschlossene Quellnotiz mit genauer Seite als fachlicher Textbeleg;
3. Original-PDF zur visuellen Kontrolle.

Themenseiten enthalten selbst keine neuen Lernbehauptungen. Generierte Lernmodule, alte Themen, Prüfungs-, Karten- und Archivschichten sind im Manifest und in Copilot ausgeschlossen. Das maschinenlesbare [[01_Index/KI_Quellenmanifest|KI-Quellenmanifest]] klassifiziert jede Projektdatei nach dieser Rolle.

## Sicherheit und Datenschutz

- Personenbilder und andere ausgeschlossene Seitenblöcke werden in aktiven Quellnotizen weder eingebettet noch textlich indexiert.
- Beispielseiten mit Kontakt-, Bank-, Register- oder ähnlichen Identifikationsdaten wurden durch fachliche, datenschutzsichere Inhaltszusammenfassungen ersetzt.
- Eine religionsbezogene Seite mit problematischen unkontextualisierten Formulierungen wird ebenfalls nur abstrahiert eingeordnet.
- Copilot verwendet eine fail-closed Dateiallowlist mit exakt **134 geprüften Markdown-Dateien**: zwei Einstiege, Themenindex, 101 Themenseiten und 30 aktive Quellnotizen. Ganze Ordner sind nicht freigegeben.
- Copilot übergibt keine Markdown-Bilder, fügt die aktive Notiz nicht automatisch hinzu, verwendet keine gespeicherten Erinnerungen oder jüngsten Gespräche und hat den autonomen Agenten deaktiviert.
- Der Systemhinweis behandelt alle Vault-Inhalte als nicht vertrauenswürdige Referenzdaten und blockiert eingebettete Prompts, QR-/URL-Aktionen und Datenfreigaben.
- Sprachmodell und Embeddings sind weiterhin über OpenRouter konfiguriert; zugelassene Indexinhalte können damit den lokalen Rechner verlassen.

## Verbleibende Qualitätsgrenzen

- `partial`, `ocr_error`, `missing` und `ocr_verified` bleiben Warnstufen für den Wortlaut. Das Thema ist visuell bestätigt, wörtliche Zitate benötigen aber die Originalkontrolle.
- Externe URLs und QR-Ziele wurden nicht online auf Erreichbarkeit, Aktualität oder Sicherheit geprüft und werden nicht automatisch geöffnet.
- Prüfungs-, Altklausur- und generierte Lernschichten wurden nicht auf dasselbe Evidenzniveau gehoben; sie bleiben bewusst außerhalb des kompakten Retrievals.

> [!danger] Ein erforderlicher manueller Schritt
> In Obsidian einmal **„Copilot: Force reindex vault“** ausführen. Eine Allowlist-Änderung entfernt bereits vorhandene alte Embeddings nicht zuverlässig von selbst.

## Reproduzierbare Werkzeuge

- `ruby 01_Index/Tools/build_verified_topics.rb`
- `ruby 01_Index/Tools/merge_verified_ocr_appendices.rb` bei einem neuen Ausgangsstand mit getrennten Anhängen
- `ruby 01_Index/Tools/build_copilot_allowlist.rb`
- `ruby 01_Index/Tools/build_quellenmatrix.rb`
- `ruby 01_Index/Tools/build_ki_manifest.rb`
- `ruby 01_Index/Tools/validate_nonprivate_links.rb`
- `ruby 01_Index/Tools/validate_verified_source_layer.rb`
