# Ungrammared files still exist

1.6.0 does not ship bash, HTML, or Markdown grammars. Ask `language:bash` and you get a shrug. The files can still sit in the index if you **map the extension** to a grammar that stores them as file-level nodes.

We use what actually stuck:

- `.sh` `.bash` `.md` `.conf` `.mdc` → `twig`
- `.html` `.htm` → `xml`
- `.json` `.service` `.timer` → `yaml`

Those nodes often have **zero symbols**. Explore then says nothing found. That is not a missing file. That is mod 05.

Never map `.ini` or `.env`. A grammar that "just wants the keys" will still pull credential files into the graph. Files over 1 MB are skipped by the engine. Still don't map secrets.

When Colby ships real `bash` / `markdown` ids, switch. Until then, this shim is the product.

Ten-minute outcome: operator `codegraph.json` `extensions` merged. You reindex. A `.md` appears in `codegraph files`.
