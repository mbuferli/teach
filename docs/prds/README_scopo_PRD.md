# Scopo di questo PRD

## Contesto

Matteo è stato invitato a tenere una docenza di **9 ore** (3 incontri da 3 ore) nell'ambito del corso "Tecnico per la sicurezza delle reti e dei servizi in cloud", presso la sede FAV. La docenza si inserisce nel modulo **"Implementazione e verifica della sicurezza delle reti e dei sistemi con l'ausilio di AI"**, e il committente ha chiesto un affondo sull'esperienza diretta del docente in ambito **AI e ISO 27001**.

Le date proposte sono:
- 22/07 (9-12)
- 27/07 (9-12)
- 29/07 (9-12)

## A cosa serve il file `PRD_Corso_Sicurezza_Reti_Cloud.md`

È il **documento di pianificazione del corso**, nato da una conversazione di brainstorming e progressivo affinamento. Contiene:

1. I dati generali del corso (docente, date, sede, obiettivi)
2. La struttura dettagliata delle tre lezioni, punto per punto
3. Un'attività di laboratorio pratico basata su **Floci** (emulatore locale gratuito di servizi AWS/GCP/Azure), pensata per far esercitare i ragazzi su uno scenario cloud volutamente vulnerabile
4. Uno stato di avanzamento esplicito: cosa è già definito e cosa manca ancora

## Stato attuale del lavoro

- **Lezione 1**: contenuto considerato completo e pronto (inclusa l'apertura con presentazioni e il laboratorio Floci)
- **Lezione 2 e Lezione 3**: contengono solo una **bozza di brainstorming**, non ancora validata da Matteo. Vanno riviste insieme a lui prima di essere considerate definitive — verificare in particolare taglio dei contenuti, esempi reali da inserire, e se l'esercitazione pratica proposta (mini Acceptable Use Policy) è realistica nei tempi

## Come continuare da qui

Se questa conversazione viene ripresa da un altro agente, da un'altra sessione, o direttamente da Matteo, i prossimi passi naturali sono:

1. Rivedere con Matteo i contenuti di Lezione 2 e Lezione 3, marcati come "da revisionare" nel PRD
2. Definire il dettaglio tecnico del laboratorio Floci per la Lezione 1 (script di setup dell'ambiente vulnerabile: bucket S3 pubblico, IAM troppo permissivo, ecc.)
3. Verificare con il referente IT della FAV la compatibilità dei PC d'aula con Docker/Floci (necessario per il laboratorio)
4. Eventualmente trasformare il PRD in materiale operativo: slide, scaletta con timing minuto per minuto, script del laboratorio

## Nota

Il file PRD è in formato Markdown proprio per essere facilmente leggibile, modificabile e riutilizzabile da altri strumenti/agenti, senza dipendenze da formati proprietari.
