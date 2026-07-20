# PRD – Piano di Realizzazione del Corso

*Tecnico per la sicurezza delle reti e dei servizi in cloud*

## 1. Informazioni generali

| Campo | Valore |
|---|---|
| Docente | Matteo |
| Corso | Tecnico per la sicurezza delle reti e dei servizi in cloud |
| Modulo | Implementazione e verifica della sicurezza delle reti e dei sistemi con l'ausilio di AI |
| Durata totale | 9 ore (3 incontri da 3 ore) |
| Sede | FAV – aula informatica (PC docente e allievi, proiettore) |
| Supporto IT | Referente IT disponibile su richiesta per strumenti/software specifici |

### Calendario proposto

- 22/07 — ore 9:00-12:00 — Lezione 1
- 27/07 — ore 9:00-12:00 — Lezione 2
- 29/07 — ore 9:00-12:00 — Lezione 3

### Obiettivo del modulo

Fornire ai ragazzi un approfondimento pratico sull'esperienza del docente in ambito AI e ISO 27001, con contenuti utili a formare sistemisti capaci di gestire la sicurezza di reti e servizi cloud anche alla luce dell'introduzione dell'intelligenza artificiale negli strumenti e nei processi di sicurezza.

---

## 2. Lezione 1 — Fondamenta ISO 27001 applicate a reti e cloud

| Campo | Valore |
|---|---|
| Data | 22/07/2026 |
| Orario | 9:00 – 12:00 |
| Stato | ✅ Contenuto definito |

### Apertura (30 minuti)

- Presentazione del docente: percorso professionale, esperienze concrete (AI, 27001), 1-2 aneddoti introduttivi ai temi del corso (10-15 min)
- Presentazione degli allievi: nome, motivazione del percorso, aspettative (10-15 min)
- Illustrazione del funzionamento delle 9 ore: aspettative reciproche, modalità di lavoro

### Fondamenta ISO 27001 applicate a reti e cloud

- Cos'è un ISMS e perché esiste
  - Definizione di Information Security Management System
  - Il ciclo PDCA (Plan-Do-Check-Act) spiegato con un esempio pratico
  - Differenza tra "fare sicurezza" in modo estemporaneo e gestirla con un sistema strutturato
  - Perché le aziende lo adottano: non solo compliance normativa, ma gestione concreta del rischio e credibilità verso clienti/partner
- I controlli Annex A più rilevanti per reti e cloud
  - Gestione della sicurezza di rete (segmentazione, monitoraggio, controllo del traffico)
  - Controllo accessi (autenticazione, autorizzazione, principio del minimo privilegio)
  - Crittografia (dati a riposo e in transito)
  - Sicurezza dei servizi cloud (controllo 5.23): responsabilità condivisa cliente/provider, cosa verificare in un contratto cloud
- Racconto di casi reali
  - Un episodio concreto da un audit o un'implementazione seguita dal docente
  - Cosa è andato storto/bene e perché
  - Il "dietro le quinte" che i ragazzi non troverebbero su un manuale

### Attività pratica

- Scenario guidato: migrazione di un servizio interno su cloud (AWS/Azure)
- Risk assessment in piccoli gruppi: identificare asset, minacce, vulnerabilità
- Discussione finale in plenaria sui risultati

### Laboratorio tecnico — Floci

Uso di Floci (emulatore locale gratuito e open source di servizi AWS/GCP/Azure, alternativa a LocalStack) per creare un ambiente cloud con una configurazione volutamente vulnerabile, da far analizzare e correggere ai ragazzi.

- Ambiente preparato in anticipo dal docente con uno script (es. bucket S3 con permessi troppo aperti, utente IAM con privilegi eccessivi, segreto salvato in chiaro invece che come SecureString)
- I ragazzi usano la CLI AWS standard (puntata su Floci in locale) per esplorare l'ambiente, individuare il problema e correggerlo
- Attività lasciabile anche per casa: chi ha un portatile può proseguire in locale; per gli altri, valutare un ambiente cloud condiviso con Floci già installato
- Verifica preliminare consigliata: testare l'esercizio su un PC dell'aula (Floci richiede accesso al socket Docker) e coinvolgere il referente IT se necessario

**✅ Implementato e testato end-to-end (16/07/2026)** in `lab/lezione-01-fondamenta-iso27001/`:
- Scenario "NuvolaSoft" — i tre problemi descritti sopra, creati da `setup.sh`
- `README.md` — come avviare l'ambiente (`make up/setup/audit/watch/down`) e cosa contiene
- `SOLUTIONS.md` — comandi di fix verificati per ciascuno dei tre problemi
- `audit.sh` — verifica di conformità che fallisce finché i problemi non sono corretti; con `--watch` ricontrolla in loop e si ferma da sola (banner verde) quando tutto è a posto
- Testato interamente in locale: setup → audit (3 FAIL) → fix → audit (3 PASS), incluso il flusso `--watch` dal vivo
- Resta da fare: verificare compatibilità con i PC dell'aula FAV (accesso al socket Docker) col referente IT

---

## 3. Lezione 2 — L'AI nella sicurezza operativa

| Campo | Valore |
|---|---|
| Data | 27/07/2026 |
| Orario | 9:00 – 12:00 |
| Stato | ⚠️ DA REVISIONARE (bilanciamento tra i tre tagli validato con il docente, dettagli di contenuto ancora da rifinire) |

> **⚠️ DA REVISIONARE**
> Contenuti proposti in fase di brainstorming, non ancora confermati né validati nel dettaglio con il docente. Da rivedere insieme prima dell'erogazione.

> **Nota sul bilanciamento dei tagli (decisione del docente, 15/07/2026)**
> Il modulo si chiama "...con l'ausilio di AI": il taglio principale della lezione deve quindi essere l'**AI come strumento di appoggio/difesa**, non come strumento offensivo. La lezione è pensata per sistemisti, non per un corso di offensive security/red-teaming — le tecniche di attacco vengono solo accennate quanto basta a motivare la necessità di governance, senza approfondimenti tecnici da red team. La governance (ISO 42001) è la cornice che tiene il discorso agganciato al filo conduttore ISO 27001 già impostato in Lezione 1. Ordine di priorità/tempo: (1) AI come aiuto/difesa — la parte con più tempo dedicato, (2) governance ISO 42001 come cornice, (3) rischi/uso improprio — trattati come motivazione per la governance, non come pilastro autonomo.

### 1. AI come strumento di appoggio e difesa (taglio principale — più tempo dedicato)

- Detection di anomalie di rete (traffico anomalo, comportamenti sospetti)
- SOC assistiti da AI: come cambia il lavoro dell'analista
- Triage automatico degli alert (riduzione del rumore, prioritizzazione)
- Phishing detection basato su modelli AI

### 2. Governare l'AI: introduzione a ISO 42001

- Cos'è un AI Management System, in breve
- Perché è il "cugino" del 27001: stesso approccio risk-based, applicato all'AI
- Come si integra (o si affianca) a un ISMS già esistente
- Perché la governance serve proprio a gestire i rischi introdotti dall'AI (collegamento al punto 3)

### 3. Perché serve la governance: rischi e uso improprio (accennati, non approfonditi tecnicamente)

- Data poisoning: cosa significa e perché è pericoloso (a livello concettuale)
- Prompt injection: un esempio semplice da mostrare in aula, solo per far capire il concetto — non un approfondimento tecnico offensivo
- Shadow AI: dipendenti che usano strumenti AI pubblici con dati aziendali sensibili
- Casi reali (anche anonimizzati) di incidenti legati a uso improprio dell'AI, presentati come lezioni imparate, non come tecniche da replicare

### Attività pratica/demo

- Analisi di log con uno strumento AI-based (demo dal vivo se possibile) — coerente con il taglio "AI come aiuto"
- In alternativa: discussione guidata su un caso concreto di incidente da AI, con proposta di contromisure da parte dei ragazzi (le contromisure, non l'attacco, restano il focus)

---

## 4. Lezione 3 — Convergenza e messa in pratica

| Campo | Valore |
|---|---|
| Data | 29/07/2026 |
| Orario | 9:00 – 12:00 |
| Stato | ⚠️ DA REVISIONARE |

> **⚠️ DA REVISIONARE**
> Contenuti proposti in fase di brainstorming, non ancora confermati né validati con il docente. Da rivedere insieme prima dell'erogazione.

### Aggiornare il risk register con rischi AI-related

- Come si inseriscono nuove categorie di rischio in un registro esistente
- Esempio pratico di voce di rischio "uso non controllato di AI generativa"

### Esercitazione a gruppi: mini Acceptable Use Policy

- Scrivere in gruppo una policy semplificata sull'uso sicuro di strumenti AI in azienda
- Punti minimi da includere: dati che non si possono condividere, strumenti approvati, responsabilità
- Presentazione e confronto tra i gruppi

### Le esperienze dirette del docente

- Cosa ha funzionato quando 27001 e AI si sono incrociati nel lavoro del docente
- Cosa invece non ha funzionato, e le lezioni imparate
- Consigli pratici "sul campo" che non si trovano nei framework teorici

### Chiusura: percorsi di crescita per un sistemista

- Certificazioni utili (ISO 27001 Lead Auditor/Implementer, altre pertinenti)
- Competenze da costruire nel breve-medio termine
- Consigli pratici su come muoversi nei primi anni di carriera

---

## 5. Stato di avanzamento e prossimi passi

- **Lezione 1**: contenuti definiti, inclusa l'attività di laboratorio con Floci. Presentazione in formato Marp abbozzata in `docs/slides/lezione-01-fondamenta-iso27001.md` — copre apertura, fondamenta ISO 27001 e attività pratica; si ferma volutamente subito prima del blocco laboratorio Floci (da preparare a parte). Contiene placeholder `[DA COMPLETARE]` per gli aneddoti personali del docente.
- **Lezione 2**: bilanciamento dei tagli validato con il docente (AI come aiuto/difesa in primo piano, ISO 42001 come cornice, rischi/offensivo solo accennati per motivare la governance) — restano da validare i singoli esempi reali, i casi di incidente e il dettaglio della demo
- **Lezione 3**: da revisionare con il docente — validare esercitazione AUP e contenuti sui percorsi di crescita
- **Da definire**: verifica compatibilità con i PC d'aula (accesso al socket Docker) — il laboratorio Floci stesso è ora implementato e testato, vedi `lab/lezione-01-fondamenta-iso27001/`

> **Nota — laboratorio Floci costruito da zero (15/07/2026)**
> Esiste una cartella `isodevops/` con un piano di corso precedente (giugno 2026, stessa docenza) che include già un laboratorio Floci funzionante (Terraform + Docker + Makefile + audit) per un tema di governance/IAM molto simile. Il docente ha scelto esplicitamente di **non riusarlo** e ripartire da zero seguendo lo scenario descritto in questo PRD (bucket S3 pubblico, IAM eccessivo, segreto in chiaro). La cartella `isodevops/` resta intatta ma non va considerata la base per il laboratorio di questo corso.
