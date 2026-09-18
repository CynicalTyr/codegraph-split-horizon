#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_copy "$HERE/files/first-index.sh" "$OP/bin/first-index.sh"
if [[ "${HORIZON_DRY_RUN:-1}" == "0" ]]; then chmod +x "$OP/bin/first-index.sh"; fi
horizon_log "12: first-index.sh staged. unlock only if lock PID is dead."
