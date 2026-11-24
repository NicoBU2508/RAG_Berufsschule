---
typ: karteikarten_deck
thema: "Programmablaufdarstellungen"
kategorie: Anwendungsentwicklung
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Programmablaufdarstellungen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 20
quellseiten_hash: 6dca37d78623
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=10"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=11"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=12"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=13"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=14"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=15"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=16"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=29"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=4"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=42"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=43"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=5"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=6"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=7"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=8"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=9"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=49"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=58"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=59"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=61"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/programmablaufdarstellungen
---

# 🗂️ Karteikarten: Programmablaufdarstellungen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Programmablaufdarstellungen|Programmablaufdarstellungen]] (**20 visuell geprüfte Seiten**).

---

<!-- card-id: programmablaufdarstellungen-01 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Struktogramm (Nassi-Shneiderman-Diagramm) und Programmablaufplan (PAP) in ihrer Darstellung?**
?
Das Struktogramm stellt den Programmablauf als geschlossenen Block aus ineinander geschachtelten Kontrollstrukturen (Sequenz, Auswahl, Schleife) dar.
Der PAP verwendet dagegen durch Ablaufpfeile verbundene Einzelsymbole nach DIN-Norm 66001 (in Prüfungen werden Ein- und Ausgaben häufig als Parallelogramme dargestellt, was weit verbreitet ist, aber nicht der Norm entspricht).
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 7–8, 42 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: programmablaufdarstellungen-02 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich einseitig bedingte und zweiseitig bedingte Auswahl (Verzweigung) im Struktogramm?**
?
Bei der einseitig bedingten Auswahl (bedingte Anweisung) stehen nur im `Ja`-Zweig Anweisungen, während das Feld unter `Nein` leer bleibt.
Bei der zweiseitig bedingten Auswahl (Alternative) enthält sowohl der `Ja`- als auch der `Nein`-Zweig mindestens eine Anweisung.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 7–8 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: programmablaufdarstellungen-03 | typ: definition | pruefung: AP1/AP2 -->
**Was kennzeichnet Pseudocode im Vergleich zu Struktogramm (STG) und Programmablaufplan (PAP)?**
?
Pseudocode ist eine nicht genormte, halbformale textuelle Ablaufbeschreibung, meist angelehnt an höhere Programmiersprachen (z. B. `if ... then ... else ... end if`), und enthält im Gegensatz zu STG und PAP auch Variablen- und Konstantendeklarationen.
Wertezuweisungen erfolgen in STG, PAP und Pseudocode mit `:=`, Anweisungen werden jedoch nur im Pseudocode mit `;` abgeschlossen.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 10 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: programmablaufdarstellungen-04 | typ: anwendung | pruefung: AP1/AP2 -->
**Welche Rolle hat der Selektor bei einer mehrfachen Verzweigung (Fallauswahl) und wie ordnet man die Auswahlfälle an?**
?
Der Selektor ist die ausgewertete Variable (i. d. R. abzählbare Datentypen wie Integer; in Java umgesetzt über `switch`, `case`, `break`, `default`).
Die Fälle werden nach Häufigkeit (häufigster Fall zuerst für schnellere Abarbeitung) bzw. numerisch/alphabetisch sortiert; alle nicht explizit genannten Werte landen im `sonst`/`otherwise`/`default`-Zweig.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 13 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: programmablaufdarstellungen-05 | typ: definition | pruefung: AP1/AP2 -->
**Welchen Zweck hat ein Datenflussplan (DFP) und wodurch unterscheidet er sich vom PAP?**
?
Der Datenflussplan (data flow chart) beschreibt grafisch mit Symbolen nach DIN 66001 den Verlauf der Daten (Eingabe-, Verarbeitungs- und Ausgabevorgänge sowie Speichermedien) in einem System.
Er zeigt, welche Programmteile von den Daten durchlaufen werden und wie die Bearbeitung erfolgt, statt den detaillierten Kontrollfluss einzelner Anweisungen abzubilden.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 42 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: programmablaufdarstellungen-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Wie verhalten sich `while`- und `for`-Schleife als kopfgesteuerte Schleifen vor dem ersten Durchlauf und am Schleifenende?**
?
Bei beiden wird der boolesche Bedingungsausdruck im Schleifenkopf *vor* dem ersten Durchlauf geprüft: Liefert die Bedingung von Anfang an `false`, wird der Schleifenkörper nie ausgeführt.
Bei der `for`-Schleife (`for (initStatement; condition; nextStatement)`) wird nach jedem Rumpfdurchlauf zuerst das `nextStatement` (z. B. `i++`) ausgeführt, bevor `condition` erneut geprüft wird.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `02_Unternehmenswiki-7.Block.pdf` S. 58, 61 (von 71) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block|Quellnotiz]]*
