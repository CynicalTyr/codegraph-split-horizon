#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_merge "$OP/codegraph.json" "$HERE/files/extensions.json"
if [[ -n "${HORIZON_ARCHITECT_HOME:-}" ]]; then
  horizon_merge "$HORIZON_ARCHITECT_HOME/codegraph.json" "$HERE/files/extensions.json"
  horizon_log "04: also merged architect-home (unwatched .md/.mdc maps)."
fi
horizon_log "04: extensions merged. index --force. do not map .ini/.env."
