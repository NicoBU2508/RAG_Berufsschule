---
typ: karteikarten_deck
thema: "Softwaretest und Testverfahren"
kategorie: Anwendungsentwicklung
pruefung: "AP1/AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwaretest und Testverfahren.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 6
quellseiten_hash: aeb97b57a26a
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=88"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=89"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=90"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=91"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=92"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=93"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/softwaretest-und-testverfahren
---
# 🗂️ Karteikarten: Softwaretest und Testverfahren

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwaretest und Testverfahren|Softwaretest und Testverfahren]] (**6 visuell geprüfte Seiten**).

---

<!-- card-id: softwaretest-und-testverfahren-01 | typ: definition | pruefung: AP1/AP2 -->
**Warum sollte mit dem Softwaretesten möglichst früh und in jeder Phase des Softwarelebenszyklus begonnen werden?**
?
Je früher ein Fehler erkannt wird, desto einfacher und günstiger ist er zu beheben. Wird ein Fehler erst im betrieblichen Einsatz entdeckt, ist die Behebung meist nur mit sehr hohem Aufwand möglich.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 88](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=88>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-02 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich statische und dynamische Testverfahren grundsätzlich?**
?
Bei **statischen Testverfahren** wird das Programm nicht ausgeführt, sondern Quellcode und Entwicklungsdokumente (z. B. Anforderungen, Struktogramme) werden analytisch geprüft. Bei **dynamischen Testverfahren** wird die Software in einer Testumgebung ausgeführt, um Laufzeitfehler bei wechselnden Eingaben oder Nutzerinteraktionen zu finden.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 88–90](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=88>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-03 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welche Fehler finden statische Testverfahren nicht, und wofür eignen sie sich daher nicht?**
?
Statische Testverfahren finden keine Fehler, die erst während der Programmausführung auftreten (z. B. **Laufzeitfehler**). Sie eignen sich daher **nicht** für Integrations- oder Systemtests.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 89](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=89>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-04 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Black-Box-Test, White-Box-Test und Grenzwert-Analyse bei dynamischen Tests?**
?
Der **Black-Box-Test** prüft das Verhalten ohne Kenntnis von Quellcode und innerer Struktur; der **White-Box-Test** nutzt bekannten Quellcode und Programmstruktur, um alle Kontrollstrukturen auszuführen. Die **Grenzwert-Analyse** konzentriert sich gezielt auf Rand- und Grenzwerte von Wertebereichen, da dort besonders häufig Fehler auftreten.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 90](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=90>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-05 | typ: anwendung | pruefung: AP1/AP2 -->
**In welcher Reihenfolge bauen Modul-/Unittest, Integrationstest, Systemtest und Abnahmetest im Entwicklungsprozess aufeinander auf?**
?
1. **Modul-/Unittest** (Implementierung): prüft einzelne Komponenten isoliert. 2. **Integrationstest** (Integration): prüft Zusammenwirken und Schnittstellen der Module.
3. **Systemtest**: abschließender Test funktionaler und nicht-funktionaler Anforderungen vor Auslieferung. 4. **Abnahmetest** (Einsatz): Prüfung in der Kundenumgebung gegen die vereinbarten Anforderungen.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 90](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=90>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-06 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Alpha-Test, Beta-Test und Release Candidate (RC)?**
?
- **Alpha-Test:** Interner Test nach Fertigstellung in der Hersteller-Testumgebung durch Entwickler, Testteams und ausgewählte Benutzer.
- **Beta-Test:** Vorabtest durch größere Nutzergruppen unter realen Bedingungen vor Markteinführung (z. B. mit Log-Feedback).
- **Release Candidate:** Abschließende Testversion mit voller Funktionalität, in der alle bekannten Fehler behoben sind.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 91](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=91>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: softwaretest-und-testverfahren-07 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum ist das Testen nicht-funktionaler Anforderungen (z. B. Bedienbarkeit, Erlernbarkeit) schwieriger als das Prüfen funktionaler Anforderungen?**
?
Bei funktionalen Anforderungen ist meist eindeutig erkennbar, ob das Ergebnis stimmt. Nicht-funktionale Anforderungen hängen oft vom **subjektiven Empfinden** einzelner Personen ab und werden daher unterschiedlich bewertet.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 88](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=88>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*
