#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
AR="${HORIZON_ARCHITECT_HOME:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${HORIZON_DRY_RUN:-1}" != "0" ]]; then
  horizon_log "dry-run hook script for $AR"
  exit 0
fi
mkdir -p "$AR/.horizon/hooks"
sed "s|__ARCHITECT_HOME__|${AR}|g" "$HERE/files/codegraph-sync-remind.sh" >"$AR/.horizon/hooks/codegraph-sync-remind.sh"
chmod +x "$AR/.horizon/hooks/codegraph-sync-remind.sh"
python3 - "$HERE/files/hooks.snippet.json" "$AR/.horizon/hooks/hooks.snippet.json" "$AR/.horizon/hooks/codegraph-sync-remind.sh" <<'PY'
import json,sys,pathlib
src, dest, hook = sys.argv[1], sys.argv[2], sys.argv[3]
data=json.loads(pathlib.Path(src).read_text())
data["command"]=hook
pathlib.Path(dest).write_text(json.dumps(data, indent=2)+"\n")
print("wrote", dest)
PY
horizon_log "07: remind hook staged. Wire it yourself. Do not exec codegraph from the IDE."
