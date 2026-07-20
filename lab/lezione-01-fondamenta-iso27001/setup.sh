#!/usr/bin/env bash
# Crea l'ambiente cloud volutamente vulnerabile su floci (NuvolaSoft).
set -euo pipefail

export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-west-1

BUCKET=nuvolasoft-dati-clienti
IAM_USER=mario.rossi
SSM_PARAM=/nuvolasoft/db-password

echo "==> Utente IAM con privilegi eccessivi ($IAM_USER)"
aws iam create-user --user-name "$IAM_USER" >/dev/null
aws iam put-user-policy \
  --user-name "$IAM_USER" \
  --policy-name full-access \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{ "Effect": "Allow", "Action": "*", "Resource": "*" }]
  }'

echo "==> Bucket S3 pubblico ($BUCKET)"
aws s3 mb "s3://${BUCKET}"
aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-policy \
  --bucket "$BUCKET" \
  --policy '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::'"${BUCKET}"'/*"
    }]
  }'

tmpfile=$(mktemp)
{
  echo "nome,email,carta_credito"
  echo "Mario Rossi,mario@esempio.it,4111-1111-1111-1111"
} > "$tmpfile"
aws s3 cp "$tmpfile" "s3://${BUCKET}/clienti.csv"
rm -f "$tmpfile"

echo "==> Segreto salvato in chiaro invece che come SecureString ($SSM_PARAM)"
aws ssm put-parameter \
  --name "$SSM_PARAM" \
  --type String \
  --value "SuperSegreta123!" \
  --overwrite >/dev/null

echo ""
echo "Ambiente pronto (volutamente vulnerabile)."
echo "Esegui './audit.sh' per vedere cosa non va, o './audit.sh --watch' per un check continuo."
