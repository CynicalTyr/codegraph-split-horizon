#!/usr/bin/env python3
"""Split-horizon DLC installer. Writes the user's trees. Never patches the CodeGraph engine."""

from __future__ import annotations

import argparse
import json
import os
import pwd
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
MODS = ROOT / "mods"
CATALOG = MODS / "catalog.json"


def load_catalog() -> dict[str, Any]:
    return json.loads(CATALOG.read_text(encoding="utf-8"))


def mod_dir(mod_id: str) -> Path:
    path = MODS / mod_id
    if not path.is_dir():
        raise SystemExit(f"unknown mod: {mod_id}")
    return path


def load_manifest(mod_id: str) -> dict[str, Any]:
    return json.loads((mod_dir(mod_id) / "manifest.json").read_text(encoding="utf-8"))


def cmd_list(_: argparse.Namespace) -> int:
    catalog = load_catalog()
    print("id\tstandalone\tjob")
    for item in catalog["mods"]:
        flag = "yes" if item.get("standalone") else "needs-core"
        print(f"{item['id']}\t{flag}\t{item['title']}")
    return 0


def cmd_info(ns: argparse.Namespace) -> int:
    path = mod_dir(ns.mod_id) / "PRODUCT.md"
    sys.stdout.write(path.read_text(encoding="utf-8"))
    return 0


def merge_codegraph(base: dict[str, Any], overlay: dict[str, Any]) -> dict[str, Any]:
    out = dict(base)
    force = os.environ.get("HORIZON_FORCE_KEY", "0") == "1"
    if "extensions" in overlay:
        ext = dict(out.get("extensions") or {})
        for key, value in overlay["extensions"].items():
            if key in ext and ext[key] != value and not force:
                raise SystemExit(
                    f"conflict extensions.{key}: existing={ext[key]!r} overlay={value!r}. "
                    "Set HORIZON_FORCE_KEY=1 to overwrite that key."
                )
            ext[key] = value
        out["extensions"] = ext
    for key in ("exclude", "include", "deprioritize"):
        if key in overlay:
            seen: set[str] = set()
            merged: list[str] = []
            for item in list(out.get(key) or []) + list(overlay[key]):
                if item not in seen:
                    seen.add(item)
                    merged.append(item)
            out[key] = merged
    return out


def backup_if_exists(path: Path, dry_run: bool) -> None:
    if dry_run or not path.is_file():
        return
    bak = path.with_name(path.name + ".bak")
    shutil.copy2(path, bak)
    print(f"backup {bak}")


def write_json(path: Path, data: dict[str, Any], dry_run: bool) -> None:
    text = json.dumps(data, indent=2) + "\n"
    if dry_run:
        print(f"dry-run would write {path}")
        print(text)
        return
    backup_if_exists(path, dry_run=False)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    print(f"wrote {path}")


def apply_fragment(target: Path, fragment: dict[str, Any], dry_run: bool) -> None:
    existing: dict[str, Any] = {}
    if target.is_file():
        existing = json.loads(target.read_text(encoding="utf-8"))
        if not isinstance(existing, dict):
            raise SystemExit(f"{target} is not a JSON object; refuse to merge")
    merged = merge_codegraph(existing, fragment)
    write_json(target, merged, dry_run)


def require_roots(ns: argparse.Namespace, manifest: dict[str, Any]) -> None:
    writes = set(manifest.get("writes") or [])
    if "operator-root" in writes and not ns.operator_root:
        raise SystemExit(f"{manifest['id']} needs --operator-root")
    if "architect-home" in writes and not ns.architect_home:
        raise SystemExit(f"{manifest['id']} needs --architect-home")


def copy_payload(src: Path, dest: Path, dry_run: bool) -> None:
    if dry_run:
        print(f"dry-run would copy {src} -> {dest}")
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dest)
    if src.suffix == ".sh":
        dest.chmod(dest.stat().st_mode | 0o111)
    print(f"copied {dest}")


def install_mcp_snippet(mcp_file: Path, snippet: dict[str, Any], dry_run: bool, replace: bool) -> None:
    blob: dict[str, Any] = {"mcpServers": {}}
    if mcp_file.is_file():
        blob = json.loads(mcp_file.read_text(encoding="utf-8"))
    servers = blob.setdefault("mcpServers", blob.setdefault("servers", {}))
    if not isinstance(servers, dict):
        raise SystemExit(f"{mcp_file} mcpServers is not an object")
    existing = servers.get("codegraph")
    if existing and not replace:
        cmd = json.dumps(existing)
        if "codegraph" not in cmd.lower():
            raise SystemExit(
                "mcp key 'codegraph' exists and does not look like CodeGraph. "
                "Pass --replace-mcp if you mean it."
            )
        print(f"mcp key codegraph already present in {mcp_file}; merge skipped (use --replace-mcp)")
        return
    servers["codegraph"] = snippet
    write_json(mcp_file, blob, dry_run)


def cmd_install(ns: argparse.Namespace) -> int:
    if ns.apply and ns.dry_run:
        raise SystemExit("refuse: --apply and --dry-run together")
    manifest = load_manifest(ns.mod_id)
    require_roots(ns, manifest)
    dry = not ns.apply
    if dry:
        print("dry-run (pass --apply to write)")
    installer = mod_dir(ns.mod_id) / "install.sh"
    env = os.environ.copy()
    env["HORIZON_ROOT"] = str(ROOT)
    env["HORIZON_DRY_RUN"] = "1" if dry else "0"
    env["HORIZON_APPLY"] = "1" if ns.apply else "0"
    if ns.operator_root:
        env["HORIZON_OPERATOR_ROOT"] = str(Path(ns.operator_root).resolve())
    if ns.architect_home:
        env["HORIZON_ARCHITECT_HOME"] = str(Path(ns.architect_home).resolve())
    if ns.mcp_file:
        env["HORIZON_MCP_FILE"] = str(Path(ns.mcp_file).expanduser())
    if ns.owner_user:
        env["HORIZON_OWNER_USER"] = ns.owner_user
    env["HORIZON_REPLACE_MCP"] = "1" if ns.replace_mcp else "0"
    env["PYTHONPATH"] = str(ROOT / "scripts")
    proc = subprocess.run(["bash", str(installer)], env=env)
    return proc.returncode


def cmd_verify(ns: argparse.Namespace) -> int:
    script = mod_dir(ns.mod_id) / "verify.sh"
    env = os.environ.copy()
    env["HORIZON_ROOT"] = str(ROOT)
    if ns.operator_root:
        env["HORIZON_OPERATOR_ROOT"] = str(Path(ns.operator_root).resolve())
    if ns.architect_home:
        env["HORIZON_ARCHITECT_HOME"] = str(Path(ns.architect_home).resolve())
    if ns.mcp_file:
        env["HORIZON_MCP_FILE"] = str(Path(ns.mcp_file).expanduser())
    return subprocess.run(["bash", str(script)], env=env).returncode


def which_codegraph() -> str | None:
    found = shutil.which("codegraph")
    if found:
        return found
    home = Path.home() / ".local/bin/codegraph"
    return str(home) if home.is_file() else None


def _cfg_extension_fail(cfg: Path) -> int:
    data = json.loads(cfg.read_text(encoding="utf-8"))
    ext = json.dumps(data.get("extensions") or {})
    rc = 0
    if ".env" in ext:
        print(f"doctor FAIL: never map .env to a grammar ({cfg})")
        rc = 1
    if ".ini" in ext:
        print(f"doctor FAIL: never map .ini to a grammar ({cfg})")
        rc = 1
    include = data.get("include") or []
    exclude = data.get("exclude") or []
    git_dir = cfg.parent / ".git"
    if include and not exclude and not git_dir.is_dir():
        print(f"doctor FAIL: non-git root has include[] but empty exclude[] ({cfg})")
        rc = 1
    return rc


def _wal_sidecars(db: Path) -> int:
    if not db.is_file():
        return 0
    rc = 0
    db_uid = db.stat().st_uid
    for side in (Path(str(db) + "-wal"), Path(str(db) + "-shm")):
        if side.is_file() and side.stat().st_uid != db_uid:
            print(f"doctor FAIL: {side} uid {side.stat().st_uid} != db uid {db_uid}")
            rc = 1
    return rc


def cmd_doctor(ns: argparse.Namespace) -> int:
    single = bool(getattr(ns, "single_root", False))
    if single:
        if bool(ns.operator_root) == bool(ns.architect_home):
            print("doctor FAIL: --single-root needs exactly one of --operator-root or --architect-home")
            return 1
    elif not ns.operator_root or not ns.architect_home:
        print("doctor FAIL: --operator-root and --architect-home are required (or pass --single-root)")
        return 1
    bin_path = which_codegraph()
    if not bin_path:
        print("doctor FAIL: codegraph binary not on PATH (install @colbymchenry/codegraph 1.6.0)")
        return 1
    ver = subprocess.run([bin_path, "--version"], capture_output=True, text=True)
    print(f"binary: {bin_path} {ver.stdout.strip() or ver.stderr.strip()}")
    rc = 0
    roots: list[tuple[str, Path]] = []
    if ns.operator_root:
        roots.append(("operator", Path(ns.operator_root)))
    if ns.architect_home:
        roots.append(("architect", Path(ns.architect_home)))
    for label, root in roots:
        cfg = root / "codegraph.json"
        if not cfg.is_file():
            print(f"doctor FAIL: missing {cfg}")
            rc = 1
            continue
        print(f"{label} codegraph.json: {cfg}")
        rc |= _cfg_extension_fail(cfg)
        db = root / ".codegraph" / "codegraph.db"
        rc |= _wal_sidecars(db)
        if ns.owner_user and label == "operator" and db.is_file():
            try:
                want = pwd.getpwnam(ns.owner_user).pw_uid
            except KeyError:
                print(f"doctor FAIL: unknown --owner-user {ns.owner_user!r}")
                return 1
            if db.stat().st_uid != want:
                print(f"doctor FAIL: {db} uid {db.stat().st_uid} != --owner-user uid {want}")
                rc = 1
            else:
                print(f"operator db owner matches --owner-user {ns.owner_user}")
        elif ns.owner_user and label == "operator" and not db.is_file():
            print(f"doctor FAIL: --owner-user set but missing {db} (init/index first)")
            rc = 1
    if ns.mcp_file:
        mcp = Path(ns.mcp_file).expanduser()
        if not mcp.is_file():
            print(f"doctor FAIL: no mcp file at {mcp}")
            rc = 1
        else:
            text = mcp.read_text(encoding="utf-8")
            if "${workspaceFolder}" in text and "codegraph" in text:
                print("doctor FAIL: serve path looks pinned to ${workspaceFolder}")
                rc = 1
            if "-lc" in text and "codegraph" in text:
                print("doctor FAIL: codegraph MCP still uses bash -lc")
                rc = 1
            if ns.operator_root:
                try:
                    blob = json.loads(text)
                    node = (blob.get("mcpServers") or {}).get("codegraph") or {}
                    args = node.get("args") or []
                    if "--path" in args:
                        got = args[args.index("--path") + 1]
                        want = str(Path(ns.operator_root).resolve())
                        if got != want:
                            print(f"doctor FAIL: mcp --path {got!r} != operator-root {want!r}")
                            rc = 1
                except (json.JSONDecodeError, KeyError, ValueError, TypeError):
                    print(f"doctor WARN: could not parse mcp argv in {mcp}")
            print(f"mcp file present: {mcp}")
    if rc == 0:
        print("doctor OK")
    return rc


def cmd_uninstall(ns: argparse.Namespace) -> int:
    folder = mod_dir(ns.mod_id)
    guide = folder / "uninstall.md"
    if guide.is_file():
        sys.stdout.write(guide.read_text(encoding="utf-8"))
    script = folder / "uninstall.sh"
    if not ns.apply:
        print("uninstall dry-run (pass --apply to run uninstall.sh if present)")
        return 0
    if not script.is_file():
        print("no uninstall.sh; follow uninstall.md (restore *.bak, delete copied payloads). no rm -rf of a live .codegraph")
        return 0
    env = os.environ.copy()
    env["HORIZON_ROOT"] = str(ROOT)
    env["HORIZON_DRY_RUN"] = "0"
    env["HORIZON_APPLY"] = "1"
    if ns.operator_root:
        env["HORIZON_OPERATOR_ROOT"] = str(Path(ns.operator_root).resolve())
    if ns.architect_home:
        env["HORIZON_ARCHITECT_HOME"] = str(Path(ns.architect_home).resolve())
    return subprocess.run(["bash", str(script)], env=env).returncode


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="horizon",
        description="Install split-horizon mods onto Colby McHenry's CodeGraph. Complements; does not replace.",
    )
    sub = p.add_subparsers(dest="cmd", required=True)
    sub.add_parser("list", help="catalog").set_defaults(func=cmd_list)
    info = sub.add_parser("info", help="print PRODUCT.md")
    info.add_argument("mod_id")
    info.set_defaults(func=cmd_info)
    inst = sub.add_parser("install", help="dry-run unless --apply")
    inst.add_argument("mod_id")
    inst.add_argument("--apply", action="store_true")
    inst.add_argument("--dry-run", action="store_true", help="explicit dry-run (default)")
    inst.add_argument("--operator-root")
    inst.add_argument("--architect-home")
    inst.add_argument("--mcp-file")
    inst.add_argument("--owner-user", help="Unix name that owns the operator index")
    inst.add_argument("--replace-mcp", action="store_true")
    inst.set_defaults(func=cmd_install)
    ver = sub.add_parser("verify")
    ver.add_argument("mod_id")
    ver.add_argument("--operator-root")
    ver.add_argument("--architect-home")
    ver.add_argument("--mcp-file")
    ver.set_defaults(func=cmd_verify)
    doc = sub.add_parser("doctor")
    doc.add_argument("--operator-root")
    doc.add_argument("--architect-home")
    doc.add_argument("--mcp-file")
    doc.add_argument("--owner-user")
    doc.add_argument("--single-root", action="store_true", help="standalone SKU: exactly one root")
    doc.set_defaults(func=cmd_doctor)
    un = sub.add_parser("uninstall", help="print uninstall.md; --apply runs uninstall.sh if present")
    un.add_argument("mod_id")
    un.add_argument("--apply", action="store_true")
    un.add_argument("--operator-root")
    un.add_argument("--architect-home")
    un.set_defaults(func=cmd_uninstall)
    return p


def main() -> int:
    ns = build_parser().parse_args()
    return int(ns.func(ns))


if __name__ == "__main__":
    raise SystemExit(main())
