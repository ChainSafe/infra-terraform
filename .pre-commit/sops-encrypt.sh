#!/usr/bin/env bash
set -eo pipefail

for f in "$@"; do
  if ! grep -L 'ENC.AES256' "$f"; then
    sops encrypt -i "$f"
  fi
done
