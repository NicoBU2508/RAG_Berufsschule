---
typ: karteikarten_deck
thema: "EVA-Prinzip"
kategorie: Anwendungsentwicklung
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/EVA-Prinzip.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 5
quellseiten_hash: bb95a3417b43
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=1"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift#page=16"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift#page=17"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift#page=26"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=14"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/eva-prinzip
---

# 🗂️ Karteikarten: EVA-Prinzip

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/EVA-Prinzip|EVA-Prinzip]] (**5 visuell geprüfte Seiten**).

---

<!-- card-id: eva-prinzip-01 | typ: definition | pruefung: AP1/AP2 -->
**Wofür steht das EVA-Prinzip und in welcher Reihenfolge laufen die drei Phasen ab?**
?
**E**ingabe → **V**erarbeitung → **A**usgabe: Daten werden zunächst eingelesen, anschließend vom Computer mittels Algorithmus/Programm verarbeitet und erst danach als Ergebnis ausgegeben.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 1 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: eva-prinzip-02 | typ: anwendung | pruefung: AP1 -->
**Nenne jeweils mindestens drei typische Eingabe- und Ausgabegeräte nach dem EVA-Prinzip.**
?
- **Eingabe:** Tastatur, Maus, Mikrofon, Scanner, Touch-Display, Webcam (auch Speicher/DB wie USB-Stick, Festplatte)
- **Ausgabe:** Monitor/Display, Drucker/3D-Drucker, Plotter, Lautsprecher, VR-Brille (auch Speicher/Brenner)
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 1 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: eva-prinzip-03 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum verstößt `print(i_stimmenKand1 + i_stimmenKand2)` in Python gegen das EVA-Prinzip – und wie lautet die saubere Lösung?**
?
**Grund:** Verarbeitung (`+`) und Ausgabe (`print(...)`) sind vermischt statt sauber getrennt.
**Saubere EVA-Lösung:** Zuerst Ergebnis in eigener Variable berechnen (`i_ges = i_stimmenKand1 + i_stimmenKand2`) und danach getrennt ausgeben (`print(i_ges)`).
*Quelle: AE Anwendungsentwicklung (2. LJ) · `Mitschrift_AE_Eix.pdf` S. 17 (von 26) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift|Quellnotiz]]*

---

<!-- card-id: eva-prinzip-04 | typ: abgrenzung | pruefung: AP1 -->
**Wie unterscheidet sich der Begriff „Software“ vom Begriff „Programm“?**
?
**Software** ist umfassender als **Programm**: Zu Software zählen neben den eigentlichen **Programmen** (Algorithmen in Programmiersprache) auch die zugehörigen **Daten** und **Dokumentationen**. Ohne Daten läuft ein Programm nicht; ohne Dokumentation ist es kaum bedienbar.
*Quelle: AE Anwendungsentwicklung (1. LJ) · `01_Algorithmus_Programm_Software_EVA.pdf` S. 1 (von 100) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|Quellnotiz]]*

---

<!-- card-id: eva-prinzip-05 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie zeigt sich das EVA-Prinzip bei einer Steuerung mit Siemens LOGO! (z. B. Ampelsteuerung im CPS)?**
?
- **E (Eingänge):** Schalter/Taster (z. B. `I1` Schalter Auto, `I4` Fußgängertaster) oder Netzwerkeingänge
- **V (Verarbeitung):** Logikbausteine, Zeitglieder und Flip-Flops in der LOGO!
- **A (Ausgänge):** Leuchten/Aktoren an `Q1–Q4` (Rot, Orange, Grün, Blau) bzw. Netzwerkausgänge
*Quelle: ITT IT-Technik (2. LJ) · `20261005_145426.pdf` S. 14 (von 18, OCR/Original prüfen) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]]*
