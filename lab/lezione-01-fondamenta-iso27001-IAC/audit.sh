#!/usr/bin/env bash
# Verifica di conformità dell'ambiente NuvolaSoft. Fallisce finché i tre
# problemi (IAM, S3, SSM) non vengono corretti. Vedi SOLUTIONS.md per i fix.
set -uo pipefail

export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=eu-west-1

BUCKET=nuvolasoft-dati-clienti
IAM_USER=mario.rossi
SSM_PARAM=/nuvolasoft/db-password

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

check_iam() {
  local policies doc
  policies=$(aws iam list-user-policies --user-name "$IAM_USER" --query 'PolicyNames' --output text 2>/dev/null) \
    || { echo "utente $IAM_USER non trovato"; return 1; }
  for p in $policies; do
    doc=$(aws iam get-user-policy --user-name "$IAM_USER" --policy-name "$p" --query 'PolicyDocument' --output json 2>/dev/null)
    if echo "$doc" | grep -q '"Action": *"\*"' && echo "$doc" | grep -q '"Resource": *"\*"'; then
      echo "la policy '$p' concede Action:* su Resource:* — privilegi eccessivi"
      return 1
    fi
  done
  return 0
}

check_s3() {
  local cfg
  cfg=$(aws s3api get-public-access-block --bucket "$BUCKET" --query 'PublicAccessBlockConfiguration' --output json 2>/dev/null) \
    || { echo "nessun Public Access Block configurato sul bucket $BUCKET"; return 1; }
  if echo "$cfg" | grep -qi 'false'; then
    echo "il bucket $BUCKET non blocca completamente l'accesso pubblico"
    return 1
  fi
  return 0
}

check_ssm() {
  local type
  type=$(aws ssm get-parameter --name "$SSM_PARAM" --query 'Parameter.Type' --output text 2>/dev/null) \
    || { echo "parametro $SSM_PARAM non trovato"; return 1; }
  if [[ "$type" != "SecureString" ]]; then
    echo "il parametro $SSM_PARAM è di tipo $type invece di SecureString"
    return 1
  fi
  return 0
}

run_once() {
  local overall=0 out
  echo "== Audit conformità ISO 27001 — ambiente NuvolaSoft =="
  echo ""

  if out=$(check_iam 2>&1); then
    echo -e "${GREEN}PASS${NC}  IAM — minimo privilegio"
  else
    echo -e "${RED}FAIL${NC}  IAM — minimo privilegio: $out"
    overall=1
  fi

  if out=$(check_s3 2>&1); then
    echo -e "${GREEN}PASS${NC}  S3 — accesso pubblico bloccato"
  else
    echo -e "${RED}FAIL${NC}  S3 — accesso pubblico bloccato: $out"
    overall=1
  fi

  if out=$(check_ssm 2>&1); then
    echo -e "${GREEN}PASS${NC}  SSM — segreto come SecureString"
  else
    echo -e "${RED}FAIL${NC}  SSM — segreto come SecureString: $out"
    overall=1
  fi

  return $overall
}

if [[ "${1:-}" == "--watch" ]]; then
  while true; do
    clear
    if run_once; then
      echo ""
      echo -e "${GREEN}Tutto risolto — ambiente conforme.${NC}"
      break
    fi
    echo ""
    echo "(ricontrollo tra 3s — Ctrl+C per uscire)"
    sleep 3
  done
else
  # Non propaghiamo l'exit code: l'audit è uno strumento di diagnosi,
  # non un test CI. L'esito è già visibile nei PASS/FAIL a video.
  run_once || true
fi
