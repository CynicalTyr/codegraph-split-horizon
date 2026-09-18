#!/usr/bin/env bash
set -euo pipefail
f="${HORIZON_ARCHITECT_HOME:?}/.horizon/hooks/codegraph-sync-remind.sh"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
if grep -q '__ARCHITECT_HOME__' "$f"; then echo "verify FAIL: placeholder left" >&2; exit 1; fi
if grep -E '^[[:space:]]*(exec[[:space:]]+)?codegraph[[:space:]]+(sync|index|serve)' "$f"; then
  echo "verify FAIL: remind hook must not run the indexer" >&2
  exit 1
fi
echo "verify OK: 07 remind-only hook"
exit 0
