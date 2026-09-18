#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_copy "$HERE/files/refuse-mount.sh" "$OP/bin/refuse-mount.sh"
if [[ "${HORIZON_DRY_RUN:-1}" == "0" ]]; then chmod +x "$OP/bin/refuse-mount.sh"; fi
horizon_log "13: refuse-mount.sh staged. run it before init/index on a new root."
