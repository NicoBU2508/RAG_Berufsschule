---
typ: karteikarten_deck
thema: "RAID-Systeme"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP2"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/RAID-Systeme.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 5
quellseiten_hash: 5f9021420193
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=3"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=5"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=6"
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=7"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/raid-systeme
---
# 🗂️ Karteikarten: RAID-Systeme

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/RAID-Systeme|RAID-Systeme]] (**5 visuell geprüfte Seiten**).

---

<!-- card-id: raid-systeme-01 | typ: definition | pruefung: AP2 -->
**Was versteht man unter RAID und was bedeutet Parität im RAID-Kontext?**
?
RAID fasst mehrere Festplatten zu einem logischen Laufwerk zusammen und verteilt oder spiegelt Daten, sodass das System bei Plattenausfall weiterläuft. Parität ist eine aus den Datenblöcken berechnete Prüfinformation, mit der ein verlorener Datenblock rekonstruiert werden kann.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 3–4](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=3>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-02 | typ: abgrenzung | pruefung: AP2 -->
**Wie unterscheiden sich RAID 0, RAID 1 und RAID 10 bei Mindestanzahl Platten, Ausfalltoleranz und Nettokapazität (`n` Platten à `S`)?**
?
RAID 0 (Striping): min. 2 Platten, 0 Ausfalltoleranz, `K = n * S`. RAID 1 (Mirroring): min. 2 Platten, 1 Platte Ausfalltoleranz, `K = 0,5 * n * S`. RAID 10 (1+0): min. 4 Platten, 1 bis max. `n/2` Platten (aus verschiedenen Spiegelpaaren), `K = 0,5 * n * S`.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 3](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=3>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-03 | typ: abgrenzung | pruefung: AP2 -->
**Worin unterscheiden sich RAID 5 und RAID 6 bei Mindestplattenanzahl, Ausfalltoleranz und Nettokapazität?**
?
RAID 5 (Striping mit einfacher verteilter Parität) benötigt min. 3 Platten, toleriert 1 Plattenausfall und bietet `K = (n - 1) * S`. RAID 6 nutzt doppelte verteilte Parität, benötigt min. 4 Platten, toleriert den gleichzeitigen Ausfall von 2 Platten und bietet `K = (n - 2) * S`.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 4](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=4>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-04 | typ: pruefungsfalle | pruefung: AP2 -->
**Warum ist ein RAID kein Ersatz für ein Backup, und welche spezielle Gefahr besteht beim Rebuild eines RAID 5?**
?
Ein RAID erhöht lediglich die Ausfallsicherheit bei Festplattendefekten, ersetzt aber keine Datensicherung („Ein RAID ist kein Backup!“). Beim RAID 5 entsteht während eines Rebuilds eine hohe Belastung und Gefahr von Folgeausfällen, da keine zweite Platte mehr ausfallen darf.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 4](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=4>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-05 | typ: definition | pruefung: AP2 -->
**Welche Funktion erfüllt eine Hot-Spare-Festplatte in einem RAID-System?**
?
Eine Hot-Spare-Festplatte ist eine bereits eingebaute und betriebsbereite Reservefestplatte, die im Normalbetrieb ungenutzt bleibt und bei Ausfall einer produktiven Platte automatisch einspringt.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 5](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=5>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-06 | typ: anwendung | pruefung: AP2 -->
**Ein NAS mit 4 Festplatten soll 12 TiByte Nettokapazität liefern. Welche Einzelplattengröße und Speichereffizienz gelten bei RAID 10 vs. RAID 5?**
?
Bei RAID 10 sind 4 × 6 TiByte nötig (24 TiByte brutto, 12 TiByte netto, 50 % Speichereffizienz). Bei RAID 5 genügen 4 × 4 TiByte (16 TiByte brutto, 12 TiByte netto, 75 % Speichereffizienz).
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 6](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=6>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: raid-systeme-07 | typ: anwendung | pruefung: AP2 -->
**Wie viele 4-TiB-Festplatten benötigt ein RAID-6-Array mit Hot-Spare für 26 TiB Gesamtspeicherbedarf (10 TiB DB + 6 TiB Nutzdaten + 10 TiB Puffer)?**
?
Für 26 TiB werden `26 / 4 = 6,5`, also aufgerundet 7 Datenplatten benötigt. Zusammen mit 2 Paritätsplatten (RAID 6) und 1 Hot-Spare-Platte ergibt das insgesamt 10 Festplatten.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 7](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=7>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*
