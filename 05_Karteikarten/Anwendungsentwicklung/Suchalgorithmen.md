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

<!-- card-id: suchalgorithmen-04 | typ: code_trace | pruefung: AP2 -->
**Welchen Index liefert eine Maximumsuche im nullindizierten Array `[10, 11, 12, 15, 13, 14]` – und warum ist das eine typische Stolperstelle?**
?
Sie liefert **`max = 3`** (nicht `4`!), weil nullindizierte Felder bei `0` starten (`feld[0]=10`, `feld[1]=11`, `feld[2]=12`, `feld[3]=15` = viertes Element).
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 45](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=45>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: suchalgorithmen-05 | typ: code_trace | pruefung: AP2 -->
**Binäre Suche im sortierten Array `[3, 7, 12, 18, 25, 31, 40]` (Indizes `0..6`) nach Zielwert `25`: Welche Indizes werden als Mitte (`(links + rechts) / 2` abgerundet) geprüft?**
?
1. `links=0, rechts=6` → `mitte=3` (`18 < 25` → rechts weitersuchen)
2. `links=4, rechts=6` → `mitte=5` (`31 > 25` → links weitersuchen)
3. `links=4, rechts=4` → `mitte=4` (`25 == 25` → Treffer an **Index 4** nach 3 Vergleichen!).
*Quelle: AE Anwendungsentwicklung (1. LJ) · [01_Algorithmus_Programm_Software_EVA.pdf · S. 44](<99_Originale/Berufsschule/AE/1_LJ/01_Algorithmus_Programm_Software_EVA.pdf#page=44>) (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*
