#!/usr/bin/env bash
# Print only. Never exec the indexer from an IDE hook.
set -euo pipefail
ARCH="${HORIZON_ARCHITECT_HOME:-${CODEGRAPH_ARCHITECT_HOME:-__ARCHITECT_HOME__}}"
if [[ -z "$ARCH" ]]; then
  echo "horizon: set CODEGRAPH_ARCHITECT_HOME if you use a second CodeGraph root (projectPath has no watcher)" >&2
  exit 0
fi
echo "horizon: architect root has no live watcher. When skills/rules/docs changed: codegraph sync --path ${ARCH}  (as the architect UID, not the operator UID)" >&2
exit 0
