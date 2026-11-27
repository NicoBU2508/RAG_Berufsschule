---
typ: karteikarten_deck
thema: "Hexadezimalsystem"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hexadezimalsystem.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 3
quellseiten_hash: 68ac69a2ae02
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=27"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=3"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=4"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/hexadezimalsystem
---
# 🗂️ Karteikarten: Hexadezimalsystem

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hexadezimalsystem|Hexadezimalsystem]] (**3 visuell geprüfte Seiten**).

---

<!-- card-id: hexadezimalsystem-01 | typ: definition | pruefung: AP1 -->
**Welche Ziffern und Stellenwertigkeiten besitzt das Hexadezimalsystem?**
?
Das Hexadezimalsystem umfasst **16 Ziffern**: `0`–`9` sowie `A` (10), `B` (11), `C` (12), `D` (13), `E` (14) und `F` (15). Die Stellenwertigkeiten sind Potenzen zur Basis 16: `16^0 = 1`, `16^1 = 16`, `16^2 = 256`, `16^3 = 4096`.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=3>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hexadezimalsystem-02 | typ: anwendung | pruefung: AP1 -->
**Wie rechnet man eine Dezimalzahl wie `7022` systematisch in das Hexadezimalsystem um?**
?
Man prüft absteigend die 16er-Potenzen und rechnet mit dem Rest weiter: `7022 - 4096 = 2926` (`1 · 16^3`), `2926 : 256 = 11` (Rest `110` → `B · 16^2`), `110 : 16 = 6` (Rest `14` → `6 · 16^1` und `E · 16^0`) = **`1B6E`**.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=3>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hexadezimalsystem-03 | typ: anwendung | pruefung: AP1 -->
**Wie rechnet man eine Binärzahl direkt in das Hexadezimalsystem um (und umgekehrt)?**
?
Man teilt die Binärzahl in **4er-Blöcke** mit den Stellenwerten **`8-4-2-1`** und übersetzt jeden Block in eine Hex-Ziffer: `0001` (`1`), `1011` (`8+2+1=11=B`), `0110` (`4+2=6`), `1110` (`8+4+2=14=E`) → **`1B6E`**.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 4](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=4>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hexadezimalsystem-04 | typ: anwendung | pruefung: AP1 -->
**Wie lautet der Rechenweg von der Hexadezimalzahl `1B6E` zurück ins Dezimalsystem?**
?
Man multipliziert jede Ziffer (Buchstaben als `10`–`15`) mit ihrer zugehörigen 16er-Potenz und addiert die Produkte: `1 · 16^3 + 11 · 16^2 + 6 · 16^1 + 14 · 16^0 = 7022`.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=3>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hexadezimalsystem-05 | typ: abgrenzung | pruefung: AP1 -->
**Welchen Vorteil hat die Hexadezimaldarstellung im Hex-Dump gegenüber dem Binärcode bei der Datenübertragung?**
?
Zur Übertragung werden Informationen (z. B. Zeichen über den **ASCII-Code**) in Bits codiert; im **Hex-Dump** stellt jede 2-stellige Hex-Gruppe ein Byte deutlich kompakter und lesbarer dar als eine 8-Bit-Binärfolge (ergänzt durch Bytezähler wie `0x1`, `0x29` und ASCII-Dekodierung).
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 27](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=27>) (von 29) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: hexadezimalsystem-06 | typ: pruefungsfalle | pruefung: AP1 -->
**Welcher typische Fehler tritt beim Umwandeln zwischen Binär- und Hexadezimalzahlen häufig auf?**
?
Bildet man keine vollständigen **4er-Blöcke** mit führenden Nullen (z. B. `0001` für `1`) oder verwechselt die Buchstabenwerte (`A=10` bis `F=15`), entstehen falsche Stellenwerte (z. B. `1011` = `11` = `B`, nicht `11` als zwei Ziffern).
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 3–4](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=3>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hexadezimalsystem-07 | typ: berechnung | pruefung: AP1 -->
**Wandle `0x3FA` direkt ins Binär- und ins Dezimalsystem um!**
?
- **Binär** (4er-Blöcke `8-4-2-1`): `3` = `0011`, `F (15)` = `1111`, `A (10)` = `1010` → **`0011 1111 1010`**
- **Dezimal**: $3 \cdot 256 + 15 \cdot 16 + 10 \cdot 1 = 768 + 240 + 10 = \mathbf{1018}$.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 3–4](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=3>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*
