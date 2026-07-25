# Access — local only, never committed
<!-- Template. Install this as `.loop/ACCESS.local.md` and add that path to .gitignore. -->


This file exists so that credentials and access notes have an obvious home that is
**not** the versioned part of the loop. It must stay in `.gitignore`. If you ever
find it tracked by git, stop and remove it from the index before doing anything else.

Write *how to get in*, not the secrets themselves wherever that is possible:
prefer "the test key is in `.env.local` as `X`" over pasting the key here.

---

## Environments

- Local dev: how to start it, which port, which database it points at.
- Test / staging: URL, and how it differs from production.
- Production: URL. **Who** is allowed to publish to it, and how.

## Test accounts

- Owner/admin: how to sign in (which vault entry, which env var).
- Regular user: same.
- Unauthorized user: needed for the negative check in `VERIFY.md`.

## Services and sandboxes

- Database: how a session reads it (MCP server, CLI, connection string location).
- Payments: where the **test-mode** key lives. Live keys never appear in this file.
- Email / storage / queues: how to observe them in test mode.

## Rules

- Never paste a live key, a production password, or a customer's data here.
- Never type a password into a browser field on the owner's behalf — the owner signs
  in, or a test session is injected.
- If a secret ever lands in a versioned file, treat it as leaked: rotate it, do not
  just delete the line.
