# Soluzioni

Comandi verificati (testati end-to-end: dopo averli lanciati, `make audit` risulta tutto `PASS`). Usali come riferimento del docente o come hint per chi resta bloccato.

Variabili d'ambiente attese (le stesse di `setup.sh`):

```bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-west-1
```

## 1. IAM — privilegi eccessivi

Il problema: `mario.rossi` ha una policy inline (`full-access`) con `Action:*` su `Resource:*`.

Fix — rimuovere la policy troppo permissiva e sostituirla con una a minimo privilegio (qui: sola lettura sul bucket che gli serve):

```bash
aws iam delete-user-policy --user-name mario.rossi --policy-name full-access

aws iam put-user-policy \
  --user-name mario.rossi \
  --policy-name s3-readonly \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::nuvolasoft-dati-clienti",
        "arn:aws:s3:::nuvolasoft-dati-clienti/*"
      ]
    }]
  }'
```

## 2. S3 — bucket pubblico

Il problema: Public Access Block disattivato + bucket policy che concede `s3:GetObject` a `Principal: *`.

Fix — bloccare l'accesso pubblico e rimuovere la policy pubblica:

```bash
aws s3api put-public-access-block \
  --bucket nuvolasoft-dati-clienti \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

aws s3api delete-bucket-policy --bucket nuvolasoft-dati-clienti
```

## 3. SSM — segreto in chiaro

Il problema: `/nuvolasoft/db-password` è di tipo `String` (testo in chiaro) invece che `SecureString` (cifrato).

Fix — sovrascrivere il parametro con lo stesso valore ma tipo `SecureString`:

```bash
aws ssm put-parameter \
  --name /nuvolasoft/db-password \
  --type SecureString \
  --value "SuperSegreta123!" \
  --overwrite
```

## Verifica finale

```bash
make audit
```

Deve risultare `PASS` su tutti e tre i controlli (exit code 0).
