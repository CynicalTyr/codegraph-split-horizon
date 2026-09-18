#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp)"
sed "s|__ALLOW_ROOT__|${OP}|g" "$HERE/files/codegraph-as-owner.sh" >"$tmp"
horizon_copy "$tmp" "$OP/bin/codegraph-as-owner.sh"
rm -f "$tmp"
if [[ "${HORIZON_DRY_RUN:-1}" == "0" ]]; then
  chmod +x "$OP/bin/codegraph-as-owner.sh"
fi
horizon_log "02-writer-uid-fence: wrapper staged. Wrong ROOT must exit 2."
