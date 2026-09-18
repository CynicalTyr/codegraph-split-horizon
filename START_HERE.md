# START_HERE

Colby McHenry wrote CodeGraph. You are installing **split-horizon mods** on **his** binary. Teaching order: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md). Engine docs: his README / [docs/ENGINE.md](docs/ENGINE.md) after overlay apply.

| File | Job |
| --- | --- |
| `horizon.sh` | list / info / install / verify / doctor / uninstall |
| `mods/` | DLC store. Each folder is a product. |
| `HORIZON.md` | Two-screen map + broke-it table |
| `mods/AGENT_INDEX.md` | If you are an AI, start there |

Need: Linux or macOS, `codegraph` 1.6.0+ from [upstream](https://github.com/colbymchenry/codegraph), bash, python3, two smashable dirs.

```bash
chmod +x horizon.sh
./horizon.sh list

mkdir -p /tmp/horizon-op /tmp/horizon-arch
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh install 00-split-horizon-core --apply \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch

# a fresh tree has no graph until init. index --force is not init.
codegraph init --yes --force /tmp/horizon-op
codegraph init --yes --force /tmp/horizon-arch
# slow disk (USB/SD/NFS): CODEGRAPH_NO_WATCHDOG=1  or install mod 12
codegraph index --force /tmp/horizon-op
codegraph index --force /tmp/horizon-arch

./horizon.sh doctor --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh verify 00-split-horizon-core \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch

codegraph files --path /tmp/horizon-op --pattern 'sample_probe.py' --format flat
```

Then the empty-explore drill (Colby's explore ranks **symbols**; mapped markdown often has zero):

```bash
./horizon.sh install 05-empty-explore-cli --apply --operator-root /tmp/horizon-op
/tmp/horizon-op/bin/horizon-node /tmp/horizon-arch ARCHITECT_NOTES.md
```

Success is `verify OK`, `doctor OK`, `sample_probe.py` in `files`, and `horizon-node` printing the architect note — not a silent explore.

Standalone SKUs (04/05/08/10/12/13) can health-check one tree:

```bash
./horizon.sh doctor --single-root --operator-root /tmp/horizon-op
```

Do not: `codegraph init /`, index MEDIA or model weights, index another host's CIFS/NFS mount, map `.env`/`.ini`, `pkill` a live owner `serve --mcp`, merge the two `.codegraph/` dirs, let the IDE session replace the unattended operator loop, publish a second npm name that looks like Colby's package.

Next: [mods/README.md](mods/README.md). One mod. Dry-run first. Engine credit stays with Colby.
