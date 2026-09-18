#!/usr/bin/env bash
set -euo pipefail
AR="${HORIZON_ARCHITECT_HOME:?}"
cfg="$AR/codegraph.json"
if [[ ! -f "$cfg" ]]; then
  echo "verify FAIL: missing $cfg" >&2
  exit 1
fi
python3 - "$cfg" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
ex = " ".join(d.get("exclude") or [])
need = [".cursor/projects/", ".cursor/chats/", "**/.env"]
miss = [x for x in need if x not in ex]
if miss:
    print("verify FAIL: exclude missing", miss)
    raise SystemExit(1)
PY
if ! command -v codegraph >/dev/null 2>&1; then
  echo "verify FAIL: codegraph CLI missing; cannot prove the fence" >&2
  exit 1
fi
if [[ ! -d "$AR/.codegraph" ]]; then
  echo "verify FAIL: $AR is not indexed (codegraph init && index --force)" >&2
  exit 1
fi
listing="$(codegraph files --path "$AR" --format flat)" || {
  echo "verify FAIL: codegraph files exited $?" >&2
  exit 1
}
if printf '%s\n' "$listing" | grep -E '\.cursor/projects/|\.cursor/chats/' >/dev/null; then
  echo "verify FAIL: index still contains dump prefixes; reindex after exclude" >&2
  exit 1
fi
echo "verify OK: 03 exclude fence keys present"
exit 0
