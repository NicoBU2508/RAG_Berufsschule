---
typ: karteikarten_deck
thema: "Datenbankgrundlagen und Datenbankentwicklung"
kategorie: Anwendungsentwicklung
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Datenbankgrundlagen und Datenbankentwicklung.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 18
quellseiten_hash: 0c0e22abd6f9
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_LF1_Wiederholung#page=1"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=11"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=12"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=13"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=16"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=4"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=5"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=6"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=7"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=8"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=9"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=12"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=3"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=4"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=5"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=6"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=7"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=8"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/datenbankgrundlagen-und-datenbankentwicklung
---

# 🗂️ Karteikarten: Datenbankgrundlagen und Datenbankentwicklung

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Datenbankgrundlagen und Datenbankentwicklung|Datenbankgrundlagen und Datenbankentwicklung]] (**18 visuell geprüfte Seiten**).

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-01 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Welche Nachteile hat eine isolierte Dateihaltung (z. B. in Excel) im Vergleich zu einem Datenbanksystem?**
?
Durch Mehrfachspeicherung gleicher Daten in getrennten Anwendungen werden Speicherplatz verschwendet, Prozesse ineffizient und Daten bei unterschiedlichen Änderungen widersprüchlich (inkonsistent).
Zudem lädt Excel beim Öffnen den gesamten Datenbestand in den Hauptspeicher, während ein Datenbanksystem nur unmittelbar benötigte Daten lädt und bei großen Mengen deutlich performanter ist.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 4 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-02 | typ: definition | pruefung: AP1/AP2 -->
**Aus welchen zwei Hauptbestandteilen besteht ein Datenbanksystem und welche vier Aufgaben übernimmt das DBMS?**
?
Es besteht aus dem Datenbankmanagementsystem (DBMS) und der Datenbasis (Datenbank).
Das DBMS übernimmt: 1. Definition (Aufbau der Datenstruktur), 2. Manipulation (Eingeben, Ändern, Löschen), 3. Abfrage (Informationsgewinnung) und 4. Kontrolle (Zugangs- und Zugriffsrechte verwalten).
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 5 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-03 | typ: definition | pruefung: AP1/AP2 -->
**Wie hängen im relationalen Datenmodell Relation, Tupel, Entität, Attribut und Datentyp zusammen?**
?
Gleichartige Entitäten (reale oder abstrakte Objekte) werden in einer Tabelle (Relation) gespeichert; jede Tabellenzeile bildet eine Entität als Datensatz (Tupel) ab.
Die Spalten heißen Attribute (gespeichert in Datenfeldern) und erhalten zur leichteren Speicherung und Fehlervermeidung einen festgelegten Datentyp samt Größe.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 5–6 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-04 | typ: definition | pruefung: AP1/AP2 -->
**Wie lauten die vier Phasen der Datenbankentwicklung und was geschieht in den ersten beiden Phasen?**
?
Die Phasen lauten: 1. Externe Phase → 2. Konzeptionelle Phase → 3. Logische Phase → 4. Physische Phase.
In der externen Phase wird der Informationsbedarf der „Miniwelt“ ermittelt und informal beschrieben (Interviews, Dokumentenanalyse); in der konzeptionellen Phase entsteht daraus ein grafisches semantisches Modell (ER-Modell).
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 7, 13 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-05 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Worin unterscheiden sich die logische Phase und die physische Phase der Datenbankentwicklung?**
?
In der logischen Phase wird das ER-Modell in ein relationales Tabellenschema überführt, durch Normalisierung optimiert (Redundanzabbau) und der Beziehungstyp festgelegt.
In der physischen Phase wird dieses Schema konkret mit Datentypen, Wertebereichen, Gültigkeitsregeln und Speicherungsstrukturen in einem DBMS umgesetzt, sodass am Ende die Datenbank existiert.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 8–9, 13 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: datenbankgrundlagen-und-datenbankentwicklung-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Welche Phasen der Datenbankentwicklung sind vom DBMS unabhängig und welche ist vom DBMS abhängig?**
?
Die externe, konzeptionelle und logische Phase sind vollständig vom Datenbankmanagementsystem (DBMS) unabhängig.
Erst die vierte und letzte Phase – die physische Phase – ist vom eingesetzten DBMS abhängig.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kis_Mitschrift.pdf` S. 7–9, 13 (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*
