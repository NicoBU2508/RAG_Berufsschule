---
typ: pruefungskatalog
pruefung: AP1
fachrichtung: "Fachinformatiker Anwendungsentwicklung (identisch für alle IT-Berufe nach AO 2020)"
region: "IHK Bayern / Bundeseinheitlich (AkA Nürnberg / ZPA Nord-West, ohne BaWü)"
katalog_auflage: "2. überarbeitete Auflage (gültig seit Frühjahr 2025 / 2026+)"
stand: 2026-11-25
rag_include: false
canonical_evidence: false
tags:
  - pruefung/ap1
  - ihk
  - stoffkatalog
---

# 🎯 IHK-Prüfungskatalog & Checkliste: Abschlussprüfung Teil 1 (AP1)

> [!IMPORTANT] Verbindliche Navigations- & Prüfungsreferenz für Nutzer & KI-Lerncoach
> Diese Datei bildet den **aktuellen bundeseinheitlichen IHK-Prüfungskatalog (2. Auflage ab Frühjahr 2025 / 2026+)** für den Prüfungsbereich **„Einrichten eines IT-gestützten Arbeitsplatzes“ (§ 9 FIAusbV)** ab und verknüpft jeden Prüfungspunkt direkt mit den visuell geprüften Themen unter [[03_Themen/00_Kuratierte_Themen]] sowie den Karteikarten unter [[05_Karteikarten/00_Karteikarten_Index]].
> *Wichtig:* Diese Datei dient der **Prüfungssteuerung und Themenauswahl** — kanonische Fachfakten für Erklärungen und Musterlösungen kommen immer aus `03_Themen/Visuell_geprueft/` + `02_Faecher/*/Quellen/` (siehe [[00_KI_QUELLENSTART]]).

---

## 1. Rahmenbedingungen (IHK Bayern & FIAE)

| Kriterium | Offizielle Regelung (IHK München, Nürnberg, Regensburg, Schwaben & restl. Bayern) |
|---|---|
| **Prüfungsbereich** | **Einrichten eines IT-gestützten Arbeitsplatzes** (§ 9 FIAusbV, AO 2020) |
| **Gültigkeit in Bayern** | **Bundeseinheitliche Aufgaben** der AkA Nürnberg / ZPA Nord-West (in ganz Bayern identisch; nur Baden-Württemberg hat eigene Prüfungen) |
| **Besonderheit für FIAE** | **100 % identisch für alle IT-Berufe** (FIAE, FISI, FIDV, FIDP, IT-SE, IT-Kaufleute). **Falle für AE:** Kaum echtes Coden – Schwerpunkt liegt auf Hardware, Netzwerk, IT-Sicherheit, Projektplanung und BWL/Kalkulation! |
| **Zeitpunkt** | 4. Ausbildungshalbjahr (Frühjahr = Ende Februar/März · Herbst = September) |
| **Dauer & Umfang** | **90 Minuten** (keine gesonderte Einlesezeit!) · **100 Punkte** · i. d. R. **4 offene, ungebundene Handlungssituationen** à ca. 20–30 Punkte |
| **Gewichtung** | **20 %** der Gesamtnote der gestreckten Abschlussprüfung (Sperrfach-Regel erst in Gesamtrechnung mit AP2 relevant, aber jedes Prozent zählt fest!) |
| **Erlaubte Hilfsmittel** | **Netzunabhängiger, nicht programmierbarer, nicht kommunikationsfähiger Taschenrechner**, dokumentenechter Stift (blau/schwarz), Lineal/Geodreieck *(maßgeblich ist immer die persönliche IHK-Einladung)* |
| **STRIKT VERBOTEN** | **Kein IT-Handbuch / Tabellenbuch** (seit AO 2020 ersatzlos gestrichen!), keine eigenen Formelsammlungen/Gesetze, kein eigenes Konzeptpapier, keine Smartwatches/Smartphones |

---

## 2. Wichtige Änderungen im neuen Prüfungskatalog (2. Auflage ab 2025/2026)

Seit Frühjahr 2025 gilt die grundlegend modernisierte **2. Auflage des AkA-Prüfungskatalogs**. Beim Üben mit älteren Altklausuren (2021–2024) unbedingt beachten:

### 🟢 Neu aufgenommen / deutlich aufgewertet in AP1
- **Künstliche Intelligenz (KI):** Grundbegriffe, Einsatzszenarien am IT-Arbeitsplatz, Chancen/Risiken (Datenschutz, Halluzinationen, Urheberrecht), einfaches Prompting.
- **Moderne Modellierung statt Alt-Notation:** **UML-Aktivitätsdiagramme** und **BPMN 2.0** für Geschäfts- und Programmabläufe.
- **Code-Analyse & Qualität:** Logische Fehler in kurzem **Pseudocode / Code-Snippets** finden und **Schreibtischtests (Trace-Tabellen)** durchführen.
- **Projektmanagement konkretisiert:** **SMART-Prinzip**, Projektmerkmale/-phasen, direkter Vergleich **Wasserfallmodell vs. Scrum**, **Netzplantechnik** (FAZ, FEZ, SAZ, SEZ, Gesamtpuffer, Freier Puffer, kritischer Pfad).
- **Netzwerk & Client-Administration:** Verstärkt **IPv6** (Aufbau, Kürzungsregeln, Präfixe, Adresstypen wie Link-Local `fe80::/10`, Global Unicast `2000::/3`) neben IPv4/Subnetting sowie **Einbinden von Clients in eine Domäne** (Active Directory, Gruppen/Rechte).
- **IT-Sicherheit am Arbeitsplatz:** **Betriebssystem-Härtung**, **Zwei-Faktor-Authentifizierung (2FA/MFA)**, **Hashverfahren**, Schutzmaßnahmen für **Homeoffice / Mobile Work**, BSI-Grundschutz.
- **Anwendungssoftware & Web:** **ERP-, SCM- und CRM-Systeme**, Cloud-Modelle (**IaaS, PaaS, SaaS**), Social Media im Unternehmenskontext sowie **digitale Barrierefreiheit** auf Websites.

### 🔴 Aus der AP1 gestrichen / in die AP2 verschoben *(jetzt für AP1 zurückstellen – für Berufsschule & spätere AP2 im Vault behalten!)*
- **SQL-Abfragen (`SELECT`, `JOIN`, `GROUP BY`) & komplexe Normalisierung** → *verschoben in [[04_Pruefung/AP2/00_AP2_Ausbauplan|AP2]]!* (**Aber Achtung:** *Einfache relationale Datenbanken & ER-Modelle* bleiben in AP1 relevant — siehe Punkt 3.9!)
- **Struktogramme (Nassi-Shneiderman) & klassische Programmablaufpläne (PAP)** → *aus IHK-Prüfungskatalog gestrichen!* (Stattdessen: UML-Aktivitätsdiagramm & Pseudocode; nur noch falls Lehrer es in einer Berufsschulklausur verlangt.)
- **Vererbung / tiefe OOP** → *gestrichen bzw. erst in [[04_Pruefung/AP2/00_AP2_Ausbauplan|AP2]]!*
- **SWOT-Analyse & sonstige Vorgehensmodelle (außer Wasserfall & Scrum)** → *aus AP1 gestrichen!* (Fokus liegt nur noch auf **Wasserfallmodell** und **Scrum**.)
- **Spezifische Softwarequalitätskriterien (z. B. ISO 25010 im Detail)** → *gestrichen/reduziert!* (Fokus liegt auf Funktionstest, Testprotokoll & Abnahme.)
- **RAID-Level (RAID 0/1/5/6/10) & komplexe Storage-Netze (SAN)** → *verschoben in [[04_Pruefung/AP2/00_AP2_Ausbauplan|AP2]]!*
- **Mobilfunk-Spezifika (LTE/5G-Detailstandards)** → *gestrichen!*

---

## 3. Vollständiger AP1-Stoffkatalog (Handlungsfelder 1–5 & Lernfelder 1–5)

Legende zur Vault-Abdeckung:
- 🟢 **Stark im Vault belegt** (visuell geprüfte Quellseiten + Karteikarten vorhanden)
- 🟡 **Teilweise / dünn belegt** (Grundlagen im Vault, aber für AP1-Tiefe ergänzenswert)
- 🔴 **Noch Lücke im Vault** (Prüfungsstoff laut IHK-Katalog, aktuell noch ohne eigene Quellseiten im Vault)

---

### Handlungsfeld 1: Kundenbedarfe zielgruppengerecht ermitteln *(LF 1, LF 5)*

| # | IHK-Prüfungsthema (AP1) | Typische Prüfungsfragen / Details | Vault-Themen (`Visuell_geprueft`) | Status |
|---|---|---|---|---|
| **1.1** | **Kundenkommunikation & Bedarfsanalyse** | Gesprächsführung, Fragetechniken, Sender-Empfänger-/4-Ohren-Modell, Zielgruppenorientierung, Fachbegriffe verständlich erklären (DE/EN) | [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Kommunikation Modelle\|Kommunikation Modelle]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Geschäftsbrief\|Geschäftsbrief]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Geschäftsmail\|Geschäftsmail]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Business Communication English\|Business Communication English]] | 🟢 |
| **1.2** | **Lastenheft vs. Pflichtenheft & SMART-Ziele** | Auftraggeber („Was/Wofür?“) vs. Auftragnehmer („Wie?“), funktionale vs. nicht-funktionale Anforderungen, Ziele **SMART** formulieren | [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Projektmanagement Lastenheft Pflichtenheft\|Projektmanagement Lastenheft Pflichtenheft]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Unternehmensziele\|Unternehmensziele]] | 🟢 |
| **1.3** | **Projektmanagement & Vorgehensmodelle** | Projektmerkmale, Magisches Dreieck, Projektphasen, **Wasserfallmodell vs. Scrum** (Rollen, Events, Artefakte) | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwarelebenszyklus und Vorgehensmodelle\|Softwarelebenszyklus und Vorgehensmodelle]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Projektmanagement Lastenheft Pflichtenheft\|Projektmanagement Lastenheft Pflichtenheft]] | 🟢 |
| **1.4** | **Termin- & Ablaufplanung (Netzplantechnik / Gantt)** | Vorgangsliste lesen, **Netzplan berechnen** (Vorwärts-/Rückwärtsrechnung: FAZ, FEZ, SAZ, SEZ, GP, FP, **kritischer Pfad**), Meilensteine | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Projektplanung und Netzplanmethode\|Projektplanung und Netzplanmethode]] | 🟢 |
| **1.5** | **Geschäftsprozesse & BPMN 2.0** | Kern-/Support-/Managementprozesse, Abläufe in **BPMN 2.0** (Events, Gateways XOR/AND/OR, Pools/Lanes) lesen & Fehler finden *(EPK ergänzend)* | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Business Process Model and Notation BPMN\|BPMN]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Prozessmanagement und Geschäftsprozesse\|Prozessmanagement]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Ereignisgesteuerte Prozessketten EPK\|EPK]] | 🟢 |
| **1.6** | **Ergonomie & Barrierefreiheit** | Bildschirmarbeitsplatz (ArbStättV: Abstand, Blickwinkel zum Fenster, Tisch/Stuhl, Beleuchtung, Lärm) sowie **digitale Barrierefreiheit (Websites/BITV/WCAG)** | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Barrierefreies Arbeiten und digitale Barrierefreiheit\|Barrierefreies Arbeiten und digitale Barrierefreiheit]] *(Ergonomie am physischen Tisch/Monitor nur knapp)* | 🟡 |

---

### Handlungsfeld 2: Hard- und Software auswählen & Beschaffung einleiten *(LF 1, LF 4)*

| # | IHK-Prüfungsthema (AP1) | Typische Prüfungsfragen / Details | Vault-Themen (`Visuell_geprueft`) | Status |
|---|---|---|---|---|
| **2.1** | **PC-/Client-Hardware & Speichermedien** | CPU (Kerne, Takt, Cache, Architektur), RAM, Mainboard/Schnittstellen (USB, DisplayPort/HDMI, PCIe/NVMe, SATA), **HDD vs. SSD**, Thin Client vs. Fat Client vs. Notebook | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Computergrundbegriffe\|Computergrundbegriffe]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/IT Vocabulary and Hardware\|IT Vocabulary and Hardware]] *(Hardware-Komponenten im Detail dünn!)* | 🟡 |
| **2.2** | **Peripherie, Bilddaten & Datenmengen-Rechnung** | Monitore (Auflösung, Bildwiederholrate, Panel), Drucker (TCO/Seitenpreis), Scanner; **Datenmengen & Übertragungsdauer berechnen** (**Decimal SI: kB/MB/GB = $10^3$** vs. **Binär IEC: KiB/MiB/GiB = $2^{10}$**, Bit vs. Byte!) | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/SI- und IEC-Dateneinheiten\|SI- und IEC-Dateneinheiten]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Binärzahlen\|Binärzahlen]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hexadezimalsystem\|Hexadezimalsystem]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Zeichencodierung und ASCII\|Zeichencodierung und ASCII]] | 🟢 |
| **2.3** | **Elektrotechnik, Energiebedarf, USV & Green IT** | $P = U \cdot I$, $W = P \cdot t$, **Stromkosten berechnen**, **Netzteil-Wirkungsgrad ($\eta$, 80 PLUS)**, **USV-Dimensionierung (VA/W, Überbrückungszeit, VFI/VI/VFD)**, Green IT (Energy Star, Blauer Engel, TCO Certified, Refurbished, Entsorgung) | [[03_Themen/Visuell_geprueft/Elektrotechnik/Elektrische Arbeit und Energiekosten\|Elektrische Arbeit und Energiekosten]], [[03_Themen/Visuell_geprueft/Elektrotechnik/Elektrische Leistung\|Elektrische Leistung]], [[03_Themen/Visuell_geprueft/Elektrotechnik/Netzteil-Wirkungsgrad und 80 PLUS\|Netzteil-Wirkungsgrad und 80 PLUS]], [[03_Themen/Visuell_geprueft/Elektrotechnik/USV-Anlagen\|USV-Anlagen]], [[03_Themen/Visuell_geprueft/Elektrotechnik/Netzteil\|Netzteil]] | 🟢 |
| **2.4** | **Softwarearten, Unternehmenssoftware & Lizenzmodelle** | System- vs. Anwendungssoftware, Standard- vs. Individualsoftware, Open Source vs. Proprietär, Lizenzmodelle (Named-User, Concurrent-User, Volumen, SaaS-Abo, OEM), **ERP, CRM, SCM**, Social Media im Betrieb | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Programm und Software\|Programm und Software]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Urheberrecht\|Urheberrecht]] *(ERP/CRM/SCM & Lizenzmodelle fehlen als Detail!)* | 🟡 |
| **2.5** | **Cloud Computing & Virtualisierung** | **IaaS vs. PaaS vs. SaaS**, Public / Private / Hybrid / Community Cloud, On-Premises vs. Cloud; **Virtualisierung** (Hypervisor Typ 1 vs. Typ 2, VM vs. Container, VDI) | — *(aktuell keine eigene kanonische Themenseite im Vault)* | 🔴 |
| **2.6** | **Künstliche Intelligenz (KI) am Arbeitsplatz** | Grundbegriffe (ML, LLM/Generative KI), betriebliche Anwendungsfälle, Prompting-Grundregeln, Risiken (Halluzination, Bias, Datenschutz/Geheimhaltung, Urheberrecht) | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Künstliche Intelligenz und Prompting\|Künstliche Intelligenz und Prompting]] *(nur 1 Quellseite – ausbauen!)* | 🟡 |
| **2.7** | **Angebotsvergleich, Nutzwertanalyse & Kalkulation** | **Bezugskalkulation** (Listeneinkaufspreis → Rabatt → Zieleinkaufspreis → Skonto → Bareinkaufspreis → Bezugskosten → Bezugspreis), **Nutzwertanalyse (NWA)** (Gewichtung, Punkte, Begründung!), **Kauf vs. Leasing vs. Miete**, TCO, Amortisation, Break-Even | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Angebotsvergleich und Nutzwertanalyse\|Angebotsvergleich und Nutzwertanalyse]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Bezugskalkulation und Verkaufskalkulation\|Bezugskalkulation und Verkaufskalkulation]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Deckungsbeitrag und Gewinnschwelle\|Deckungsbeitrag und Gewinnschwelle]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Wirtschaftlichkeit und Rechnungswesen\|Wirtschaftlichkeit und Rechnungswesen]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Beschaffungsquellen und Stammdaten\|Beschaffungsquellen und Stammdaten]], [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Ordering Technical Products\|Ordering Technical Products]] | 🟢 |
| **2.8** | **Vertragsrecht bei Beschaffung & IT-Projekten** | Antrag & Annahme, **Kaufvertrag vs. Werkvertrag vs. Dienstvertrag vs. Miet-/Leasingvertrag**, AGB, Eigentumsvorbehalt | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Kaufvertrag und Geschäftsfähigkeit\|Kaufvertrag und Geschäftsfähigkeit]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Besitz Eigentum und Rechtssubjekte\|Besitz Eigentum und Rechtssubjekte]] *(Werk- vs. Dienstvertrag gezielt ergänzen)* | 🟡 |

---

### Handlungsfeld 3: IT-Arbeitsplatz konfigurieren, vernetzen & absichern *(LF 2, LF 3, LF 5)*

| # | IHK-Prüfungsthema (AP1) | Typische Prüfungsfragen / Details | Vault-Themen (`Visuell_geprueft`) | Status |
|---|---|---|---|---|
| **3.1** | **Betriebssysteme, Domänenintegration & Härtung** | OS-Auswahl (Windows/Linux/macOS), Partitionierung/Dateisysteme (NTFS, ext4, FAT32/exFAT), Treiber/Updates, **Einbinden eines Clients in eine Domäne (AD)**, Benutzer-/Gruppenrechte (Least Privilege), **OS-Härtung** (Dienste deaktivieren, lokaler Admin weg, BitLocker/Verschlüsselung) | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwareanpassung und Dokumentation\|Softwareanpassung und Dokumentation]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Sicherheitsmanagement und Maßnahmen\|Sicherheitsmanagement und Maßnahmen]] *(AD-Domänenbeitritt & Dateisysteme fehlen noch im Detail!)* | 🔴 |
| **3.2** | **Netzwerkgrundlagen, Topologien & OSI-Modell** | LAN/MAN/WAN, Topologien (Stern, Baum, Ring, Bus, Masche), Komponenten (**Hub, Switch, Router, Access Point, Firewall, Modem**), Kupfer (Twisted Pair/Cat) vs. Glasfaser (LWL), WLAN-Standards & Sicherheit (WPA2/WPA3), **ISO/OSI-7-Schichtenmodell** & TCP vs. UDP, DHCP, DNS, NAT | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Netzwerktechnik und Netzplan\|Netzwerktechnik und Netzplan]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/OSI-Schichtenmodell\|OSI-Schichtenmodell]], [[03_Themen/Visuell_geprueft/Elektrotechnik/Verstärkung Dämpfung und Pegelrechnung\|Verstärkung Dämpfung und Pegelrechnung]] | 🟢 |
| **3.3** | **IPv4-Adressierung & Subnetting** | Aufbau (32 Bit), private IP-Bereiche, CIDR-Notation (`/24`, `/26` …), **Netz-ID, Broadcast, erster/letzter Host, Anzahl Hosts ($2^n - 2$) berechnen**, Fehler in IP-/Gateway-/Masken-Konfiguration finden | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IPv4-Adressierung und Subnetting\|IPv4-Adressierung und Subnetting]] | 🟢 |
| **3.4** | **IPv6-Grundlagen** *(Stark im neuen Katalog!)* | 128 Bit (8 Blöcke à 16 Bit Hex), **Kürzungsregeln** (führende Nullen weglassen, `::` genau einmal!), Präfixlänge (z. B. `/64`), Adresstypen (**Loopback `::1`**, **Link-Local `fe80::/10`**, **Unique Local `fc00::/7` / `fd00::/8`**, **Global Unicast `2000::/3`**, Multicast `ff00::/8`), SLAAC vs. DHCPv6 | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hexadezimalsystem\|Hexadezimalsystem]] *(IPv6 selbst fehlt noch als eigene Themenseite!)* | 🔴 |
| **3.5** | **IT-Sicherheit: Schutzziele, BSI-Grundschutz & Risiko** | **CIA-Schutzziele (Vertraulichkeit, Integrität, Verfügbarkeit)** + Authentizität/Verbindlichkeit, **BSI IT-Grundschutz** (Strukturanalyse, **Schutzbedarfsfeststellung**: normal / hoch / sehr hoch, Modellierung, Basis-/Standard-/Kern-Absicherung), **PDCA-Zyklus**, Risikoanalyse | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IT-Sicherheit Grundlagen\|IT-Sicherheit Grundlagen]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Schutzbedarfsfeststellung\|Schutzbedarfsfeststellung]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Strukturanalyse und Informationsverbund\|Strukturanalyse und Informationsverbund]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/BSI-Modellierung\|BSI-Modellierung]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Sicherheitsmanagement und ISMS\|Sicherheitsmanagement und ISMS]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Risikoanalyse\|Risikoanalyse]] | 🟢 |
| **3.6** | **Malware, Angriffe, Kryptografie, Hash, 2FA & Backup** | Phishing, Social Engineering, Ransomware, Trojaner, DDoS, Man-in-the-Middle; **Symmetrisch vs. Asymmetrisch vs. Hybrid**, **Hashfunktionen** (Integrität/Passwort-Speicherung mit Salt), Digitale Signatur, **Zwei-Faktor-Authentifizierung (2FA: Wissen, Besitz, Sein/Biometrie)**, VPN / Homeoffice-Absicherung, **Backup (Voll-, Differenz-, Inkrementell, 3-2-1-Regel, GVS)** | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Malware und Angriffe\|Malware und Angriffe]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Kryptografie Hash und Signatur\|Kryptografie Hash und Signatur]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Backup und Datensicherung\|Backup und Datensicherung]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Mobile Sicherheit\|Mobile Sicherheit]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Physische Sicherheit und Infrastruktur\|Physische Sicherheit und Infrastruktur]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Hochverfügbarkeit und Redundanz\|Hochverfügbarkeit und Redundanz]] | 🟢 |
| **3.7** | **Datenschutz (DSGVO / BDSG) am Arbeitsplatz** | Personenbezogene vs. besondere Kategorien (Art. 9), **Grundsätze (Art. 5: Rechtmäßigkeit, Zweckbindung, Datenminimierung, Speicherbegrenzung, Integrität/Vertraulichkeit)**, Verbot mit Erlaubnisvorbehalt (Art. 6), **Betroffenenrechte** (Auskunft, Löschung, Berichtigung, Widerspruch), **TOMs** (Art. 32), Auftragsverarbeitung (AVV), Meldepflicht bei Datenpanne (**72 Stunden** an Aufsichtsbehörde!), Rollen (Verantwortlicher, DSB) | [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Datenschutz und Rollen\|Datenschutz und Rollen]] *(nur 5 Seiten – Betroffenenrechte, Art. 5/6 & 72h-Frist gezielt vertiefen!)* | 🟡 |
| **3.8** | **Softwareentwicklung, UML-Aktivitätsdiagramm & Schreibtischtest** *(LF 5)* | EVA-Prinzip, Variablen/Datentypen, Arrays, Verzweigungen & Schleifen, **Pseudocode / Code-Snippets lesen, Fehler finden & Schreibtischtest (Trace-Tabelle) ausfüllen**, **UML-Aktivitätsdiagramm** (Start/Ende, Aktion, Entscheidung/Merge, Parallelisierung Fork/Join, Swimlanes) & Use-Case-Grundlagen, Compiler vs. Interpreter *(ohne Vererbung/OOP)* | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/UML-Diagramme\|UML-Diagramme]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Algorithmus\|Algorithmus]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Variablen und Datentypen\|Variablen und Datentypen]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Arrays und Datenstrukturen\|Arrays und Datenstrukturen]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Operatoren und Bedingungen\|Operatoren und Bedingungen]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Schleifen\|Schleifen]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Methoden Parameter und Rückgabewerte\|Methoden Parameter und Rückgabewerte]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Programmiersprachen und Übersetzer\|Programmiersprachen und Übersetzer]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Entwicklungswerkzeuge und Debugging\|Entwicklungswerkzeuge und Debugging]] | 🟢 |
| **3.9** | **Relationale Datenbanken & einfaches ER-Modell** *(LF 5)* | Aufbau einer relationalen Datenbank (Tabelle, Datensatz, Attribut), **Primärschlüssel (PK) & Fremdschlüssel (FK)**, einfaches **ER-Modell (1:1, 1:n, n:m)** lesen/ergänzen *(tiefe Normalisierung & komplexes SQL erst in AP2!)* | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Datenbankgrundlagen und Datenbankentwicklung\|Datenbankgrundlagen und Datenbankentwicklung]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Datenbankmodellierung und ER-Modell\|Datenbankmodellierung und ER-Modell]] | 🟢 |

---

### Handlungsfeld 4: Kunden in die Nutzung des Arbeitsplatzes einweisen *(LF 1, LF 5)*

| # | IHK-Prüfungsthema (AP1) | Typische Prüfungsfragen / Details | Vault-Themen (`Visuell_geprueft`) | Status |
|---|---|---|---|---|
| **4.1** | **Benutzer- vs. technische Dokumentation** | Zielgruppengerechte Sprache, Benutzerhandbuch / Kurzanleitung / FAQ vs. System-/Installationsdokumentation | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwareanpassung und Dokumentation\|Softwareanpassung und Dokumentation]] | 🟢 |
| **4.2** | **Schulung, Einweisung & Sicherheitsunterweisung** | Planung einer Kundeneinweisung (Vorbereitung, Durchführung, Verständnischeck), Hinweise zu Ergonomie, Passwort-/Sicherheitsrichtlinien & Clean-Desk-Policy | [[03_Themen/Visuell_geprueft/Deutsch_Englisch_Kommunikation/Kommunikation Modelle\|Kommunikation Modelle]], [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Sicherheitsmanagement und Maßnahmen\|Sicherheitsmanagement und Maßnahmen]] | 🟡 |

---

### Handlungsfeld 5: Leistungserbringung kontrollieren & protokollieren *(LF 1, LF 5)*

| # | IHK-Prüfungsthema (AP1) | Typische Prüfungsfragen / Details | Vault-Themen (`Visuell_geprueft`) | Status |
|---|---|---|---|---|
| **5.1** | **Qualitätssicherung, Testverfahren & Testprotokoll** | Black-Box vs. White-Box, Testfälle (Äquivalenzklassen, Grenzwerte), Funktionstest, Fehlerbehebung & **Testprotokoll** *(spezifische ISO-25010-Qualitätskriterien wurden in AP1 gestrichen)* | [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwaretest und Testverfahren\|Softwaretest und Testverfahren]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwarequalität und Wartbarkeit\|Softwarequalität und Wartbarkeit]] | 🟢 |
| **5.2** | **Übergabe, Abnahmeprotokoll & Mängelrüge (Schlechtleistung)** | **Soll-Ist-Vergleich**, Abnahmeprotokoll (Wirkung der Abnahme: Gefahrübergang, Fälligkeit, Beweislastumkehr, Verjährungsbeginn), **Sachmängel / Kaufvertragsstörungen** (Schlecht-, Falsch-, Minderlieferung, Lieferverzug, Nacherfüllung: Nachbesserung vs. Ersatzlieferung) | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Kaufvertrag und Geschäftsfähigkeit\|Kaufvertrag und Geschäftsfähigkeit]], [[03_Themen/Visuell_geprueft/Anwendungsentwicklung/Softwareanpassung und Dokumentation\|Softwareanpassung und Dokumentation]] *(Abnahmeprotokoll & Mängelrechte gezielt üben!)* | 🟡 |
| **5.3** | **Nachkalkulation & Abweichungsanalyse** | **Vorkalkulation (Soll) vs. Nachkalkulation (Ist)** (Stundensätze, Material, Lizenzen), Kosten-/Zeitabweichungen berechnen & Ursachen begründen, Lessons Learned | [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Wirtschaftlichkeit und Rechnungswesen\|Wirtschaftlichkeit und Rechnungswesen]], [[03_Themen/Visuell_geprueft/Wirtschaft_und_Recht/Bezugskalkulation und Verkaufskalkulation\|Bezugskalkulation und Verkaufskalkulation]] | 🟡 |

---

## 4. Top-10 „Punktegaranten“ (Dauerbrenner aus AP1 2025 & 2026)

Aus den bundeseinheitlichen Prüfungen **Frühjahr/Herbst 2025** und **Frühjahr/Herbst 2026** zeigen sich diese wiederkehrenden Aufgabentypen (immer **mit vollständigem Rechenweg / Begründung** lösen!):

1. **Nutzwertanalyse (NWA):** Gewichtungen prüfen (Summe = 100 %), gewichtete Punkte berechnen, **Entscheidung schriftlich begründen** (inkl. K.-o.-Kriterien wie Budgetlimit!).
2. **Bezugskalkulation & Kauf vs. Leasing:** Rabatt → Skonto → Bezugskosten exakt in richtiger Reihenfolge rechnen; Gesamtkosten über Laufzeit (z. B. 36/48 Monate) vergleichen + je 2 Vor-/Nachteile von Kauf vs. Leasing nennen.
3. **Datenmengen & Übertragungszeit:** Dateigröße / Backup-Dauer über Leitung (z. B. `100 Mbit/s`) berechnen — **Prüfungsfalle Nr. 1:** `Byte × 8 = Bit` und `MB ($10^6$) ≠ MiB ($2^{20}$)`!
4. **IPv4-Subnetting & IPv6-Adressanalyse:** Subnetzmaske/CIDR bestimmen, Netz-ID / Broadcast / Hostbereich ausrechnen; IPv6-Adresse kürzen/entkürzen und Adresstyp (`fe80::` Link-Local vs. `2001:...` Global Unicast) erkennen.
5. **Netzplantechnik:** Vorwärts- und Rückwärtsrechnung ausfüllen, Gesamtpuffer & Freien Puffer bestimmen, **kritischen Pfad** markieren und Auswirkung einer Verzögerung erklären.
6. **Schreibtischtest & Fehler im Pseudocode:** Schleife/Bedingung mit einem Array Schritt für Schritt durchspielen (Trace-Tabelle) oder Off-by-One-Fehler (`<` vs. `<=`, Nullindizierung!) finden.
7. **UML-Aktivitätsdiagramm oder BPMN 2.0:** Aus einem kurzen Textprozess ein Diagramm ergänzen/zeichnen oder logische Modellierungsfehler (z. B. falsches Gateway) benennen.
8. **IT-Sicherheit & Homeoffice / Arbeitsplatz:** CIA-Schutzziele auf ein konkretes Szenario anwenden, 2FA erklären, Passwort-/Härtungs-/Backup-Maßnahmen (inkl. USV) vorschlagen.
9. **DSGVO-Praxisfall:** Prüfen, ob Datenverarbeitung erlaubt ist, Betroffenenrechte nennen oder Maßnahmen bei einer Datenpanne (inkl. 72-Stunden-Meldung) beschreiben.
10. **Stromverbrauch, Netzteil-Wirkungsgrad & Green IT:** reale Aufnahmeleistung $P_{\text{zu}} = P_{\text{ab}} / \eta$ über Wirkungsgrad berechnen, Jahresstromkosten in € ermitteln.

---

## 5. Konkrete Vault-Lückenliste für die AP1 (Priorisiert)

Damit der Vault die AP1 zu **100 %** aus eigenen geprüften Unterlagen abdeckt, sollten bei künftigen Berufsschul-Mitschriften (oder Lernskripten) vorrangig diese Themen ergänzt werden:

1. 🔴 **IPv6-Adressierung & Protokolle** (Aufbau, Kürzungsregeln, Adresstypen `fe80::`/`fc00::`/`2000::`, SLAAC vs. DHCPv6)
2. 🔴 **Cloud Computing & Virtualisierung** (IaaS/PaaS/SaaS, Public/Private/Hybrid, Hypervisor Typ 1/2, VM vs. Container, VDI)
3. 🔴 **Client-Domänenintegration & OS-Administration** (Active Directory, Gruppenrichtlinien/GPO, Dateisysteme NTFS/ext4, Betriebssystem-Härtung)
4. 🟡 **PC-Hardware im Detail** ( direkter Vergleich **HDD vs. SSD**, CPU-Kenndaten, RAM-Typen, Monitor-/Peripherie-Schnittstellen)
5. 🟡 **Unternehmenssoftware & Lizenzmodelle** (**ERP, CRM, SCM**, SaaS-/Named-/Concurrent-Lizenzen, Open-Source-Lizenzen)
6. 🟡 **Künstliche Intelligenz (KI)** (aktuell nur 1 Seite im Vault – Grundlagen, Chancen/Risiken & Datenschutz am Arbeitsplatz ergänzen)
7. 🟡 **DSGVO-Vertiefung** (Art. 5 Grundsätze, Art. 6 Rechtmäßigkeit, Betroffenenrechte Art. 15–21, 72h-Meldepflicht, TOMs, AVV)
8. 🟡 **Ergonomie & Green IT** (Bildschirmarbeitsplatz-Regeln nach ArbStättV, Prüfsiegel Blauer Engel / Energy Star / TCO)
9. 🟡 **Werkvertrag vs. Dienstvertrag, Abnahmeprotokoll & Nachkalkulation** (Vertragsarten-Abgrenzung, Mängelrüge, Soll-Ist-Kostenvergleich)

---

## Siehe auch
- [[04_Pruefung/AP1/00_AP1_Lernmatrix|AP1 Lernmatrix (Übersicht der Handlungsbereiche)]]
- [[04_Pruefung/Lueckenanalyse|Lückenanalyse (AP1 & AP2)]]
- [[04_Pruefung/Pruefungsmodus|Prüfungsmodus & Lernroutine]]
- [[03_Themen/00_Kuratierte_Themen|Alle visuell geprüften Vault-Themen]]
- [[05_Karteikarten/00_Karteikarten_Index|Alle Karteikarten-Decks]]
