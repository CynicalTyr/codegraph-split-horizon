#!/usr/bin/env bash
set -euo pipefail
OP="${HORIZON_OPERATOR_ROOT:?}"
w="$OP/bin/refuse-mount.sh"
if [[ ! -f "$w" ]]; then echo "verify FAIL: missing $w" >&2; exit 1; fi
bash "$w" "$OP"
echo "verify OK: 13 foreign-mount fence (local root accepted)"
exit 0
