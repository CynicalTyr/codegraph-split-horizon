#!/usr/bin/env bash
set -euo pipefail
OP="${HORIZON_OPERATOR_ROOT:?}"
AR="${HORIZON_ARCHITECT_HOME:?}"
rc=0
for p in "$OP/codegraph.json" "$AR/codegraph.json" "$OP/sample_probe.py" "$AR/ARCHITECT_NOTES.md"; do
  if [[ ! -f "$p" ]]; then
    echo "verify FAIL: missing $p" >&2
    rc=1
  fi
done
if python3 - "$OP/codegraph.json" "$AR/codegraph.json" <<'PY'
import json,sys
a=json.load(open(sys.argv[1])); b=json.load(open(sys.argv[2]))
assert ".env" not in json.dumps(a.get("extensions") or {})
assert ".env" not in json.dumps(b.get("extensions") or {})
print("verify OK: 00-split-horizon-core configs present")
PY
then
  :
else
  rc=1
fi
exit "$rc"
