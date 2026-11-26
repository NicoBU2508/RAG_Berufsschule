---
typ: karteikarten_deck
thema: "IT-Sicherheit Grundlagen"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1/AP2"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IT-Sicherheit Grundlagen.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 11
quellseiten_hash: 79f8db7a8b72
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=100"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA#page=99"
  - "02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=2"
  - "02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=5"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=2"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=100"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=70"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=83"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=12"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=5"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/it-sicherheit-grundlagen
---
# 🗂️ Karteikarten: IT-Sicherheit Grundlagen

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IT-Sicherheit Grundlagen|IT-Sicherheit Grundlagen]] (**11 visuell geprüfte Seiten**).

---

<!-- card-id: it-sicherheit-grundlagen-01 | typ: definition | pruefung: AP1/AP2 -->
**Wie sind die drei Schutzziele der IT-Sicherheit (Vertraulichkeit, Integrität, Verfügbarkeit) definiert?**
?
**Vertraulichkeit** schützt Daten vor Einsicht durch Unbefugte. **Integrität** bedeutet Korrektheit, Vollständigkeit und Konsistenz der Daten (Unverfälschtheit), und **Verfügbarkeit** stellt sicher, dass Daten und Systeme bei Bedarf zuverlässig nutzbar sind.
*Quelle: ITT IT-Technik (2. LJ) · [20261005_145426.pdf · S. 12](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Liebscher/20261005_145426.pdf#page=12>) (von 18) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]]*

---

<!-- card-id: it-sicherheit-grundlagen-02 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Wie unterscheidet sich die Priorisierung der Schutzziele zwischen klassischen IT-Netzen und OT-Netzen (Operative Technology)?**
?
In **IT-Netzen** steht 1. Vertraulichkeit vor 2. Integrität und 3. Verfügbarkeit. In **OT-Netzen** zur Echtzeit-Steuerung physischer Anlagen ist die Reihenfolge umgekehrt: 1. Verfügbarkeit hat höchste Priorität, gefolgt von 2. Integrität und 3. Vertraulichkeit.
*Quelle: ITT IT-Technik (2. LJ) · [20261005_145426.pdf · S. 12](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Liebscher/20261005_145426.pdf#page=12>) (von 18) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]]*

---

<!-- card-id: it-sicherheit-grundlagen-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich Steganographie und Kryptographie?**
?
**Steganographie** versteckt eine Nachricht so (z. B. in einem Bild oder einer Audiodatei), dass Außenstehende möglichst nicht merken, dass eine geheime Botschaft existiert. **Kryptographie** verschlüsselt den Inhalt, sodass er ohne passenden Schlüssel nicht gelesen werden kann.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 70](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=70>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: it-sicherheit-grundlagen-04 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie läuft eine asymmetrische E-Mail-Verschlüsselung zwischen Sender und Empfänger ab, und welchen Vor- bzw. Nachteil hat sie gegenüber symmetrischer Verschlüsselung?**
?
Der Sender verschlüsselt die E-Mail mit dem **öffentlichen Schlüssel des Empfängers**, sodass nur dieser sie mit seinem **privaten Schlüssel** entschlüsseln kann (Schutzziel: Vertraulichkeit). Vorteil gegenüber symmetrischen Verfahren ist der sichere, einfachere Schlüsselaustausch; Nachteil ist der hohe Rechenaufwand.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 83](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=83>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: it-sicherheit-grundlagen-05 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Ransomware, Rootkits und DoS-/DDoS-Angriffe?**
?
**Ransomware** blockiert bzw. verschlüsselt Systemzugriff oder Daten gegen Lösegeldforderung; **Rootkits** verbergen Schadsoftware durch Manipulation von Kernel-Code und -Prozessen. **DoS-Angriffe** verursachen einen Dienstausfall (z. B. durch Überlastung) — bei **DDoS** senden viele Angriffssysteme gleichzeitig Anfragen.
*Quelle: Allgemein Berufsschule (1. LJ) · [Gescanntes Dokument 16.09.25 um 11.21.41.pdf · S. 4](<99_Originale/Berufsschule/Allgemein/1_LJ/Gescanntes Dokument 16.09.25 um 11.21.41.pdf#page=4>) (von 4) · [[02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: it-sicherheit-grundlagen-06 | typ: anwendung | pruefung: AP1/AP2 -->
**Welche vier Gefahrenbereiche der physischen Sicherheit von IT-Systemen gibt es und welche Schutzmaßnahmen gehören dazu?**
?
- **Unberechtigter Raumzugang:** Schließsysteme, biometrische Zugangskontrolle, separate Serverräume
- **Physischer System-/Kabelzugriff:** abschließbare Server-/Verteilerschränke, Gehäuseverschluss, Kensington-Schloss, Unterboden-/Schachtverlegung
- **Klima/Umwelt (Temperatur, Feuchtigkeit, Staub):** Klimaanlage, Umgebungskontrollen, Reinigung
- **Hardwareausfall:** Fehlertoleranz durch redundante Komponenten und RAID
*Quelle: Allgemein Berufsschule (1. LJ) · [Gescanntes Dokument 16.09.25 um 11.21.41.pdf · S. 2](<99_Originale/Berufsschule/Allgemein/1_LJ/Gescanntes Dokument 16.09.25 um 11.21.41.pdf#page=2>) (von 4) · [[02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41|Quellnotiz]], OCR/Original prüfen*
