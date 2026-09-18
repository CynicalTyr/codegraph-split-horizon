#!/usr/bin/env bash
set -euo pipefail
OP="${HORIZON_OPERATOR_ROOT:?}"
w="$OP/bin/codegraph-as-owner.sh"
if [[ ! -f "$w" ]]; then
  echo "verify FAIL: missing $w" >&2
  exit 1
fi
if grep -q '__ALLOW_ROOT__' "$w"; then
  echo "verify FAIL: placeholder not substituted" >&2
  exit 1
fi
if grep -E '^[[:space:]]*(pkill|killall)([[:space:]]|$)' "$w"; then
  echo "verify FAIL: wrapper must never pkill" >&2
  exit 1
fi
if ! grep -q 'EUID' "$w"; then
  echo "verify FAIL: wrapper missing EUID vs db uid check" >&2
  exit 1
fi
set +e
bash "$w" /tmp >/dev/null 2>&1
rc=$?
set -e
if [[ "$rc" -ne 2 ]]; then
  echo "verify FAIL: wrong ROOT exited $rc want 2" >&2
  exit 1
fi
echo "verify OK: 02-writer-uid-fence refuses wrong ROOT and never pkills"
exit 0
