---
id: vault.audit.pdf-seiten
typ: visueller_pdf_seitenaudit
status: vollständig
stand: 2026-11-26
reviewed_on: 2026-11-26
ki_prioritaet: 1
tags:
  - ki_quelle
  - qualitaetssicherung
  - pdf_audit
---

# Visueller PDF-Seitenaudit

Alle **53 aktiven nichtprivaten PDFs mit 1403 Seiten** wurden vollständig visuell geprüft. Zusätzlich wurden **0 inaktive PDFs mit 0 Seiten** vollständig gerendert und als pixelidentische Dubletten aktiver PDFs bestätigt. Damit sind **53 nichtprivate PDFs und 1403 Seiten** abgedeckt.

> [!privacy] Bewusst ausgeschlossen
> Die private Noten-PDF unter `98_Archiv_nicht_lernen/Privat_Noten_nicht_fuer_KI/` wurde nicht geöffnet, gerendert, gehasht oder inhaltlich gelesen.

## Methode

Jede Seite wurde über vollständig gerenderte Kontaktbögen oder Einzelseiten bei Originaldetail gesichtet. Sichtinhalt, lokaler Quelltext, bisherige Modulreferenzen und kuratierte Themen wurden seitenweise verglichen. Das maschinenlesbare Ergebnis mit einer Zeile pro aktiver PDF-Seite steht in [[01_Index/PDF_Seitenaudit.json|PDF_Seitenaudit.json]].

## Gesamtbefund vor der Korrektur

- Textabgleich: `missing` 28, `ocr_error` 22, `ok` 938, `partial` 415
- Themen-/Modulmapping: `correct` 86, `excluded` 23, `missing` 306, `mixed` 413, `ok` 339, `overbroad` 229, `verified` 7
- Inhaltstypen: `aufgabe` 239, `beispiel` 130, `formular` 17, `fragment` 55, `index` 34, `leer` 19, `loesung` 324, `theorie` 585
- Prüfsicherheit: `high` 1369, `medium` 34

## Abdeckung nach Quelle

| Quellnotiz | Fach | Seiten | Textabgleich | Mapping vor Korrektur |
|---|---|---:|---|---|
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA|01_Algorithmus_Programm_Software_EVA]] | AE_Anwendungsentwicklung | 100 | `ocr_error` 10, `ok` 88, `partial` 2 | `missing` 18, `mixed` 69, `ok` 11, `overbroad` 2 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Eix_Mitschrift|AE_2LJ_Eix_Mitschrift]] | AE_Anwendungsentwicklung | 26 | `ok` 18, `partial` 8 | `ok` 26 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Jac_Mitschrift|AE_2LJ_Jac_Mitschrift]] | AE_Anwendungsentwicklung | 20 | `partial` 20 | `ok` 20 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_LF1_Wiederholung|AE_2LJ_Kislik_LF1_Wiederholung]] | AE_Anwendungsentwicklung | 1 | `ok` 1 | `missing` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Mitschrift|AE_2LJ_Kislik_Mitschrift]] | AE_Anwendungsentwicklung | 45 | `ok` 39, `partial` 6 | `missing` 40, `ok` 5 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/AE_2LJ_Kislik_Skript|AE_2LJ_Kislik_Skript]] | AE_Anwendungsentwicklung | 62 | `ok` 52, `partial` 10 | `missing` 55, `ok` 7 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/JAVA_Java_Basics|JAVA_Java_Basics]] | AE_Anwendungsentwicklung | 4 | `missing` 1, `ok` 2, `partial` 1 | `correct` 1, `missing` 1, `mixed` 2 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_4_Block|Stol_02_Unternehmenswiki_4_Block]] | AE_Anwendungsentwicklung | 48 | `ok` 48 | `mixed` 47, `overbroad` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_5_Block|Stol_02_Unternehmenswiki_5_Block]] | AE_Anwendungsentwicklung | 56 | `ok` 56 | `mixed` 55, `overbroad` 1 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_7_Block|Stol_02_Unternehmenswiki_7_Block]] | AE_Anwendungsentwicklung | 71 | `ok` 71 | `excluded` 2, `ok` 69 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_260210_092824|Stol_Lernzettel_260210_092824]] | AE_Anwendungsentwicklung | 4 | `missing` 1, `ok` 3 | `mixed` 4 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Lernzettel_AEuP_Stol|Stol_Lernzettel_AEuP_Stol]] | AE_Anwendungsentwicklung | 3 | `missing` 1, `ok` 2 | `mixed` 3 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Stol|Stol_Stol]] | AE_Anwendungsentwicklung | 8 | `ok` 8 | `correct` 1, `mixed` 3, `ok` 4 |
| [[02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Wiki|Stol_Wiki]] | AE_Anwendungsentwicklung | 48 | `missing` 1, `ok` 47 | `mixed` 47, `overbroad` 1 |
| [[02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41|Gescanntes_Dokument_16_09_25_um_11_21_41]] | Allgemein_Berufsschule | 4 | `ocr_error` 2, `partial` 2 | `missing` 2, `ok` 2 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP|BGWP]] | BGWP_Betriebswirtschaft | 83 | `ok` 77, `partial` 6 | `excluded` 1, `mixed` 48, `ok` 28, `overbroad` 6 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Mitschrift|BGWP_2LJ_Mitschrift]] | BGWP_Betriebswirtschaft | 35 | `missing` 1, `ok` 14, `partial` 20 | `ok` 35 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP_2LJ_Unbenannt_Einzelseite|BGWP_2LJ_Unbenannt_Einzelseite]] | BGWP_Betriebswirtschaft | 1 | `ok` 1 | `missing` 1 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/Bgwp_schredl|Bgwp_schredl]] | BGWP_Betriebswirtschaft | 45 | `ok` 44, `partial` 1 | `mixed` 6, `ok` 3, `overbroad` 36 |
| [[02_Faecher/BGWP_Betriebswirtschaft/Quellen/ZusammenfassungBGWP|ZusammenfassungBGWP]] | BGWP_Betriebswirtschaft | 7 | `missing` 1, `partial` 6 | `mixed` 3, `overbroad` 4 |
| [[02_Faecher/Deutsch/Quellen/Deutsch|Deutsch]] | Deutsch | 46 | `ok` 46 | `mixed` 30, `overbroad` 16 |
| [[02_Faecher/Deutsch/Quellen/Deutsch_2LJ_Skript|Deutsch_2LJ_Skript]] | Deutsch | 44 | `ok` 31, `partial` 13 | `excluded` 3, `missing` 34, `ok` 7 |
| [[02_Faecher/Deutsch/Quellen/Regelsammlung|Regelsammlung]] | Deutsch | 10 | `ok` 10 | `mixed` 7, `overbroad` 3 |
| [[02_Faecher/Deutsch/Quellen/Station_1|Station_1]] | Deutsch | 2 | `ok` 2 | `overbroad` 2 |
| [[02_Faecher/Englisch/Quellen/Englisch|Englisch]] | Englisch | 49 | `missing` 1, `ok` 47, `partial` 1 | `mixed` 45, `overbroad` 4 |
| [[02_Faecher/Englisch/Quellen/Englisch_2LJ_Conditionals|Englisch_2LJ_Conditionals]] | Englisch | 20 | `missing` 1, `ok` 16, `partial` 3 | `missing` 14, `ok` 6 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Begriffe_Computerwelt_Gitterratsel|Begriffe_Computerwelt_Gitterratsel]] | ITT_IT_Technik | 1 | `partial` 1 | `correct` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|FU_IT_2LJ_Abded_Mitschriften]] | ITT_IT_Technik | 7 | `missing` 2, `partial` 5 | `missing` 4, `ok` 3 |
| [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Ott_OSI_Modell|FU_IT_2LJ_Ott_OSI_Modell]] | ITT_IT_Technik | 37 | `ok` 14, `partial` 23 | `excluded` 4, `missing` 29, `ok` 4 |
| [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|FU_IT_2LJ_Zielske_IPv4_Wiederholung]] | ITT_IT_Technik | 14 | `ok` 6, `partial` 8 | `missing` 13, `ok` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Grundausbildung_IT]] | ITT_IT_Technik | 16 | `missing` 2, `partial` 14 | `correct` 14, `excluded` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|IT_Sicherheit_Aufgabe_1]] | ITT_IT_Technik | 4 | `ok` 3, `partial` 1 | `mixed` 4 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1_1|IT_Sicherheit_Aufgabe_1_1]] | ITT_IT_Technik | 1 | `ok` 1 | `correct` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Fachbegriffe|IT_Sicherheit_Fachbegriffe]] | ITT_IT_Technik | 34 | `ok` 1, `partial` 33 | `overbroad` 34 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Lernziele|IT_Sicherheit_Lernziele]] | ITT_IT_Technik | 2 | `partial` 2 | `correct` 1, `overbroad` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Netzplan_251022_160116|IT_Sicherheit_Netzplan_251022_160116]] | ITT_IT_Technik | 7 | `ok` 3, `partial` 4 | `mixed` 7 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement|IT_Sicherheit_Sicherheitsmanagement]] | ITT_IT_Technik | 16 | `ocr_error` 3, `partial` 13 | `correct` 4, `mixed` 8, `ok` 3, `overbroad` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|IT_Sicherheit_Skript_Wittmann]] | ITT_IT_Technik | 103 | `missing` 6, `ok` 79, `partial` 18 | `correct` 41, `excluded` 9, `missing` 25, `mixed` 8, `ok` 2, `overbroad` 18 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Urheberrecht|IT_Sicherheit_Urheberrecht]] | ITT_IT_Technik | 5 | `ok` 5 | `correct` 5 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung|IT_Tech_2LJ_Jacob_Verstaerkung_Daempfung]] | ITT_IT_Technik | 8 | `ok` 4, `partial` 4 | `missing` 4, `ok` 4 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|IT_Tech_2LJ_Liebscher_Mitschrift]] | ITT_IT_Technik | 18 | `ok` 11, `partial` 7 | `missing` 17, `verified` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|IT_Tech_2LJ_Zielske_Node_RED]] | ITT_IT_Technik | 9 | `ok` 3, `partial` 6 | `missing` 9 |
| [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q|It_Elektro_Wild_01_AB_Ladung_Q]] | ITT_IT_Technik | 101 | `missing` 2, `ok` 1, `partial` 98 | `correct` 11, `missing` 21, `ok` 43, `overbroad` 26 |
| [[02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_Zusammenfassung|It_Elektro_Wild_Zusammenfassung]] | ITT_IT_Technik | 8 | `missing` 1, `partial` 7 | `mixed` 1, `ok` 6, `overbroad` 1 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Otma_Netzwerkt]] | ITT_IT_Technik | 13 | `missing` 2, `partial` 11 | `correct` 5, `mixed` 6, `overbroad` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Aufgabenblatt_mogliche_Losung|Stol_Aufgabenblatt_mogliche_Losung]] | ITT_IT_Technik | 4 | `ok` 3, `partial` 1 | `mixed` 2, `overbroad` 2 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Skript|Stol_Skript]] | ITT_IT_Technik | 54 | `ok` 38, `partial` 16 | `missing` 18, `ok` 1, `overbroad` 35 |
| [[02_Faecher/ITT_IT_Technik/Quellen/Stol_Zusammenfassung_260120_080521|Stol_Zusammenfassung_260120_080521]] | ITT_IT_Technik | 4 | `partial` 4 | `mixed` 4 |
| [[02_Faecher/PuG_Politik_und_Gesellschaft/Quellen/PuG_2LJ_Mitschrift|PuG_2LJ_Mitschrift]] | PuG_Politik_und_Gesellschaft | 19 | `ok` 7, `partial` 12 | `ok` 19 |
| [[02_Faecher/PuG_Politik_und_Gesellschaft/Quellen/Pug|Pug]] | PuG_Politik_und_Gesellschaft | 51 | `missing` 1, `ok` 31, `partial` 19 | `correct` 1, `mixed` 1, `ok` 16, `overbroad` 33 |
| [[02_Faecher/Religion/Quellen/Ethik_2LJ_Skript_Gewissen|Ethik_2LJ_Skript_Gewissen]] | Religion | 14 | `missing` 2, `ok` 5, `partial` 7 | `excluded` 2, `ok` 6, `verified` 6 |
| [[02_Faecher/Religion/Quellen/Reli_Notizen|Reli_Notizen]] | Religion | 7 | `missing` 1, `ocr_error` 5, `partial` 1 | `mixed` 2, `ok` 5 |
| [[02_Faecher/Vertretung/Quellen/Untitled|Untitled]] | Vertretung | 4 | `missing` 1, `ocr_error` 2, `partial` 1 | `mixed` 1, `ok` 3 |

## Kanonische Schicht nach der Korrektur

- **140 visuell geprüfte Themen**
- **1136 direkte Evidenzseiten**
- **11 nur unterstützende Fragmentseiten**
- **256 ausgeschlossene aktive Seiten**
- **296 alte Lernordner-Referenzen vollständig ersetzt**

Die korrigierte Zuordnung steht in [[03_Themen/00_Kuratierte_Themen|Visuell geprüfte Themen]], [[01_Index/KI_Quellenqualitaet|KI-Quellenqualität]] und [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>). Die Tabelle oben bleibt als dokumentierter Ausgangsbefund **vor** der Korrektur erhalten.

## Belegregel

Der Audit bestätigt die semantische Zuordnung, ersetzt aber keine Originalquelle. Für Zahlen, Formeln, Tabellen, Rechtsnormen, Handschrift und OCR-unsichere Stellen immer die verlinkte PDF-Seite öffnen.
