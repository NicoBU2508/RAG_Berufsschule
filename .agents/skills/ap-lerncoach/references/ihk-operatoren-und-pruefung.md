# IHK-Operatoren, Bloom-Taxonomie & Vault-Prüfungsbezug

Für Fachinformatiker-Abschlussprüfungen (**AP1: Einrichten eines IT-gestützten Arbeitsplatzes** und **AP2: Fachrichtung + WiSo**) entscheiden die **Operatoren** in der Aufgabenstellung darüber, wie detailliert geantwortet werden muss und wie die IHK Punkte vergibt.

---

## 1. IHK-Operatoren nach Anderson & Krathwohl (Bloom, 2001)

| Bloom-Stufe | Typische IHK-Operatoren | Was der Prüfer erwartet | Optimale Antwortform | Häufiger Punkteverlust |
|---|---|---|---|---|
| **1. Erinnern** | *nennen, aufzählen, angeben, benennen* | Präzise Fakten, Begriffe oder Merkmale ohne Ausschmückung | Knappe Stichpunkte; exakt geforderte Anzahl liefern | Zu lange Aufsätze (Zeitverlust) oder mehr Punkte geraten als gefragt |
| **2. Verstehen** | *beschreiben, erläutern, erklären, darstellen, zusammenfassen* | Zusammenhang in eigenen Worten nachvollziehbar machen (*Was + Wie*) | Ganze, klare Sätze; bei *erläutern* idealerweise mit kurzem Beispiel | Nur Schlagworte hingeworfen statt Zusammenhang zu erklären |
| **3. Anwenden** | *berechnen, erstellen, entwerfen, modellieren, implementieren, ermitteln* | Regeln, Formeln, SQL, Code, ER-/UML-Modelle oder Subnetting korrekt auf konkrete Daten anwenden | Rechenweg / Schritte sichtbar machen, Einheiten angeben, Syntax sauber halten | Nur Endergebnis ohne Rechenweg (verliert Folgefehler-Punkte!) |
| **4. Analysieren** | *vergleichen, unterscheiden, untersuchen, begründen, zuordnen, herausarbeiten* | Kriteriengeleitet Gemeinsamkeiten/Unterschiede oder logische Ursachen (*weil/da*) darlegen | Kriterien-Tabelle oder klare Kausalkette (*Behauptung → Begründung → Bezug zur Situation*) | Zwei Dinge nacheinander beschreiben statt am selben Kriterium zu vergleichen |
| **5. Bewerten** | *bewerten, beurteilen, abwägen, Stellung nehmen, entscheiden und begründen* | Eigenständiges, kriterienbasiertes Urteil mit Pro & Contra und klarem Fazit | Kriterien (z. B. Kosten, Sicherheit, Skalierbarkeit) abwägen + eindeutige Empfehlung | Nur „Ja/Nein“ oder einseitige Argumentation ohne Bezug auf das Szenario |
| **6. Erschaffen** | *konzipieren, entwickeln, planen* | Vollständiges, konsistentes Konzept für eine komplexe Handlungssituation | Strukturiertes Gesamtkonzept (Ziel → Komponenten → Ablauf → Sicherheit/Test) | Einzeldetails ohne Gesamtzusammenhang oder fehlende Randbedingungen |

---

## 2. Verbindung zu den 6 kanonischen Vault-Kategorien

Alle 140 visuell geprüften Themen liegen unter `03_Themen/Visuell_geprueft/` in sechs Kategorien (Übersicht: [[03_Themen/00_Kuratierte_Themen]]; maschinenlesbares AP1/AP2-Mapping: `01_Index/Pruefungskatalog_Mapping.json`):

| Vault-Kategorie (`03_Themen/Visuell_geprueft/...`) | Prüfungsrelevanz (AP1 / AP2 / Berufsschule) | Besonders wirksame Lernmethoden |
|---|---|---|
| `Anwendungsentwicklung` | SQL, ER-Modell/DB, Java, Python, Algorithmen, OOP, UML, Softwaretest, Vorgehensmodelle | Worked Example → Fading, Code-Tracing, Interleaving (`SELECT`/`GROUP BY`/`JOIN`, Schleifen/Rekursion) |
| `IT_Technik_und_Sicherheit` | IPv4/Subnetting, OSI, Netzwerke, RAID, IT-Sicherheit/DSGVO, PDCA, Risikoanalyse, Digitaltechnik, CPS/IoT | Dual Coding (Schichten/Topologien), Rechen-Drills mit Fading, Interleaving (Angriffstypen, RAID, Protokolle) |
| `Wirtschaft_und_Recht` | Bezugskalkulation, Angebotsvergleich, Deckungsbeitrag, Kauf-/Werk-/Dienstvertrag, Geschäftsprozesse/EPK, Grundrechte, Personal, Lohnabrechnung | Rechenschemata als Worked Example, Fallprüfung (Subsumtion), Kontrasttabellen für Vertrags-/Rechtsformen |
| `Elektrotechnik` | Spannung/Strom/Widerstand, Leistung, Netzteil, Schaltungen | Formel-Dreiecke / Schaltpläne (Dual Coding), Einheiten-Check, gestufte Rechenaufgaben |
| `Deutsch_Englisch_Kommunikation` | Geschäftsbrief/-mail, Lasten-/Pflichtenheft, Kommunikationsmodelle, IT-Englisch, Case Studies | Checklisten-Abruf, Textkorrektur-Übungen, aktive Schreibaufgaben mit IHK-Kriterienfeedback |
| `Religion_Ethik` | Berufsethik, Verantwortung, gesellschaftliche Fragestellungen | Argumentations-Training (Pro/Contra + Fazit), Elaboration |

---

## 3. Aktuelle Prüfungsphase & Nutzung der Planungsdateien im Vault

- **Aktuelle Lernphase: Fokus `AP1` (später folgt `AP2 FIAE`):**
  - Solange der Nutzer für die **AP1** lernt, bei offenen Prüfungsdrills, Simulationen und Lernplänen **AP1-Themen priorisieren**.
  - Fragt der Nutzer gezielt ein reines **AP2- oder Berufsschul-Thema** an (z. B. SQL, ER-Modell, tiefe Java-OOP, RAID, Sozialversicherung), normal und gründlich coachen (wichtig für Berufsschul-Klausuren & spätere AP2!), aber kurz transparent einordnen: *„Für Berufsschule & spätere AP2 wichtig – in der AP1 (ab Katalog 2025) nicht mehr Schwerpunkt.“*
- **AP1-Prüfungskatalog & Themen-Checkliste (2. Auflage ab 2025/2026, IHK Bayern / bundeseinheitlich AkA):** [[04_Pruefung/AP1/01_AP1_IHK_Pruefungskatalog_und_Checkliste]] (verbindliche Orientierung, was in der AP1 drankommt, was ab 2025 neu ist – z. B. KI, IPv6, Domäne, UML-Aktivitätsdiagramm, BPMN, Scrum, 2FA – und was in die AP2 verschoben wurde – z. B. SQL, Struktogramm/PAP, RAID).
- **AP1-Rahmen & Lernziele:** [[04_Pruefung/AP1/00_AP1_Lernmatrix]] (Orientierung über die Handlungsbereiche).
- **AP2-Ausbau:** [[04_Pruefung/AP2/00_AP2_Ausbauplan]].
- **Prüfungsroutine:** [[04_Pruefung/Pruefungsmodus]].
- **Original-IHK-Altklausuren & offizielle Lösungen (`06_Altklausuren/` & `01_Index/Altklausuren_Index.json`):**
  - Hochgeladene Originalprüfungen und Lösungshinweise werden über den Skill `altklausur-import` (`ruby 01_Index/Tools/import_altklausur.rb`) visuell geprüft, in Einzelaufgaben mit Punktzahl, Operator, Aufgabentyp, Erwartungshorizont und typischen Fallen zerlegt und in `01_Index/Altklausuren_Index.json` gespeichert.
  - `ruby .agents/skills/ap-lerncoach/scripts/vault_lookup.rb tasks "<thema>"` lädt automatisch alle passenden Original-IHK-Aufgaben samt offiziellem Erwartungshorizont!
  - **Bewertungsregel:** Nutze den offiziellen Erwartungshorizont aus `Altklausuren_Index.json` für die exakte Teilpunkte-Vergabe, verrate ihn aber **niemals vor dem eigenen Lösungsversuch** des Nutzers.
  - **Hybrid-Regel bei sprachspezifischen AE-Themen (Python / Java):** Da IHK-AP1 (und weite Teile von AP2 Algorithmen) sprachneutralen Pseudocode, Schreibtischtests (Trace-Tabellen) und Fehleranalyse prüfen, während in der Berufsschule konkrete Sprachen (z. B. Python mit striktem EVA-Prinzip & Typ-Präfixen) gelehrt werden, verbinde in **Stufe 4 (Hybrid-IHK-Aufgabe)** beides: Stelle eine echte IHK-Handlungssituation mit Punkten & Operator und lasse den Nutzer wahlweise in **seinem Unterrichts-Python/-Java** oder in **IHK-Pseudocode** antworten.
- **Quellenübersicht:** [[01_Index/Quellenmatrix]].
- **Wichtig:** Fachliche Erklärungen und Unterrichtsregeln müssen immer durch die verlinkten Seiten unter `03_Themen/Visuell_geprueft/` und `02_Faecher/<Fach>/Quellen/` belegt sein (siehe [[00_KI_QUELLENSTART]]).
