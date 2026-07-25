# The laws

Five rules. They are short on purpose: a method nobody can recite is a method nobody
follows. Everything else in this kit is machinery for making these true.

---

## 1 · Verification

**Nothing is done until it has been observed working.** A green build, "I read the
code and it looks right", and "this should work" are not verification. The only valid
signal is observed behaviour — and what counts as observation for *this* project is
written in `VERIFY.md`.

*Prevents:* the failure that costs the most — work reported as finished that has to
be redone weeks later, after other work was built on top of it.

## 2 · Slices at 100%

Work is cut into **thin vertical slices, each complete and usable**. The test is:
**would it be safe to leave this exactly as it is, forever?** If it leaves a dead
end, a control that does not do what it says, or a setting with no effect — it is not
a slice. One epic at a time, depth before breadth, nothing new opens until what is
open is closed.

*Prevents:* ten things at 60%, which is the same as nothing shipped and twice the
maintenance.

## 3 · Completeness over speed

The goal is **accuracy, not velocity**: that nothing is left out. If finishing needs
one more thing, that thing gets built — it is not reported as a leftover and it is
not offered as a question. When there is a real open question, it goes to a council
that decides against real documentation, not from memory.

*Prevents:* the half-built feature that technically exists and helps nobody.

## 4 · One source of truth

The plan lives in **`STATE.md`**, not in anyone's head and not in a chat scroll.
Finished is marked with how it was verified. Deferred is marked with **why** and
**exactly what is missing**. Blocked means **parked, not abandoned**: leave the code
clean and committed, write down the blocker, and move to the next item.

*Prevents:* rebuilding what already exists, and quietly losing what was deferred.

## 5 · The owner decides what is the owner's

An agent decides all the technical questions itself. It asks only for what only the
owner can unblock: a key or an access, moving real money, a business/legal/pricing
call, or permission to publish. **"Do you want me to test it?" is never a valid
question** — if it matters, it is already tested.

*Prevents:* both failure modes — an agent that asks permission for everything, and
an agent that publishes without asking.

---

**In one line:** locate yourself → investigate the real code → build it complete →
observe it working → if it fails, fix and observe again → commit on a branch →
report what you verified and what you did not. Nothing half-done, nothing skipped,
nothing assumed.
