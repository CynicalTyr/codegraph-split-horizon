#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
AR="${HORIZON_ARCHITECT_HOME:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$AR/.horizon/systemd"
if [[ "${HORIZON_DRY_RUN:-1}" != "0" ]]; then
  horizon_log "dry-run would write units into $out"
  sed "s|__ARCHITECT_HOME__|${AR}|g" "$HERE/files/horizon-architect-sync.service.tmpl"
  exit 0
fi
mkdir -p "$out"
sed "s|__ARCHITECT_HOME__|${AR}|g" "$HERE/files/horizon-architect-sync.service.tmpl" >"$out/horizon-architect-sync.service"
cp "$HERE/files/horizon-architect-sync.timer" "$out/horizon-architect-sync.timer"
sed "s|__ARCHITECT_HOME__|${AR}|g" "$HERE/files/cron.stanza.tmpl" >"$out/cron.stanza"
horizon_log "06: templates in $out — enable them yourself as the architect user"
