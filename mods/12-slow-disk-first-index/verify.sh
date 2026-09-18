#!/usr/bin/env bash
set -euo pipefail
w="${HORIZON_OPERATOR_ROOT:?}/bin/first-index.sh"
if [[ ! -f "$w" ]]; then echo "verify FAIL: missing $w" >&2; exit 1; fi
grep -q 'CODEGRAPH_NO_WATCHDOG' "$w"
grep -q 'codegraph.lock' "$w"
grep -q 'kill -0' "$w"
echo "verify OK: 12 slow-disk first-index"
exit 0
