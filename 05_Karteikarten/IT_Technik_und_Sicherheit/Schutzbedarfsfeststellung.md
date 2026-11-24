---
typ: karteikarten_deck
thema: "Schutzbedarfsfeststellung"
kategorie: IT_Technik_und_Sicherheit
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Schutzbedarfsfeststellung.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 8
quellseiten_hash: 32eeca37b37e
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Sicherheitsmanagement#page=15"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=17"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=18"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=19"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=20"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=21"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=22"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann#page=23"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/schutzbedarfsfeststellung
---

# 🗂️ Karteikarten: Schutzbedarfsfeststellung

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Schutzbedarfsfeststellung|Schutzbedarfsfeststellung]] (**8 visuell geprüfte Seiten**).

---

<!-- card-id: schutzbedarfsfeststellung-01 | typ: definition | pruefung: AP1/AP2 -->
**Welche drei klassischen Grundwerte (Schutzziele) werden bei der Schutzbedarfsfeststellung betrachtet und wann sind sie verletzt?**
?
- **Vertraulichkeit**: vertrauliche Informationen werden unberechtigt zur Kenntnis genommen oder weitergegeben.
- **Integrität**: Korrektheit der Informationen und Funktionsweise von Systemen ist nicht mehr gegeben.
- **Verfügbarkeit**: autorisierte Benutzer werden am Zugriff auf Informationen und Systeme behindert.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 17 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-02 | typ: definition | pruefung: AP1/AP2 -->
**Welche drei Schutzbedarfskategorien empfiehlt die IT-Grundschutz-Methodik und wie grenzen sie sich beim Schadensausmaß ab?**
?
- **normal**: Die Schadensauswirkungen sind begrenzt und überschaubar.
- **hoch**: Die Schadensauswirkungen können beträchtlich sein.
- **sehr hoch**: Die Schadensauswirkungen können ein existentiell bedrohliches, katastrophales Ausmaß erreichen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 17 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-03 | typ: anwendung | pruefung: AP1/AP2 -->
**Welche sechs Schadensszenarien werden bei der Schutzbedarfsfeststellung berücksichtigt?**
?
1. Verstöße gegen Gesetze, Vorschriften oder Verträge sowie Beeinträchtigungen des informationellen Selbstbestimmungsrechts.
2. Beeinträchtigungen der persönlichen Unversehrtheit oder der Aufgabenerfüllung.
3. Negative Innen- oder Außenwirkung (Image-Schaden) sowie finanzielle Auswirkungen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 17 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-04 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Wie unterscheiden sich Maximumprinzip, Kumulationseffekt und Verteilungseffekt bei der Vererbung des Schutzbedarfs auf ein IT-System?**
?
- **Maximumprinzip**: Der höchste Schutzbedarf aller darauf laufenden Anwendungen wird übernommen.
- **Kumulationseffekt**: Mehrere Einzelschäden (z. B. gleichzeitiger Ausfall normaler Anwendungen auf einem Server) addieren sich zu einem höheren Gesamtschaden.
- **Verteilungseffekt**: Der Schutzbedarf sinkt, wenn eine Anwendung verteilt ist und auf dem System nur weniger kritische Teile oder redundante Ausweichsysteme laufen.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 17 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-05 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Unter welchen Bedingungen kann der Schutzbedarf eines IT-Systems bezüglich Verfügbarkeit geringer sein als der der zugeordneten Anwendung?**
?
1. Wenn das IT-System nur weniger wichtige Teile einer Anwendung bedient (z. B. bei verteilter Architektur oder nur pseudonymisierten Daten).
2. Wenn mindestens ein weiteres **redundantes IT-System** in Betrieb ist, das die Anwendung innerhalb kurzer Zeit bereitstellen kann (**Verteilungseffekt**).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 23 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-06 | typ: pruefungsfalle | pruefung: AP1/AP2 -->
**Warum kann ein Raum mit zwei gespiegelten Servern (jeweils normaler Schutzbedarf) einen höheren Schutzbedarf haben als die einzelnen Server?**
?
Durch den **Kumulationseffekt**: Fällt ein Server aus, übernimmt der zweite – fällt jedoch der gesamte Raum aus (z. B. durch einen Brand), sind **beide** Server gleichzeitig betroffen.
Werden die gespiegelten Server auf unterschiedliche Räume oder Gebäude verteilt, tritt dieser Effekt nicht auf.
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 22 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*

---

<!-- card-id: schutzbedarfsfeststellung-07 | typ: abgrenzung | pruefung: AP1/AP2 -->
**Welche drei Arten von Kommunikationsverbindungen sollten bei der Schutzbedarfsfeststellung als kritisch eingestuft werden?**
?
1. Verbindungen, die aus der Institution in ein **öffentliches Netz** (z. B. Internet) oder über öffentliches Gelände reichen.
2. Verbindungen, über die **besonders schützenswerte Informationen** übertragen werden (Gefahr von Abhören, Manipulation, Ausfall).
3. Verbindungen, über die **vertrauliche Informationen nicht übertragen werden dürfen** (Schutz vor Einsicht durch Unbefugte).
*Quelle: ITT IT-Technik (1. LJ) · `Skript_Wittmann.pdf` S. 22 (von 103) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Sicherheit_Skript_Wittmann|Quellnotiz]]*
