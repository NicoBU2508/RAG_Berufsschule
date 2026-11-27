---
typ: karteikarten_deck
thema: Hochverfügbarkeit und Redundanz
kategorie: IT_Technik_und_Sicherheit
pruefung: "AP1/AP2"
thema_quelle: 03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hochverfügbarkeit
  und Redundanz.md
stand_karten: '2026-11-24'
stand_quelle: '2026-11-24'
quellseiten_anzahl: 14
quellseiten_hash: 69f5333389fb
quellseiten:
- 02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=2
- 02_Faecher/Allgemein_Berufsschule/Quellen/Gescanntes_Dokument_16_09_25_um_11_21_41#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften#page=7
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1#page=2
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=1
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=10
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=6
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=7
rag_include: false
canonical_evidence: false
tags:
- karteikarten
- flashcards/it-technik-und-sicherheit/hochverfuegbarkeit-und-redundanz
---
# 🗂️ Karteikarten: Hochverfügbarkeit und Redundanz

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hochverfügbarkeit und Redundanz|Hochverfügbarkeit und Redundanz]] (**14 visuell geprüfte Seiten**).

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-01 | typ: definition | pruefung: AP1/AP2 -->
**Was versteht man unter Hochverfügbarkeit in Abgrenzung zur Fehlertoleranz und welche drei Standby-Stufen werden unterschieden?**
?
Hochverfügbarkeit ist eine Weiterführung der Fehlertoleranz, bei der Systeme als Ganze mehrfach vorhanden sind. Unterschieden werden Bare Metal (nur Hardware redundant, OS und Backup müssen erst eingespielt werden), Cold Standby (Ersatzsystem bei Bedarf hochfahren) und Hot Standby (Ersatzsystem übernimmt automatisch und sofort).
*Quelle: ITT IT-Technik (1. LJ) · [Aufgabe 1.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Aufgabe 1.pdf#page=3>) (von 4) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|Quellnotiz]]*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-02 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum ersetzt Redundanz (z. B. RAID oder zweites Netzteil) kein Backup?**
?
Redundanz erhöht nur die **Ausfallsicherheit** bei Hardware-Defekten, sodass der Betrieb weiterläuft. Logische Fehler, Ransomware oder versehentliches Löschen werden sofort auf alle redundanten Medien gespiegelt — nur ein **getrenntes Backup** stellt frühere Datenstände wieder her.
*Quelle: ITT IT-Technik (2. LJ) · [Mitschriften_Abde.pdf · S. 4](<99_Originale/Berufsschule/ITT/2_LJ/FU_IT_Abded/Mitschriften_Abde.pdf#page=4>) (von 7) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Abded_Mitschriften|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-03 | typ: fallentscheidung | pruefung: AP1/AP2 -->
**Ein Webserver hat ein redundantes Netzteil (N+1), aber nur einen einzigen Uplink-Switch zum Router. Ist der Netzwerkpfad hochverfügbar?**
?
**Nein.** Der einzelne Uplink-Switch ist ein **Single Point of Failure (SPOF)**: Fällt er aus, ist der gesamte Server nicht mehr erreichbar. Für echte Hochverfügbarkeit müssen alle kritischen Komponenten der Kette (Netzteil, Switch, Firewall, Storage) redundant ausgelegt sein.
*Quelle: ITT IT-Technik (1. LJ) · [Aufgabe 1.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Aufgabe 1.pdf#page=3>) (von 4) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|Quellnotiz]]*

---

<!-- card-id: hochverfuegbarkeit-und-redundanz-04 | typ: fallentscheidung | pruefung: AP1/AP2 -->
**In einem Krankenhaus-Rechenzentrum darf ein Ausfall des Patientendaten-Servers maximal wenige Sekunden dauern. Welches Standby-Konzept (Bare Metal, Cold Standby, Hot Standby) ist erforderlich?**
?
**Hot Standby**, da das Ersatzsystem permanent mitläuft (synchronisiert) und bei Ausfall des Primärsystems automatisch und nahezu unterbrechungsfrei übernimmt (Cold Standby müsste erst hochgefahren, Bare Metal erst bespielt werden).
*Quelle: ITT IT-Technik (1. LJ) · [Aufgabe 1.pdf · S. 3](<99_Originale/Berufsschule/ITT/1_LJ/IT Sicherheit/Aufgabe 1.pdf#page=3>) (von 4) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Aufgabe_1|Quellnotiz]]*

*(Hinweis: Spezifische RAID-Level 0/1/5/6/10 und Kapazitätsberechnungen befinden sich im AP2-Deck [[05_Karteikarten/IT_Technik_und_Sicherheit/RAID-Systeme|RAID-Systeme]].)*
