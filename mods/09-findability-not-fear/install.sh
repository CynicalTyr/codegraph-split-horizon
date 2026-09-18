#!/usr/bin/env bash
set -euo pipefail
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
horizon_merge "$OP/codegraph.json" "$HERE/files/secrets-out.json"
# Optional: HORIZON_KEEP_YAML=ledger.yaml,routing.yaml — strip those basenames from exclude.
python3 - "$OP/codegraph.json" <<'PY'
import json, os, sys
p = sys.argv[1]
if os.environ.get("HORIZON_DRY_RUN", "1") != "0":
    raise SystemExit(0)
keep = [x.strip() for x in os.environ.get("HORIZON_KEEP_YAML", "").split(",") if x.strip()]
if not keep:
    print("09: env/auth excluded. pass HORIZON_KEEP_YAML=your.yaml to un-exclude named config")
    raise SystemExit(0)
d = json.loads(open(p, encoding="utf-8").read())
ex = d.get("exclude") or []
d["exclude"] = [x for x in ex if not any(b in x for b in keep)]
open(p, "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
print("stripped user-named config YAML from exclude:", keep)
PY
horizon_log "09: env/auth stay excluded. config YAML the user named stays findable. do not print values."
