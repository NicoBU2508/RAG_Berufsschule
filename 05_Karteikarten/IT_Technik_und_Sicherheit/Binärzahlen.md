---
typ: karteikarten_deck
thema: "Binärzahlen"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Binärzahlen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 7
quellseiten_hash: 409005f0fc2b
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=27"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=1"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=2"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=3"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=2"
  - "02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=3"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/binaerzahlen
---
# 🗂️ Karteikarten: Binärzahlen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Binärzahlen|Binärzahlen]] (**7 visuell geprüfte Seiten**).

---

<!-- card-id: binaerzahlen-01 | typ: definition | pruefung: AP1 -->
**Was bedeuten Bit, Nibble (Halbbyte) und Byte, und wie werden 8 Bit zur besseren Lesbarkeit notiert?**
?
Ein **Bit (b)** ist eine einzelne binäre Stelle (0 oder 1), **4 Bit** ergeben ein **Halbbyte (Nibble)** und **8 Bit** bilden ein **Byte (B)**.
Zur besseren Lesbarkeit notiert man 8 Bit in zwei 4er-Blöcken (z. B. `1011 0111`).
*Quelle: ITT IT-Technik (1. LJ) · [Netzwerkt.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/Otma/Netzwerkt.pdf#page=3>) (von 13), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]]*

---

<!-- card-id: binaerzahlen-02 | typ: anwendung | pruefung: AP1 -->
**Welche Stellenwerte besitzen die ersten 8 Stellen einer Binärzahl, und wie viele Kombinationen bzw. welche höchste Dezimalzahl sind damit darstellbar?**
?
Die Stellenwerte von rechts nach links verdoppeln sich beginnend bei 1: **1, 2, 4, 8, 16, 32, 64, 128** ($2^0$ bis $2^7$).
Mit 8 Bit sind **$2^8 = 256$ Kombinationen** möglich; die höchste darstellbare Dezimalzahl ist **255**.
*Quelle: ITT IT-Technik (1. LJ) · [Netzwerkt.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/Otma/Netzwerkt.pdf#page=3>) (von 13), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]]*

---

<!-- card-id: binaerzahlen-03 | typ: pruefungsfalle | pruefung: AP1 -->
**Woran erkennt man bei einer Binärzahl sofort, ob sie gerade oder ungerade ist, und was gilt für die binäre Addition $1 + 1$?**
?
Die **erste Stelle ganz rechts** (Stellenwert $2^0 = 1$) legt fest, ob die Zahl gerade (`0`) oder ungerade (`1`) ist.
Da im Binärsystem nur die Ziffern `0` und `1` existieren, entsteht bei `1 + 1` ein Übertrag auf die nächste Stelle: **$1 + 1 = 10$**.
*Quelle: ITT IT-Technik (1. LJ) · [Netzwerkt.pdf · S. 2](<99_Originale/Berufsschule/ITT/1_LJ/Otma/Netzwerkt.pdf#page=2>) (von 13), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]]*

---

<!-- card-id: binaerzahlen-04 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum reicht ein reines Bitmuster wie `0101 1001` zur eindeutigen Interpretation nicht aus?**
?
Ein Bitmuster benötigt einen **Datentyp** (bzw. eine festgelegte Codierung wie ASCII), damit das System weiß, wie es die Bits interpretieren muss.
Dasselbe Muster `0101 1001` entspricht z. B. als `int` der Zahl **89**, als `char` jedoch dem Zeichen **`'Y'`**.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 2](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=2>) (von 16), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]]*

---

<!-- card-id: binaerzahlen-05 | typ: anwendung | pruefung: AP1 -->
**Wie wandelt man eine Binärzahl in eine Hexadezimalzahl (und umgekehrt) um?**
?
Man unterteilt die Binärzahl von rechts in **4er-Blöcke** mit den Stellenwerten **8–4–2–1** und übersetzt jeden Block in eine Hex-Ziffer (`0–9`, `A–F` für `10–15`).
Beispiel: `0001 1011 0110 1110` ergibt `1` (1), `1011` (`8+2+1=11` -> `B`), `0110` (`4+2=6`), `1110` (`8+4+2=14` -> `E`), also **`1B6E`**.
*Quelle: ITT IT-Technik (1. LJ) · [Grudausbildumg.pdf · S. 4](<99_Originale/Berufsschule/ITT/1_LJ/Grudausbildumg.pdf#page=4>) (von 16), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]]*

---

<!-- card-id: binaerzahlen-06 | typ: abgrenzung | pruefung: AP1 -->
**Wie ist eine IPv4-Adresse binär aufgebaut und was gibt die Präfixlänge einer Subnetzmaske an?**
?
Eine IPv4-Adresse ist eine **32-stellige Binärzahl**, unterteilt in **4 Oktette zu je 8 Bit** (dezimal je Oktett dargestellt) sowie in Netz- und Hostteil.
Die **Präfixlänge** gibt die Anzahl der Bits in der Subnetzmaske an, die auf **`1`** gesetzt sind.
*Quelle: ITT IT-Technik (2. LJ) · [00_IPv4_Wiederholung.pdf · S. 1](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Zielske/00_IPv4_Wiederholung.pdf#page=1>) (von 13), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]]*
