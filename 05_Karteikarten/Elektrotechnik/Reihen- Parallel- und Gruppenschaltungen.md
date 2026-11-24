---
typ: karteikarten_deck
thema: "Reihen-, Parallel- und Gruppenschaltungen"
kategorie: Elektrotechnik
thema_quelle: "03_Themen/Visuell_geprueft/Elektrotechnik/Reihen- Parallel- und Gruppenschaltungen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 14
quellseiten_hash: 302f025fb1fc
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung#page=5"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=64"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=65"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=66"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=67"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=68"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=69"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=70"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=71"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=72"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=73"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=74"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=75"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=76"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/elektrotechnik/reihen-parallel-und-gruppenschaltungen
---

# 🗂️ Karteikarten: Reihen-, Parallel- und Gruppenschaltungen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Elektrotechnik/Reihen- Parallel- und Gruppenschaltungen|Reihen-, Parallel- und Gruppenschaltungen]] (**14 visuell geprüfte Seiten**).

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-01 | typ: definition | pruefung: AP1/AP2 -->
**Welche Grundgesetze gelten für Stromstärke $I$, Spannung $U$ und Gesamtwiderstand $R_{\text{ges}}$ in der Reihenschaltung?**
?
In der Reihenschaltung fließt überall derselbe Strom ($I = I_1 = I_2 = \dots = I_n$), die Gesamtspannung ist die Summe aller Teilspannungen ($U_{\text{ges}} = U_1 + U_2 + \dots + U_n$) und der Gesamtwiderstand ist die Summe der Einzelwiderstände ($R_{\text{ges}} = R_1 + R_2 + \dots + R_n$).
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 64–65, 67 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-02 | typ: definition | pruefung: AP1/AP2 -->
**Welche Grundgesetze gelten für Spannung $U$, Stromstärke $I$ (Knotenpunktsatz) und Ersatzwiderstand $R_{\text{ges}}$ in der Parallelschaltung?**
?
An parallel geschalteten Verbrauchern liegt dieselbe Spannung ($U_{\text{ges}} = U_1 = U_2 = \dots$), der Gesamtstrom verzweigt sich ($I_{\text{ges}} = I_1 + I_2 + \dots$, Knotenpunktsatz) und die Kehrwerte bzw. Leitwerte ($G = \frac{1}{R}$) addieren sich: $\frac{1}{R_{\text{ges}}} = \frac{1}{R_1} + \frac{1}{R_2} + \dots$.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 68–69 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie verändert sich der Gesamtwiderstand, wenn ein weiterer Widerstand in Reihe bzw. parallel hinzugeschaltet wird?**
?
In der **Reihenschaltung** steigt $R_{\text{ges}}$ durch Addition an (bei konstanter Quellspannung sinkt der Strom, z. B. leuchtet eine verlängerte Lichterkette schwächer). In der **Parallelschaltung** sinkt $R_{\text{ges}}$ und ist stets kleiner als der kleinste Einzelwiderstand, weil der Strom einen weiteren Pfad erhält.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 67, 69 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-04 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie geht man systematisch vor, um den Ersatzwiderstand einer gemischten Schaltung (Gruppenschaltung) zu berechnen?**
?
Man fasst schrittweise von **innen nach außen** einzelne reine Teil-Reihenschaltungen und Teil-Parallelschaltungen zu Ersatzwiderständen zusammen, bis am Ende nur noch ein einziger Gesamtwiderstand $R_{\text{ges}}$ übrig bleibt.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 70 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-05 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie berechnet man bei einem ohmschen Spannungsteiler ($R_1 = 10\text{ k}\Omega$, $R_2 = 10\text{ k}\Omega$, $U_E = 10\text{ V}$) den Gesamtstrom $I_G$ und die Ausgangsspannung $U_A = U_2$?**
?
Über den Reihen-Gesamtwiderstand $R_G = R_1 + R_2 = 20\text{ k}\Omega$ folgt $I_G = \frac{U_E}{R_G} = \frac{10\text{ V}}{20\text{ k}\Omega} = 0{,}5\text{ mA}$. Damit fällt an $R_2$ die Teilspannung $U_A = U_2 = I_2 \cdot R_2 = 0{,}5\text{ mA} \cdot 10\text{ k}\Omega = 5\text{ V}$ ab.
*Quelle: ITT IT-Technik (2. LJ) · `1_30_Grundlagen_Elektro__Verstaerkung_Daempfung.pdf` S. 5 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: reihen-parallel-und-gruppenschaltungen-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welcher Rechenfehler passiert bei der Parallelschaltung am häufigsten nach dem Berechnen von $\frac{1}{R_1} + \frac{1}{R_2} + \dots$?**
?
Es wird vergessen, am Schluss erneut den **Kehrwert** zu bilden! Die Summe der Kehrwerte ergibt den Gesamtleitwert $G_{\text{ges}}$ (in $\text{S}$), erst $R_{\text{ges}} = \frac{1}{G_{\text{ges}}}$ liefert den gesuchten Ersatzwiderstand in $\Omega$.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 69–70 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*
