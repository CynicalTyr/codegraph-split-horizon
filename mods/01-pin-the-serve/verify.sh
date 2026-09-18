#!/usr/bin/env bash
set -euo pipefail
OP="${HORIZON_OPERATOR_ROOT:?}"
sidecar="$OP/.horizon/mcp-codegraph.json"
fail=0
check() {
  local f="$1"
  python3 - "$f" "$OP" <<'PY'
import json, sys
from pathlib import Path
path, op = Path(sys.argv[1]), sys.argv[2]
if not path.is_file():
    print(f"verify FAIL: missing {path}", file=sys.stderr)
    raise SystemExit(1)
text = path.read_text(encoding="utf-8")
if "workspaceFolder" in text or "-lc" in text:
    print(f"verify FAIL: {path} still uses workspaceFolder or bash -lc", file=sys.stderr)
    raise SystemExit(1)
try:
    blob = json.loads(text)
except json.JSONDecodeError:
    print(f"verify FAIL: {path} is not JSON", file=sys.stderr)
    raise SystemExit(1)
node = blob
if "mcpServers" in blob:
    node = (blob.get("mcpServers") or {}).get("codegraph") or blob
args = node.get("args") if isinstance(node, dict) else None
if not isinstance(args, list) or "--path" not in args:
    print(f"verify FAIL: {path} has no argv --path", file=sys.stderr)
    raise SystemExit(1)
got = args[args.index("--path") + 1]
if got != op:
    print(f"verify FAIL: --path {got!r} != operator-root {op!r}", file=sys.stderr)
    raise SystemExit(1)
PY
}
if [[ -n "${HORIZON_MCP_FILE:-}" ]]; then
  check "$HORIZON_MCP_FILE" || fail=1
fi
check "$sidecar" || fail=1
if [[ "$fail" -ne 0 ]]; then
  exit 1
fi
echo "verify OK: 01-pin-the-serve argv pin equals operator-root"
exit 0
