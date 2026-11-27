---
typ: karteikarten_deck
thema: "Rekursion und Iteration"
kategorie: Anwendungsentwicklung
pruefung: "AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Rekursion und Iteration.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 4
quellseiten_hash: e005a1a7b680
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=46"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=47"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=48"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=49"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/rekursion-und-iteration
---
# 🗂️ Karteikarten: Rekursion und Iteration

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Rekursion und Iteration|Rekursion und Iteration]] (**4 visuell geprüfte Seiten**).

---

<!-- card-id: rekursion-und-iteration-01 | typ: definition | pruefung: AP2 -->
**Was versteht man unter einem rekursiven Algorithmus?**
?
Ein rekursiver Algorithmus ist eine Funktion bzw. ein Unterprogramm, das sich immer wieder selbst aufruft, bis eine definierte Abbruchbedingung erfüllt ist.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 47](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=47>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: rekursion-und-iteration-02 | typ: abgrenzung | pruefung: AP2 -->
**Worin unterscheiden sich Iteration und Rekursion bei der Umsetzung eines Algorithmus?**
?
Ein iterativer Algorithmus löst eine Aufgabe mithilfe von Schleifendurchläufen (z. B. `while`-Schleife).
Ein rekursiver Algorithmus löst die Aufgabe durch wiederholte Selbstaufrufe einer Funktion bis zur Abbruchbedingung.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 46–47](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=46>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: rekursion-und-iteration-03 | typ: anwendung | pruefung: AP2 -->
**Welche Zwischenwerte von `result` und `x` entstehen beim iterativen Aufruf `compFact(5)` (`while (x > 1)`)?**
?
Startend mit `x = 5` durchläuft die Schleife `result = result * x` und `x = x - 1` für `x = 5, 4, 3, 2` (`result`: `5 -> 20 -> 60 -> 120`).
Bei `x = 1` ist `x > 1` gleich `false`, die Schleife bricht ab und der Algorithmus gibt `120` zurück.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 46](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=46>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: rekursion-und-iteration-04 | typ: code_trace | pruefung: AP2 -->
**Welchen Rückgabewert liefert der rekursive Algorithmus `summe(4)` (`wenn x > 0 dann return x + summe(x - 1) sonst return 0`) – inklusive Aufruf- und Rückkehrfolge?**
?
Abstieg: `4 -> 3 -> 2 -> 1 -> 0` (Abbruch bei `x = 0` liefert `0`). Aufstieg/Addition: `0 + 1 + 2 + 3 + 4` → Rückgabewert **`10`**.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 48–49](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=48>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: rekursion-und-iteration-05 | typ: pruefungsfalle | pruefung: AP2 -->
**Warum muss ein rekursiver Algorithmus zwingend eine erreichbare Abbruchbedingung besitzen?**
?
Ohne eine Abbruchbedingung (z. B. Stopp bei `x = 0`), der sich der Parameter mit jedem Aufruf annähert (z. B. `x - 1`), würde sich die Funktion endlos selbst aufrufen.
Ein geordnetes Zurückkehren und Aufsummieren bzw. Berechnen des Rückgabewerts wäre dann nicht möglich.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 47–48](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=47>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]], OCR/Original prüfen*
