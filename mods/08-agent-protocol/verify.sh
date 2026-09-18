#!/usr/bin/env bash
set -euo pipefail
d="${HORIZON_OPERATOR_ROOT:?}/.horizon"
f="$d/HORIZON.rule.md"
if [[ ! -f "$f" ]]; then echo "verify FAIL: missing $f" >&2; exit 1; fi
for need in projectPath 'language:bash' 'MCP not connected' 'index --force' 'inner loop' 'three calls' 'messenger'; do
  if ! grep -q "$need" "$f"; then
    echo "verify FAIL: rule missing $need" >&2
    exit 1
  fi
done
for extra in SKILL.fragment.md CLAUDE.md; do
  if [[ ! -f "$d/$extra" ]]; then
    echo "verify FAIL: missing $d/$extra" >&2
    exit 1
  fi
done
echo "verify OK: 08 agent protocol"
exit 0
