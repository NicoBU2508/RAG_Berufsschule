---
typ: karteikarten_deck
thema: "Power Apps und Power Automate"
kategorie: Anwendungsentwicklung
pruefung: "BS"
thema_quelle: "03_Themen/Visuell_geprueft/Anwendungsentwicklung/Power Apps und Power Automate.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 2
quellseiten_hash: 10159c1ea9bf
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=6"
  - "02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT#page=7"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/anwendungsentwicklung/power-apps-und-power-automate
---
# 🗂️ Karteikarten: Power Apps und Power Automate

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Power Apps und Power Automate|Power Apps und Power Automate]] (**2 visuell geprüfte Seiten**).

---

<!-- card-id: power-apps-und-power-automate-01 | typ: definition | pruefung: BS -->
**Wofür wird Microsoft Power Apps eingesetzt und welche typischen Elemente kommen in der Oberfläche zum Einsatz?**
?
Power Apps ermöglicht das Erstellen eigener Apps und Programme mit Low-Code (z. B. To-do-Liste, Geräteverleih) zur Vereinfachung von Aufgaben in kleinen Abteilungen.
Typische Elemente sind Eingabefelder (Texteingabe, DatePicker, Dropdown, Combobox, Beschriftungsfeld), Container zur logischen Gruppierung sowie eine Gallery zur Darstellung einer verknüpften Datenquelle (z. B. SharePoint-Liste).
*Quelle: ITT IT-Technik (1. LJ) · `Grudausbildumg.pdf` S. 6 (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: power-apps-und-power-automate-02 | typ: anwendung | pruefung: BS -->
**Welche Aufgaben erfüllen die Power-Apps-Funktionen `Collect`, `Remove` und `Navigate` im Zusammenspiel mit `ThisItem`?**
?
- `Collect(Datenquelle; {Spalte: Feld.Text})` schreibt neue Werte in die Datenquelle (bei Dropdown/Combobox `.SelectedText`, beim DatePicker `.SelectedDate`).
- `Remove(Datenquelle; ThisItem)` löscht das aktuell ausgewählte Element (`ThisItem`) einer Gallery, typischerweise über `OnSelect` eines Icons.
- `Navigate(Screen2)` wechselt auf einen anderen Bildschirm.
*Quelle: ITT IT-Technik (1. LJ) · `Grudausbildumg.pdf` S. 6 (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: power-apps-und-power-automate-03 | typ: abgrenzung | pruefung: BS -->
**Welche drei Arten von Cloud Flows unterscheidet Power Automate anhand ihres Triggers?**
?
- **Automated Cloud Flow:** wird automatisch durch ein Event ausgelöst (z. B. E-Mail-Eingang / Abwesenheits-E-Mail).
- **Instant Cloud Flow:** wird manuell durch den Benutzer ausgelöst (z. B. Klick auf eine Schaltfläche).
- **Scheduled Cloud Flow:** wird zeitgesteuert zu einer bestimmten Zeit ausgelöst.
*Quelle: ITT IT-Technik (1. LJ) · `Grudausbildumg.pdf` S. 7 (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: power-apps-und-power-automate-04 | typ: pruefungsfalle | pruefung: BS -->
**Was ist bei rot unterkringelten Datenquellen-Fehlern in Power Apps zu prüfen und wie unterscheiden sich AND- und OR-Verknüpfung in Power Automate?**
?
Bei rot unterkringelten Fehlern rund um die Datenquelle sollte zuerst die Verbindung zur SharePoint-Liste geprüft, die Datenquelle aktualisiert und die App neu gestartet werden.
In Power Automate müssen bei einer **AND-Verknüpfung** alle Bedingungen zutreffen, während bei einer **OR-Verknüpfung** bereits eine erfüllte Bedingung ausreicht, um die folgende Aktion auszulösen.
*Quelle: ITT IT-Technik (1. LJ) · `Grudausbildumg.pdf` S. 7 (von 16) · [[02_Faecher/ITT_IT_Technik/Quellen/Grundausbildung_IT|Quellnotiz]], OCR/Original prüfen*
