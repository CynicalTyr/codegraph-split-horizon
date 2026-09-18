# Split-horizon CodeGraph (agent policy)

You are on a machine that may have **two** CodeGraph indexes. Colby McHenry's CodeGraph is the engine. This rule is the split. Do not overwrite his engine `AGENTS.md`.

1. Pick the index before the first explore. Operator runtime (unattended local-model loop) → default serve / omit `projectPath`. Architect skills/rules/docs → `projectPath` (or CLI `--path`) on that home. Wrong root looks like "CodeGraph is broken."
2. MCP tool is `codegraph_explore` only on 1.6.0+. Query is a question or the symbol/file names that span the flow. Budget about three calls **per index** as discipline (the engine does not reject a fourth). Callers and blast radius are already in the response.
3. Treat returned source as already Read. Do not Grep the same tree to confirm unless a staleness banner named the file, or you are hunting a secret/log literal. Do not grade your own unread `codegraph.json` merge.
4. Empty explore on `.sh` `.md` `.mdc` `.html` `.json` `.yaml` `.service` `.timer` is expected (zero symbols). Use `horizon-node` / `codegraph files` + `node --file`. Never `language:bash` or `language:html`. Those rows are stored as `twig` / `xml` / `yaml`.
5. MCP not connected: same CLI on that root. Not a Glob survey.
6. After `codegraph.json` edits: `index --force`. `sync` does not load new config. After file edits on an unwatched root: `sync` as the **owner UID of that DB**.
7. YAML hits are keys. Do not print cookie, token, or SID values.
8. Do not merge the two SQLite files. Do not `codegraph sync` the operator tree as the architect user. Do not `files`/`node` the other tree as the wrong UID. Do not replace the local operator's inner loop with this IDE session. Do not spawn the indexer from an IDE hook (remind only).
9. The graph is a messenger, not an oracle. Pair it with lexical search or ANN when the question is literals or meaning — do not substitute one instrument for the others.
10. After `horizon.sh install --apply`, `horizon.sh verify` is the check. Skipping it is self-grading.
