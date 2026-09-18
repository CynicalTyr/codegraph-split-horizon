# Include is not a whitelist

On a git repo, `include` is how you pull gitignored `.sh` files back into the graph. We copied that instinct onto a **home directory**. First `index --force` started walking a stale agent tree — tens of thousands of Python files that were never the product.

`include` only adds. It does not fence. On a non-git home, **`exclude` is the fence.** Prove it with `codegraph files --format flat`, not optimism.

Built-in ignores still drop `node_modules/`, `.venv/`, `build/`. You cannot `include` those back. Stop trying.

We deprioritize tests and generated trees when they must stay findable. Dump trees (old checkouts, plugin caches, chat transcripts, nested copies of the operator) get **excluded**. If they stay in the graph they outrank the skills you actually wanted.

Ten-minute outcome: architect `codegraph.json` gains a starter exclude list. You append **your** dump dirs. `verify.sh` fails if those prefixes still appear in `files --format flat`.
