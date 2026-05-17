#!/usr/bin/env bash
set -euo pipefail

# Simple helper to update a .env file safely on the server.
# Usage: set-secrets.sh /path/to/.env KEY1=val1 KEY2=val2 ...

ENV_FILE=${1:-}
if [ -z "$ENV_FILE" ]; then
  echo "Usage: $0 /path/to/.env KEY=VALUE [KEY2=VALUE2 ...]"
  exit 2
fi

shift
if [ $# -lt 1 ]; then
  echo "No keys provided. Nothing to do."
  exit 0
fi

BACKUP="$ENV_FILE.bak.$(date +%Y%m%d%H%M%S)"
cp "$ENV_FILE" "$BACKUP"
echo "Backed up existing env to $BACKUP"

TMP=$(mktemp)
cp "$ENV_FILE" "$TMP"

for kv in "$@"; do
  key=${kv%%=*}
  value=${kv#*=}
  # escape slashes for sed
  esc=$(printf '%s' "$value" | sed -e 's/[&/\\]/\\&/g')

  if grep -qE "^${key}=" "$TMP"; then
    sed -i -E "s/^${key}=.*/${key}=${esc}/" "$TMP"
    echo "Updated $key"
  else
    printf "%s=%s\n" "$key" "$value" >> "$TMP"
    echo "Appended $key"
  fi
done

mv "$TMP" "$ENV_FILE"
chmod 640 "$ENV_FILE" || true
echo "Wrote $ENV_FILE"

exit 0
