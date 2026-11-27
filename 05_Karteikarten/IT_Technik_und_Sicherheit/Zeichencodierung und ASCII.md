---
typ: karteikarten_deck
thema: "Zeichencodierung und ASCII"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Zeichencodierung und ASCII.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 4
quellseiten_hash: a214578c8805
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=2"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=27"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=2"
  - "02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=13"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/zeichencodierung-und-ascii
---
# 🗂️ Karteikarten: Zeichencodierung und ASCII

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Zeichencodierung und ASCII|Zeichencodierung und ASCII]] (**4 visuell geprüfte Seiten**).

---

<!-- card-id: zeichencodierung-und-ascii-01 | typ: definition | pruefung: AP1 -->
**Warum wird für Zeichenfolgen der ASCII-Code verwendet und wie gliedern sich 8 Bit bei klassischem ASCII laut Mitschrift?**
?
Zur Übertragung und Verarbeitung müssen Informationen wie Zeichenfolgen in Bits codiert werden; bei Zeichenfolgen übernimmt das der ASCII-Code. Ein 8-Bit-Byte besteht dabei aus 7 Bit für die ASCII-Zeichendarstellung und 1 Sicherungsbit.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 2](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=2>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: zeichencodierung-und-ascii-02 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum ergibt dasselbe Bitmuster `0101 1001` (dezimal 89) je nach Kontext die Zahl `89` oder das Zeichen `'Y'`?**
?
Ein Bitmuster benötigt einen Datentyp, um korrekt interpretiert zu werden: Als `int` steht `0101 1001` für die Ganzzahl `89`, als `char` über den ASCII-Code für das Zeichen `'Y'`. Das Umwandeln zwischen Datentypen heißt Typecast.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 2](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=2>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: zeichencodierung-und-ascii-03 | typ: definition | pruefung: AP1 -->
**Aus welchen drei Spalten bzw. Bereichen besteht ein Hex-Dump?**
?
1. Zeilen-/Bytezähler (Offset in 16-Byte-Schritten, z. B. `0000`, `0010`), 2. Hex-Dump (die einzelnen Bytes als zweistellige Hexadezimalwerte) und 3. ASCII-Decoded (die zugehörige decodierte ASCII-Zeichenfolge).
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 27](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=27>) (von 29) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: zeichencodierung-und-ascii-04 | typ: anwendung | pruefung: AP1 -->
**Wie liest man in einem 16-Byte-Hex-Dump (Zeilen `0000`, `0010`, `0020`) das Byte am Offset `0x1c` ab?**
?
Die Zehner-Hex-Stelle `0x1_` verweist auf Zeile `0010` (Bytes `0x10` bis `0x1f`), die Einerstelle `c` (= 12, 0-basiert gezählt) auf das 13. Byte dieser Zeile. Im Beispiel auf dem Arbeitsblatt steht dort der Hex-Wert `02` (nicht druckbares ASCII-Zeichen `.`).
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 27](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=27>) (von 29) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: zeichencodierung-und-ascii-05 | typ: abgrenzung | pruefung: AP1 -->
**Welchen Vorteil hat die hexadezimale Darstellung gegenüber der binären bei der ASCII-Codierung eines Bytes?**
?
Ein 8-Bit-Byte lässt sich über die Stellenwerte zweier 4-Bit-Gruppen (`8, 4, 2, 1`) kompakt als zwei Hex-Ziffern schreiben (z. B. `1101 | 0011` = `D3`) statt als acht einzelne Bits, was deutlich kürzer und lesbarer ist.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 2](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=2>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: zeichencodierung-und-ascii-06 | typ: anwendung | pruefung: AP1 -->
**Wie wird eine gegebene Folge dezimaler ASCII-Werte (z. B. `68 105 ... 32 ... 33`) in Klartext umgewandelt?**
?
Jeder Dezimalwert (0–255) wird einzeln in der ASCII-Tabelle nachgeschlagen und dem zugehörigen Buchstaben, Satz- oder Steuerzeichen (z. B. `32` = Leerzeichen, `33` = `!`) zugeordnet, bis der vollständige Text entsteht.
*Quelle: ITT IT-Technik (1. LJ) · [Netzwerkt.pdf · S. 13](<99_Originale/Berufsschule/ITT/1_LJ/Otma/Netzwerkt.pdf#page=13>) (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: zeichencodierung-und-ascii-07 | typ: berechnung | pruefung: AP1 -->
**ASCII-Stützwerte: `'A'` hat Code `65`, `'a'` hat `97`, `'0'` hat `48`. Welcher dezimale und hexadezimale ASCII-Code gehört zu `"C3"`?**
?
- `'C'` = $65 + 2 = \mathbf{67}$ (`0x43`)
- `'3'` = $48 + 3 = \mathbf{51}$ (`0x33`) → Hex: **`43 33`**.
*Quelle: ITT IT-Technik (1. LJ) · [Netzwerkt.pdf · S. 13](<99_Originale/Berufsschule/ITT/1_LJ/Otma/Netzwerkt.pdf#page=13>) (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]], OCR/Original prüfen*
