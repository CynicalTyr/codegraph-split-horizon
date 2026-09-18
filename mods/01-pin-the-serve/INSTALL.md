# Install 01-pin-the-serve

```bash
./horizon.sh install 01-pin-the-serve --dry-run \
  --operator-root /opt/operator \
  --mcp-file "$HOME/.cursor/mcp.json"

./horizon.sh install 01-pin-the-serve --apply \
  --operator-root /opt/operator \
  --mcp-file "$HOME/.cursor/mcp.json"
```

Sidecar is enough without `--mcp-file`. `--apply --mcp-file` merges the same argv block. `--apply --dry-run` is refused.

Service-user owner:

```bash
./horizon.sh install 01-pin-the-serve --apply \
  --operator-root /opt/operator \
  --owner-user operator \
  --mcp-file "$HOME/.cursor/mcp.json"
```

If `codegraph` already exists in that file and the command is not CodeGraph, the installer exits. `--replace-mcp` means you read the old block.

Reload the MCP client after apply. `./horizon.sh doctor` still wants both roots from mod 00:

```bash
./horizon.sh doctor --operator-root /opt/operator --architect-home "$HOME/architect" \
  --mcp-file "$HOME/.cursor/mcp.json"
```

You messed up if explore still returns architect-only files when you asked about operator symbols. Check the serve path, not the grammar.
