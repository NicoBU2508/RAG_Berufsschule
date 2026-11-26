---
typ: karteikarten_deck
thema: "Mobile Sicherheit"
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Mobile Sicherheit.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 3
quellseiten_hash: 69394e963a8d
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=40"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=41"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=42"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/mobile-sicherheit
---
# 🗂️ Karteikarten: Mobile Sicherheit

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Mobile Sicherheit|Mobile Sicherheit]] (**3 visuell geprüfte Seiten**).

---

<!-- card-id: mobile-sicherheit-01 | typ: definition | pruefung: AP1 -->
**Was ist ein Synchronisationskonflikt bei Laptops und welche Schutzziele sind bei Synchronisationsfehlern betroffen?**
?
Ein **Synchronisationskonflikt** entsteht, wenn sowohl die lokale Datei auf dem Notebook als auch die Version auf dem Server geändert wurde und entschieden werden muss, welche Version überspielt wird. Fehler bei der Synchronisation gefährden **Integrität (I)** und **Verfügbarkeit (A)**.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 40, 42](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=40>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: mobile-sicherheit-02 | typ: abgrenzung | pruefung: AP1 -->
**Welche Grundwerte (C, I, A) sind bei Diebstahl, ungeordnetem Benutzerwechsel und Datendiebstahl über öffentliche WLANs betroffen?**
?
**Diebstahl** betrifft **Vertraulichkeit (C)** und **Verfügbarkeit (A)**, ein **ungeordneter Benutzerwechsel** betrifft **Vertraulichkeit (C)** und **Integrität (I)** (z. B. Restdaten, Schadsoftware) und **Datendiebstahl mithilfe von Laptops** betrifft die **Vertraulichkeit (C)**.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 40, 42](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=40>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: mobile-sicherheit-03 | typ: anwendung | pruefung: AP1 -->
**Welche technischen Basis-Anforderungen (BSI SYS.3.1) müssen bei der Einrichtung eines Laptops erfüllt werden?**
?
Ein angemessener **Zugriffsschutz**, eine aktive **Personal Firewall** (restriktive, getestete Filterregeln), ein aktuelles **Antivirenprogramm** (ohne sicherheitsrelevante Änderungsrechte für Benutzer) sowie eine regelmäßige, weitgehend **automatisierte Datensicherung** lokal gespeicherter Daten.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 40–41](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=40>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: mobile-sicherheit-04 | typ: anwendung | pruefung: AP1 -->
**Wie muss man laut BSI-Anforderungen bei einem infizierten Laptop sowie bei einem wiederaufgetauchten gestohlenen Laptop vorgehen?**
?
Ein infizierter Laptop muss im **Offlinebetrieb** darauf untersucht werden, ob Schadsoftware Daten gesammelt, Schutzfunktionen deaktiviert oder Code nachgeladen hat. Ein wiederaufgetauchtes Gerät ist auf Manipulationen zu prüfen und **komplett neu zu installieren**.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 41](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=41>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: mobile-sicherheit-05 | typ: abgrenzung | pruefung: AP1 -->
**Welche Standard-Anforderungen schützen Daten auf mobilen Laptops im Ruhezustand gegenüber der Netzübertragung?**
?
Lokal gespeicherte Daten werden durch **Festplattenverschlüsselung** (sicherer Algorithmus, zufällig erzeugte und geeignet aufbewahrte Schlüssel) geschützt; Übertragungen zwischen Laptop und internem Netz werden über **VPN** oder **TLS** abgesichert.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 41](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=41>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: mobile-sicherheit-06 | typ: pruefungsfalle | pruefung: AP1 -->
**Warum reicht es beim Benutzerwechsel eines Pool-Laptops nicht aus, das Gerät einfach weiterzureichen, und warum wiegt Diebstahl oft schwerer als der Gerätewert?**
?
Beim ungeordneten Benutzerwechsel können schutzbedürftige Restdaten ausgelesen oder Schadsoftware weitergegeben werden; Daten müssen sicher gelöscht und Virenfreiheit geprüft (oder das System neu aufgesetzt) werden. Bei Diebstahl wiegt der Zugriff Unbefugter auf vertrauliche Daten oft deutlich schwerer als der materielle Geräteverlust.
*Quelle: ITT IT-Technik (1. LJ) · [Skript_Wittmann.pdf · S. 40–41](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Skript_Wittmann.pdf#page=40>) (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*
