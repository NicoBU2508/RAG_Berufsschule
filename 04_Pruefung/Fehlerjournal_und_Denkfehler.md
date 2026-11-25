---
typ: fehlerjournal
stand: 2026-11-25
rag_include: false
canonical_evidence: false
tags:
  - pruefung
  - hypercorrection
  - fehlerjournal
---
# 🎯 Denkfehler- & Hypercorrection-Register

> [!IMPORTANT] Wissenschaftliches Prinzip (Hypercorrection-Effekt — Butterfield & Metcalfe, 2001)
> Fehler, die du mit **hoher Sicherheit (`3 = sicher`)** begehst, werden im Gehirn besonders tief korrigiert — **wenn** der Kontrast (*„Ich dachte X → tatsächlich gilt Y“*) sofort festgehalten und verzögert an **Tag +1** sowie **Tag +7** aktiv ohne Hilfe abgefragt wird.

## Status-Überblick

- **Offene Denkfehler aktiv im Training:** **0** *(davon ⚡ **0** Hypercorrection-Fälle · 🔴 **0** heute zum Pretest fällig)*
- **Dauerhaft überwundene Denkfehler (Tag +1 & Tag +7 bestanden):** **0**
- **Verknüpftes FSRS-Cockpit:** [[04_Pruefung/Lernstand_Dashboard|📊 Lernstand-Dashboard öffnen]]

## 🔴 Aktive Denkfehler (Wiederholungs-Queue Tag +1 / Tag +7)

_Aktuell keine offenen Denkfehler eingetragen. Sobald im Quiz, Rechentraining oder Karteikarten-Drill ein Denkfehler auftritt, trägt der `ap-lerncoach` ihn hier automatisch für deinen Tag-+1- und Tag-+7-Pretest ein._

## CLI-Schnellbefehle (für Coach & Terminal)

```bash
# Morgendliches Session-Briefing (zeigt fällige Pretests + Top-3 FSRS-Themen):
ruby 01_Index/Tools/learn_tracker.rb briefing --exam AP1

# Neuen Denkfehler eintragen:
ruby 01_Index/Tools/learn_tracker.rb log-error --topic "IPv4-Adressierung und Subnetting" --mistake "Hostanzahl mit 2^n berechnet" --correct "2^n - 2 (Netz-ID & Broadcast abziehen)" --confidence 3 --type Rechenfalle

# Pretest-Ergebnis verbuchen (Tag +1 -> Tag +7 -> Gemeistert):
ruby 01_Index/Tools/learn_tracker.rb resolve-error ERR-001 --pass
```
