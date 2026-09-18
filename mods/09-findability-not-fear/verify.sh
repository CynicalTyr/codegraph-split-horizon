#!/usr/bin/env bash
set -euo pipefail
python3 - "${HORIZON_OPERATOR_ROOT:?}/codegraph.json" <<'PY'
import json, os, sys
d = json.load(open(sys.argv[1]))
ex = " ".join(d.get("exclude") or [])
for need in ("**/.env", "**/*auth.json"):
    if need not in ex:
        print("verify FAIL: missing", need)
        raise SystemExit(1)
keep = [x.strip() for x in os.environ.get("HORIZON_KEEP_YAML", "").split(",") if x.strip()]
for name in keep:
    if name in ex:
        print("verify FAIL: user-named config still excluded", name)
        raise SystemExit(1)
print("verify OK: 09 findability fence")
PY
