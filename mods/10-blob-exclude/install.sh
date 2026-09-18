#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_merge "$OP/codegraph.json" "$HERE/files/blobs.json"
horizon_log "10: db/wal/sqlite excluded. append your ANN suffix (*.ann, *.faiss, or yours)."
