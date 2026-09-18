# Install 03-non-git-home-fence

```bash
./horizon.sh install 03-non-git-home-fence --dry-run \
  --architect-home "$HOME/architect"
./horizon.sh install 03-non-git-home-fence --apply \
  --architect-home "$HOME/architect"

# edit exclude[] — add YOUR dump trees, then:
codegraph index --force "$HOME/architect"
./horizon.sh verify 03-non-git-home-fence --architect-home "$HOME/architect"
```

`sync` will not see the new excludes until a reindex. 1.6.0 reloads exclude on a live watcher; a home you only hit via `projectPath` has no watcher. Reindex.

You messed up if `include` is a list of the only folders you want and `exclude` is empty. That is how the 23k-file walk starts.
