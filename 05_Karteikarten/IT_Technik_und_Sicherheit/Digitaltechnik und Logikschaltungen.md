---
typ: karteikarten_deck
thema: "Digitaltechnik und Logikschaltungen"
kategorie: IT_Technik_und_Sicherheit
pruefung: "BS"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Digitaltechnik und Logikschaltungen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 9
quellseiten_hash: 3d12c3b5cf48
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=1"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=14"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=3"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=5"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=6"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=7"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=8"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=9"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/digitaltechnik-und-logikschaltungen
---
# 🗂️ Karteikarten: Digitaltechnik und Logikschaltungen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Digitaltechnik und Logikschaltungen|Digitaltechnik und Logikschaltungen]] (**9 visuell geprüfte Seiten**).

---

<!-- card-id: digitaltechnik-und-logikschaltungen-01 | typ: definition | pruefung: BS -->
**Wie bestimmt man die Zeilenanzahl einer Wahrheitstabelle bei n digitalen Eingängen und welche drei Grundverknüpfungen gibt es in der Booleschen Algebra?**
?
Bei n Eingängen (mit den Signalwerten 0 und 1) besitzt die Wahrheitstabelle 2^n Zeilen. Die drei Grundverknüpfungen sind Konjunktion (UND / AND: Q = A ∧ B), Disjunktion (ODER / OR: Q = A ∨ B) und Negation (NICHT / NOT: Q = ¬A).
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 3](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=3>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]]*

---

<!-- card-id: digitaltechnik-und-logikschaltungen-02 | typ: abgrenzung | pruefung: BS -->
**Welchen elektrischen Schaltungen entsprechen ODER-, UND-, NICHT- und XOR-Verknüpfung?**
?
ODER entspricht einer Parallelschaltung der Schalter E1 und E2, UND einer Reihenschaltung (seriell). NICHT entspricht einem betätigten Öffner und XOR einer Wechselschaltung zweier Schalter vor einer Lampe.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 1](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=1>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: digitaltechnik-und-logikschaltungen-03 | typ: abgrenzung | pruefung: BS -->
**Wie unterscheiden sich NAND- und NOR-Gatter in ihrer Funktionsgleichung und Wahrheitstabelle?**
?
Ein NAND-Gatter (Q = ¬(A ∧ B)) liefert nur bei (1,1) den Ausgang 0 und bei allen anderen Kombinationen 1. Ein NOR-Gatter (Q = ¬(A ∨ B)) liefert dagegen nur bei (0,0) den Ausgang 1 und sonst immer 0.
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 6](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=6>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: digitaltechnik-und-logikschaltungen-04 | typ: pruefungsfalle | pruefung: BS -->
**Worin liegt der Unterschied zwischen XOR (=1) und XNOR (=), insbesondere bei gleichen Eingängen (0,0) und (1,1)?**
?
XOR (Exklusiv-ODER, Q = (¬A ∧ B) ∨ (A ∧ ¬B)) gibt nur bei ungleichen Eingängen 1 aus — bei (0,0) und (1,1) also 0. XNOR (Äquivalenz, Q = (A ∧ B) ∨ (¬A ∧ ¬B)) verhält sich genau umgekehrt und liefert bei (0,0) und (1,1) den Wert 1.
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 9](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=9>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: digitaltechnik-und-logikschaltungen-05 | typ: anwendung | pruefung: BS -->
**Welche Ausgangswerte liefert die Schaltung Q = (A ∧ B) ∨ (¬A ∧ ¬B) für alle vier Eingangskombinationen?**
?
Bei (0,0) ergibt der zweite Zweig X = ¬A ∧ ¬B = 1 (Q = 1), bei (0,1) und (1,0) sind beide UND-Zweige 0 (Q = 0), und bei (1,1) ergibt der erste Zweig Z = A ∧ B = 1 (Q = 1). Die Schaltung entspricht damit einer Äquivalenz (XNOR).
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 5](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=5>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: digitaltechnik-und-logikschaltungen-06 | typ: anwendung | pruefung: BS -->
**Wie wird eine Steuerungsaufgabe (z. B. Ampelsteuerung mit Siemens LOGO!) nach dem EVA-Prinzip aufgebaut?**
?
Eingänge (z. B. Schalter I1, Taster I4 an +24 V) werden im Funktionsplan (FBD) über Zeitglieder und Flip-Flops logisch verarbeitet und steuern die Ausgänge (Q1–Q4 gegen 0 V) sowie Netzwerkvariablen (Byte.Bit wie V0.1).
*Quelle: ITT IT-Technik (2. LJ) · [20261005_145426.pdf · S. 14](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Liebscher/20261005_145426.pdf#page=14>) (von 18) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]], OCR/Original prüfen*
