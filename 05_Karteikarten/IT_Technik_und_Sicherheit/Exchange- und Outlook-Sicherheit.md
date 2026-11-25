---
typ: karteikarten_deck
thema: "Exchange- und Outlook-Sicherheit"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Exchange- und Outlook-Sicherheit.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 3
quellseiten_hash: e3e7d5c7b8e9
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=43"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=44"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=45"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/exchange-und-outlook-sicherheit
---
# 🗂️ Karteikarten: Exchange- und Outlook-Sicherheit

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Exchange- und Outlook-Sicherheit|Exchange- und Outlook-Sicherheit]] (**3 visuell geprüfte Seiten**).

---

<!-- card-id: exchange-und-outlook-sicherheit-01 | typ: definition | pruefung: AP1 -->
**Was bezeichnet laut BSI-Baustein APP.5.2 ein Microsoft Exchange-System?**
?
Ein **Microsoft Exchange-System** ist die Kombination aus **Microsoft Exchange-Servern** (Groupware-Lösung für E-Mails, Kontakte, Kalender, Aufgaben und Notizen) und **Outlook-Clients** (Office-Client, mobil integriert oder über die **Outlook Web App (OWA)** im Browser).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 43 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: exchange-und-outlook-sicherheit-02 | typ: anwendung | pruefung: AP1 -->
**Welche drei Basis-Anforderungen sichern bei Microsoft Exchange vorrangig die Verfügbarkeit?**
?
1. Server (insbesondere die **Exchange-Server-Datenbanken**) vor Installationen und Konfigurationsänderungen sichern.
2. Server regelmäßig in **zyklischen Abständen** sichern.
3. **Gelöschte Exchange-Objekte** erst nach einiger Zeit endgültig aus der Datenbank entfernen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 44–45 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: exchange-und-outlook-sicherheit-03 | typ: abgrenzung | pruefung: AP1 -->
**Wie unterscheiden sich Encrypting File System (EFS) und Windows BitLocker bei der Absicherung von Outlook-Daten?**
?
**EFS** ist ein System zur **Dateiverschlüsselung** auf NTFS-Datenträgern, sodass Dateiinhalte auch bei Diebstahl des Mediums vertraulich bleiben. **Windows BitLocker** ist eine **Festplattenverschlüsselung**, mit der auch das gesamte Systemlaufwerk verschlüsselt werden kann.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 45 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: exchange-und-outlook-sicherheit-04 | typ: definition | pruefung: AP1 -->
**Wofür stehen NTFS-Berechtigungen und PST-Dateien im Zusammenhang mit Exchange und Outlook?**
?
**NTFS-Berechtigungen** speichern zusätzliche Zugriffsrechte direkt an Dateien (für das Exchange-Verzeichnis auf autorisierte Admins und Systemkonten einzuschränken). Im Format **Personal Store (PST)** speichert Outlook lokal E-Mails, Kalender, Aufgaben und Notizen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 44–45 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: exchange-und-outlook-sicherheit-05 | typ: anwendung | pruefung: AP1 -->
**Welche Standard-Anforderungen gelten für die sichere Konfiguration von Outlook-Clients?**
?
Dateianhänge dürfen **nicht automatisch** geöffnet werden, **Vorschaufenster und Autovorschau** sind zu deaktivieren, Benutzer dürfen nur ausgewählte Profileinstellungen ändern und **Lesebestätigungen** sowie interne Strukturinfos dürfen nicht an externe Anwender gesendet werden.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 44 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: exchange-und-outlook-sicherheit-06 | typ: pruefungsfalle | pruefung: AP1 -->
**Welche Sicherheitsrisiken entstehen durch unsachgemäßen Browserzugriff (OWA/IIS) und selbst entwickelte Makros in Outlook?**
?
Ein falsch konfigurierter Browserzugriff über **IIS** kann Angreifern von außen Zugriff auf E-Mails, Spam-Versand und interne Infos ermöglichen (**C, I, A**). Bösartige oder fehlerhafte **Makros/APIs** können per einfachem Aufruf Daten manipulieren, automatisierten Datenabfluss auslösen oder durch Indexfehler Fehlentscheidungen verursachen (**C, I, A**).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 43, 45 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*
