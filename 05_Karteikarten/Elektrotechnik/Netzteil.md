---
typ: karteikarten_deck
thema: "Netzteil"
kategorie: Elektrotechnik
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/Elektrotechnik/Netzteil.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 7
quellseiten_hash: baffaf5bf175
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=22"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=23"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=24"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=25"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=50"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=51"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_Zusammenfassung#page=3"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/elektrotechnik/netzteil
---
# 🗂️ Karteikarten: Netzteil

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Elektrotechnik/Netzteil|Netzteil]] (**7 visuell geprüfte Seiten**).

---

<!-- card-id: netzteil-01 | typ: definition | pruefung: AP1 -->
**Welche Hauptaufgabe erfüllt ein PC-Netzteil (PSU – Power Supply Unit)?**
?
Es wandelt die vom Verteilungsnetzbetreiber gelieferte Netzwechselspannung von 230 V (AC) in kleinere Gleichspannungen (DC) zwischen +3,3 V und +12 V für die PC-Komponenten um.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 22 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: netzteil-02 | typ: definition | pruefung: AP1 -->
**Was legt der Formfaktor ATX bei einem PC-Netzteil fest?**
?
Der Formfaktor ATX normiert die Gehäuseabmessungen (Form und Größe) des Netzteils, sodass es sich problemlos in genormte PC-Gehäuse einbauen lässt.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 23 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: netzteil-03 | typ: anwendung | pruefung: AP1 -->
**Welche PC-Komponenten werden über die verschiedenen Gleichspannungsausgänge (+3,3 V, +5 V, +12 V und Standby) eines ATX-Netzteils versorgt?**
?
+3,3 V versorgt Arbeitsspeicher und Teile des Mainboards; +5 V CPU-Bereiche und USB-Anschlüsse; +12 V (oft auf zwei Ausgängen) CPU, Grafikkarte (PCIe/Slot) und Laufwerke; der Standby-Ausgang (+5 V) versorgt Maus, Tastatur, Netzwerkkarte und RAM im Energiesparmodus.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 23–25 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: netzteil-04 | typ: definition | pruefung: AP1 -->
**Wofür steht die Netzteil-Schutzfunktion „SCP“ („Safety feature SCP“) und wie wirkt sie?**
?
SCP steht für *Short Circuit Protection* (Kurzschlussschutz). Sie erkennt einen Kurzschluss an einem Ausgang (z. B. an einem Kabel) und schaltet das Netzteil automatisch ab.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 25 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: netzteil-05 | typ: abgrenzung | pruefung: AP1 -->
**Wie grenzen sich die Netzteil-Schutzfunktionen OPP, OVP und UVP voneinander ab?**
?
**OPP** (*Over Power Protection*) schaltet ab, wenn die Gesamtleistung die maximal zulässige Last übersteigt; **OVP** (*Over Voltage Protection*) bei zu hoher Ausgangs- oder Eingangsspannung; **UVP** (*Under Voltage Protection*) bei zu niedriger Ausgangsspannung zur Vermeidung von Fehlfunktionen.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 25 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: netzteil-06 | typ: pruefungsfalle | pruefung: AP1 -->
**Was passiert bei einem geschützten PC-Netzteil, wenn eine Grafikkarte angeschlossen wird, die mehr Leistung benötigt als das Netzteil bereitstellen kann?**
?
Die Hardware nimmt durch die Überlastung keinen direkten Schaden, da die Überlastschutzschaltung (OPP) das Netzteil im Fehlerfall automatisch abschaltet.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 23, 25 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*
