#!/usr/bin/env bash
set -euo pipefail
OP="${HORIZON_OPERATOR_ROOT:?}"
f="$OP/.horizon/systemd/horizon-operator-sync.service"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
if grep -q '__OPERATOR_ROOT__\|__WRAPPER__' "$f"; then
  echo "verify FAIL: placeholder left" >&2
  exit 1
fi
if grep -q -- '-lc' "$f"; then echo "verify FAIL: bash -lc" >&2; exit 1; fi
echo "verify OK: 14 operator-own-sync templates"
exit 0
