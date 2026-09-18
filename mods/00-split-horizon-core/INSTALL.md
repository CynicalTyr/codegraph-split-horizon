# Install 00-split-horizon-core

Need: `codegraph` 1.6.0 from Colby (`@colbymchenry/codegraph`), bash, python3.

Pick two directories you own. Scratch is fine for the first pass:

```bash
mkdir -p /tmp/horizon-op /tmp/horizon-arch
cd /path/to/codegraph-split-horizon

./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op \
  --architect-home /tmp/horizon-arch

./horizon.sh install 00-split-horizon-core --apply \
  --operator-root /tmp/horizon-op \
  --architect-home /tmp/horizon-arch
```

A fresh directory is not a graph yet. `index --force` is not `init`.

```bash
codegraph init --yes --force /tmp/horizon-op
codegraph init --yes --force /tmp/horizon-arch
```

Index **as the Unix user who will own that database**. Mixing users is mod 02's entire reason to exist.

```bash
codegraph index --force /tmp/horizon-op
codegraph index --force /tmp/horizon-arch
./horizon.sh doctor --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh verify 00-split-horizon-core \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

You messed up if:

- both configs point at the same path
- you ran `codegraph init /` or indexed `$HOME` without mod 03
- you copied one `.codegraph/` into the other tree
- you skipped `init` and wondered why `index --force` returned 1

`sync` does not pick up a new `codegraph.json`. After any later mod that merges config, `index --force` again.
