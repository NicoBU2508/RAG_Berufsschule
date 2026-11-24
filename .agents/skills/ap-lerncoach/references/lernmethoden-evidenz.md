# Wissenschaftliche Evidenzbasis des AP-Lerncoach-Skills

Diese Referenz fasst die empirisch gesicherten Lernmethoden, Meta-Analysen und aktuellen KI-Tutor-Studien zusammen, auf denen [SKILL.md](../SKILL.md) aufbaut. Alle Prinzipien stammen aus begutachteter Kognitions-, Lern- und Bildungspsychologie.

---

## 1. Kernstrategien im Überblick (Evidenz-Matrix)

| Methode | Zentrale Primärstudien / Meta-Analysen | Empirischer Befund | Konkrete Umsetzung im Skill |
|---|---|---|---|
| **Active Recall / Retrieval Practice (Testing Effect)** | Dunlosky et al. (2013, *PSPI*, **High Utility**); Roediger & Karpicke (2006); Roediger & Butler (2011, *TiCS*); Adesope et al. (2017, *RER*) | Aktives Abrufen aus dem Gedächtnis stärkt Speicher- und Abrufspuren deutlich stärker als nochmaliges Lesen oder Markieren — auch bei identischer Lernzeit. | Jede Erklärung schließt mit 1–2 aktiven Abruffragen (freier Abruf vor Multiple Choice) ohne direkt sichtbare Lösung. |
| **Spaced Repetition / Distributed Practice** | Dunlosky et al. (2013, **High Utility**); Cepeda et al. (2006, *Psych. Bulletin*); Cepeda et al. (2008, *Psych. Science*); Bjork & Bjork (2011) | Verteiltes Wiederholen über Zeit schlägt Bulimielernen dramatisch. Optimaler Abstand hängt vom Zielhorizont ab: ca. **20–40 %** bei 1 Woche Ziel, **5–10 %** bei 1 Jahr Ziel. | Am Session-Ende konkreter Wiederholungsplan (`+1 / +3 / +7 / +21 / +60` Tage bzw. dynamisch am AP1/AP2-Datum ausgerichtet). |
| **Sokratisches KI-Scaffolding (Anti-Cognitive-Offloading)** | Kestin et al. (2025, *Scientific Reports*, Harvard RCT); Bastani et al. (2024/2025, *PNAS*); Fan et al. (2024/2025, *BJET*); Google DeepMind LearnLM (2024/2025, arXiv:2407.12687 & 2412.16429) | Ungeschützte KI-Antwortgeber führen zu **−17 %** schlechterer Eigenleistung ohne KI (*Cognitive Offloading* / *Metacognitive Laziness*). Didaktisch geführte KI-Tutoren erzielen dagegen **> 2× höheren Lernzuwachs** als klassisches aktives Lernen. | Strenges 3-Stufen-Scaffolding (Denkimpuls → Hinweis/Gerüst → Musterlösung erst nach Versuch); nie sofort Komplettlösung bei Übungen. |
| **Interleaved Practice (Verschachtelung)** | Rohrer & Taylor (2007); Dunlosky et al. (2013, Moderate Utility); Brunmair & Richter (2019, *Psych. Bulletin*, Hedges' **g = 0,42**) | Mischen ähnlicher Aufgabentypen schärft die Unterscheidung (*„Similarity matters“*), besonders bei Mathematik, Code, Kategorien und verwechselbaren Regeln. Schwächer bei unzusammenhängenden Einzeltexten. | Gezielt einsetzen für verwechselbare Paare/Familien (SQL-Klauseln, RAID, Netzwerkprotokolle, Vertragsarten, Kalkulationen), **nach** erstem Grundverständnis. |
| **Cognitive Load Theory & Worked-Example-Fading** | Sweller (1988, 2011); Kalyuga et al. (2003, *Expertise Reversal*); Renkl & Atkinson (2003); Renkl (2014) | Arbeitsgedächtnis ist stark begrenzt. Anfänger lernen am besten mit **Worked Examples**; bei Fortgeschrittenen kehrt sich der Effekt um (*Expertise Reversal*). | Adaptiver Einstieg: Anfänger erhalten Worked Example → Completion Problem → freie Aufgabe; Fortgeschrittene starten direkt mit Transfer/Grenzfällen. |
| **Pretesting & Productive Failure** | Kornell, Hays & Bjork (2009); Kapur (2008, 2016); Pan & Sana (2021) | Kurzes Testen oder Problemversuche *vor* der Erklärung — selbst bei hoher Fehlerquote — aktivieren Vorwissen und verbessern die anschließende Einspeicherung der Lösung. | Optionaler 1-Frage-Pretest vor neuen Themen („Was vermutest du?“); Fehler explizit als produktiven Startpunkt normalisieren. |
| **Generative Learning (Elaboration, Self-Explanation, Mapping, Teaching)** | Fiorella & Mayer (2016, *Educ. Psych. Review*, SOI-Modell); Chi et al. (1994); Weinstein, Madan & Sumeracki (2018, *CRPI*) | Tiefes Lernen entsteht durch aktives **Auswählen, Organisieren und Integrieren** (SOI) — u. a. durch *Warum*-Fragen (Elaborative Interrogation), Concept Maps und Erklären an andere (Protégé-Effekt / Feynman). | Gezielte *Warum/Wie*-Rückfragen, visuelle Übersichten/Maps und dedizierter Feynman-Lehr-Modus („Erkläre es einem Azubi im 1. LJ“). |
| **Dual Coding, Farbcodierung & Multimedia-Layout** | Paivio (1971, 1986); Mayer (CTML: *Coherence, Segmenting, Signaling, Spatial Contiguity*); Schneider et al. (2018) | Prägnanter Text + visuelle Struktur nutzen zwei Gedächtnispfade. Konsistente Farbsignale (*Signaling*) und Weglassen von Ballast (*Coherence*) senken *Extraneous Cognitive Load* deutlich. | Fester Farbcode (`🔵🟢🟡🔴`), farbige Mini-Mermaid-Diagramme (max. 6 Knoten), `> [!TIP]`/`> [!WARNING]`, kompakte Tabellen, max. 2–3 Zeilen pro Punkt. |
| **Advance Organizer (Kurz-Antwort zuerst / BLUF)** | Ausubel (1960); Mayer (*Pre-Training Principle*) | Ein vorangestellter Überblick aktiviert ein mentales Grundgerüst, in das Details sofort logisch eingeordnet werden können. | Jede Erklärkarte startet ohne Callout-Tag mit **1–2 fett gesetzten Kernsätzen** (Oberbegriff + direkte Antwort) ganz oben. |
| **Mnemonics, Eselsbrücken & Chunking** | Dunlosky et al. (2013, Moderate Utility); Putnam (2015); Miller (1956) | Kurze Merksätze und visuelles Bündeln (*Chunking*) verdichten leicht verwechselbare Fakten zu schnellen Abruf-Ankern und entlasten das Arbeitsgedächtnis. | Jede Lernkarte enthält eine griffige **Eselsbrücke / Merksatz** (`> [!TIP]`) und ultrakompakte Kontrast-Tabellen (max. 4–5 Wörter/Zelle). |
| **Wenn-Dann-Entscheidungsregeln (Implementation Intentions)** | Gollwitzer (1999); Sweller (*Cognitive Load Theory*) | Vorab formulierte `Wenn X → dann Y`-Regeln automatisieren typische Prüfungsentscheidungen und halten Arbeitsgedächtnis für Transfer frei. | Kompakte **Prüfungs-Regeln (`> [!WARNING]`)** mit konkreter `Wenn … → immer …`-Heuristik + häufigster Falle. |
| **Konkrete Beispiele** | Weinstein, Madan & Sumeracki (2018, *CRPI*); Rawson et al. (2015) | Abstrakte Regeln haften schlecht ohne Anker. Konkrete, realistische Anwendungsfälle verankern Konzepte und erleichtern späteren Transfer. | Jedes theoretische Konzept erhält mindestens 1 konkretes Fachinformatiker-/Betriebsbeispiel (bevorzugt aus dem Vault). |
| **Metakognition, Kalibrierung & Hypercorrection** | Karpicke, Butler & Roediger (2009); Butterfield & Metcalfe (2001); Zimmerman (2000, 2002, SRL-Zyklus) | Passives Lesen erzeugt *Kompetenzillusionen*. Überraschend: **Mit hoher Sicherheit begangene Fehler** werden nach klarem Feedback *nachhaltiger* korrigiert als geratene Fehler (*Hypercorrection-Effekt*). | Sicherheits-Rating (1–3) bei Quizzen, explizites Kontrastieren sicherer Denkfehler, SRL-Struktur (*Forethought → Performance → Self-Reflection*). |
| **Formatives Feedback** | Hattie & Timperley (2007, *RER*); Shute (2008, *RER*) | Wirksames Feedback richtet sich auf Aufgabe, Prozess und Selbstregulation (nicht auf pauschales Personenlob) und beantwortet *Feed Up, Feed Back, Feed Forward*. | Jede Korrektur trennt klar: (1) Konkreter Ist-Stand, (2) IHK-/Zielmaßstab, (3) Konkreter nächster Übungsschritt. |
| **Kognitive Taxonomie & Operatoren** | Anderson & Krathwohl (2001, überarbeitete Bloom-Taxonomie) | Lern- und Prüfungsleistungen bauen stufenweise auf: *Erinnern → Verstehen → Anwenden → Analysieren → Bewerten → Erschaffen*. | Steigerung der Aufgabentiefe im Training und exakte Ausrichtung auf IHK-Prüfungsoperatoren. |

---

## 2. Was der Skill bewusst VERMEIDET (nachweislich ineffektiv)

Aus Dunlosky et al. (2013), Karpicke et al. (2009), Bastani et al. (2024/2025) und Fan et al. (2024/2025):

1. **Passives Wiederlesen / endlose Textwände:** Erzeugt nur kurzfristige Vertrautheit (*Fluency Illusion*, hohe *Retrieval Strength*, niedrige *Storage Strength* nach Bjork & Bjork 2011).
2. **Sofortiges Komplettlösen durch die KI:** Fördert *Cognitive Offloading* und *Metacognitive Laziness* — der Output sieht perfekt aus, aber im Kopf bleibt fast nichts hängen.
3. **Massed Practice (Bulimielernen ohne Pausen):** Kurzfristig trügerisch effektiv, langfristig steiler Vergessensabfall.
4. **Seductive Details & Deko-Ballast:** Überflüssige Ausschmückungen erhöhen *Extraneous Cognitive Load* (Mayer, *Coherence Principle*).
5. **Ungezieltes Interleaving bei völligen Anfängern:** Zu früh gemischte Konzepte überfordern das Arbeitsgedächtnis — erst Kernschema aufbauen, dann verschachteln.

---

## 3. Spaced-Repetition-Faustregel für AP1 & AP2 (nach Cepeda et al. 2008)

| Abstand bis zur Prüfung / Klassenarbeit | Empfohlene Wiederholungsintervalle |
|---|---|
| **Kurzfristig (1 Woche)** | Tag 0 (Lernen + Sofort-Check) → **Tag +1** → **Tag +3** → **Tag +5** (Kurz-Generalprobe) |
| **Mittelfristig (4–6 Wochen)** | Tag 0 → **Tag +1** → **Tag +4** → **Tag +10** → **Tag +21** → **3 Tage vor Prüfung** |
| **Langfristig (AP1 / AP2 in 3–12 Monaten)** | Tag 0 → **Tag +1** → **Tag +3** → **Tag +7** → **Tag +21** → **Tag +60** → **monatlicher Interleaved-Mix** |

**Grundregel:** Wenn ein Abruf **mühelos richtig** war → nächstes Intervall verdoppeln/verlängern. Wenn **unsicher oder falsch** → Intervall zurück auf `Tag +1` setzen und gezielt 1 Gegenbeispiel üben.

---

## 4. Google DeepMind LearnLM – 5 Leitprinzipien für Gemini als Tutor

Die speziell für Gemini entwickelte pädagogische Leitlinie (*LearnLM*, arXiv:2407.12687 & arXiv:2412.16429) fasst die optimale Tutor-Haltung in fünf Prinzipien zusammen, die in jedem Gespräch aktiv bleiben:

1. **Inspire Active Learning:** Lernende denken, formulieren, rechnen und begründen lassen statt fertige Texte zu liefern.
2. **Manage Cognitive Load:** Komplexe Themen in klare, sequenzielle Chunks mit visueller Struktur zerlegen.
3. **Adapt to the Learner:** Erklärtiefe, Tempo und Hilfestufen dynamisch an Vorwissen und Antworten anpassen.
4. **Stimulate Curiosity:** Konzepte mit echten IT-Praxisszenarien und *„Was passiert, wenn…?“*-Fragen verknüpfen.
5. **Deepen Metacognition:** Reflexion über den eigenen Lösungsweg, Fehlerursachen und Lernstrategien anregen.
