#!/usr/bin/env bash
# sourced by mod install.sh / verify.sh
set -euo pipefail
: "${HORIZON_ROOT:?HORIZON_ROOT unset}"
DRY="${HORIZON_DRY_RUN:-1}"
APPLY="${HORIZON_APPLY:-0}"

horizon_log() { printf '%s\n' "$*"; }

horizon_copy() {
  local src="$1" dest="$2"
  if [[ "$DRY" != "0" ]]; then
    horizon_log "dry-run would copy $src -> $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  horizon_log "copied $dest"
}

horizon_write() {
  local dest="$1"
  if [[ "$DRY" != "0" ]]; then
    horizon_log "dry-run would write $dest"
    cat
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cat >"$dest"
  horizon_log "wrote $dest"
}

horizon_merge() {
  local target="$1" fragment="$2"
  python3 "$HORIZON_ROOT/scripts/apply_fragment.py" "$target" "$fragment"
}
