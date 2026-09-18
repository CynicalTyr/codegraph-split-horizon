#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?need --operator-root}"
AR="${HORIZON_ARCHITECT_HOME:?need --architect-home}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$OP" == "$AR" ]]; then
  echo "operator-root and architect-home must differ" >&2
  exit 2
fi
horizon_merge "$OP/codegraph.json" "$HERE/files/operator.codegraph.json"
horizon_merge "$AR/codegraph.json" "$HERE/files/architect.codegraph.json"
horizon_copy "$HERE/files/sample_probe.py" "$OP/sample_probe.py"
horizon_copy "$HERE/files/ARCHITECT_NOTES.md" "$AR/ARCHITECT_NOTES.md"
horizon_log "00-split-horizon-core: two configs staged. index --force each root as its owner UID."
