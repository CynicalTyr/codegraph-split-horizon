#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_copy "$HERE/files/NROOT.md" "$OP/.horizon/NROOT.md"
horizon_log "11: fill $OP/.horizon/NROOT.md. one serve. rest are projectPath."
