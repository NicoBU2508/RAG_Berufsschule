---
typ: karteikarten_deck
thema: Verstärkung Dämpfung und Pegelrechnung
kategorie: Elektrotechnik
pruefung: AP1
thema_quelle: 03_Themen/Visuell_geprueft/Elektrotechnik/Verstärkung Dämpfung und Pegelrechnung.md
stand_karten: '2026-11-26'
stand_quelle: '2026-11-26'
quellseiten_anzahl: 6
quellseiten_hash: 1ca5f620a3c8
quellseiten:
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=1
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=2
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=7
rag_include: false
canonical_evidence: false
tags:
- karteikarten
- flashcards/elektrotechnik/verstaerkung-daempfung-und-pegelrechnung
---
# 🗂️ Karteikarten: Verstärkung Dämpfung und Pegelrechnung

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Elektrotechnik/Verstärkung Dämpfung und Pegelrechnung|Verstärkung Dämpfung und Pegelrechnung]] (**6 visuell geprüfte Seiten**).

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-01 | typ: abgrenzung | pruefung: AP1 -->
**Wie unterscheiden sich Verstärkungsfaktor $V$ und Dämpfungsfaktor $D$ bei Signalen an Eingang ($E$ / $1$) und Ausgang ($A$ / $2$)?**
?
Verstärkung liegt vor, wenn das Ausgangssignal größer ist als das Eingangssignal ($V = \frac{S_A}{S_E}$, z. B. $V_U = \frac{U_2}{U_1}$); Dämpfung ist der Kehrwert bei kleinerem Ausgangssignal ($D = \frac{S_E}{S_A}$, z. B. $D_U = \frac{U_1}{U_2}$).
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1, 3](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-02 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum steht beim relativen Leistungspegel der Faktor $10$, beim Spannungs- und Strompegel hingegen der Faktor $20$ vor dem dekadischen Logarithmus?**
?
Die Leistung hängt quadratisch von Spannung und Strom ab ($P = \frac{U^2}{R} = I^2 \cdot R$). Bei gleichem Widerstand bzw. gleicher Impedanz kürzt sich $R$ bzw. $Z$ heraus und der Exponent $2$ wird vorgezogen: $L_P = 10 \cdot \lg\!\left(\frac{P_a}{P_e}\right)\text{ dB}$, aber $L_U = 20 \cdot \lg\!\left(\frac{U_a}{U_e}\right)\text{ dB}$ und $L_I = 20 \cdot \lg\!\left(\frac{I_a}{I_e}\right)\text{ dB}$.
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-03 | typ: abgrenzung | pruefung: AP1 -->
**Worin unterscheiden sich relativer und absoluter Pegel, und welche Bezugswerte gelten für `dBm`, `dBW`, `dBµV`, `dBV` und `dBu`?**
?
Der relative Pegel vergleicht zwei beliebige Größen in $\text{dB}$; beim absoluten Pegel wird auf einen festen Referenzwert (Index $0$, Wechselgrößen als Effektivwerte) bezogen: `dBm` ($1\text{ mW}$), `dBW` ($1\text{ W}$), `dBµV` ($1\ \mu\text{V}$), `dBV` ($1\text{ V}$) und `dBu` ($775\text{ mV}$, entspricht $1\text{ mW}$ an $600\ \Omega$).
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1–2](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-04 | typ: anwendung | pruefung: AP1 -->
**Wie berechnet man die Gesamtverstärkung einer Übertragungskette bei Angabe als Faktoren vs. in Dezibel ($\text{dB}$)?**
?
Als Faktoren ($>1$ Verstärkung, $<1$ Dämpfung) werden die Einzelwerte multipliziert. Bei Pegeln in $\text{dB}$ (auf angepasster Strecke $Z_E = Z_A$) werden sie addiert, wobei Verstärkungen positiv und Dämpfungen negativ eingehen (ein negatives Verstärkungsmaß entspricht einer Dämpfung).
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1–2](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-05 | typ: anwendung | pruefung: AP1 -->
**Was passiert mit dem Leistungsverstärkungsfaktor, wenn sich das Leistungsverstärkungsmaß um $+3\text{ dB}$ erhöht?**
?
Der Leistungsverstärkungsfaktor **verdoppelt** sich (da $10^{\frac{3}{10}} \approx 2$).
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1, 7](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 8) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-06 | typ: anwendung | pruefung: AP1 -->
**Eine Empfangsantenne liefert $L_U = 46\text{ dB}\mu\text{V}$ über $24\text{ m}$ Leitung mit $a_L = 8{,}4\text{ dB}/100\text{ m}$. Welcher Pegel liegt am Empfänger an, und wie viel Verstärkung fehlt bis zum Mindestpegel $60\text{ dB}\mu\text{V}$?**
?
Leitungsdämpfung: $24\text{ m} \cdot \frac{8{,}4\text{ dB}}{100\text{ m}} = 2{,}016\text{ dB}$; Empfängerpegel: $46\text{ dB}\mu\text{V} - 2{,}016\text{ dB} = 43{,}984\text{ dB}\mu\text{V}$. Notwendiges Verstärkungsmaß: $60 - 43{,}984 = 16{,}016\text{ dB}$.
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 2, 7](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=2>) (von 8) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-07 | typ: anwendung | pruefung: AP1 -->
**Ein Verstärker hat $U_A = 6\text{ V}$ und $v_U = 30\text{ dB}$. Wie groß sind Spannungsverstärkungsfaktor $V_U$ und Eingangsspannung $U_E$?**
?
$V_U = 10^{\frac{v_U}{20}} = 10^{\frac{30}{20}} = 10^{1{,}5} \approx 31{,}62$; damit beträgt die Eingangsspannung $U_E = \frac{U_A}{V_U} = \frac{6\text{ V}}{31{,}62} \approx 0{,}190\text{ V}$ ($190\text{ mV}$).
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 1, 7](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=1>) (von 8) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]]*

---

<!-- card-id: verstaerkung-daempfung-und-pegelrechnung-08 | typ: anwendung | pruefung: BS -->
**Wie berechnet man den Spannungsdämpfungsfaktor $D_U$ eines RC-Tiefpasses ($R = 10\,\text{k}\Omega$, $C = 22\,\text{nF}$, $U_E = 10\,\text{V}$) bei $f = 1\,\text{kHz}$?**
?
1. Kapazitiver Blindwiderstand: $X_C = \frac{1}{2\pi f C} = \frac{1}{2\pi \cdot 1\,\text{kHz} \cdot 22\,\text{nF}} \approx 7{,}2\,\text{k}\Omega$
2. Scheinwiderstand (Impedanz): $Z = \sqrt{R^2 + X_C^2} \approx 12{,}3\,\text{k}\Omega$
3. Spannungsdämpfungsfaktor: $D_U = \frac{U_E}{U_A} = \frac{U_E}{(U_E / Z) \cdot X_C} = \frac{12{,}3\,\text{k}\Omega}{7{,}2\,\text{k}\Omega} \approx 1{,}7$
*Quelle: ITT IT-Technik (2. LJ) · [1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf · S. 3, 5](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Jacob/1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf#page=3>) (von 8) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]], OCR/Original prüfen*
