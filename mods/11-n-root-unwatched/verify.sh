#!/usr/bin/env bash
set -euo pipefail
f="${HORIZON_OPERATOR_ROOT:?}/.horizon/NROOT.md"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
grep -q 'init /' "$f"
grep -q 'projectPath' "$f"
echo "verify OK: 11 n-root card"
exit 0
