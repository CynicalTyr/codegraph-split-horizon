# Split-horizon CodeGraph (Claude / generic harness card)

Colby McHenry wrote the indexer. This card is how two consumers use it on one box.

Operator tree: pin `serve --mcp --path` there. Architect home: `projectPath`. They do not share a SQLite file or a writer UID.

`codegraph_explore` is the Read. Empty explore on `.md`/`.sh` is expected. CLI `files` + `node --file`. MCP down: CLI, not Glob.

Never `language:bash`. Never map `.env`/`.ini`. Never merge the two graphs. Never replace the unattended local loop with this chat.
