#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wrap="$OP/bin/codegraph-as-owner.sh"
out="$OP/.horizon/systemd"
if [[ "${HORIZON_DRY_RUN:-1}" != "0" ]]; then
  horizon_log "dry-run would write operator units into $out (wrapper $wrap)"
  sed -e "s|__OPERATOR_ROOT__|${OP}|g" -e "s|__WRAPPER__|${wrap}|g" "$HERE/files/horizon-operator-sync.service.tmpl"
  exit 0
fi
if [[ ! -x "$wrap" && ! -f "$wrap" ]]; then
  echo "14: install 02-writer-uid-fence first (missing $wrap)" >&2
  exit 2
fi
mkdir -p "$out"
sed -e "s|__OPERATOR_ROOT__|${OP}|g" -e "s|__WRAPPER__|${wrap}|g" \
  "$HERE/files/horizon-operator-sync.service.tmpl" >"$out/horizon-operator-sync.service"
cp "$HERE/files/horizon-operator-sync.timer" "$out/horizon-operator-sync.timer"
horizon_log "14: templates in $out — enable them yourself as the owner user. linger checklist, do not enable unless you mean it."
