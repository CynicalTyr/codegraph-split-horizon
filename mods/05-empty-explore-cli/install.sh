#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_copy "$HERE/files/horizon-node" "$OP/bin/horizon-node"
if [[ "${HORIZON_DRY_RUN:-1}" == "0" ]]; then chmod +x "$OP/bin/horizon-node"; fi
horizon_log "05: horizon-node staged."
