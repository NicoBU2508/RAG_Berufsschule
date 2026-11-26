---
typ: karteikarten_deck
thema: "Node-RED und IoT-Flows"
kategorie: IT_Technik_und_Sicherheit
pruefung: "BS"
thema_quelle: "03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Node-RED und IoT-Flows.md"
stand_karten: 2026-11-24
stand_quelle: 2026-11-24
quellseiten_anzahl: 3
quellseiten_hash: 437fb1ed7985
quellseiten:
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift#page=15"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=1"
  - "02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED#page=2"
rag_include: false
canonical_evidence: false
tags:
  - karteikarten
  - flashcards/it-technik-und-sicherheit/node-red-und-iot-flows
---
# 🗂️ Karteikarten: Node-RED und IoT-Flows

> [!tip] Quellenbasis
> Alle Karten basieren ausschließlich auf [[03_Themen/Visuell_geprueft/IT_Technik_und_Sicherheit/Node-RED und IoT-Flows|Node-RED und IoT-Flows]] (**3 visuell geprüfte Seiten**).

---

<!-- card-id: node-red-und-iot-flows-01 | typ: definition | pruefung: BS -->
**Welche drei Standard-Attribute besitzt jedes Nachrichtenobjekt (`msg`) in Node-RED und wofür stehen `payload` und `topic`?**
?
Jedes Nachrichtenobjekt besitzt `msg.payload`, `msg.topic` und `msg._msgid`. `Payload` bezeichnet die Nutzlast (den eigentlichen Inhalt einer Übertragung) und `Topic` das Thema der Nachricht.
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 2](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=2>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: node-red-und-iot-flows-02 | typ: pruefungsfalle | pruefung: BS -->
**Woran erkennt man in Node-RED, dass Änderungen an einem Node noch nicht aktiv sind, und wie werden sie übernommen?**
?
Ein blauer Punkt am Node signalisiert, dass Änderungen noch nicht ausgerollt wurden. Erst über die Schaltfläche „Deploy“ wird der angepasste Flow übernommen und ausgeführt.
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 1](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=1>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]]*

---

<!-- card-id: node-red-und-iot-flows-03 | typ: abgrenzung | pruefung: BS -->
**Welche Rollenverteilung gilt zwischen Steuerung (z. B. S7/LOGO!) und Node-RED, und welche drei Parameter definieren einen Endpoint?**
?
Die Steuerung übernimmt die Rolle des Servers, während Node-RED als Client (über S7-Node oder OPC-Node) zugreift. Die Schnittstellendefinition eines Endpoints umfasst IP-Adresse, Port und die jeweilige Variable für den lesenden oder schreibenden Zugriff.
*Quelle: ITT IT-Technik (2. LJ) · [20261005_145426.pdf · S. 15](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Liebscher/20261005_145426.pdf#page=15>) (von 18) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: node-red-und-iot-flows-04 | typ: abgrenzung | pruefung: BS -->
**Welche Aufgaben übernehmen das IoT-Gateway und der MQTT-Broker bei der Vernetzung cyberphysischer Systeme mit Node-RED?**
?
Das IoT-Gateway sorgt für die Trennung zwischen IT-Netz und OT-Netz (Steuerungen/Sensorik). Der MQTT-Broker vermittelt Nachrichten zwischen den Komponenten nach dem Publish/Subscribe-Prinzip.
*Quelle: ITT IT-Technik (2. LJ) · [20261005_145426.pdf · S. 15](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Liebscher/20261005_145426.pdf#page=15>) (von 18) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Liebscher_Mitschrift|Quellnotiz]], OCR/Original prüfen*

---

<!-- card-id: node-red-und-iot-flows-05 | typ: anwendung | pruefung: BS -->
**Wie ist ein Ping-Flow in Node-RED aufgebaut, der die Erreichbarkeit eines Servers regelmäßig prüft und als Statusmeldung ausgibt?**
?
Ein Inject-Node löst den Ping-Node periodisch (z. B. jede Minute) aus; ein Switch-Node teilt bei Erfolg bzw. Misserfolg auf zwei Pfade auf, Change-Nodes setzen die passende Text-Payload („läuft“ / „offline“) und ein Debug-Node gibt die Meldung aus.
*Quelle: ITT IT-Technik (2. LJ) · [Unbenannt.pdf · S. 2](<99_Originale/Berufsschule/ITT/2_LJ/IT_Tech_Zielske/Unbenannt.pdf#page=2>) (von 9) · [[02_Faecher/ITT_IT_Technik/Quellen/IT_Tech_2LJ_Zielske_Node_RED|Quellnotiz]], OCR/Original prüfen*
