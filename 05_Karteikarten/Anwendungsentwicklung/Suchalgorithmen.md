---
typ: karteikarten_deck
thema: "Suchalgorithmen"
kategorie: Anwendungsentwicklung
pruefung: "AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Suchalgorithmen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 2
quellseiten_hash: 47a80d78dd0c
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=44"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=45"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/suchalgorithmen
---
# 🗂️ Karteikarten: Suchalgorithmen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Suchalgorithmen|Suchalgorithmen]] (**2 visuell geprüfte Seiten**).

---

<!-- card-id: suchalgorithmen-01 | typ: definition | pruefung: AP2 -->
**Wie funktioniert die lineare (sequentielle) Suche und wovon hängt ihr Aufwand ab?**
?
Die lineare Suche geht ein Array mit $n$ Elementen Element für Element durch und vergleicht, bis das gesuchte Element (z. B. ein konkreter Wert oder das Maximum) gefunden ist.
Im besten Fall steht der Treffer an erster, im ungünstigsten Fall an letzter Stelle; der Suchaufwand steigt mit der Anzahl der Elemente.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 44](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=44>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: suchalgorithmen-02 | typ: anwendung | pruefung: AP2 -->
**Wie geht die binäre Suche Schritt für Schritt vor und wann terminiert sie?**
?
Zuerst wird das mittlere Element mit dem gesuchten Wert verglichen: Ist es größer, wird nur in der unteren Hälfte weitergesucht; ist es kleiner, nur in der oberen Hälfte.
Die zu prüfende Elementmenge halbiert sich in jedem Schritt, bis das Element gefunden wurde oder nur noch ein Element übrig bleibt (Treffer oder nicht im Array enthalten).
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 44](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=44>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: suchalgorithmen-03 | typ: abgrenzung | pruefung: AP2 -->
**Unter welcher zwingenden Voraussetzung darf die binäre Suche statt der linearen Suche eingesetzt werden?**
?
Die binäre Suche setzt zwingend ein bereits geordnetes (nach Größe der Elemente sortiertes) Array voraus und ist dann deutlich effizienter als die lineare Suche.
Bei unsortierten Arrays kann sie nicht angewendet werden; dort nutzt man die lineare Suche.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 44](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=44>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: suchalgorithmen-04 | typ: pruefungsfalle | pruefung: AP2 -->
**Warum liefert die Maximumsuche im nullindizierten Array `[10, 11, 12, 15, 13, 14]` für das vierte Element die Position `3`?**
?
Bei nullindizierten Feldern startet der Index bei `0` (`feld[0] = 10`, `feld[1] = 11`, `feld[2] = 12`, `feld[3] = 15`).
Der ausgegebene Index `max = 3` entspricht daher dem vierten Feldelement – eine typische Stolperstelle beim Schreibtischtest.
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 45](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=45>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*
