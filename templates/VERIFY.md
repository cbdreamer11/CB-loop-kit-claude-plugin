# Verification contract

**This file is the whole reason the method is portable.** It is where *this* project
declares what "it actually works" looks like. Everything else in the loop is generic;
this is yours. Keep it true — a stale command here produces confident green nonsense.

Fill each slot with a real command, or with `N/A — <reason>`. A slot marked N/A
becomes a declared GAP: items that need it are delivered as "verified except X",
never as done.

---

## BUILD — does it still compile / do the tests pass

```
<e.g. npm run build && npm test   |   make check   |   pytest -q   |   cargo test>
```

Necessary, never sufficient. A green build is not verification.

## OBSERVE — the thing doing its thing, watched

How do I see the change working with my own eyes, and what artifact proves it?

```
<e.g. start the dev server and open the page in a real browser: render + clean
console + a real interaction (click, type, navigate). Artifact: screenshot.>
<CLI project: the exact command and the output line that only exists now.>
<API project: the request, and the field in the response that is new.>
```

Evidence rules: an **exit code is not evidence**, and **HTTP 200 is not evidence**
(many servers answer 200 for a page that does not exist). Verify by finding a string
that only exists in the new behaviour.

## DATA — confirm the effect where the state lives

```
<e.g. psql "select ... " and confirm the row/value   |   sqlite3 db "..."
     |   read the written file   |   check the queue/bucket/cache>
```

Also confirm the **negative**: the wrong value is refused, the unauthorized caller
gets nothing. Your own tooling may run with more privileges than a real user — check
with the actual role, or permission bugs stay invisible.

## MONEY — only if this project moves money

```
<the provider's test/sandbox mode: create it for real, then confirm the resulting
state changed. Never with live money.>
```

---

## Where verification runs

- [ ] **Test environment** (default): set up → run → tear down.
- [ ] **Shared/live environment** (exception — declare why): ______________________
      Then: wrap in a transaction and roll back, or restore fixtures afterwards and
      confirm nothing was left behind.

## Guardrails this project declares

- Protected branch (an agent never pushes here): `______`
- Publishing is authorized by: `______`
- Forbidden commands for an agent: `______________________________________`
- Shared resource two sessions could collide on: `______`
  Command that reads its true current state: `______________________________`
  (This is a convention, not a lock. It makes collisions visible; it does not
  prevent them.)
- Mode: `[ ] solo — done = committed on a branch` / `[ ] team — done = PR + green CI + reviewer`
