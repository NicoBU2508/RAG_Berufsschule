---
typ: "ki_lernschicht_report"
datum: "2026-06-19"
status: "projektweit-ergaenzt"
lernmodule_geprueft: 129
dateien_geaendert: 131
ki_komprimate_ergaenzt: 128
karteikarten_bloecke_ergaenzt: 128
ocr_hinweise_ergaenzt: 71
vollstaendigkeitscheck: "bestanden"
inhaltscheck: "bestanden"
inhaltscheck_dateien_nachgebessert: 30
inhaltscheck_markdown_dateien: 432
quellentreue_karteikarten: "bestanden"
quellenbasierte_karteikarten: 683
lernmodule_mit_quellenkarten: 104
lernmodule_ohne_quellenkarten: 25
ocr_schwache_karteikarten: 0
---

# KI-Lernschicht Projektweiter Durchlauf 2026-06-19

## Ergebnis

- Lernmodule geprüft: **129**
- Dateien geändert: **131**
- Neue KI-Komprimate: **128**
- Neue Karteikarten-Blöcke: **128**
- Neue OCR-Hinweise mit bereinigtem Lerntext: **71**
- Zentraler Karteikarten-Index aktualisiert: [[05_Karteikarten/00_Karteikarten_Index|Karteikarten Index]]

## Vollständigkeitscheck

- Lernmodule geprüft: **129**
- Lernmodule mit genau einem `KI-Komprimat`: **129**
- Lernmodule mit genau einem `Karteikarten`-Abschnitt: **129**
- Module mit fehlender oder falscher Abschnittsreihenfolge: **0**
- Lernmodule mit quellenbasierten `Frage::`/`Antwort::`-Karten: **104 / 129**
- Lernmodule ohne Karten wegen fehlender/zu schwacher Quelle: **25 / 129**
- Karteikartenfelder außerhalb echter Lernmodule/Templates entschärft: **0 aktive Treffer**
- Lernmodule im zentralen Karteikartenindex verlinkt: **104 Kartenquellen + 25 bewusst ohne Karten**
- OCR-auffällige Seiten ohne Warnhinweis: **0**
- Globaler Linkcheck nach Durchlauf: **22.344 Wiki-/Embed-Links, 0 fehlende Markdown-Ziele, 0 fehlende PDF-Ziele, 0 leere Wikilinks, 0 mehrdeutige Kurzlinks**

Nicht jedes Markdown-Dokument im Vault muss diese Lernschicht tragen: Quellen-, Index-, Prüfungs-, Template- und Archivdateien bleiben bewusst in ihrer jeweiligen Rolle. Der Vollständigkeitscheck bezieht sich auf alle fachlichen Lernmodule unter `02_Faecher/*/10_Lernordner/*/00_*.md`.

## Inhaltscheck

- Markdown-Dateien geprüft: **432**
- Leere Markdown-Dateien: **0**
- Fachliche Lernmodule geprüft: **129**
- Lernmodule mit fehlenden Pflichtabschnitten oder leerem Lerninhalt: **0**
- Quellenbasierte Karteikarten freigegeben: **683**
- Nicht belegbare oder zu schwache Karten entfernt/nicht übernommen: **284**
- Karteikarten mit Antwort außerhalb des verlinkten Lerninhalts: **0**
- Null-Quellen-Module als Verweismodule markiert und ohne Lernkarten gelassen: **5**
- Inhaltscheck-Nachbesserungen: **30 Dateien**

Bei den fünf Modulen ohne eigene Original-PDF-Seite wurde kein Inhalt erfunden. Sie sind jetzt ausdrücklich als Verweis-/Suchmodule markiert und verlinken auf fachlich passende Nachbarmodule mit echten PDF-Belegen.

## Karteikarten-Quellentreue

- Jede aktive `Antwort::` in den Lernmodulen wurde gegen den zugehörigen Lerninhalt/OCR-Auszug der verlinkten PDF-Seite geprüft.
- Karten mit eigenen Zusammenfassungen, Meta-Hinweisen oder zu schwachem OCR-Text wurden entfernt statt geglättet.
- Der zentrale Karteikartenindex verlinkt nur noch Module mit echten Quellenkarten als Kartenquelle; Module ohne belastbare Karten stehen separat.
- Karten aus OCR-Warnseiten werden nicht mehr erzeugt; alle aktiven Karten tragen `OCR:: sicher` und besitzen `Antwort::` = `Beleg::`.

## Was ergänzt wurde

- `## 🧭 KI-Komprimat` als schneller Einstieg für GPT/Gemini/Obsidian-Suche.
- `> [!warning] OCR unsicher` plus `> [!note] Bereinigter Lerntext` bei auffälligen OCR-/Layoutstellen.
- `## 🗂️ Karteikarten` am Ende der Lernmodule mit `Frage::`, `Antwort::`, `Quelle::`, `Prüfung::`, `Fehlerquelle::`.

## Hinweis zur Quellentreue

Die Ergänzungen wurden aus vorhandenen Referenztabellen, Seitentiteln, OCR-Auszügen und PDF-Links abgeleitet. OCR-bereinigte Lerntexte sind als vorsichtige Lesefassung markiert und ersetzen nicht die Original-PDF-Seite. Das lokale Werkzeug `01_Index/Tools/ocr_pdf_pages.swift` liest jetzt zuerst eingebetteten PDF-Text und nutzt Vision-OCR nur als Fallback.

## Geänderte Dateien

- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Algorithmus und Programmablauf/00_Algorithmus und Programmablauf|00_Algorithmus und Programmablauf]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Arrays und Sammlungen/00_Arrays und Sammlungen|00_Arrays und Sammlungen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Dokumentation Installation und Anpassung/00_Dokumentation Installation und Anpassung|00_Dokumentation Installation und Anpassung]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/EVA Prinzip/00_EVA Prinzip|00_EVA Prinzip]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/IPv4 Subnetting und Binaerzahlen/00_IPv4 Subnetting und Binaerzahlen|00_IPv4 Subnetting und Binaerzahlen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Java Grundlagen und IDE/00_Java Grundlagen und IDE|00_Java Grundlagen und IDE]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Klassen Objekte Attribute/00_Klassen Objekte Attribute|00_Klassen Objekte Attribute]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Methoden Parameter Rueckgabewerte/00_Methoden Parameter Rueckgabewerte|00_Methoden Parameter Rueckgabewerte]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Netzplan und Netzwerktechnik/00_Netzplan und Netzwerktechnik|00_Netzplan und Netzwerktechnik]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Operatoren und Bedingungen/00_Operatoren und Bedingungen|00_Operatoren und Bedingungen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Programm und Software/00_Programm und Software|00_Programm und Software]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Programmiersprachen und Uebersetzer/00_Programmiersprachen und Uebersetzer|00_Programmiersprachen und Uebersetzer]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Scanner Random Benutzereingaben/00_Scanner Random Benutzereingaben|00_Scanner Random Benutzereingaben]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Schleifen/00_Schleifen|00_Schleifen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Softwareentwicklung Vorgehensmodelle Scrum V-Modell/00_Softwareentwicklung Vorgehensmodelle Scrum V-Modell|00_Softwareentwicklung Vorgehensmodelle Scrum V-Modell]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Softwarequalitaet Wartbarkeit Usability/00_Softwarequalitaet Wartbarkeit Usability|00_Softwarequalitaet Wartbarkeit Usability]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Syntax und Code-Struktur/00_Syntax und Code-Struktur|00_Syntax und Code-Struktur]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Unternehmenswiki/00_Unternehmenswiki|00_Unternehmenswiki]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Unternehmenswiki Projektaufgaben/00_Unternehmenswiki Projektaufgaben|00_Unternehmenswiki Projektaufgaben]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Variablen und Datentypen/00_Variablen und Datentypen|00_Variablen und Datentypen]]
- [[02_Faecher/AE_Anwendungsentwicklung/10_Lernordner/Werkzeuge Debugging und IDE/00_Werkzeuge Debugging und IDE|00_Werkzeuge Debugging und IDE]]
- [[02_Faecher/Allgemein_Berufsschule/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/Allgemein_Berufsschule/10_Lernordner/Hochverfuegbarkeit und Redundanz/00_Hochverfuegbarkeit und Redundanz|00_Hochverfuegbarkeit und Redundanz]]
- [[02_Faecher/Allgemein_Berufsschule/10_Lernordner/IT Sicherheit Ueberblick/00_IT Sicherheit Ueberblick|00_IT Sicherheit Ueberblick]]
- [[02_Faecher/Allgemein_Berufsschule/10_Lernordner/Ransomware und Malware/00_Ransomware und Malware|00_Ransomware und Malware]]
- [[02_Faecher/Allgemein_Berufsschule/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Angebotsvergleich und Bezugskalkulation/00_Angebotsvergleich und Bezugskalkulation|00_Angebotsvergleich und Bezugskalkulation]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Betrieb und Unternehmen/00_Betrieb und Unternehmen|00_Betrieb und Unternehmen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Betriebswirtschaft BGWP/00_Betriebswirtschaft BGWP|00_Betriebswirtschaft BGWP]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Geschaeftsbrief Anfrage Angebot/00_Geschaeftsbrief Anfrage Angebot|00_Geschaeftsbrief Anfrage Angebot]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Kaufvertrag und Rechtsgeschaefte/00_Kaufvertrag und Rechtsgeschaefte|00_Kaufvertrag und Rechtsgeschaefte]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Marktumfeld und Marktformen/00_Marktumfeld und Marktformen|00_Marktumfeld und Marktformen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Materialwirtschaft und Beschaffung/00_Materialwirtschaft und Beschaffung|00_Materialwirtschaft und Beschaffung]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Organigramm und Liniensysteme/00_Organigramm und Liniensysteme|00_Organigramm und Liniensysteme]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Organisation im Betrieb/00_Organisation im Betrieb|00_Organisation im Betrieb]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Personalwirtschaft/00_Personalwirtschaft|00_Personalwirtschaft]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Produktionsfaktoren/00_Produktionsfaktoren|00_Produktionsfaktoren]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Projektplanung und Netzplanmethode/00_Projektplanung und Netzplanmethode|00_Projektplanung und Netzplanmethode]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Rechtsformen/00_Rechtsformen|00_Rechtsformen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Unternehmen und betriebliche Funktionen/00_Unternehmen und betriebliche Funktionen|00_Unternehmen und betriebliche Funktionen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Unternehmensrecht Handelsregister Vollmachten/00_Unternehmensrecht Handelsregister Vollmachten|00_Unternehmensrecht Handelsregister Vollmachten]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Unternehmensziele/00_Unternehmensziele|00_Unternehmensziele]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Wirtschaftlichkeit und Rechnungswesen/00_Wirtschaftlichkeit und Rechnungswesen|00_Wirtschaftlichkeit und Rechnungswesen]]
- [[02_Faecher/BGWP_Betriebswirtschaft/10_Lernordner/Wirtschaftssektoren/00_Wirtschaftssektoren|00_Wirtschaftssektoren]]
- [[02_Faecher/Deutsch/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/Deutsch/10_Lernordner/Ausbildung und Beruf/00_Ausbildung und Beruf|00_Ausbildung und Beruf]]
- [[02_Faecher/Deutsch/10_Lernordner/Betrieb und Unternehmen/00_Betrieb und Unternehmen|00_Betrieb und Unternehmen]]
- [[02_Faecher/Deutsch/10_Lernordner/Das oder Dass/00_Das oder Dass|00_Das oder Dass]]
- [[02_Faecher/Deutsch/10_Lernordner/Fremdwoerter/00_Fremdwoerter|00_Fremdwoerter]]
- [[02_Faecher/Deutsch/10_Lernordner/Geschaeftsbrief Anfrage Angebot/00_Geschaeftsbrief Anfrage Angebot|00_Geschaeftsbrief Anfrage Angebot]]
- [[02_Faecher/Deutsch/10_Lernordner/Kommasetzung/00_Kommasetzung|00_Kommasetzung]]
- [[02_Faecher/Deutsch/10_Lernordner/Kommunikation Modelle/00_Kommunikation Modelle|00_Kommunikation Modelle]]
- [[02_Faecher/Deutsch/10_Lernordner/Projektmanagement Lastenheft Pflichtenheft/00_Projektmanagement Lastenheft Pflichtenheft|00_Projektmanagement Lastenheft Pflichtenheft]]
- [[02_Faecher/Deutsch/10_Lernordner/Rechtschreibung Gross und Klein/00_Rechtschreibung Gross und Klein|00_Rechtschreibung Gross und Klein]]
- [[02_Faecher/Deutsch/10_Lernordner/Rechtschreibung und Grammatik/00_Rechtschreibung und Grammatik|00_Rechtschreibung und Grammatik]]
- [[02_Faecher/Deutsch/10_Lernordner/Sprachtraining und Grammatik/00_Sprachtraining und Grammatik|00_Sprachtraining und Grammatik]]
- [[02_Faecher/Deutsch/10_Lernordner/Unternehmensleitbild Corporate Identity/00_Unternehmensleitbild Corporate Identity|00_Unternehmensleitbild Corporate Identity]]
- [[02_Faecher/Englisch/10_Lernordner/Applying for a Position/00_Applying for a Position|00_Applying for a Position]]
- [[02_Faecher/Englisch/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/Englisch/10_Lernordner/Business Communication English/00_Business Communication English|00_Business Communication English]]
- [[02_Faecher/Englisch/10_Lernordner/Company Structure and Departments/00_Company Structure and Departments|00_Company Structure and Departments]]
- [[02_Faecher/Englisch/10_Lernordner/Company Websites and Web Design/00_Company Websites and Web Design|00_Company Websites and Web Design]]
- [[02_Faecher/Englisch/10_Lernordner/Englisch IT Jobs/00_Englisch IT Jobs|00_Englisch IT Jobs]]
- [[02_Faecher/Englisch/10_Lernordner/Geschaeftsbrief Anfrage Angebot/00_Geschaeftsbrief Anfrage Angebot|00_Geschaeftsbrief Anfrage Angebot]]
- [[02_Faecher/Englisch/10_Lernordner/IT Jobs and Roles/00_IT Jobs and Roles|00_IT Jobs and Roles]]
- [[02_Faecher/Englisch/10_Lernordner/IT Vocabulary and Hardware/00_IT Vocabulary and Hardware|00_IT Vocabulary and Hardware]]
- [[02_Faecher/Englisch/10_Lernordner/Introducing a Company/00_Introducing a Company|00_Introducing a Company]]
- [[02_Faecher/Englisch/10_Lernordner/Making Phone Calls and Voicemail/00_Making Phone Calls and Voicemail|00_Making Phone Calls and Voicemail]]
- [[02_Faecher/Englisch/10_Lernordner/Ordering Technical Products/00_Ordering Technical Products|00_Ordering Technical Products]]
- [[02_Faecher/Englisch/10_Lernordner/Reading Comprehension and Case Studies/00_Reading Comprehension and Case Studies|00_Reading Comprehension and Case Studies]]
- [[02_Faecher/Englisch/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/Englisch/10_Lernordner/Useful Phrases and Grammar/00_Useful Phrases and Grammar|00_Useful Phrases and Grammar]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Backup und Datensicherung/00_Backup und Datensicherung|00_Backup und Datensicherung]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Begriffe Computerwelt Gitterraetsel/00_Begriffe Computerwelt Gitterraetsel|00_Begriffe Computerwelt Gitterraetsel]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Beschaffung Angebot und Kalkulation/00_Beschaffung Angebot und Kalkulation|00_Beschaffung Angebot und Kalkulation]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Betrieb und Unternehmen/00_Betrieb und Unternehmen|00_Betrieb und Unternehmen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Betriebswirtschaft BGWP/00_Betriebswirtschaft BGWP|00_Betriebswirtschaft BGWP]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Computergrundbegriffe/00_Computergrundbegriffe|00_Computergrundbegriffe]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Datenschutz und Rollen/00_Datenschutz und Rollen|00_Datenschutz und Rollen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Elektrische Ladung/00_Elektrische Ladung|00_Elektrische Ladung]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Elektrische Leistung und Netzteil/00_Elektrische Leistung und Netzteil|00_Elektrische Leistung und Netzteil]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Elektrotechnik Aufgaben und Loesungen/00_Elektrotechnik Aufgaben und Loesungen|00_Elektrotechnik Aufgaben und Loesungen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Elektrotechnik Grundlagen Mathematik/00_Elektrotechnik Grundlagen Mathematik|00_Elektrotechnik Grundlagen Mathematik]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Geschaeftsbrief Anfrage Angebot/00_Geschaeftsbrief Anfrage Angebot|00_Geschaeftsbrief Anfrage Angebot]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Hochverfuegbarkeit und Redundanz/00_Hochverfuegbarkeit und Redundanz|00_Hochverfuegbarkeit und Redundanz]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/IPv4 Subnetting und Binaerzahlen/00_IPv4 Subnetting und Binaerzahlen|00_IPv4 Subnetting und Binaerzahlen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/IT Sicherheit Grundlagen/00_IT Sicherheit Grundlagen|00_IT Sicherheit Grundlagen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Kryptografie Verschluesselung Hash Signatur/00_Kryptografie Verschluesselung Hash Signatur|00_Kryptografie Verschluesselung Hash Signatur]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Malware und Angriffe/00_Malware und Angriffe|00_Malware und Angriffe]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Netzplan und Netzwerktechnik/00_Netzplan und Netzwerktechnik|00_Netzplan und Netzwerktechnik]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Netzteil/00_Netzteil|00_Netzteil]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Recht Kaufvertrag Geschaeftsfaehigkeit/00_Recht Kaufvertrag Geschaeftsfaehigkeit|00_Recht Kaufvertrag Geschaeftsfaehigkeit]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Risikoanalyse/00_Risikoanalyse|00_Risikoanalyse]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Risikoanalyse und Schutzbedarf/00_Risikoanalyse und Schutzbedarf|00_Risikoanalyse und Schutzbedarf]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Sicherheitsmanagement und Massnahmen/00_Sicherheitsmanagement und Massnahmen|00_Sicherheitsmanagement und Massnahmen]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Sicherheitsprozess PDCA/00_Sicherheitsprozess PDCA|00_Sicherheitsprozess PDCA]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Sicherheitsprozess PDCA und ISMS/00_Sicherheitsprozess PDCA und ISMS|00_Sicherheitsprozess PDCA und ISMS]]
- [[02_Faecher/ITT_IT_Technik/10_Lernordner/Spannung Strom Widerstand/00_Spannung Strom Widerstand|00_Spannung Strom Widerstand]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Aufgaben Uebungen und Loesungen/00_Aufgaben Uebungen und Loesungen|00_Aufgaben Uebungen und Loesungen]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Ausbildung und Beruf/00_Ausbildung und Beruf|00_Ausbildung und Beruf]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Ausbildungsvertrag und BBiG/00_Ausbildungsvertrag und BBiG|00_Ausbildungsvertrag und BBiG]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Betrieb und Unternehmen/00_Betrieb und Unternehmen|00_Betrieb und Unternehmen]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Betriebsrat und Betriebsverfassung/00_Betriebsrat und Betriebsverfassung|00_Betriebsrat und Betriebsverfassung]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Bundesurlaubsgesetz/00_Bundesurlaubsgesetz|00_Bundesurlaubsgesetz]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Elterngeld und Elternzeit/00_Elterngeld und Elternzeit|00_Elterngeld und Elternzeit]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Jugendarbeitsschutz/00_Jugendarbeitsschutz|00_Jugendarbeitsschutz]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Kuendigung und Arbeitsrecht/00_Kuendigung und Arbeitsrecht|00_Kuendigung und Arbeitsrecht]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Mutterschutz/00_Mutterschutz|00_Mutterschutz]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Recht und Vertraege/00_Recht und Vertraege|00_Recht und Vertraege]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Schwerbehinderung/00_Schwerbehinderung|00_Schwerbehinderung]]
- [[02_Faecher/PuG_Politik_und_Gesellschaft/10_Lernordner/Tarifvertrag und Koalitionsrecht/00_Tarifvertrag und Koalitionsrecht|00_Tarifvertrag und Koalitionsrecht]]
- [[02_Faecher/Religion/10_Lernordner/Freiheit und Selbstbestimmung/00_Freiheit und Selbstbestimmung|00_Freiheit und Selbstbestimmung]]
- [[02_Faecher/Religion/10_Lernordner/Gewissen und Verantwortung/00_Gewissen und Verantwortung|00_Gewissen und Verantwortung]]
- [[02_Faecher/Religion/10_Lernordner/Karwoche und Kirchenjahr/00_Karwoche und Kirchenjahr|00_Karwoche und Kirchenjahr]]
- [[02_Faecher/Religion/10_Lernordner/Nelson Mandela und Vorbilder/00_Nelson Mandela und Vorbilder|00_Nelson Mandela und Vorbilder]]
- [[02_Faecher/Religion/10_Lernordner/Paulus und christliche Freiheit/00_Paulus und christliche Freiheit|00_Paulus und christliche Freiheit]]
- [[02_Faecher/Religion/10_Lernordner/Recht und Vertraege/00_Recht und Vertraege|00_Recht und Vertraege]]
- [[02_Faecher/Religion/10_Lernordner/Religion Ethik und Menschenbild/00_Religion Ethik und Menschenbild|00_Religion Ethik und Menschenbild]]
- [[02_Faecher/Religion/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[02_Faecher/Religion/10_Lernordner/Symbole und Glaube/00_Symbole und Glaube|00_Symbole und Glaube]]
- [[02_Faecher/Vertretung/10_Lernordner/Einheiten Umrechnen/00_Einheiten Umrechnen|00_Einheiten Umrechnen]]
- [[02_Faecher/Vertretung/10_Lernordner/Elektrotechnik Rechenuebungen/00_Elektrotechnik Rechenuebungen|00_Elektrotechnik Rechenuebungen]]
- [[02_Faecher/Vertretung/10_Lernordner/Restseiten Originalbelege/00_Restseiten Originalbelege|00_Restseiten Originalbelege]]
- [[05_Karteikarten/00_Karteikarten_Index|00_Karteikarten_Index]]
