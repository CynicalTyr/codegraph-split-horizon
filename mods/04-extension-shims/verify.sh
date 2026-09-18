#!/usr/bin/env bash
set -euo pipefail
check() {
  python3 - "$1" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
ext = d.get("extensions") or {}
for bad in (".env", ".ini"):
    if bad in ext:
        print("verify FAIL: mapped", bad)
        raise SystemExit(1)
for k, v in {".sh": "twig", ".md": "twig", ".html": "xml", ".json": "yaml"}.items():
    if ext.get(k) != v:
        print("verify FAIL: expected", k, v, "got", ext.get(k))
        raise SystemExit(1)
print("verify OK: 04 extension shims", sys.argv[1])
PY
}
check "${HORIZON_OPERATOR_ROOT:?}/codegraph.json"
if [[ -n "${HORIZON_ARCHITECT_HOME:-}" ]]; then
  check "$HORIZON_ARCHITECT_HOME/codegraph.json"
fi
