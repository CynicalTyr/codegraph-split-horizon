#!/usr/bin/env bash
# Fail-closed CodeGraph driver for a split-horizon operator tree.
# ALLOW_ROOT is the only tree this script will index/sync.
# Never pkill a live owner serve --mcp.
set -euo pipefail
ALLOW_ROOT="${CODEGRAPH_ALLOW_ROOT:-__ALLOW_ROOT__}"
BIN="${CODEGRAPH_BIN:-codegraph}"
REPAIR="${CODEGRAPH_REPAIR_WAL:-0}"
FORCE="${CODEGRAPH_FORCE_REINDEX:-0}"
ROOT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repair-wal) REPAIR=1; shift ;;
    --force-reindex) FORCE=1; shift ;;
    --) shift; break ;;
    -*)
      echo "unknown flag $1 (use --repair-wal | --force-reindex | ROOT)" >&2
      exit 2
      ;;
    *)
      if [[ -n "$ROOT" ]]; then
        echo "usage: codegraph-as-owner.sh [--repair-wal] [--force-reindex] ROOT" >&2
        exit 2
      fi
      ROOT="$1"
      shift
      ;;
  esac
done
if [[ -z "$ROOT" ]]; then
  echo "usage: codegraph-as-owner.sh [--repair-wal] [--force-reindex] ROOT" >&2
  exit 2
fi
ROOT="$(cd "$ROOT" && pwd)"
ALLOW="$(cd "$ALLOW_ROOT" && pwd)"
if [[ "$ROOT" != "$ALLOW" ]]; then
  echo "refuse ROOT=$ROOT (allow $ALLOW) exit 2" >&2
  exit 2
fi
if [[ -d "$ROOT/.codegraph/versions" ]]; then
  echo "refuse: $ROOT/.codegraph/versions looks like a CLI cache, not an operator graph" >&2
  exit 2
fi
db="$ROOT/.codegraph/codegraph.db"
if [[ -f "$db" ]]; then
  db_uid="$(stat -c '%u' "$db" 2>/dev/null || stat -f '%u' "$db")"
  if [[ "$(id -u)" != "$db_uid" ]]; then
    echo "refuse: EUID=$(id -u) != db uid $db_uid. Writer UID equals SQLite UID. exit 2" >&2
    exit 2
  fi
  for side in "$db-wal" "$db-shm"; do
    if [[ -f "$side" ]]; then
      suid="$(stat -c '%u' "$side" 2>/dev/null || stat -f '%u' "$side")"
      if [[ "$suid" != "$db_uid" ]]; then
        echo "refuse: leftover $(basename "$side") uid $suid != db uid $db_uid. chown then --repair-wal" >&2
        exit 2
      fi
    fi
  done
fi
serve_live=0
if pgrep -u "$(id -u)" -f "codegraph serve --mcp --path ${ROOT}" >/dev/null 2>&1 \
  || pgrep -u "$(id -u)" -f "codegraph.js serve --mcp --path ${ROOT}" >/dev/null 2>&1; then
  serve_live=1
fi
if [[ "$serve_live" -eq 1 ]]; then
  if [[ "$FORCE" == "1" ]]; then
    echo "live serve --mcp holds the lock; not killing it. reload MCP, then retry --force-reindex" >&2
    exit 3
  fi
  echo "serve --mcp already running for $ROOT as this UID; skip sync (watcher owns the lock)"
  exit 0
fi
if [[ "$REPAIR" == "1" ]]; then
  echo "repair-wal: chown leftover *.db-wal to the owner user yourself, then:"
  echo "  $BIN unlock --path $ROOT   # only if lock PID is dead"
fi
if [[ "$FORCE" == "1" ]]; then
  exec "$BIN" index --force "$ROOT"
fi
exec "$BIN" sync --path "$ROOT"
