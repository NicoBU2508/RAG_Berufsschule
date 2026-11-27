---
typ: karteikarten_deck
thema: "SQL-Aggregatfunktionen und Gruppierung"
kategorie: Anwendungsentwicklung
pruefung: "AP2"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/SQL-Aggregatfunktionen und Gruppierung.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 14
quellseiten_hash: 7e442e4ab290
quellseiten:
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=37"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=38"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=39"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=40"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift#page=41"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=33"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=34"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=35"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=36"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=37"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=48"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=49"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=50"
  - "02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript#page=51"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/sql-aggregatfunktionen-und-gruppierung
---
# 🗂️ Karteikarten: SQL-Aggregatfunktionen und Gruppierung

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/SQL-Aggregatfunktionen und Gruppierung|SQL-Aggregatfunktionen und Gruppierung]] (**14 visuell geprüfte Seiten**).

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-01 | typ: definition | pruefung: AP2 -->
**Welche fünf grundlegenden SQL-Aggregatfunktionen gibt es und wofür werden sie eingesetzt?**
?
- `COUNT(...)`: Anzahl der Datensätze zählen
- `MAX(Attribut)` / `MIN(Attribut)`: Maximal- bzw. Minimalwert einer Spalte
- `AVG(Attribut)`: Durchschnittswert einer Spalte
- `SUM(Attribut)`: Werte einer Spalte addieren
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kis_Mitschrift.pdf · S. 37](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kis_Mitschrift.pdf#page=37>) (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-02 | typ: anwendung | pruefung: AP2 -->
**Wie gibt man in SQL den Durchschnittswert einer Spalte auf 2 Dezimalstellen gerundet mit einem Alias mit Leerzeichen aus?**
?
Man kombiniert `FORMAT(Ausdruck, 2)` und setzt den Alias (`AS`) mit Leerzeichen in Anführungszeichen/Hochkommas:
`SELECT FORMAT(AVG(tagesmietpreis), 2) AS "Durchschnittlicher Tagesmietpreis" FROM fahrraeder;`
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kislik.pdf · S. 48](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kislik.pdf#page=48>) (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-03 | typ: abgrenzung | pruefung: AP2 -->
**Worin unterscheiden sich `GROUP BY` (ohne Funktion) und `SELECT DISTINCT` beim Entfernen von Mehrfachnennungen?**
?
Beide fassen Datensätze mit identischen Werten zu einer Zeile zusammen. **Wichtig (ANSI-SQL, MySQL 8.0+ `ONLY_FULL_GROUP_BY`, Kislik S. 51):** Bei `GROUP BY` müssen alle nicht-aggregierten `SELECT`-Attribute im `GROUP BY` stehen (z. B. `GROUP BY ort, plz` statt nur `GROUP BY ort`). Zudem garantiert `GROUP BY` im aktuellen SQL-Standard **keine automatische Sortierung** — für garantierte Sortierreihenfolge in IHK-Prüfungen stets `ORDER BY` angeben!
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kis_Mitschrift.pdf · S. 40](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kis_Mitschrift.pdf#page=40>) (von 45) · [AE_Kislik.pdf · S. 51](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kislik.pdf#page=51>) (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-04 | typ: pruefungsfalle | pruefung: AP2 -->
**Welche Regel gilt in SQL, wenn in `SELECT` sowohl normale Attribute als auch Aggregatfunktionen stehen?**
?
Normale Attribute dürfen in `SELECT` nur dann mit Aggregatfunktionen kombiniert werden, wenn über alle diese Attribute mit `GROUP BY` Gruppen gebildet werden.
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kis_Mitschrift.pdf · S. 40](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kis_Mitschrift.pdf#page=40>) (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-05 | typ: abgrenzung | pruefung: AP2 -->
**Wie unterscheiden sich die SQL-Klauseln `WHERE` und `HAVING` bei gruppierten Abfragen?**
?
`WHERE` filtert einzelne Datensätze **vor** der Gruppenbildung. `HAVING` wirkt ausschließlich zusammen mit `GROUP BY` und legt fest, welche der bereits **gruppierten Datensätze** angezeigt werden.
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kis_Mitschrift.pdf · S. 40](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kis_Mitschrift.pdf#page=40>) (von 45) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-06 | typ: anwendung | pruefung: AP2 -->
**Wie ermittelt man in SQL die Anzahl angeschaffter Fahrräder je Kalenderjahr, aufsteigend nach Kaufjahr sortiert?**
?
Man extrahiert das Jahr mit `YEAR(kaufdatum)` und gruppiert sowie sortiert danach:
`SELECT YEAR(kaufdatum) AS "Kaufjahr", COUNT(*) AS "Anzahl" FROM fahrraeder GROUP BY YEAR(kaufdatum) ORDER BY YEAR(kaufdatum);`
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kislik.pdf · S. 50](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kislik.pdf#page=50>) (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-07 | typ: pruefungsfalle | pruefung: AP2 -->
**Wo steht in einer gruppierten Abfrage eine Filterbedingung auf Einzelzeilen (z. B. `kaufdatum < "2015-1-1"`) im Gegensatz zu einer Gruppenbedingung?**
?
Einzelzeilen-Filter stehen vor `GROUP BY` in der `WHERE`-Klausel, damit nur relevante Datensätze in die Gruppenbildung eingehen; `HAVING` wird erst nach `GROUP BY` auf die gebildeten Gruppen angewendet.
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kislik.pdf · S. 50–51](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kislik.pdf#page=50>) (von 57) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*

---

<!-- card-id: sql-aggregatfunktionen-und-gruppierung-08 | typ: code_trace | pruefung: AP2 -->
**Tabelle `vermietung(id, ort, preis, jahr)`. Schreibe eine SQL-Abfrage für alle Orte mit mindestens 5 Vermietungen im Jahr `2025`, absteigend nach der Anzahl sortiert!**
?
```sql
SELECT ort, COUNT(*) AS anzahl
FROM vermietung
WHERE jahr = 2025
GROUP BY ort
HAVING COUNT(*) >= 5
ORDER BY anzahl DESC;
```
*Quelle: AE Anwendungsentwicklung (2. LJ) · [AE_Kislik.pdf · S. 50–51](<99_Originale/Berufsschule/AE/2_LJ/AE_Kislik/AE_Kislik.pdf#page=50>) (von 62) · [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|Quellnotiz]]*
