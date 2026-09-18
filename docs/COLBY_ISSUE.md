# Courtesy issue (do not post until the public URL exists)

Target: https://github.com/colbymchenry/codegraph/issues/new

Title: Field notes + complementary DLC for a two-consumer (local operator + CLI IDE) setup

Body:

Hi Colby — CodeGraph is the engine I actually run. I did not replace it.

I ended up with two consumers on one box: an unattended local autonomous loop (on-box models, tools) and a CLI IDE architect on MCP. One `serve --mcp --path`. Two SQLite graphs. Writer UID has to match the database owner. `include` is not a whitelist on a home directory. Empty explore on mapped scripts is expected. Extra corpora stay `projectPath`. Slow-disk first index needs `CODEGRAPH_NO_WATCHDOG`. A CIFS share of another host is not a local graph. I wrote that down as installable mods (00–14) sitting on `@colbymchenry/codegraph` 1.6.0, MIT, engine `src/` untouched. Teaching order is in the overlay `docs/HOW_IT_WORKS.md`.

Public pack (after it exists): <PUBLIC_URL>

This is a courtesy note, not a request to merge my overlay or to take a docs dump PR. If an ecosystem link is useful, that is your call. If it is noise, close it.

Credit stays with you for the indexer. I just paid the WAL tax so the next person does not have to invent the same fences.
