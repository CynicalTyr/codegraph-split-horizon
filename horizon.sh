#!/usr/bin/env bash
# Split-horizon DLC dispatcher. Colby's CodeGraph stays the engine.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$ROOT/scripts/horizon.py" "$@"
