#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_copy "$HERE/files/HORIZON.rule.md" "$OP/.horizon/HORIZON.rule.md"
horizon_copy "$HERE/files/SKILL.fragment.md" "$OP/.horizon/SKILL.fragment.md"
horizon_copy "$HERE/files/CLAUDE.md" "$OP/.horizon/CLAUDE.md"
horizon_log "08: policy cards in operator .horizon/ — copy into your harness. Do not overwrite Colby's engine AGENTS.md."
