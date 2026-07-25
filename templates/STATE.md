# State — the only source of truth

Nothing about this work lives only in someone's head. If it is not here, it does not
exist. Every session reads this first and writes to it before closing.

Labels: `[ ]` open · `[x]` done + how it was verified · `GAP` built but not verifiable
here · `PARKED` blocked, with why and exactly what is missing · `BLOCKED-<who>` waiting
on a person.

---

## Epic: <name>

**Goal — what this must actually achieve:** <one or two sentences. If this is fuzzy,
stop and clarify it before building.>

**Deliberately out of scope:** <what and why>

### Slices

```
[ ] 1. <thin vertical slice — complete and safe to leave forever>
       non-negotiables: <what must be true for this to count as done>
       verify: BUILD + OBSERVE + DATA
       run: ./loop build

[ ] 2. <slice>
       non-negotiables:
       verify:
       run: ./loop build
```

### Closed

```
[x] 0. <slice>  — verified: <what was observed, and how>  (<date>)
```

### Gaps and blocks

```
GAP: <what is built but could not be verified here, and why>
PARKED: <what is blocked> — why: <reason> — missing: <exact scope left>
BLOCKED-owner: <the precise thing only the owner can unblock>
```

---

## Next

**Next item:** the first `[ ]` above.
**Command:** `./loop build`
