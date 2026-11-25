---
typ: karteikarten_deck
thema: "USV-Anlagen"
kategorie: Elektrotechnik
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/Elektrotechnik/USV-Anlagen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 11
quellseiten_hash: c643378f04a1
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=100"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=101"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=91"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=92"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=93"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=94"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=95"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=96"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=97"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=98"
  - "02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q#page=99"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/elektrotechnik/usv-anlagen
---
# 🗂️ Karteikarten: USV-Anlagen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Elektrotechnik/USV-Anlagen|USV-Anlagen]] (**11 visuell geprüfte Seiten**).

---

<!-- card-id: usv-anlagen-01 | typ: abgrenzung | pruefung: AP1 -->
**Wofür steht USV/UPS, wie grenzt sie sich von einer Notstromversorgung ab und gegen welche Netzstörungen schützt sie?**
?
USV = Unterbrechungsfreie Stromversorgung (*Uninterruptible Power Supply*). Sie überbrückt Stromausfälle nur für wenige Minuten (z. B. zum geordneten Herunterfahren) und schützt neben Netzausfällen auch vor Spannungsschwankungen, Überspannung und Frequenzabweichungen.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 91–92 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: usv-anlagen-02 | typ: abgrenzung | pruefung: AP1 -->
**Wie unterscheiden sich Offline- (VFD), Line-interactive- (VI) und Online-USV (VFI) bei Schutzwirkung und Umschaltzeit?**
?
**Offline (VFD):** Netz direkt am Verbraucher, Umschaltzeit < 10 ms, günstig, fängt Störungen kaum ab. **Line-interactive (VI):** AVR-Spannungsregler stabilisiert im Normalbetrieb (spannungsunabhängig), Umschaltung erst bei Ausfall. **Online (VFI):** dauerhafte Doppelwandlung (Gleich-/Wechselrichter), 0 ms Umschaltzeit, saubere Sinusspannung, aber geringerer Wirkungsgrad (90 %) und höchster Preis.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 93 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]]*

---

<!-- card-id: usv-anlagen-03 | typ: definition | pruefung: AP1 -->
**Welche zwei Aufgaben erfüllt der Bypass bei einer Online-USV?**
?
1. Bei auftretenden Lastspitzen (z. B. Einschalten zusätzlicher Endverbraucher) schaltet er direkt auf das speisende Spannungsnetz um. 2. Bei einem Defekt innerhalb der USV stellt er weiterhin die Energieversorgung des Verbrauchers sicher.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 94 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: usv-anlagen-04 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum wird die Nennbelastbarkeit einer USV in Scheinleistung S_el (VA) statt nur in Wirkleistung P_el (W) angegeben?**
?
Durch induktive und kapazitive Bauteile in Schaltnetzteilen entsteht eine Phasenverschiebung zwischen Strom und Spannung (Blindleistung $Q$). Die USV muss die größere Scheinleistung $S_{\text{el}} = \frac{P_{\text{el}}}{\cos \varphi}$ liefern (Standardwert $\cos \varphi = 0{,}8$, falls nicht angegeben).
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 96–97 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: usv-anlagen-05 | typ: anwendung | pruefung: AP1 -->
**Wie berechnet man die benötigte USV-Scheinleistung mit 25 % Reserve für Server (600 W, cos φ = 0,8), Firewall (100 VA) und Switch (0,8 A / 230 V)?**
?
$S_{\text{Server}} = \frac{600\,\text{W}}{0{,}8} = 750\,\text{VA}$, $S_{\text{Firewall}} = 100\,\text{VA}$, $S_{\text{Switch}} = 230\,\text{V} \cdot 0{,}8\,\text{A} = 184\,\text{VA}$. Gesamtleistung mit 25 % Reserve: $(750 + 100 + 184)\,\text{VA} \cdot 1{,}25 = 1.034\,\text{VA} \cdot 1{,}25 = 1.292{,}5\,\text{VA}$.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 99 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: usv-anlagen-06 | typ: anwendung | pruefung: AP1 -->
**Mit welcher Formel berechnet man die Autonomiezeit t_A einer USV bei vorgegebener Restladung der Akkus?**
?
$t_A = \frac{n_{\text{Akku}} \cdot U_{\text{Akku}} \cdot Q_{\text{Akku}} \cdot \text{Nutzanteil}}{S_{\text{gesamt}}}$ (Ergebnis in Stunden). Soll z. B. eine Restladung von 35 % verbleiben, beträgt der Nutzanteil $100\,\% - 35\,\% = 0{,}65$.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 97–98 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: usv-anlagen-07 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum plant man bei USVs mind. 25 % Reserve ein, welches Bauteil ist am fehleranfälligsten und wozu dient das Datenkabel zum Server?**
?
Reserve wegen 1. künftiger Erweiterungen, 2. Akku-Alterung (Kapazitätsverlust) und 3. Einschaltspitzen. Fehleranfälligstes Bauteil ist der **Akkumulator** (möglichst jährlich prüfen lassen). Das Datenkabel (USB/Netzwerkkarte) meldet Akkustand und Stromausfall für ein geordnetes Herunterfahren.
*Quelle: ITT IT-Technik (1. LJ) · `01_AB_Ladung Q.pdf` S. 99, 101 (von 101) · [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|Quellnotiz]], OCR/Original prüfen*
