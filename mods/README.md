# Split-horizon mods

Colby McHenry built CodeGraph. This directory is DLC: installable pieces that sit **on top of** `@colbymchenry/codegraph` 1.6.0. Nobody replaced his indexer. I paid for a setup his README cannot see — a persistent local autonomous/ML operator sharing a machine with a CLI IDE architect — and filed the scars as mods.

Teaching order (engine first, then 00→14): [../docs/HOW_IT_WORKS.md](../docs/HOW_IT_WORKS.md).

Pick one. Read `PRODUCT.md`. Run the CLI in `INSTALL.md`, or:

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh install 00-split-horizon-core --apply \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh verify 00-split-horizon-core \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

`--dry-run` is the default. `--apply` writes **your** trees. Nothing here patches `src/` or `codegraph-kernel/`.

If you are an AI agent, start at [AGENT_INDEX.md](AGENT_INDEX.md). Humans who want the 10-minute path: [../START_HERE.md](../START_HERE.md).

## Catalog (install order)

| Mod | Install if | Skip if |
| --- | --- | --- |
| [00-split-horizon-core](00-split-horizon-core/PRODUCT.md) | You have (or will have) two consumers: unattended operator + IDE | One git repo, one user, one question |
| [01-pin-the-serve](01-pin-the-serve/PRODUCT.md) | Cursor opened the architect home but the code lives elsewhere | Serve already points at the corpus you query most |
| [02-writer-uid-fence](02-writer-uid-fence/PRODUCT.md) | A service user owns the operator SQLite | Same Unix user edits and indexes |
| [03-non-git-home-fence](03-non-git-home-fence/PRODUCT.md) | You indexed a home directory | The root is a real git checkout |
| [04-extension-shims](04-extension-shims/PRODUCT.md) | You care about `.sh` / `.md` / `.html` / units / Cursor `.mdc` | You only query Python/TS symbols |
| [05-empty-explore-cli](05-empty-explore-cli/PRODUCT.md) | Explore returns nothing on a file you know is indexed | You never ask about scripts or docs |
| [06-architect-sync-timer](06-architect-sync-timer/PRODUCT.md) | Second root is always `projectPath` (no watcher) | One root, live serve watcher is enough |
| [07-remind-hook](07-remind-hook/PRODUCT.md) | You almost spawned `codegraph sync` from an IDE hook | You already sync by hand and will keep doing it |
| [08-agent-protocol](08-agent-protocol/PRODUCT.md) | Other agents keep Grep-firsting the operator tree | Solo human, no agent loop |
| [09-findability-not-fear](09-findability-not-fear/PRODUCT.md) | Agents cannot find the identity/config YAML | You have no config SSOT worth locating |
| [10-blob-exclude](10-blob-exclude/PRODUCT.md) | Memory/vector/chat SQLite sits next to source | No `*.db` in the tree |
| [11-n-root-unwatched](11-n-root-unwatched/PRODUCT.md) | A third (or Nth) corpus appeared | Two roots already cover it |
| [12-slow-disk-first-index](12-slow-disk-first-index/PRODUCT.md) | First `--force` on USB/SD/NFS dies under the watchdog | Fast local disk, first index already finished |
| [13-foreign-mount-fence](13-foreign-mount-fence/PRODUCT.md) | You almost indexed a CIFS/NFS share of another host | Every root is a local filesystem |
| [14-operator-own-sync](14-operator-own-sync/PRODUCT.md) | Operator graph goes stale when the laptop lid closes | 02 is not installed, or serve never dies |

Mods 04, 05, 08, 10, 12, and 13 are marked standalone. 14 needs 02. The rest expect 00.

Engine credit stays with Colby. If this pack saved you a readonly-WAL weekend, there is an optional coffee note in [../SUPPORT.md](../SUPPORT.md). The software stays MIT either way.
