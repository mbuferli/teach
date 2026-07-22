---
marp: true
theme: cc-dark
paginate: true
size: 16:9

style: |
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;

    /* Center align content vertically */
    align-items: center;
  }
---

<!--
Lezione 1 — Fondamenta ISO 27001 applicate a reti e cloud
Data: 22/07/2026, 9:00-12:00 (3h)
Fonte: docs/prds/PRD_Corso_Sicurezza_Reti_Cloud.md — sezione 2

Questo deck copre: Apertura, Fondamenta ISO 27001, Attività pratica (risk assessment).
Si ferma volutamente PRIMA del laboratorio Floci: quel blocco (scenario vulnerabile,
istruzioni CLI, hint) va preparato a parte quando arriviamo a quel punto del corso.

Timing indicativo (totale 180 min, di cui 30 fissati nel PRD per l'apertura):
- Apertura: 30 min (fisso da PRD)
- Fondamenta ISO 27001: ~45-50 min
- Attività pratica (risk assessment): ~30-35 min
- Laboratorio Floci: ~60-70 min (da preparare a parte)
-->

# Tecnico per la sicurezza delle reti e dei servizi in cloud

## Lezione 1 — Fondamenta ISO 27001 applicate a reti e cloud

22/07/2026 — 9:00-12:00

**Matteo** Buferli — *Founder Comuni-Chiamo.com*
matteo.buferli@comuni-chiamo.com

---

# Chi sono

---

- Matteo Buferli 
- Laurea Triennale in Scienze dell'Informazione a Bologna
- Founder di Comuni-Chiamo.com

---

- Ho cominciato ad usare il PC a 13 anni (ne compio 40 a breve), con un bellissimo Pentium II della Packard Bell, che ho rotto dopo pochi mesi di utilizzo ...

---

![bg cover](images/pb.jpg)

---

- ... ascoltavo Spotify ...

---

![bg cover](images/walkman.webp)

---

- ... mi ritrovavo in uno spazio virtuale con i miei amici ...

---

![bg cover](images/wow.jpg)

---

- spesso solo per fare 2 chiacchiere :)

---

<style>
img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
</style>

![w:50% center](images/ts.jpg)

---

- 2009: Laurea triennale in scienze dell'informazione a Bologna
- 2009 - 2011: Junior Developer @ Almalaurea
- 2011 - oggi: fondo **Comuni-Chiamo** — software as a service per la gestione delle segnalazioni dei cittadini, oggi usato da 100+ comuni e 6.500+ operatori
- dal 2016 al 2023: Mentor @ Fondazione Golinelli — Palestra di imprenditorialità

---

![bg cover](images/c-c.png)

---

## Comuni-Chiamo (1)

- *The story so far ...*

---

## Comuni-Chiamo (2012 - 2015)

Il mio ruolo nel tempo (1):

<div class="columns">
<div>

- Founder
- Frontend Developer
- Backend Developer
- Mobile Developer

</div>

<div>

- DevOps
- Software Architect
- System Administrator
- System Integrator

</div>
</div>

---

## Comuni-Chiamo (2016 - 2020)

Il mio ruolo nel tempo (2):

<div class="columns">
<div>

- Founder
- ~~Frontend Developer~~
- **Design System Engineer**
- Backend Developer
- ~~Mobile Developer~~
- ~~DevOps~~

</div>
<div>

- Software Architect
- System Administrator
- System Integrator
- **Project Manager**

- **Mentor** @ Fondazione Golinelli (Palestra di imprenditorialità)

</div>
</div>

---

![bg cover](images/fg.jpg)

---

## Comuni-Chiamo (2021 - 2023)

Il mio ruolo nel tempo (3):

<div class="columns">
<div>

- Founder
- **Tech Team Leader** + Project Manager
- Design System Engineer
- Backend Developer
- Project Manager

</div>
<div>

- Software Architect
- System Administrator
- System Integrator
- **Cloud Specialist (Partner AWS)**

- ~~Mentor~~

</div>
</div>

---

## Comuni-Chiamo (2023 - --> Today)

Il mio ruolo nel tempo (3):

<div class="columns">
<div>

- Founder
- Tech Team Leader + Project Manager
- Design System Engineer
- Backend Developer
- Project Manager

</div>
<div>

- Software Architect
- System Administrator
- System Integrator
- Cloud Specialist
- **ISO 9001 / ISO 27001 / NIS2 Specialist**

</div>
</div>

---

## Comuni-Chiamo (2027)

Nuovi ruoli (?):

- Enterprise AI Architect
- AI Security Engineer 
- Private AI Deployment Specialist

---

## Sharing is caring!

Giro di presentazioni (volontario):

- Nome
- Cosa ti piace di questo ambito?
- Cosa vorresti imparare?

---

## Importante

In questa industria non c'è un unico modo per fare le cose, ma più di uno.

E quello che impariamo, a volte è già obsoleto.

---

## Ready?

---

# Fondamenta ISO 27001 applicate a reti e cloud

---

## Cos'è un ISMS 
*Information Security Management System*

---

Non è:

- un prodotto
- un firewall
- una soluzione che possiamo installare

---

**Information Security Management System**

È un **sistema di gestione**

- Un insieme di politiche, processi e controlli
- Per gestire il rischio sulle informazioni in modo continuo
- Non "sicurezza fatta una volta", ma un ciclo che si ripete

---

## Il ciclo PDCA

**Plan → Do → Check → Act**

| Fase | Cosa significa | Esempio pratico |
|---|---|---|
| **Plan** | Identifico rischi, definisco policy | Rilevo che i backup non sono testati |
| **Do** | Applico i controlli | Introduco test di restore mensili |
| **Check** | Verifico che funzioni | Audit interno sui backup |
| **Act** | Correggo e migliora | Aggiorno la policy di backup |

Il ciclo non finisce mai: si ripete e migliora nel tempo.

---

## Estemporaneo vs strutturato

**Fare sicurezza "a spot"**
- Reagisco quando succede qualcosa
- Nessuna tracciabilità delle decisioni
- Dipende dalla persona, non dal processo

**Gestire la sicurezza con un sistema**
- Rischi identificati e rivalutati nel tempo
- Decisioni documentate e ripetibili
- Sopravvive al turnover delle persone

---

## Perché le aziende adottano ISO 27001 (1)

Non è solo compliance normativa:

- **Gestione concreta del rischio** — sapere cosa può andare storto prima che succeda
- **Credibilità verso clienti e partner** — spesso è un requisito contrattuale
- **Linguaggio comune** — audit, fornitori e clienti parlano lo stesso framework

---

## Perché le aziende adottano ISO 27001 (2.1)

A volte, però è un obbligo:

- **Servizi Cloud, SaaS e IT Vendor (B2B)** — nell'industria cloud, le aziende spesso si affidano a fornitori di servizi
- **Appalti Pubblici e Pubblica Amministrazione (PA)** — in ambito pubblico è sempre più importante averla per operare in tranquillità sul mercato, inoltre è un requisito per la conformità con le normative vigenti (vendita del servizio su MEPA e requisiti NIS di ACN)
- ...

---

## Perché le aziende adottano ISO 27001 (2.2)

- ... **Fintech, Settore Bancario e Assicurativo** — questo settore è regolato da normative severe (come il regolamento europeo DORA - Digital Operational Resilience Act)
- **Sanità e Digital Health (MedTech)** — sviluppano software medici, app di telemedicina o che gestiscono cartelle cliniche elettroniche devono essere certificate
- **Telecomunicazioni e Infrastrutture Critiche** — Ovviamente :)

---

## I controlli Annex A rilevanti per reti e cloud

Quattro aree su cui ci concentriamo oggi:

1. Gestione della sicurezza di rete (8.20)
2. Controllo accessi (8.3)
3. Crittografia (8.24)
4. Sicurezza dei servizi cloud (5.23)

---

## 1. Gestione della sicurezza di rete

- **Segmentazione** — ...
- **Monitoraggio** — ...
- **Controllo del traffico** — ...

---

## 1. Gestione della sicurezza di rete (!)

- **Segmentazione** — non tutto deve parlare con tutto
- **Monitoraggio** — sapere cosa attraversa la rete
- **Controllo del traffico** — regole esplicite, non "permetti tutto per comodità"

---

## 2. Controllo accessi

- **Autenticazione** — ...
- **Autorizzazione** — ...
- **Minimo privilegio** — ...

---

## 2. Controllo accessi (!)

- **Autenticazione** — sei davvero chi dici di essere?
- **Autorizzazione** — hai il diritto di fare questa cosa specifica?
- **Minimo privilegio** — solo i permessi strettamente necessari al ruolo

---

## 3. Crittografia

- **Dati a riposo** (at rest) — cosa succede se rubano il disco?
- **Dati in transito** (in transit) — cosa succede se qualcuno intercetta il traffico?
- Non è "attivare un flag": è capire cosa si sta proteggendo e da chi

---

## 4. Sicurezza dei servizi cloud

- **Responsabilità condivisa**: cosa fa il provider, cosa fai tu
- Il provider protegge *il* cloud, tu proteggi *ciò che ci metti dentro*
- Cosa verificare in un contratto cloud: SLA, localizzazione dati, notifica incidenti

---

# Attività pratica

---

## Scenario simulato

Siamo un'azienda dal nome NuvolaSoft deve spostare un servizio interno su cloud (su AWS), la nostra realtà ha improvvisamente acquistato cliente e quei servizi comprati al volo per andare online su Aruba non sono sufficienti.

I nostri clienti sono soggetti NIS2, quindi per continuare a fornire servizi dobbiamo garantire standard di lavoro adeguati...

---

## Siamo il nuovo DevOps

... le risorse umane vedono che abbiamo conoscenze nel mondo ISO27001 e ci chiede di migrare i loro servizi su AWS rispettando le normative ISO27001.

---

## Ora mettiamo le mani in pasto (1)

https://github.com/mbuferli/teach

---

## Ora mettiamo le mani in pasto (2)

Passiamo dal laboratorio "sulla carta" a un ambiente cloud vero (anche se locale e finto):

- **Laboratorio tecnico**
  - Floci 
  - Terraform 
  - AWS Cli
  - Docker

---

## Discussione in plenaria

- Ogni gruppo condivide un pensiero
- Cosa abbiamo imparato?

---

# Grazie

Buona giornata a tutti :)
