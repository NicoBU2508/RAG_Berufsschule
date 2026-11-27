---
typ: karteikarten_deck
thema: "Business Process Model and Notation BPMN"
kategorie: Wirtschaft_und_Recht
pruefung: "AP1/AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Business Process Model and Notation BPMN.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 8
quellseiten_hash: 52856295e7dc
quellseiten:
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=23"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=24"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=25"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=26"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=27"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=28"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=29"
  - "02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift#page=30"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/wirtschaft-und-recht/business-process-model-and-notation-bpmn
---
# 🗂️ Karteikarten: Business Process Model and Notation BPMN

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Business Process Model and Notation BPMN|Business Process Model and Notation BPMN]] (**8 visuell geprüfte Seiten**).

---

<!-- card-id: business-process-model-and-notation-bpmn-01 | typ: definition | pruefung: AP1/AP2 -->
**Was ist BPMN (Business Process Model and Notation) und welche zentralen Vorteile bietet diese Notation?**
?
BPMN ist eine standardisierte, **grafische Modellierungssprache** zur Darstellung von Geschäftsprozessen, die als **Brücke zwischen Fachbereichen und IT** (fachlichen Konzepten und ausführbaren Modellen) dient.
- **Einheitliche Sprache & gemeinsames Verständnis:** Klare, konsistente Kommunikation abteilungs- und unternehmensübergreifend für Fach- und IT-Personal.
- **Standardisierung & Praxisnähe:** Breite Unterstützung durch Modellierungstools sowie umfangreiche Schulungs- und Lernressourcen.
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 23, 28](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=23>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]]*
---

<!-- card-id: business-process-model-and-notation-bpmn-02 | typ: definition | pruefung: AP1/AP2 -->
**Welche sechs Grundelemente bilden ein BPMN-Diagramm und wofür stehen sie jeweils?**
?
- **Ereignisse (Events, Kreise):** Markieren Start, Zwischenzustand oder Ende eines Prozesses.
- **Aktivitäten (Activities, abgerundete Rechtecke):** Zeigen Aufgaben oder Teilprozesse (Beschriftung im Format *„Substantiv + Verb“*).
- **Gateways (Rauten/Diamanten):** Spalten Prozessflüsse bedingungsabhängig auf oder führen sie wieder zusammen.
- **Verbindungen (Flows):** Geben die Fließrichtung an (Unterscheidung zwischen Aktivitäten-/Sequenzfluss und Nachrichtenfluss).
- **Pools und Lanes:** Stellen Verantwortungsbereiche (Gruppen, Rollen oder Organisationen) dar.
- **Artefakte:** Ergänzen Zusatzinformationen (Anmerkungen, Gruppen, Datenobjekte).
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 24–25](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=24>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]]*
---

<!-- card-id: business-process-model-and-notation-bpmn-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Woran lassen sich Start-, Zwischen-, End- und Abbruch-Ereignis (Terminate) in BPMN optisch unterscheiden?**
?
- **Startereignis:** Kreis mit **dünner** einfacher Umrandung.
- **Zwischenereignis:** Kreis mit **doppelter** kreisförmiger Umrandung.
- **Endereignis:** Kreis mit **dicker** einfacher Umrandung.
- **Terminate (Abbruch-Ereignis):** Dicker Kreis mit **ausgefülltem schwarzem Innenkreis**.
*(Symbole im Kreis wie Briefumschlag = Nachricht oder Uhr = Zeit/Timer konkretisieren den Auslöser.)*
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 25–26](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=25>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*
---

<!-- card-id: business-process-model-and-notation-bpmn-04 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Welche vier Aktivitätstypen (Tasks) unterscheidet BPMN anhand des Symbols oben links im abgerundeten Rechteck?**
?
- **Service-Task (Zahnräder):** Automatisierte System- bzw. Service-Aktivität.
- **User-Task (Personen-Symbol):** Benutzeraufgabe mit IT-Unterstützung (z. B. Fehler identifizieren).
- **Manual-Task (Hand-Symbol):** Manuelle Tätigkeit **ohne** IT-System (z. B. Workaround vor Ort umsetzen).
- **Script-Task (Skript-Symbol):** Automatisiert ausgeführtes Skript (z. B. Zähler erhöhen).
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 26, 30](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=26>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*
---

<!-- card-id: business-process-model-and-notation-bpmn-05 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Exclusive Gateway (`X`) und Parallel Gateway (`+`) in der Prozesssteuerung?**
?
- **Exclusive Gateway (`X`, XOR):** Exklusives ODER – es wird genau **ein** alternativer Pfad anhand einer Bedingung gewählt bzw. ein aktiver Zweig wieder zusammengeführt (z. B. *„Kreditwürdig? Ja / Nein“*).
- **Parallel Gateway (`+`, UND):** Bei der Aufspaltung starten **alle** ausgehenden Zweige gleichzeitig; bei der Zusammenführung wartet der Prozess, bis **alle** parallelen Zweige abgeschlossen sind.
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 26–28, 30](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=26>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*
---

<!-- card-id: business-process-model-and-notation-bpmn-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welche formalen Modellierungsregeln gelten in BPMN für Pools/Lanes, Aufgabenbeschriftung und Datenobjekte?**
?
- **Pflichtstruktur:** Jedes BPMN-Diagramm muss mindestens **einen Pool mit einem Verantwortungsbereich (Lane)** umfassen sowie mit einem Ereignis beginnen und enden.
- **Beschriftung von Aktivitäten:** Immer im Format **„Substantiv + Verb“** (z. B. *„Antrag prüfen“*, *„Bestellung erfassen“*).
- **Datenobjekte (Pfeil oben links):** Weißer Pfeil = **Data Input** (Eingangsdaten), schwarzer Pfeil = **Data Output** (Ausgangsdaten); Übergaben zwischen Bereichen/Pools als **Nachrichtenfluss** vom reinen **Sequenzfluss** trennen.
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 24–28](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=24>) (von 30) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: business-process-model-and-notation-bpmn-07 | typ: modellierung | pruefung: AP1/AP2 -->
**Fehlercheck im BPMN-Diagramm: Zwei Lanes desselben Pools („Vertrieb“ und „Lager“) sind durch eine gestrichelte Linie mit leerem Kreis am Start und Pfeil am Ende verbunden. Was ist falsch?**
?
Innerhalb **desselben Pools** (über Lane-Grenzen hinweg) wird ein **Sequenzfluss (durchgezogene Linie)** verwendet — der **Nachrichtenfluss (gestrichelt)** ist ausschließlich zwischen *verschiedenen Pools* erlaubt!
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 24–28](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=24>) (von 35) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: business-process-model-and-notation-bpmn-08 | typ: modellierung | pruefung: AP1/AP2 -->
**In BPMN startet nach „Auftrag annehmen“ entweder „Sofortversand“ (wenn Bestand > 0) oder „Nachbestellen“ — niemals beides. Welches Gateway nutzt du?**
?
Ein **Exclusive Gateway (`X`, XOR)** mit expliziten Bedingungen (`[Bestand > 0]` / `[Bestand == 0]`) an den ausgehenden Sequenzflüssen sowie demselben `X`-Gateway zur Zusammenführung.
*Quelle: BGWP Betriebswirtschaft (2. LJ) · [BGWP mitschickt.pdf · S. 26–28](<99_Originale/Berufsschule/BGWP/2_LJ/BGWP mitschickt.pdf#page=26>) (von 35) · [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|Quellnotiz]], OCR/Original prüfen*
