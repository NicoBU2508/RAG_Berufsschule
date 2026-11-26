---
typ: posteingang
status: aktiv
rag_include: false
---
# 📥 Posteingang für Original-IHK-Altklausuren & Lösungen

Lege hier deine **Original-IHK-Prüfungen (AP1, AP2 GA1/GA2, WiSo)** und die dazugehörigen **offiziellen Lösungshinweise** als PDF ab (oder ziehe sie direkt in den Chat).

## So funktioniert der Import

1. Lege die Prüfungs-PDF und (falls vorhanden) die Lösungs-PDF hier in `06_Altklausuren/00_Posteingang/` ab – z. B.:
   - `AP1_2025_Fruehjahr_Aufgaben.pdf`
   - `AP1_2025_Fruehjahr_Loesung.pdf`
2. Schreib im Chat einfach: **„Integriere meine neuen IHK-Altklausuren“** (der Skill `altklausur-import` übernimmt den Rest automatisch).
3. Die Pipeline (`ruby 01_Index/Tools/import_altklausur.rb`) prüft alle Seiten visuell, zerlegt die Prüfung in **Einzelaufgaben mit Punktzahl, IHK-Operator, Aufgabentyp, offiziellem Erwartungshorizont und typischen Prüfungsfallen**, verknüpft sie mit deinen kanonischen Themen und aktualisiert `01_Index/Altklausuren_Index.json`.
4. Sobald eine Prüfung importiert ist, nutzt der `ap-lerncoach` sie **sofort automatisch**, wenn du dir Aufgaben zu einem Thema erstellen lässt!

> [!privacy] Datenschutz & Git
> Ungeprüfte Dateien in diesem Posteingang werden von Git und Obsidian Copilot ignoriert, bis sie sauber über `import_altklausur.rb` analysiert und eingebunden wurden. Lege hier keine privaten Zeugnisse oder persönlichen Bescheide ab.
