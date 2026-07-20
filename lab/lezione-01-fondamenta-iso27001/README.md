# Laboratorio — Fondamenta ISO 27001 applicate a reti e cloud

Ambiente cloud locale e finto (nessun account, nessuna credenziale reale) su cui esercitarsi a riconoscere e correggere configurazioni insicure comuni.

## Cosa c'è dentro

Lo scenario: **NuvolaSoft**, una piccola azienda che ha appena migrato il suo primo carico di lavoro in cloud, di fretta, senza pensare troppo alla sicurezza.

`setup.sh` crea tre problemi, uno per ciascuno dei controlli Annex A visti in aula:

| Problema | Dove | Controllo ISO 27001 |
|---|---|---|
| Utente IAM `mario.rossi` con una policy che concede `Action:*` su `Resource:*` | IAM | A.8.2 — Diritti di accesso privilegiati, minimo privilegio |
| Bucket S3 `nuvolasoft-dati-clienti` con accesso pubblico e un file `clienti.csv` dentro | S3 | Sicurezza dei servizi cloud, controllo accessi |
| Parametro `/nuvolasoft/db-password` salvato come `String` invece che `SecureString` | SSM Parameter Store | Crittografia dei dati a riposo |

Il compito: **trovare e correggere i tre problemi** usando la AWS CLI puntata su [floci](https://floci.io) (emulatore locale gratuito di servizi AWS, nessuna credenziale reale richiesta).

## Prerequisiti

- Docker (Desktop / OrbStack / engine) — deve avere accesso al socket Docker
- AWS CLI v2 (`aws --version`)

## Avvio

```bash
make up      # avvia floci (container Docker)
make setup   # crea l'ambiente vulnerabile (NuvolaSoft)
make audit   # mostra cosa non va
```

`make audit` va in `FAIL` su tutti e tre i controlli finché non li correggi. Se vuoi un check continuo che si aggiorna da solo mentre lavori:

```bash
make watch
```

Si ferma automaticamente (con un messaggio verde) quando tutti e tre i problemi sono risolti.

## Esplorare l'ambiente

Le stesse variabili d'ambiente usate dagli script:

```bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-west-1
```

Qualche comando utile per esplorare prima di correggere:

```bash
# Utenti e policy IAM
aws iam list-users
aws iam list-user-policies --user-name mario.rossi
aws iam get-user-policy --user-name mario.rossi --policy-name full-access

# Bucket S3
aws s3 ls
aws s3api get-public-access-block --bucket nuvolasoft-dati-clienti
aws s3api get-bucket-policy --bucket nuvolasoft-dati-clienti

# Parametro SSM
aws ssm get-parameter --name /nuvolasoft/db-password
```

Se resti bloccato, i comandi risolutivi sono in [`SOLUTIONS.md`](./SOLUTIONS.md) — ma prova prima da solo.

## Comandi

| Comando | Cosa fa |
|---|---|
| `make up` | Avvia il container floci |
| `make setup` | Crea l'ambiente NuvolaSoft (volutamente vulnerabile) |
| `make audit` | Verifica di conformità, una tantum |
| `make watch` | Verifica in loop, si ferma da sola quando tutto è a posto |
| `make status` | Stato del container floci |
| `make down` | Ferma e rimuove tutto |

## Note

- Ambiente interamente locale: nessun account AWS reale, nessuna credenziale vera, nessun costo.
- `make down` cancella tutto — per ripartire da capo basta `make up && make setup`.
