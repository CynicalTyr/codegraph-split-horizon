#!/usr/bin/env bash
# First CodeGraph index on a slow disk. Unlock only if the lock PID is dead.
set -euo pipefail
ROOT="${1:?usage: first-index.sh ROOT}"
ROOT="$(cd "$ROOT" && pwd)"
BIN="${CODEGRAPH_BIN:-codegraph}"
lock="$ROOT/.codegraph/codegraph.lock"
if [[ -f "$lock" ]]; then
  pid="$(tr -dc '0-9' <"$lock" || true)"
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    echo "refuse: lock PID $pid is live (serve or index). do not unlock. do not pkill. exit 3" >&2
    exit 3
  fi
  echo "stale lock (PID ${pid:-unknown} is dead); unlocking $ROOT"
  "$BIN" unlock "$ROOT"
fi
export CODEGRAPH_NO_WATCHDOG=1
echo "CODEGRAPH_NO_WATCHDOG=1 index --force $ROOT"
exec "$BIN" index --force "$ROOT"
