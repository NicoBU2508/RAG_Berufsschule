---
typ: karteikarten_deck
thema: "SQL-Datenmanipulation INSERT UPDATE DELETE"
kategorie: Anwendungsentwicklung
pruefung: "AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/SQL-Datenmanipulation INSERT UPDATE DELETE.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 16
quellseiten_hash: 7dfb78071cc9
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=27"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=42"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=43"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=44"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=45"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=23"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=38"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=39"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=40"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=41"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=52"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=53"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=54"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=55"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=56"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=57"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/sql-datenmanipulation-insert-update-delete
---
# 🗂️ Karteikarten: SQL-Datenmanipulation INSERT UPDATE DELETE

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/SQL-Datenmanipulation INSERT UPDATE DELETE|SQL-Datenmanipulation INSERT UPDATE DELETE]] (**16 visuell geprüfte Seiten**).

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-01 | typ: anwendung | pruefung: AP2 -->
**Wie fügt man in SQL mit einem einzigen `INSERT`-Befehl mehrere Datensätze gleichzeitig in eine Tabelle ein?**
?
Nach `INSERT INTO <Tabelle> (<Spaltenliste>) VALUES` werden die einzelnen Datensatz-Tupel jeweils in runden Klammern angegeben und durch Kommas getrennt (Abschluss mit `;`).
Beispiel: `INSERT INTO fahrraeder (rahmennr, tagesmietpreis, fahrradart) VALUES ("380/4532", 22, "Mountainbike"), ("TS-457-5", 15, "Trekkingrad");`
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 53 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-02 | typ: anwendung | pruefung: AP2 -->
**Wie ändert man mit `UPDATE` einen numerischen Spaltenwert prozentual (z. B. um 20 % erhöhen oder um 12 % senken)?**
?
Man weist der Spalte im `SET`-Teil eine Multiplikation auf Basis des aktuellen Werts zu und grenzt die Zieldatensätze über `WHERE` ein.
Für +20 % verwendet man z. B. `SET tagesmietpreis = tagesmietpreis * 1.2`, für −12 % entsprechend `SET tagesmietpreis = tagesmietpreis * 0.88`.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 54–55 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-03 | typ: pruefungsfalle | pruefung: AP2 -->
**Welcher logische Operator muss bei `UPDATE ... WHERE` verwendet werden, wenn alle Datensätze *außer* zwei bestimmten Ausprägungen geändert werden sollen?**
?
Zwischen den Ungleich-Bedingungen (`!=`) muss `AND` stehen, z. B. `WHERE fahrradart != "Trekkingrad" AND fahrradart != "Mountainbike";`.
Ein `OR` ist eine typische Prüfungsfalle: Da kein Wert gleichzeitig beide Typen sein kann, wäre die Bedingung für jeden Datensatz wahr und würde die gesamte Tabelle ändern.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 55–56 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-04 | typ: anwendung | pruefung: AP2 -->
**Wie prüft man vor dem Ausführen eines `DELETE`-Befehls sicher, welche Datensätze gelöscht werden?**
?
Man führt zuerst eine `SELECT *`-Abfrage mit exakt derselben `FROM`- und `WHERE`-Klausel aus (z. B. `SELECT * FROM fahrraeder WHERE YEAR(kaufdatum) <= 2016 - 2;`).
Erst wenn die angezeigte Treffermenge stimmt, ersetzt man `SELECT *` durch `DELETE`.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 57 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-05 | typ: pruefungsfalle | pruefung: AP2 -->
**Wann verknüpft man Bedingungen in `DELETE ... WHERE` mit `OR` statt mit `AND`?**
?
Mit `OR`, wenn Datensätze gelöscht werden sollen, die *mindestens eine* der Teilbedingungen erfüllen (z. B. `WHERE anschaffungswert < 100 OR fahrradart = "Kinderrad";`).
`AND` würde dagegen nur Datensätze löschen, auf die beide Kriterien gleichzeitig zutreffen.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 57 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-datenmanipulation-insert-update-delete-06 | typ: definition | pruefung: AP2 -->
**Was verhindert die Option „Safe Updates“ in MySQL Workbench und was ist nach dem Ändern der Einstellung nötig?**
?
„Safe Updates“ verbietet `UPDATE`- und `DELETE`-Befehle ohne Schlüsselspalte in der `WHERE`-Klausel oder ohne `LIMIT`-Klausel.
Nach dem Setzen oder Entfernen des Hakens (unter *Edit → Preferences... → SQL Queries → General*) muss die bestehende Verbindung geschlossen und neu verbunden (*Reconnect*) werden.
*Quelle: AE Anwendungsentwicklung (2. LJ) · `AE_Kislik.pdf` S. 41 (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]], OCR/Original prüfen*
