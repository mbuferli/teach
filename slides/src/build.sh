#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

for f in *.md; do
  echo "==> ${f}"
  npx --yes @marp-team/marp-cli "$f" -o "../output/${f}/${f%.md}.pdf" \
    --allow-local-files --theme-set theme/cc-dark.css
  npx --yes @marp-team/marp-cli "$f" -o "../output/${f}/${f%.md}.html" \
    --allow-local-files --theme-set theme/cc-dark.css
done
