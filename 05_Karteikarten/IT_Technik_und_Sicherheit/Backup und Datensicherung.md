---
typ: karteikarten_deck
thema: "Backup und Datensicherung"
kategorie: IT_Technik_und_Sicherheit
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Backup und Datensicherung.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 9
quellseiten_hash: 1a1e9bdd5ef9
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=4"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=10"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=93"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=94"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=95"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=96"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=97"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=98"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=99"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/backup-und-datensicherung
---

# 🗂️ Karteikarten: Backup und Datensicherung

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Backup und Datensicherung|Backup und Datensicherung]] (**9 visuell geprüfte Seiten**).

---

<!-- card-id: backup-und-datensicherung-01 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin liegt der Unterschied zwischen einem Backup und einer Archivierung?**
?
- **Backup**: Sicherheitskopie für den Fall eines unerwarteten Datenverlusts, um schnell wieder auf dem aktuellen Stand zu sein.
- **Archivierung**: Aufbewahrung von Daten in einem bestimmten Zustand (z. B. für Zugriff auf ältere Versionen oder aufgrund gesetzlicher Aufbewahrungsvorschriften).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 93 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-02 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wann setzt man ein dateibasiertes Backup und wann ein Image ein?**
?
- **Backup**: Sichert ausgewählte Dateien und Verzeichnisse – ideal für persönliche bzw. selbst produzierte Daten.
- **Image**: Erstellt ein Abbild einer kompletten Partition – ideal für die schnelle Wiederherstellung des Betriebssystems (inkl. Programmkonfigurationen).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 94 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-03 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Voll-Backup, inkrementelles Backup und differenzielles Backup bei Sicherung und Wiederherstellung?**
?
- **Voll-Backup**: Sichert alle Daten; einfaches Zurückspielen, braucht aber viel Speicherplatz.
- **Inkrementell**: Sichert nur Änderungen seit dem **letzten Backup**; spart Platz, macht Restore aufwendig (Voll-Backup + alle inkrementellen in Entstehungsreihenfolge).
- **Differenziell**: Sichert alle Änderungen seit dem **letzten Voll-Backup**; Mittelweg beim Platz, für Restore genügen Voll-Backup + **letztes** differenzielles Backup.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 95 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-04 | typ: definition | pruefung: AP1/AP2 -->
**Was besagt die 3-2-1-Backup-Regel und wovor schützt sie?**
?
Sie fordert **3 Kopien** der Daten auf **2 verschiedenen Medientypen**, davon **1 Kopie an einem externen Standort**.
Dadurch schützt sie vor Hardware-Ausfall, Diebstahl, Feuer und Ransomware.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 95 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-05 | typ: anwendung | pruefung: AP1/AP2 -->
**Wie funktioniert das Großvater-Vater-Sohn-Prinzip bei der Bandrotation?**
?
Es nutzt drei Stufen (typisch 19 Bänder für ein Jahr):
- **Söhne**: 4 Bänder für tägliche inkrementelle Sicherungen (Mo–Do).
- **Väter**: 3 Bänder für wöchentliche Vollsicherungen (freitags).
- **Großväter**: 12 Monatsbänder (am letzten Freitag des Monats statt eines Wochenbands).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 97 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum ersetzt ein RAID-System kein Backup?**
?
Ein RAID stellt nur die Verfügbarkeit beim Ausfall einzelner Datenträger sicher, ermöglicht aber **keine echte Trennung zwischen Originaldaten und Backup**.
Es schützt daher z. B. nicht vor Viren (die alle Daten löschen), Ransomware oder versehentlichem Überschreiben.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 98 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: backup-und-datensicherung-07 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welche Besonderheiten und Risiken sind bei Online-/Cloud-Backups bei Dritten zu beachten?**
?
Man muss Bandbreite (z. B. Kombination aus lokalem Voll-Backup + täglichem inkrementellem Online-Backup per VPN) und Datenschutz (vertrauenswürdiger Anbieter, Rechtsraum) prüfen.
Liegen Backups bei Dritten, sollten sie **verschlüsselt** werden (z. B. mit PGP), wobei die Schlüssel sicher für den Notfall aufbewahrt werden müssen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 99 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*
