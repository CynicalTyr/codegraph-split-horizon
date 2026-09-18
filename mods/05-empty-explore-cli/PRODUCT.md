# Empty explore is not a missing file

`codegraph_explore` ranks **symbols**. A systemd unit, a Cursor rule, a shell script, a markdown runbook — after the twig/xml/yaml shim — often has zero symbols. Explore says nothing found. Agents then Glob/Grep the whole machine. That is the nodding loop. The file was in the index the whole time.

CLI:

```bash
codegraph files --path <root> --pattern '*.sh' --format flat
codegraph node --file relative/path/from/root.sh --path <root>
```

`horizon-node` is that pair with less typing. Language filters `bash` and `html` are lies on 1.6.0. On disk those rows are `twig` and `xml`.

MCP down? Same CLI. Do not start a twenty-file Read survey because the stdio server blinked.

Ten-minute outcome: `bin/horizon-node` on the operator root. Point it at `ARCHITECT_NOTES.md` or any `.md` you indexed.
