---
id: vault.audit.pdf-seiten
typ: visueller_pdf_seitenaudit
status: vollständig
stand: 2026-07-13
reviewed_on: 2026-07-13
ki_prioritaet: 1
tags:
  - ki_quelle
  - qualitaetssicherung
  - pdf_audit
---

# Visueller PDF-Seitenaudit

Alle **33 aktiven nichtprivaten PDFs mit 805 Seiten** wurden vollständig visuell geprüft. Zusätzlich wurden **3 inaktive PDFs mit 97 Seiten** vollständig gerendert und als pixelidentische Dubletten aktiver PDFs bestätigt. Damit sind **36 nichtprivate PDFs und 902 Seiten** abgedeckt.

> [!privacy] Bewusst ausgeschlossen
> Die private Noten-PDF unter `98_Archiv_nicht_lernen/Privat_Noten_nicht_fuer_KI/` wurde nicht geöffnet, gerendert, gehasht oder inhaltlich gelesen.

## Methode

Jede Seite wurde über vollständig gerenderte Kontaktbögen oder Einzelseiten bei Originaldetail gesichtet. Sichtinhalt, lokaler Quelltext, bisherige Modulreferenzen und kuratierte Themen wurden seitenweise verglichen. Das maschinenlesbare Ergebnis mit einer Zeile pro aktiver PDF-Seite steht in [[01_Index/PDF_Seitenaudit.json|PDF_Seitenaudit.json]].

## Gesamtbefund vor der Korrektur

- Textabgleich: `missing` 14, `ocr_error` 22, `ok` 553, `partial` 216
- Themen-/Modulmapping: `correct` 35, `missing` 72, `mixed` 433, `overbroad` 265
- Inhaltstypen: `aufgabe` 163, `beispiel` 55, `formular` 11, `fragment` 49, `index` 15, `leer` 11, `loesung` 200, `theorie` 301
- Prüfsicherheit: `high` 768, `medium` 37

## Abdeckung nach Quelle

| Quellnotiz | Fach | Seiten | Textabgleich | Mapping vor Korrektur |
|---|---|---:|---|---|
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|01_Algorithmus_Programm_Software_EVA]] | AE_Anwendungsentwicklung | 87 | `ocr_error` 10, `ok` 76, `partial` 1 | `missing` 9, `mixed` 76, `overbroad` 2 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/JAVA_Java_Basics|JAVA_Java_Basics]] | AE_Anwendungsentwicklung | 4 | `missing` 1, `ok` 2, `partial` 1 | `correct` 1, `missing` 1, `mixed` 2 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_4_Block|Stol_02_Unternehmenswiki_4_Block]] | AE_Anwendungsentwicklung | 48 | `ok` 48 | `mixed` 47, `overbroad` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_5_Block|Stol_02_Unternehmenswiki_5_Block]] | AE_Anwendungsentwicklung | 56 | `ok` 56 | `mixed` 55, `overbroad` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824|Stol_Lernzettel_260210_092824]] | AE_Anwendungsentwicklung | 4 | `missing` 1, `ok` 3 | `mixed` 4 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_AEuP_Stol|Stol_Lernzettel_AEuP_Stol]] | AE_Anwendungsentwicklung | 3 | `missing` 1, `ok` 2 | `mixed` 3 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Stol|Stol_Stol]] | AE_Anwendungsentwicklung | 8 | `ok` 8 | `correct` 1, `mixed` 6, `overbroad` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Wiki|Stol_Wiki]] | AE_Anwendungsentwicklung | 48 | `missing` 1, `ok` 47 | `mixed` 47, `overbroad` 1 |
| [[02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41|Gescanntes_Dokument_16_09_25_um_11_21_41]] | Allgemein_Berufsschule | 4 | `ocr_error` 2, `partial` 2 | `missing` 3, `mixed` 1 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP|BGWP]] | BGWP_Betriebswirtschaft | 54 | `ok` 54 | `mixed` 48, `overbroad` 6 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/Bgwp_schredl|Bgwp_schredl]] | BGWP_Betriebswirtschaft | 44 | `ok` 44 | `mixed` 6, `overbroad` 38 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/ZusammenfassungBGWP|ZusammenfassungBGWP]] | BGWP_Betriebswirtschaft | 7 | `missing` 1, `partial` 6 | `mixed` 3, `overbroad` 4 |
| [[02_Faecher/Deutsch/Quellen/Deutsch|Deutsch]] | Deutsch | 46 | `ok` 46 | `mixed` 30, `overbroad` 16 |
| [[02_Faecher/Deutsch/Quellen/Regelsammlung|Regelsammlung]] | Deutsch | 10 | `ok` 10 | `mixed` 7, `overbroad` 3 |
| [[02_Faecher/Deutsch/Quellen/Station_1|Station_1]] | Deutsch | 2 | `ok` 2 | `overbroad` 2 |
| [[02_Faecher/Englisch/Quellen/Englisch|Englisch]] | Englisch | 49 | `missing` 1, `ok` 47, `partial` 1 | `mixed` 45, `overbroad` 4 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Begriffe_Computerwelt_Gitterratsel|Begriffe_Computerwelt_Gitterratsel]] | ITT_IT_Technik | 1 | `partial` 1 | `correct` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|IT_Sicherheit_Aufgabe_1]] | ITT_IT_Technik | 4 | `ok` 3, `partial` 1 | `mixed` 4 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1_1|IT_Sicherheit_Aufgabe_1_1]] | ITT_IT_Technik | 1 | `ok` 1 | `correct` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Fachbegriffe|IT_Sicherheit_Fachbegriffe]] | ITT_IT_Technik | 34 | `ok` 1, `partial` 33 | `overbroad` 34 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Lernziele|IT_Sicherheit_Lernziele]] | ITT_IT_Technik | 2 | `partial` 2 | `correct` 1, `overbroad` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Netzplan_251022_160116|IT_Sicherheit_Netzplan_251022_160116]] | ITT_IT_Technik | 7 | `ok` 3, `partial` 4 | `mixed` 7 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement|IT_Sicherheit_Sicherheitsmanagement]] | ITT_IT_Technik | 16 | `ocr_error` 3, `partial` 13 | `correct` 5, `mixed` 9, `overbroad` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|IT_Sicherheit_Skript_Wittmann]] | ITT_IT_Technik | 67 | `ok` 59, `partial` 8 | `correct` 14, `missing` 25, `mixed` 10, `overbroad` 18 |
| [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|It_Elektro_Wild_01_AB_Ladung_Q]] | ITT_IT_Technik | 90 | `missing` 2, `partial` 88 | `missing` 34, `overbroad` 56 |
| [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_Zusammenfassung|It_Elektro_Wild_Zusammenfassung]] | ITT_IT_Technik | 8 | `missing` 1, `partial` 7 | `mixed` 7, `overbroad` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Otma_Netzwerkt]] | ITT_IT_Technik | 12 | `missing` 2, `partial` 10 | `correct` 4, `mixed` 6, `overbroad` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Aufgabenblatt_mogliche_Losung|Stol_Aufgabenblatt_mogliche_Losung]] | ITT_IT_Technik | 4 | `ok` 3, `partial` 1 | `mixed` 2, `overbroad` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Skript|Stol_Skript]] | ITT_IT_Technik | 36 | `ok` 20, `partial` 16 | `overbroad` 36 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Zusammenfassung_260120_080521|Stol_Zusammenfassung_260120_080521]] | ITT_IT_Technik | 4 | `partial` 4 | `mixed` 4 |
| [[02_Faecher/PuG_Politik_und_Gesellschaft/Quellen/Pug|Pug]] | PuG_Politik_und_Gesellschaft | 35 | `missing` 1, `ok` 18, `partial` 16 | `correct` 1, `mixed` 1, `overbroad` 33 |
| [[02_Faecher/Religion/Quellen/Reli_Notizen|Reli_Notizen]] | Religion | 6 | `missing` 1, `ocr_error` 5 | `correct` 3, `mixed` 2, `overbroad` 1 |
| [[02_Faecher/Vertretung/Quellen/Untitled|Untitled]] | Vertretung | 4 | `missing` 1, `ocr_error` 2, `partial` 1 | `correct` 3, `mixed` 1 |

## Kanonische Schicht nach der Korrektur

- **101 visuell geprüfte Themen**
- **713 direkte Evidenzseiten**
- **3 nur unterstützende Fragmentseiten**
- **89 ausgeschlossene aktive Seiten**
- **296 alte Lernordner-Referenzen vollständig ersetzt**

Die korrigierte Zuordnung steht in [[03_Themen/00_Kuratierte_Themen|Visuell geprüfte Themen]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>). Die Tabelle oben bleibt als dokumentierter Ausgangsbefund **vor** der Korrektur erhalten.

## Belegregel

Der Audit bestätigt die semantische Zuordnung, ersetzt aber keine Originalquelle. Für Zahlen, Formeln, Tabellen, Rechtsnormen, Handschrift und OCR-unsichere Stellen immer die verlinkte PDF-Seite öffnen.
