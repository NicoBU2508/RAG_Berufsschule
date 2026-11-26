---
typ: karteikarten_deck
thema: "Kryptografie, Hash und Signatur"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1/AP2"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Kryptografie Hash und Signatur.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 20
quellseiten_hash: ec2ec3e5965f
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=11"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=12"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=13"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=14"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=8"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=9"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=100"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=101"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=102"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=103"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=70"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=71"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=72"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=77"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=78"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=79"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=80"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=81"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=82"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=83"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/kryptografie-hash-und-signatur
---
# 🗂️ Karteikarten: Kryptografie, Hash und Signatur

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Kryptografie Hash und Signatur|Kryptografie, Hash und Signatur]] (**20 visuell geprüfte Seiten**).

---

<!-- card-id: kryptografie-hash-und-signatur-01 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Kryptografie und Steganografie, und welche zwei klassischen Prinzipien gibt es bei der Verschlüsselung?**
?
**Kryptografie** verschlüsselt eine Nachricht, sodass sie ohne Schlüssel unlesbar ist; **Steganografie** versteckt die Existenz der Nachricht selbst (z. B. in Bild- oder Audiodateien). Klassische Prinzipien sind **Substitution** (Zeichen oder Wörter ersetzen: Chiffrierung bzw. Codierung) und **Transposition** (Reihenfolge der Zeichen umstellen).
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 70–71](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=70>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: kryptografie-hash-und-signatur-02 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich symmetrische und asymmetrische Verschlüsselung bei Schlüsseln, Geschwindigkeit und Einsatzbereich?**
?
**Symmetrische Verfahren** (z. B. AES, ChaCha20) verwenden denselben geheimen Schlüssel – sie sind sehr schnell für große Datenmengen, haben aber das Schlüsselverteilungsproblem. **Asymmetrische Verfahren** (z. B. RSA, ECC) nutzen ein Schlüsselpaar (Public Key & Private Key) – sie sind rechenintensiver, lösen aber die Schlüsselverteilung und ermöglichen Signaturen.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 101–103](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=101>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: kryptografie-hash-und-signatur-03 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie viele eindeutige Schlüssel sind bei rein symmetrischer Verschlüsselung nötig, wenn `n` Parteien (z. B. 5 Hauptabteilungen bzw. 24 Abteilungen) paarweise sicher kommunizieren wollen?**
?
Es gilt die Formel `n * (n - 1) / 2`. Für `n = 5` Hauptabteilungen werden `5 * 4 / 2 = 10` Schlüssel benötigt; bei `n = 24` Abteilungen (5 Haupt- + 19 Unterabteilungen) sind es bereits `24 * 23 / 2 = 276` Schlüssel.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 78](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=78>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: kryptografie-hash-und-signatur-04 | typ: definition | pruefung: AP1/AP2 -->
**Wie funktioniert die hybride Verschlüsselung (z. B. bei HTTPS/TLS) und warum ist sie Praxisstandard?**
?
Die Nutzdaten werden schnell **symmetrisch** mit einem zufälligen Sitzungsschlüssel (z. B. AES) verschlüsselt, und nur dieser Sitzungsschlüssel wird **asymmetrisch** mit dem Public Key des Empfängers geschützt mitgesendet (oder per (EC)DH ausgehandelt). So kombiniert man die Performance der Symmetrie mit der sicheren Schlüsselverteilung der Asymmetrie.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 103](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=103>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: kryptografie-hash-und-signatur-05 | typ: definition | pruefung: AP1/AP2 -->
**Welche Aufgabe hat eine kryptologische Hashfunktion (z. B. SHA) und wie wird sie in digitalen Signaturen eingesetzt?**
?
Eine Hashfunktion bildet beliebig große Eingabedaten auf einen kleineren Prüfwert (Hashwert) ab; SHA (*Secure Hash Algorithm*) ist dafür ein Standard. Zur Erstellung einer digitalen Signatur wird dieser Hashwert der Nachricht mit dem Private Key signiert, sodass Empfänger Integrität und Urheberschaft prüfen können.
*Quelle: ITT IT-Technik (1. LJ) · [Sicherheitsmanagement.pdf · S. 11](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Sicherheitsmanagement.pdf#page=11>) (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: kryptografie-hash-und-signatur-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welcher Schlüssel wird bei der asymmetrischen Verschlüsselung verwendet – und welcher bei der digitalen Signatur?**
?
Beim **Verschlüsseln** (Vertraulichkeit) verschlüsselt der Absender mit dem **Public Key des Empfängers**, und nur der Empfänger entschlüsselt mit seinem Private Key. Bei der **digitalen Signatur** (Integrität & Authentizität) signiert der Absender mit seinem **eigenen Private Key**, und der Empfänger prüft mit dem **Public Key des Absenders**.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 102](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=102>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: kryptografie-hash-und-signatur-07 | typ: definition | pruefung: AP1/AP2 -->
**Warum werden für asymmetrische Kryptografie digitale Zertifikate und eine PKI (Certification Authority) benötigt?**
?
Asymmetrische Verfahren sind nur sicher, wenn der Public Key tatsächlich zur Gegenstelle gehört – sonst droht ein **Man-in-the-Middle-Angriff** mit untergeschobenen Schlüsseln. Eine **Certification Authority (CA)** bestätigt als vertrauenswürdige dritte Instanz per digitalem Zertifikat die Echtheit und Zuordnung des Public Keys.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 102](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=102>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*
