#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$HORIZON_ROOT/scripts/common.sh"
OP="${HORIZON_OPERATOR_ROOT:?need --operator-root}"
OWNER="${HORIZON_OWNER_USER:-}"
if [[ "$OP" == *'${workspaceFolder}'* ]]; then
  echo "refuse: operator-root contains \${workspaceFolder}" >&2
  exit 2
fi
if [[ -n "$OWNER" && ! "$OWNER" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "refuse: --owner-user is not a simple Unix name" >&2
  exit 2
fi
BIN='codegraph'
if command -v codegraph >/dev/null 2>&1; then
  BIN="$(command -v codegraph)"
fi
snippet=$(
  HORIZON_BIN="$BIN" HORIZON_OP="$OP" HORIZON_OWNER="$OWNER" python3 - <<'PY'
import json, os
bin_path = os.environ["HORIZON_BIN"]
op = os.environ["HORIZON_OP"]
owner = os.environ.get("HORIZON_OWNER") or ""
if owner:
    snippet = {
        "type": "stdio",
        "command": "sudo",
        "args": ["-u", owner, "--", bin_path, "serve", "--mcp", "--path", op],
    }
else:
    snippet = {
        "type": "stdio",
        "command": bin_path,
        "args": ["serve", "--mcp", "--path", op],
    }
print(json.dumps(snippet))
PY
)
outdir="${OP}/.horizon"
if [[ "${HORIZON_DRY_RUN:-1}" != "0" ]]; then
  horizon_log "dry-run MCP snippet:"
  printf '%s\n' "$snippet"
else
  mkdir -p "$outdir"
  printf '%s\n' "$snippet" >"$outdir/mcp-codegraph.json"
  horizon_log "wrote $outdir/mcp-codegraph.json"
fi
if [[ -n "${HORIZON_MCP_FILE:-}" && "${HORIZON_APPLY:-0}" == "1" ]]; then
  python3 - "$HORIZON_MCP_FILE" "$snippet" "${HORIZON_REPLACE_MCP:-0}" <<'PY'
import json, sys
from pathlib import Path
path, snippet_raw, replace = Path(sys.argv[1]), sys.argv[2], sys.argv[3] == "1"
snippet = json.loads(snippet_raw)
blob = {"mcpServers": {}}
if path.is_file():
    raw = path.read_text(encoding="utf-8").strip()
    if raw:
        blob = json.loads(raw)
        if not isinstance(blob, dict):
            raise SystemExit(f"{path} is not a JSON object")
servers = blob.get("mcpServers")
if servers is None:
    servers = blob.setdefault("servers", {})
    blob.setdefault("mcpServers", servers)
if not isinstance(servers, dict):
    raise SystemExit("mcpServers is not an object")
existing = servers.get("codegraph")
if existing and not replace:
    blob_s = json.dumps(existing)
    if "codegraph" not in blob_s.lower():
        raise SystemExit("codegraph key exists and does not look like CodeGraph; pass --replace-mcp")
    args = existing.get("args") if isinstance(existing, dict) else None
    path_eq = False
    if isinstance(args, list) and "--path" in args:
        i = args.index("--path")
        if i + 1 < len(args) and args[i + 1] == snippet.get("args", [None])[-1]:
            path_eq = True
    if "${workspaceFolder}" in blob_s or "-lc" in blob_s or not path_eq:
        raise SystemExit(
            "existing codegraph pin is not this operator --path (or uses workspaceFolder / bash -lc). "
            "Pass --replace-mcp if you mean to overwrite."
        )
    print(f"left existing codegraph entry in {path} (path already matches)")
    raise SystemExit(0)
servers["codegraph"] = snippet
blob["mcpServers"] = servers
path.parent.mkdir(parents=True, exist_ok=True)
if path.is_file():
    bak = path.with_name(path.name + ".bak")
    bak.write_text(path.read_text(encoding="utf-8"), encoding="utf-8")
    print(f"backup {bak}")
path.write_text(json.dumps(blob, indent=2) + "\n", encoding="utf-8")
print(f"wrote {path}")
PY
elif [[ -n "${HORIZON_MCP_FILE:-}" ]]; then
  horizon_log "dry-run would merge snippet into ${HORIZON_MCP_FILE}"
fi
