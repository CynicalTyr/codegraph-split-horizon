#!/usr/bin/env bash
# Copy the split-horizon DLC onto a clone of colbymchenry/codegraph.
# Does not rewrite src/, package.json, LICENSE, or AGENTS.md.
# Does not git commit or push. Operator runs this after a local clone exists.
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:?usage: apply-overlay.sh /path/to/codegraph-clone}"
DEST="$(cd "$DEST" && pwd)"
if [[ ! -f "$DEST/LICENSE" ]]; then
  echo "refuse: $DEST has no LICENSE (not an upstream clone?)" >&2
  exit 2
fi
if [[ ! -d "$DEST/src" && ! -d "$DEST/codegraph-kernel" ]]; then
  echo "refuse: $DEST does not look like colbymchenry/codegraph" >&2
  exit 2
fi
mkdir -p "$DEST/docs" "$DEST/scripts" "$DEST/.github" "$DEST/.cursor/rules"
if [[ -f "$DEST/README.md" ]]; then
  if [[ ! -f "$DEST/docs/ENGINE.md" ]] || ! grep -q 'colbymchenry/codegraph' "$DEST/docs/ENGINE.md" 2>/dev/null; then
    if grep -q 'codegraph_explore' "$DEST/README.md" || [[ "$(wc -c <"$DEST/README.md")" -gt 20000 ]]; then
      cp -a "$DEST/README.md" "$DEST/docs/ENGINE.md"
      echo "moved upstream README.md -> docs/ENGINE.md"
    fi
  fi
fi
# Public copy set. SHIP.md stays in the staging tree only.
copy_paths=(
  README.md
  START_HERE.md
  HORIZON.md
  llms.txt
  NOTICE
  SUPPORT.md
  horizon.sh
  repo-meta.yml
  mods
  scripts/horizon.py
  scripts/apply_fragment.py
  scripts/common.sh
  scripts/apply-overlay.sh
  docs/COLBY_ISSUE.md
  docs/HOW_IT_WORKS.md
  docs/split-horizon
  .github/FUNDING.yml
  .cursor/rules/split-horizon.mdc
)
for rel in "${copy_paths[@]}"; do
  src="$SRC/$rel"
  dest="$DEST/$rel"
  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    cp -a "$src"/. "$dest"/
  elif [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
  else
    echo "skip missing $rel" >&2
  fi
done
chmod +x "$DEST/horizon.sh" "$DEST/scripts/horizon.py" "$DEST/scripts/apply-overlay.sh" || true
echo "overlay copied onto $DEST"
echo "next: do not push until the operator says publish"
echo "do not copy SHIP.md"
