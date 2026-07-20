# Laboratorio — Fondamenta ISO 27001 (versione Infrastructure as Code)

Stessa lezione, stesso scenario **NuvolaSoft**, stesse tre misconfig — ma l'infrastruttura è descritta in **Terraform** invece che con comandi AWS CLI imperativi.

Se hai fatto la versione senza `-IAC`: l'ambiente floci è identico, l'`audit.sh` è lo stesso file. Cambia solo *come* si crea e si corregge l'ambiente.

## Cosa c'è dentro

Lo scenario: **NuvolaSoft**, una piccola azienda che ha appena migrato il suo primo carico di lavoro in cloud, di fretta, senza pensare troppo alla sicurezza.

`main.tf` descrive tre problemi, uno per ciascuno dei controlli Annex A visti in aula:

| Problema | Risorsa Terraform | Controllo ISO 27001 |
|---|---|---|
| Utente IAM `mario.rossi` con policy `Action:*` su `Resource:*` | `aws_iam_user_policy.mario_rossi_full_access` | A.8.2 — Minimo privilegio |
| Bucket S3 `nuvolasoft-dati-clienti` con PAB disattivato e bucket policy pubblica | `aws_s3_bucket_public_access_block.nuvolasoft` + `aws_s3_bucket_policy.nuvolasoft_public_read` | Sicurezza dei servizi cloud, controllo accessi |
| Parametro `/nuvolasoft/db-password` come `String` invece di `SecureString` | `aws_ssm_parameter.db_password` | Crittografia dei dati a riposo |

Il compito: **trovare e correggere i tre problemi editando `main.tf`** e riapplicando con Terraform.

## Prerequisiti

- Docker (Desktop / OrbStack / engine) — deve avere accesso al socket Docker
- Terraform >= 1.5 (`terraform version`)
- AWS CLI v2 (`aws --version`) — serve solo all'`audit.sh`

## Avvio

```bash
make up      # avvia floci (container Docker)
make setup   # terraform init + apply → crea l'ambiente vulnerabile
make audit   # mostra cosa non va
```

`make audit` va in `FAIL` su tutti e tre i controlli finché non correggi il Terraform e rilanci `make apply`. Per un check continuo mentre lavori:

```bash
make watch
```

Si ferma automaticamente (con un messaggio verde) quando tutti e tre i problemi sono risolti.

## Il ciclo di lavoro

1. Apri `main.tf` e individua il blocco che causa il problema segnalato dall'audit.
2. Modificalo (elimina, cambia, sostituisci con qualcosa di sicuro).
3. `make plan` per vedere il diff che Terraform applicherà.
4. `make apply` per applicarlo.
5. `make audit` per verificare.

I comandi Terraform "grezzi" (senza Makefile):

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Esplorare l'ambiente

L'`audit.sh` e i comandi manuali di esplorazione usano la AWS CLI puntata su floci:

```bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-west-1
```

Qualche comando utile per ispezionare cosa Terraform ha creato:

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

# Stato Terraform
terraform state list
terraform show
```

Se resti bloccato, le patch al Terraform sono in [`SOLUTIONS.md`](./SOLUTIONS.md) — ma prova prima da solo.

## Comandi

| Comando | Cosa fa |
|---|---|
| `make up` | Avvia il container floci |
| `make setup` | `terraform init` + `apply` → crea l'ambiente NuvolaSoft (volutamente vulnerabile) |
| `make plan` | Mostra il diff Terraform senza applicarlo |
| `make apply` | Applica le modifiche fatte ai file `.tf` |
| `make audit` | Verifica di conformità, una tantum |
| `make watch` | Verifica in loop, si ferma da sola quando tutto è a posto |
| `make status` | Stato del container floci |
| `make down` | `terraform destroy` + ferma e rimuove il container |

## Differenze rispetto alla versione non-IAC

| Aspetto | Versione `setup.sh` | Versione `-IAC` |
|---|---|---|
| Creazione risorse | Comandi `aws ...` imperativi | `terraform apply` su `main.tf` |
| Correzione | Nuovi comandi `aws ...` che sovrascrivono lo stato | Modifica `main.tf` + `terraform apply` |
| Fonte di verità | Nessuna — lo stato vive solo nel cloud | `main.tf` versionato |
| Drift detection | Assente | `terraform plan` lo mostra |
| Reset pulito | `make down` (rimuove floci) | `terraform destroy` **prima** di `make down` |

## Note

- Ambiente interamente locale: nessun account AWS reale, nessuna credenziale vera, nessun costo.
- `make down` fa sia `terraform destroy` sia `docker compose down -v` — per ripartire da capo basta `make up && make setup`.
- Lo state Terraform (`terraform.tfstate*`, `.terraform/`) è ignorato da git via `.gitignore`.
