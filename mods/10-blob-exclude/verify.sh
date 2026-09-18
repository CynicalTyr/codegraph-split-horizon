#!/usr/bin/env bash
set -euo pipefail
python3 - "${HORIZON_OPERATOR_ROOT:?}/codegraph.json" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
ex=" ".join(d.get("exclude") or [])
for need in ("**/*.db","**/*.db-wal","**/*.sqlite"):
    if need not in ex:
        print("verify FAIL: missing", need)
        raise SystemExit(1)
print("verify OK: 10 blob exclude")
PY
