---
typ: "bericht"
status: "graph-coverage-repariert"
---

# ✅ Graph-Coverage-Reparaturbericht

## Ergebnis

- Alle Fach-Lernordner wurden aus den aktiven Quellen neu aufgebaut.
- Jede aktive PDF-Seite wurde mindestens einem sinnvollen Fachthema zugeordnet.
- Seiten mit Mehrfachbezug wurden mehrfach in die passenden Themenmodule aufgenommen.
- Automatische `Sonstiges`-Knoten wurden durch echte Themen wie `Kryptografie Verschlüsselung Hash Signatur`, `Elterngeld und Elternzeit`, `Projektplanung und Netzplanmethode` usw. ersetzt.

## Kennzahlen

- Aktive Quellseiten: **805**
- Abgedeckte Quellseiten: **805**
- Nicht abgedeckte Quellseiten: **0**
- Themenmodule neu erzeugt: **128**

| Fach | Quellseiten | Abgedeckt | Fehlend | Themenmodule | Seiten-Themen-Referenzen |
|---|---:|---:|---:|---:|---:|
| AE Anwendungsentwicklung | 258 | 258 | 0 | 23 | 1634 |
| Allgemein Berufsschule | 4 | 4 | 0 | 5 | 8 |
| BGWP Betriebswirtschaft | 105 | 105 | 0 | 19 | 587 |
| Deutsch | 58 | 58 | 0 | 13 | 194 |
| Englisch | 49 | 49 | 0 | 15 | 170 |
| ITT IT-Technik | 286 | 286 | 0 | 27 | 1253 |
| PuG Politik und Gesellschaft | 35 | 35 | 0 | 14 | 146 |
| Religion | 6 | 6 | 0 | 9 | 17 |
| Vertretung | 4 | 4 | 0 | 3 | 6 |

## Beispiel: Schleifen vollständig repariert

Das Thema `Schleifen` enthält jetzt **42 eindeutige PDF-Seiten**. Enthalten sind explizit die vorher fehlenden Seiten aus `01_Algorithmus_Programm_Software_EVA`: S10, S18, S19, S37, S38, S39, S40.

| Quelle | Seiten im Schleifen-Modul |
|---|---|
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA\|01_Algorithmus_Programm_Software_EVA]] | 10, 13, 17, 18, 19, 20, 21, 22, 23, 29, 31, 32, 33, 34, 37, 38, 39, 40, 41, 44, 46, 56, 59, 61, 62, 70, 75, 76, 77 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/JAVA_Java_Basics\|JAVA_Java_Basics]] | 3, 4 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_4_Block\|Stol_02_Unternehmenswiki_4_Block]] | 3, 24, 33 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_5_Block\|Stol_02_Unternehmenswiki_5_Block]] | 3, 24, 33 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824\|Stol_Lernzettel_260210_092824]] | 3, 4 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Wiki\|Stol_Wiki]] | 4, 21, 42 |

## Neue/aufgelöste Themenblöcke

- ITT: Kryptografie, Hash, AES, Signaturen, Backuparten, Malware, PDCA/ISMS und Sicherheitsmanagement sind keine `Sonstiges`-Knoten mehr.
- PuG: `Elterngeld und Elternzeit`, `Tarifvertrag und Koalitionsrecht`, `Betriebsrat und Betriebsverfassung` wurden als eigene Themen ergänzt.
- BGWP: Wirtschaftssektoren, Marktformen, Handelsregister/Vollmachten und Netzplanmethode wurden als eigene Themenblöcke angelegt.
- Deutsch: Kommunikation/Eisbergmodell und Lastenheft/Pflichtenheft wurden besser getrennt.
- Englisch: Telefonieren, Company Structure, Websites, Ordering Technical Products und Hardware/Vocabulary wurden eigene Suchthemen.
- Religion: Freiheit, Symbole, Paulus, Gewissen, Mandela und Karwoche wurden getrennt.

## Hinweis zur Bedeutung von Vollständigkeit

Eine Seite kann in mehreren Themen vorkommen. Das ist Absicht: Wenn eine Seite z. B. Arrays **und** Schleifen behandelt, steht sie in beiden Modulen. Dadurch funktioniert der Graph als Lernsystem und nicht nur als Ablage nach PDF-Reihenfolge.

## Finaler Linkcheck

- Interne Wiki-Links geprüft: **7444**
- Potenziell kaputte interne Wiki-Links: **0**
- Weiterleitungen/Aliase für alte Graph-Links: **16**
