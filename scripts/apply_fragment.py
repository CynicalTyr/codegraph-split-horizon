#!/usr/bin/env python3
"""Merge a JSON fragment into a user's codegraph.json. Used by mod install.sh."""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from horizon import apply_fragment  # noqa: E402


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: apply_fragment.py TARGET FRAGMENT.json", file=sys.stderr)
        return 2
    target = Path(sys.argv[1])
    fragment = json.loads(Path(sys.argv[2]).read_text(encoding="utf-8"))
    dry = os.environ.get("HORIZON_DRY_RUN", "1") != "0"
    apply_fragment(target, fragment, dry)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
