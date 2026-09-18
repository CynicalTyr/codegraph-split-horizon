#!/usr/bin/env bash
set -euo pipefail
f="${HORIZON_OPERATOR_ROOT:?}/bin/horizon-node"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
if grep -q 'language:bash' "$f"; then echo "verify FAIL: wrapper should not query language:bash" >&2; exit 1; fi
echo "verify OK: 05 horizon-node present"
exit 0
