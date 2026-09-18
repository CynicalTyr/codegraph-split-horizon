#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$HORIZON_ROOT/scripts/common.sh"
AR="${HORIZON_ARCHITECT_HOME:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_merge "$AR/codegraph.json" "$HERE/files/exclude-fragment.json"
horizon_log "03: merged exclude + deprioritize. Dump trees stay in exclude. tests/generated stay findable but lose rank. index --force."
