---
typ: karteikarten_deck
thema: "Schleifen"
kategorie: Anwendungsentwicklung
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Schleifen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 30
quellseiten_hash: 0f984d44e247
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=17"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=18"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=19"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=20"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=21"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=22"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=23"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=29"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=31"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=32"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=33"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=34"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=35"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=36"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=40"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=41"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/JAVA_Java_Basics#page=3"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=56"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=57"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=58"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=59"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=60"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=61"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=62"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=69"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=70"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block#page=71"
  - "02_Faecher/Deutsch/Quellen/Deutsch_2LJ_Skript#page=17"
  - "02_Faecher/Deutsch/Quellen/Deutsch_2LJ_Skript#page=23"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=10"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/schleifen
---

# 🗂️ Karteikarten: Schleifen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Schleifen|Schleifen]] (**30 visuell geprüfte Seiten**).

---

<!-- card-id: schleifen-01 | typ: definition | pruefung: AP1/AP2 -->
**Aus welchen Bestandteilen setzt sich die Kontrollstruktur „Schleife“ zusammen?**
?
Eine **Schleife** ermöglicht die wiederholte Ausführung von Anweisungen und besteht aus der **Schleifensteuerung** (unterteilt in **Schleifenkopf** und **Schleifenfuß**) sowie dem **Schleifenrumpf**, der die zu wiederholenden Anweisungen enthält.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 17 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: schleifen-02 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich kopfgesteuerte (`while`) und fußgesteuerte (`do-while`) bedingte Schleife?**
?
Die **kopfgesteuerte Schleife (`while`)** prüft die Bedingung **vor** dem Rumpf und wird bei anfänglich falscher Bedingung **0-mal** ausgeführt (**abweisende/vorprüfende** Schleife). Die **fußgesteuerte Schleife (`do-while`)** prüft erst **nach** dem Rumpf, sodass dieser **mindestens 1-mal** durchlaufen wird (**annehmende/nachprüfende** Schleife).
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 20–21 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: schleifen-03 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welche Ausgabe entsteht bei `nummer := 50` in einer `while (nummer < 50)`-Schleife im Vergleich zu `do { Ausgabe(nummer); nummer := nummer * nummer; } while (nummer < 50)`?**
?
Die **`while`-Schleife** prüft `50 < 50` zuerst (`false`) und gibt **nichts** aus. Die **`do-while`-Schleife** gibt zuerst **`50`** aus, berechnet `2500`, prüft danach `2500 < 50` (`false`) und beendet die Schleife.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 20–21 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: schleifen-04 | typ: definition | pruefung: AP1/AP2 -->
**Wann verwendet man eine zählergesteuerte `for`-Schleife und aus welchen drei Teilen besteht ihre Steuerung in Java?**
?
Man nutzt sie, wenn die **Anzahl der Durchläufe (Anfangs- und Endwert) bekannt** ist. Der Kopf `for (initStatement; condition; nextStatement)` umfasst **Initialisierung** der Laufvariable, **Bedingungsausdruck** (Abbruchkriterium) und **Aktualisierungsteil** (meist In-/Dekrement).
*Quelle: AE Anwendungsentwicklung (1. LJ) · `02_Unternehmenswiki-7.Block.pdf` S. 60–61 (von 71) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block|Quellnotiz]]*

---

<!-- card-id: schleifen-05 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Ist die zählergesteuerte `for`-Schleife kopf- oder fußgesteuert — und wie oft läuft sie, wenn der Anfangswert bereits über dem Endwert liegt?**
?
Die `for`-Schleife ist **kopfgesteuert**, da die Bedingung vor jedem Schleifendurchlauf geprüft wird. Ist die Laufvariable bei der Initialisierung bereits größer als der Endwert (bei positiver Schrittweite), werden die Schleifenanweisungen **kein einziges Mal** ausgeführt.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 20 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: schleifen-06 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie durchläuft man in Java ein Array `arrayEins` mit einer `for`-Schleife sicher über alle Elemente?**
?
Man startet bei `int i = 0`, prüft **`i < arrayEins.length`** (echt kleiner, weil die Indizes von `0` bis `length - 1` laufen) und zählt `i++` nach jedem Durchlauf hoch.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `02_Unternehmenswiki-7.Block.pdf` S. 69 (von 71) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block|Quellnotiz]]*

---

<!-- card-id: schleifen-07 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich die Schleifen-Steueranweisungen `break`, `continue` und `pass` in Python?**
?
**`break`** beendet die Schleifenausführung sofort komplett, **`continue`** springt unmittelbar zur nächsten Iteration der Schleife und **`pass`** führt keine Aktion aus (leerer Platzhalter).
*Quelle: ITT IT-Technik (1. LJ) · `Grudausbildumg.pdf` S. 10 (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*
