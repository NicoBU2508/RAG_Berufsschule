---
typ: karteikarten_deck
thema: "SI- und IEC-Dateneinheiten"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/SI- und IEC-Dateneinheiten.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 8
quellseiten_hash: 3435ec0b0d51
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=6"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=7"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=6"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=7"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=8"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell#page=9"
  - "02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=5"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/si-und-iec-dateneinheiten
---
# 🗂️ Karteikarten: SI- und IEC-Dateneinheiten

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/SI- und IEC-Dateneinheiten|SI- und IEC-Dateneinheiten]] (**8 visuell geprüfte Seiten**).

---

<!-- card-id: si-und-iec-dateneinheiten-01 | typ: definition | pruefung: AP1 -->
**Worin unterscheiden sich SI-Präfixe und IEC-Präfixe bei Dateneinheiten in ihrer mathematischen Basis?**
?
- **SI-Präfixe** (Dezimalpräfixe) rechnen zur **Basis 10** in Tausenderschritten: $10^{3 \cdot n}$ (z. B. k = $10^3$, M = $10^6$, G = $10^9$).
- **IEC-Präfixe** (Binärpräfixe, erkennbar am `i`) rechnen zur **Basis 2** in 1024er-Schritten: $2^{10 \cdot n}$ (z. B. Ki = $2^{10}$, Mi = $2^{20}$, Gi = $2^{30}$).
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 6](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=6>) (von 29), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: si-und-iec-dateneinheiten-02 | typ: abgrenzung | pruefung: AP1 -->
**Wie lauten die Kürzel und Potenzen der sechs wichtigsten SI- und IEC-Präfixe im Vergleich?**
?
1. $10^3$ **k** vs. $2^{10}$ **Ki** · 2. $10^6$ **M** vs. $2^{20}$ **Mi** · 3. $10^9$ **G** vs. $2^{30}$ **Gi**
4. $10^{12}$ **T** vs. $2^{40}$ **Ti** · 5. $10^{15}$ **P** vs. $2^{50}$ **Pi** · 6. $10^{18}$ **E** vs. $2^{60}$ **Ei**
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 6](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=6>) (von 29), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: si-und-iec-dateneinheiten-03 | typ: pruefungsfalle | pruefung: AP1 -->
**Welche doppelte Einheitenfalle lauert in IHK-Aufgaben bei der Berechnung von Übertragungszeiten (z. B. 500 MiB über 10 Mbit/s)?**
?
1. **Basis-Unterschied**: Dateigrößen stehen oft in **IEC-Einheiten** (`500 MiB` = $500 \cdot 2^{20}$ B), Übertragungsraten in **SI-Einheiten** (`10 Mbit/s` = $10 \cdot 10^6$ bit/s).
2. **Byte vs. Bit**: Byte müssen mit dem **Faktor 8** in Bit umgerechnet werden (oder bit/s durch 8 in B/s).
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 6](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=6>) (von 29), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: si-und-iec-dateneinheiten-04 | typ: anwendung | pruefung: AP1 -->
**Mit welcher Formel berechnet man die theoretisch minimale Übertragungsdauer $t$ einer Datei inklusive Frame-Overhead?**
?
Zwei gleichwertige Rechenwege (mit einheitlichen Einheiten in Bit oder Byte):
- Über Frame-Anzahl: $t = \frac{(\text{Dateigröße} / \text{Netto-Framegröße}) \cdot \text{Framegröße}}{\text{Übertragungsrate}}$
- Über Nutzdatenanteil: $t = \frac{\text{Dateigröße}}{(\text{Netto-Framegröße} / \text{Framegröße}) \cdot \text{Übertragungsrate}}$
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 7](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=7>) (von 29), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*

---

<!-- card-id: si-und-iec-dateneinheiten-05 | typ: pruefungsfalle | pruefung: AP1 -->
**Welcher Rechenfehler entsteht, wenn man $2.160\text{ GiB}$ einfach durch $1.000$ statt durch $1.024$ in $\text{TiB}$ umrechnet?**
?
Bei dezimaler Näherung ($/ 1.000$) erhält man $2{,}16\text{ TiB}$; binär exakt ($2.160 / 1.024$) sind es jedoch nur **$2{,}109\text{ TiB}$** (da $1\text{ TiB} = 2^{10}\text{ GiB} = 1.024\text{ GiB}$).
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 7](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=7>) (von 7), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]]*

---

<!-- card-id: si-und-iec-dateneinheiten-06 | typ: anwendung | pruefung: AP1 -->
**Wie rechnet man eine Header-/Trailersumme von `704 Bit` in Byte und eine Datenrate von `100 MB/s` in `Mbit/s` um?**
?
- Bit -> Byte (durch 8 teilen): $704\text{ Bit} / 8 = \mathbf{88\text{ Byte}}$.
- MB/s -> Mbit/s (mit 8 multiplizieren): $100\text{ MB/s} \cdot 8 = \mathbf{800\text{ Mbit/s}}$.
*Quelle: ITT IT-Technik (2. LJ) · [Einf Funktsw OSI 23-3.pdf · S. 9](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Ott/Einf Funktsw OSI 23-3.pdf#page=9>) (von 29), OCR/Original prüfen · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|Quellnotiz]]*
