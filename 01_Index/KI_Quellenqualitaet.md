---
id: vault.index.ki-quellenqualitaet
typ: qualitaetsbericht
status: abgeschlossen
stand: 2026-07-13
rag_include: false
tags:
  - seitenaudit
  - ki_qualitaet
  - datenschutz
---

# KI-Quellenqualität nach vollständiger Sichtprüfung

## Ergebnis

- **36 nicht-private PDFs / 902 Seiten** vollständig berücksichtigt.
- **33 aktive PDFs / 805 Seiten** seitenweise visuell geprüft.
- **3 inaktive PDFs / 97 Seiten** als pixelidentische Dubletten nachgewiesen.
- **101 kanonische Themen** mit exakten Seitenbelegen erzeugt.
- **713 Evidenzseiten**, **3 nur unterstützende Fragmentseiten**, **89 ausgeschlossene aktive Seiten**.
- Der private Notenbereich und seine PDF wurden nicht geöffnet, gerendert, geOCRt oder inhaltlich inventarisiert.

## Ausschlussgründe

| Grund | Seiten |
|---|---:|
| Exakte Seitendublette von IT_Sicherheit_Aufgabe_1.md, Seite 2 | 1 |
| Export visuell nicht belastbar: sichtbar sind nur Überschriften; Definitionen liegen außerhalb der sichtbaren Seitenfläche | 34 |
| Fachfremder Urheberrechts-Einschub; Datenschutz und externe QR-Ziele nicht freigegeben | 5 |
| Nur Index- und Lernhinweisseiten ohne eigenständigen fachlichen Lerninhalt | 2 |
| Personenbezogenes oder persönliches Bild/Fragment ohne Lernbezug | 7 |
| Reine Index-, Inhaltsverzeichnis- oder Metaseite; nur Navigation | 9 |
| Visuell leere Seite ohne Lerninhalt | 11 |
| Zu schwacher Titel-/Fragmentbeleg; nicht als alleinige Wissensevidenz verwendbar | 4 |
| Überlappende kürzere Wiki-Ausgabe; für Retrieval gilt die längere Ausgabe ab Seite 20 | 16 |

## Betroffene aktive Quellen

| Quellnotiz | Ausgeschlossene PDF-Seiten |
|---|---:|
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/01_Algorithmus_Programm_Software_EVA.md` | 37 |
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/JAVA_Java_Basics.md` | 1 |
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_4_Block.md` | 1–2 |
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_02_Unternehmenswiki_5_Block.md` | 1–2 |
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Stol.md` | 2 |
| `02_Faecher/AE_Anwendungsentwicklung/Quellen/Stol_Wiki.md` | 1–20 |
| `02_Faecher/BGWP_Betriebswirtschaft/Quellen/BGWP.md` | 54 |
| `02_Faecher/BGWP_Betriebswirtschaft/Quellen/Bgwp_schredl.md` | 16, 20 |
| `02_Faecher/Englisch/Quellen/Englisch.md` | 1, 9 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1_1.md` | 1 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Fachbegriffe.md` | 1–34 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Lernziele.md` | 1–2 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Netzplan_251022_160116.md` | 5–7 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement.md` | 16 |
| `02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann.md` | 1–2, 63–67 |
| `02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_01_AB_Ladung_Q.md` | 7, 77 |
| `02_Faecher/ITT_IT_Technik/Quellen/It_Elektro_Wild_Zusammenfassung.md` | 1 |
| `02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt.md` | 1, 6 |
| `02_Faecher/PuG_Politik_und_Gesellschaft/Quellen/Pug.md` | 1, 16 |
| `02_Faecher/Religion/Quellen/Reli_Notizen.md` | 1 |
| `02_Faecher/Vertretung/Quellen/Untitled.md` | 1 |

## Themen nach Bereich

| Bereich | Themen |
|---|---:|
| Anwendungsentwicklung | 19 |
| Deutsch Englisch Kommunikation | 19 |
| Elektrotechnik | 13 |
| IT Technik und Sicherheit | 21 |
| Religion Ethik | 6 |
| Wirtschaft und Recht | 23 |

## Technische Schutzwirkung

- Referenztabellen verweisen nur noch auf `03_Themen/Visuell_geprueft/`.
- Ausgeschlossene Seitenblöcke enthalten keine PDF-Einbettung und keinen extrahierten Inhalt mehr.
- Ganze unbrauchbare oder doppelte Quellnotizen tragen `ki_exclude: true`.
- Kontakt-, Bank- und vergleichbare Unterrichts-Beispieldaten werden in indexierbaren Texten redigiert.
- Maschinenlesbare Details: [Themenreferenzen_Visuell_Geprueft.json](<Themenreferenzen_Visuell_Geprueft.json>), [PDF_Seitenaudit.json](<PDF_Seitenaudit.json>).
