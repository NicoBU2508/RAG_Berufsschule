---
typ: karteikarten_deck
thema: IPv4-Adressierung und Subnetting
kategorie: IT_Technik_und_Sicherheit
pruefung: AP1
thema_quelle: 03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IPv4-Adressierung
  und Subnetting.md
stand_karten: '2026-11-26'
stand_quelle: '2026-11-26'
quellseiten_anzahl: 21
quellseiten_hash: 48a2d1418760
quellseiten:
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=1
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=10
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=11
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=12
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=13
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=14
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=2
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=3
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=4
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=5
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=6
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=7
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=8
- 02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung#page=9
- 02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=18
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=10
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=11
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=12
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=7
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=8
- 02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt#page=9
rag_include: false
canonical_evidence: false
tags:
- karteikarten
- flashcards/it-technik-und-sicherheit/ipv4-adressierung-und-subnetting
---
# 🗂️ Karteikarten: IPv4-Adressierung und Subnetting

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/IPv4-Adressierung und Subnetting|IPv4-Adressierung und Subnetting]] (**21 visuell geprüfte Seiten**).

---

<!-- card-id: ipv4-adressierung-und-subnetting-01 | typ: definition | pruefung: AP1 -->
**Wie ist eine IPv4-Adresse aufgebaut und welche Funktion hat die Subnetzmaske?**
?
Eine IPv4-Adresse besteht aus 32 Bit (4 Oktette zu je 8 Bit, meist gepunktet dezimal dargestellt) und teilt sich in Netz-ID und Host-ID. Die ebenfalls 32 Bit lange Subnetzmaske trennt beide Teile: binäre Einsen markieren den Netzteil (in CIDR-Notation als Präfixlänge `/n`), binäre Nullen den Hostteil.
*Quelle: ITT IT-Technik (1. LJ) · `Netzwerkt.pdf` S. 7 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-02 | typ: anwendung | pruefung: AP1 -->
**Wie werden Netzadresse und Broadcastadresse eines IPv4-Netzes bestimmt und warum dürfen sie nicht an Hosts vergeben werden?**
?
Die **Netzadresse** entsteht mit allen Hostbits auf `0` (`IP UND Maske`, erste Adresse im Netz); die **Broadcastadresse** mit allen Hostbits auf `1` (`IP ODER INV(Maske)`, letzte Adresse im Netz). Beide sind Sonderadressen für das Netzwerk bzw. alle Hosts darin und dürfen nicht für Endgeräte vergeben werden.
*Quelle: ITT IT-Technik (1. LJ) · `Netzwerkt.pdf` S. 7 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-03 | typ: abgrenzung | pruefung: AP1 -->
**Worin unterscheiden sich Limited Broadcast und Directed Broadcast bei IPv4?**
?
Ein **Limited Broadcast** nutzt die Zieladresse `255.255.255.255` und bleibt immer im eigenen lokalen Netz. Ein **Directed Broadcast** adressiert dagegen die spezifische Broadcastadresse eines bestimmten Zielnetzes (z. B. `192.168.255.255`).
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 2 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-04 | typ: definition | pruefung: AP1 -->
**Was versteht man unter Subnetting und welche drei Vorteile bietet die Aufteilung in Teilnetze?**
?
Subnetting unterteilt ein größeres IP-Netzwerk durch Erweiterung der Netz-ID um Bits der Host-ID in kleinere, logisch getrennte Teilnetze (Subnets). Vorteile sind höhere Übersichtlichkeit (z. B. nach Organisationseinheiten, Gerätetypen oder Standorten), bessere Performance (weniger Broadcasts/Kollisionen) und eigene Sicherheitsregeln pro Subnetz.
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 4 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]]*

---

<!-- card-id: ipv4-adressierung-und-subnetting-05 | typ: anwendung | pruefung: AP1 -->
**Wie kommunizieren Geräte aus verschiedenen Subnetzen miteinander und welche Rolle spielt das Default Gateway?**
?
Zwischen Subnetzen wird ohne **Router** kein Datenverkehr weitergeleitet. Geräte senden Pakete für entfernte Netze an die Router-Schnittstelle ihres LANs (**Default Gateway**), die eine Hostadresse aus demselben Subnetz besitzt und anhand der Subnetzmaske zum Zielnetz weiterleitet.
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 5 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]]*

---

<!-- card-id: ipv4-adressierung-und-subnetting-06 | typ: anwendung | pruefung: AP1 -->
**Sie teilen `10.1.0.0/16` auf: Wie viele Subnetze entstehen bei `/18` bzw. `/24`, und welche Präfixlänge ist nötig, um 30 Teilnehmer pro Subnetz zu adressieren?**
?
Gegenüber `/16` ergibt `/18` genau 2 zusätzliche Netzbits (`2^2 = 4` Subnetze) und `/24` ergibt 8 zusätzliche Netzbits (`2^8 = 256` Subnetze). Für 30 Teilnehmer braucht man mindestens 5 Hostbits (`2^5 - 2 = 30` nutzbare Hostadressen), also die Subnetzmaske `/27`.
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 11 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]]*

---

<!-- card-id: ipv4-adressierung-und-subnetting-07 | typ: pruefungsfalle | pruefung: AP1 -->
**Welche privaten und reservierten IPv4-Adressbereiche werden nicht im öffentlichen Internet geroutet?**
?
Private Bereiche nur fürs LAN sind `10.0.0.0/8` (Klasse A), `172.16.0.0/16` bis `172.31.0.0/16` (16 Klasse-B-Netze) sowie `192.168.0.0/24` bis `192.168.255.0/24` (256 Klasse-C-Netze). Zudem sind `127.0.0.1/8` (Loopback/Localhost) und `169.254.0.0/16` (APIPA) reserviert.
*Quelle: ITT IT-Technik (1. LJ) · `Netzwerkt.pdf` S. 9 (von 13) · [[02_Faecher/ITT_IT_Technik/Quellen/Otma_Netzwerkt|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-08 | typ: anwendung | pruefung: AP1 -->
**Wie bestimmt man Netz- und Broadcastadresse schnell mithilfe der Blockgröße (Schrittweite) ohne vollständige Binärumrechnung?**
?
Im Oktett der Subnetzmaske, das ungleich `255` und `0` ist, gilt: `Schrittweite = 256 - Maskenwert`. Die **Netzadresse** nutzt das größte Vielfache der Schrittweite `<=` IP-Oktett (Oktette dahinter `0`); die **Broadcastadresse** entspricht dem nächsten Netz minus `1` in diesem Oktett (Oktette dahinter `255`).
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 14 (von 14) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-09 | typ: definition | pruefung: AP1 -->
**Wie ermittelt man die CIDR-Präfixlänge `/x` schnell aus einer dezimalen Subnetzmaske?**
?
Man zählt alle `1`-Bits der Subnetzmaske zusammen: Jedes Oktett mit `255` liefert `8` Bits; für typische Maskenwerte im Übergangsoktett gilt `128 = 1`, `192 = 2`, `224 = 3`, `240 = 4` und `248 = 5` Bits (z. B. `255.255.192.0` -> `8 + 8 + 2 = /18`).
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 14 (von 14) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: ipv4-adressierung-und-subnetting-10 | typ: anwendung | pruefung: AP1 -->
**Bestimmen Sie für `10.98.212.34` mit der Subnetzmaske `255.248.0.0` Präfixlänge, Netzadresse, Broadcastadresse und Anzahl nutzbarer Hosts.**
?
**Präfixlänge:** `/13` (`255` = 8 Bit, `248` = 5 Bit). Mit der Schrittweite `256 - 248 = 8` im 2. Oktett liegt `98` zwischen `96` und `104`: **Netzadresse** `10.96.0.0`, **Broadcastadresse** `10.103.255.255`, **Hosts:** `2^(32 - 13) - 2 = 524.286`.
*Quelle: ITT IT-Technik (2. LJ) · `00_IPv4_Wiederholung.pdf` S. 14 (von 14) · [[02_Faecher/ITT_IT_Technik/Quellen/FU_IT_2LJ_Zielske_IPv4_Wiederholung|Quellnotiz]], OCR/Original prüfen*
