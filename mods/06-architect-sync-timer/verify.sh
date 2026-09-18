#!/usr/bin/env bash
set -euo pipefail
AR="${HORIZON_ARCHITECT_HOME:?}"
f="$AR/.horizon/systemd/horizon-architect-sync.service"
t="$AR/.horizon/systemd/horizon-architect-sync.timer"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
if grep -q '__ARCHITECT_HOME__' "$f"; then echo "verify FAIL: placeholder left" >&2; exit 1; fi
if grep -q -- '-lc' "$f"; then echo "verify FAIL: unit still uses bash -lc" >&2; exit 1; fi
if [[ ! -f "$t" ]] || ! grep -q OnBootSec "$t"; then
  echo "verify FAIL: timer missing OnBootSec" >&2
  exit 1
fi
echo "verify OK: 06 unit templates"
exit 0
