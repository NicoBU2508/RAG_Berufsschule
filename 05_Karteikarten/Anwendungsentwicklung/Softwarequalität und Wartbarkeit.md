---
typ: karteikarten_deck
thema: "Softwarequalität und Wartbarkeit"
kategorie: Anwendungsentwicklung
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwarequalität und Wartbarkeit.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 8
quellseiten_hash: 82c544b7f866
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=28"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=78"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=79"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=80"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=81"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=88"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift#page=10"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift#page=9"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/softwarequalitaet-und-wartbarkeit
---

# 🗂️ Karteikarten: Softwarequalität und Wartbarkeit

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwarequalität und Wartbarkeit|Softwarequalität und Wartbarkeit]] (**8 visuell geprüfte Seiten**).

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-01 | typ: definition | pruefung: AP1/AP2 -->
**Welche Norm beschreibt Qualitätsanforderungen an Software und wie viele Hauptmerkmale definiert sie?**
?
Die internationale Norm **ISO/IEC 25010** definiert ein Qualitätsmodell mit **acht Hauptmerkmalen**, um Softwarequalität messbar und vergleichbar zu machen: Funktionale Tauglichkeit, Leistungseffizienz, Kompatibilität, Benutzbarkeit, Zuverlässigkeit, Sicherheit, Wartbarkeit und Übertragbarkeit.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 78–81 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-02 | typ: definition | pruefung: AP1/AP2 -->
**Welche fünf Teilmerkmale gehören nach ISO/IEC 25010 zur „Wartbarkeit“ (Maintainability)?**
?
1. **Modularität** (Aufbau aus unabhängigen Komponenten), 2. **Wiederverwendbarkeit**, 3. **Analysierbarkeit** (Leichtigkeit der Fehlersuche), 4. **Modifizierbarkeit** (Änderungsaufwand) und 5. **Testbarkeit** (Effizienz der Prüfung).
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 81 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich die ISO/IEC-25010-Merkmale „Kompatibilität“ und „Übertragbarkeit“?**
?
**Kompatibilität** beschreibt die Zusammenarbeit mit anderen Systemen im Betrieb (Koexistenz und Interoperabilität/Datenaustausch). **Übertragbarkeit** beschreibt, wie leicht Software auf eine andere Hardware- oder Softwareplattform überführt werden kann (Anpassungsfähigkeit, Installierbarkeit, Austauschbarkeit).
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 79, 81 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-04 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich „Verfügbarkeit“, „Fehlertoleranz“ und „Wiederherstellbarkeit“ unter Zuverlässigkeit (ISO/IEC 25010)?**
?
- **Verfügbarkeit:** Zeitanteil, in dem das System betriebsbereit ist.
- **Fehlertoleranz:** Weiterbetrieb trotz Fehlern in Hardware oder Software.
- **Wiederherstellbarkeit:** Fähigkeit, Daten nach einem Absturz wiederherzustellen.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 80 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-05 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie werden die vier Schutzziele der „Sicherheit“ (Security) nach ISO/IEC 25010 voneinander abgegrenzt?**
?
- **Vertraulichkeit:** Zugriff nur für autorisierte Personen.
- **Integrität:** Schutz vor unbefugter Änderung von Daten.
- **Nichtabstreitbarkeit:** Aktionen sind eindeutig einem Nutzer zuordenbar.
- **Authentizität:** Sicherstellung der Identität des Kommunikationspartners.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 80 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwarequalitaet-und-wartbarkeit-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Wie verhalten sich Clean Code und Kommentare im Hinblick auf Wartbarkeit zueinander?**
?
Code sollte durch sprechende Variablen- und Funktionsnamen möglichst selbsterklärend sein, sodass rein erklärende Kommentare überflüssig werden. Dennoch ersetzen sprechende Namen keine **Warnungen, rechtlichen Hinweise** oder Erklärungen komplexer Schritte – gezielte Kommentare verkürzen die Einarbeitungszeit und erleichtern die Fehlersuche.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `Mitschrift_AE_Eix.pdf` S. 9–10 (von 26) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift|Quellnotiz]]*
