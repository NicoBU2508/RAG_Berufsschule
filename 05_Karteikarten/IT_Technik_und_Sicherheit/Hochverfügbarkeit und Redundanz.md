---
typ: karteikarten_deck
thema: Hochverfügbarkeit und Redundanz
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1/AP2"
thema_quelle: 03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hochverfügbarkeit
  und Redundanz.md
stand_karten: '2026-11-24'
stand_quelle: '2026-11-24'
quellseiten_anzahl: 14
quellseiten_hash: 69f5333389fb
quellseiten:
- 02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=2
- 02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=7
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1#page=2
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=1
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=10
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=6
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=7
rag_include: false
canonical_evidence: false
tags:
- karteikarten
- flashcards/it-technik-und-sicherheit/hochverfuegbarkeit-und-redundanz
---
# 🗂️ Karteikarten: Hochverfügbarkeit und Redundanz

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hochverfügbarkeit und Redundanz|Hochverfügbarkeit und Redundanz]] (**14 visuell geprüfte Seiten**).

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-01 | typ: definition | pruefung: AP1/AP2 -->
**Was versteht man unter Hochverfügbarkeit in Abgrenzung zur Fehlertoleranz und welche drei Standby-Stufen werden unterschieden?**
?
Hochverfügbarkeit ist eine Weiterführung der Fehlertoleranz, bei der Systeme als Ganze mehrfach vorhanden sind. Unterschieden werden Bare Metal (nur Hardware redundant, OS und Backup müssen erst eingespielt werden), Cold Standby (Ersatzsystem bei Bedarf hochfahren) und Hot Standby (Ersatzsystem übernimmt automatisch und sofort).
*Quelle: ITT IT-Technik (1. LJ) · `Aufgabe 1.pdf` S. 3 (von 4) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|Quellnotiz]]*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-02 | typ: definition | pruefung: AP1/AP2 -->
**Was ist ein RAID-System und welches Grundziel verfolgt es?**
?
RAID (*Redundant Array of Independent Disks*) kombiniert mehrere Festplatten zu einem logischen Laufwerk und verteilt oder spiegelt Daten mit gezielten Redundanzinformationen. So behält das System bei Ausfall einzelner Speichermedien seine Funktionalität und Integrität, sodass Daten rekonstruiert werden können.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 3 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich RAID 0, RAID 1 und RAID 10 hinsichtlich Mindestplattenanzahl, Ausfalltoleranz und Nettokapazität (bei `n` gleichen Platten der Größe `S`)?**
?
- **RAID 0 (Striping):** mind. 2 Platten, Ausfalltoleranz 0 (Totalverlust bei Ausfall), Kapazität `K = n * S`.
- **RAID 1 (Mirroring):** mind. 2 Platten, Ausfalltoleranz 1 Platte, Kapazität `K = 0,5 * n * S` (50 % Nutzung).
- **RAID 10 (RAID 1+0):** mind. 4 Platten, Ausfalltoleranz mind. 1 Platte (max. `n/2`, falls nicht beide Platten eines Spiegels ausfallen), Kapazität `K = 0,5 * n * S`.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 3 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-04 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich RAID 5 und RAID 6 bei Parität, Mindestanzahl der Platten, Ausfalltoleranz und Nettokapazität?**
?
- **RAID 5:** Striping mit einfacher verteilter Parität; mind. 3 Platten, Ausfalltoleranz 1 Platte, Nettokapazität `K = (n - 1) * S`.
- **RAID 6:** Striping mit doppelter verteilter Parität; mind. 4 Platten, Ausfalltoleranz 2 Platten gleichzeitig, Nettokapazität `K = (n - 2) * S` (dafür sehr langsames Schreiben und lange Rebuilds).
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 4 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-05 | typ: anwendung | pruefung: AP1/AP2 -->
**Ein NAS mit 4 Festplatten soll 12 TiByte Nettokapazität bereitstellen. Welche Plattengröße (aus 4, 6 oder 8 TiByte) ist nötig und wie viele Platten dürfen bei RAID 10 bzw. RAID 5 maximal gleichzeitig ausfallen?**
?
Bei RAID 5 (`K = (4 - 1) * S`) reichen 4-TiByte-Platten (3 × 4 = 12 TiByte), bei RAID 10 (`K = 0,5 * 4 * S`) sind 6-TiByte-Platten nötig (2 × 6 = 12 TiByte). Ohne Datenverlust dürfen bei RAID 5 maximal 1 Platte und bei RAID 10 bis zu 2 Platten aus unterschiedlichen Spiegelpaaren gleichzeitig ausfallen.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 5 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-06 | typ: definition | pruefung: AP1/AP2 -->
**Welche Funktion hat eine Hot-Spare-Festplatte in einem RAID-Verbund und was leistet die Parität?**
?
Eine **Hot-Spare-Festplatte** ist eine eingebaute, betriebsbereite Reserveplatte, die im Normalbetrieb ungenutzt bleibt und bei Ausfall einer aktiven Platte automatisch einspringt. Die **Parität** ist eine aus den Datenblöcken berechnete Prüfinformation, mit der ein verlorener Datenblock wiederhergestellt werden kann.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 4–5 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-07 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum ersetzt ein RAID-System (z. B. RAID 1, 5 oder 6) kein Backup?**
?
Ein RAID erhöht nur die Ausfallsicherheit beim Defekt einzelner Festplatten, sodass das System weiterläuft und Daten rekonstruiert werden können. Logische Schäden oder ungewollte Änderungen/Löschungen werden sofort auf alle Platten gespiegelt – für die Wiederherstellung früherer Stände bleiben eigenständige Backups (z. B. inkrementell oder differenziell) unverzichtbar.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 4 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-08 | typ: anwendung | pruefung: AP1/AP2 -->
**Für einen Datenbankserver werden 26 TiB Nettokapazität (10 TiB Datenbank + 6 TiB Nutzdaten + 10 TiB Puffer) auf 4-TiB-Festplatten benötigt. Wie viele Festplatten sind bei RAID 6 mit einer Hot-Spare-Festplatte mindestens erforderlich?**
?
Mindestens **10 Festplatten** (`40 TiB` brutto): `26 TiB / 4 TiB = 6,5` → aufgerundet **7 Datenplatten** (`28 TiB` netto ≥ `26 TiB`), plus **2 Paritätsplatten** für RAID 6 (`K = (n - 2) * S`) sowie **1 Hot-Spare-Festplatte** als Reserve.
*Quelle: ITT IT-Technik (2. LJ) · `Mitschriften_Abde.pdf` S. 7 (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*
