# Findability over fear

We excluded the identity ledger YAML "for safety." The next session could not **find** the SSOT through CodeGraph. Restored. Explore on YAML returns **keys**, not a license to paste SIDs, cookies, or tokens into chat.

Index the config files agents must locate (identity ledger, model-routing, harness YAML — whatever you actually have). Exclude the jars: `.env`, `.env.*`, `*auth.json`, lockfiles.

The graph is how future agents find files. If it is first-party config, it belongs unless it is a secret blob.

Ten-minute outcome: operator `codegraph.json` drops common identity-config filenames from exclude if you had cargo-culted them there, and keeps env/auth excludes. You still do not print values.
