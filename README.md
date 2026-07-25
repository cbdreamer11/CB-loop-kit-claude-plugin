# loop-kit

***English** · [Español](README.es.md)*

A working method for building real software with coding agents, across many sessions.

It exists to kill one specific failure: **work reported as finished that was never
observed working.** That failure is expensive because it is discovered weeks later,
after other work was built on top of it.

The method is five rules and six commands. Nothing here is specific to a language, a
framework, or a database — the only thing you write is a short file declaring what
*"it actually works"* looks like in your project.

---

## Install

**As a plugin (recommended — updates with `/plugin update`):**

```
/plugin marketplace add cbdreamer11/CB-loop-kit-claude-plugin
```

then

```
/plugin install loop-kit@loop-kit
```

**Or as plain skills (no plugin machinery):** copy `skills/*` into `~/.claude/skills/`
for every project, or into `.claude/skills/` for one project. Copy `agents/*` into
`.claude/agents/` of the project.

Then, in the project you want to work on:

```
/loop-kit:loop-setup
```

That is **session 0**. It reads your project, checks which connections actually work,
asks the handful of decisions that are yours, and writes the files. It builds nothing.

> Installed as a plugin, the skills are namespaced — `/loop-kit:loop-setup`. If you
> copied the skills into `~/.claude/skills/` instead, they are just `/loop-setup`.

---

## The commands

Two ways to run the same thing. **The skills are the method; the wrapper is only a
launcher that also picks the model for you.**

| What you want | In the desktop app or an IDE | In a terminal |
|---|---|---|
| Session 0, once per project | `/loop-kit:loop-setup` | `/loop-kit:loop-setup` |
| Plan an epic | `/loop-kit:loop-plan <goal>` | `./loop plan "<goal>"` |
| Build the next slice | `/loop-kit:loop` | `./loop build` |
| Verify honestly | `/loop-kit:loop-verify` | `./loop verify` |
| Council on an open question | `/loop-kit:loop-council` | — (invoke the skill) |
| Audit, record, hand off | `/loop-kit:loop-close` | `./loop close` |
| Where does the work stand? | `/loop-kit:loop-doctor`, or read `.loop/STATE.md` | `./loop` |
| Check the install | `/loop-kit:loop-doctor` | `./loop doctor` |

**The one real difference:** in a terminal, `./loop plan` launches the session *with*
the right model and effort already set, because a role is a settings profile passed at
launch. In the app you pick the model yourself in the app's model selector before
invoking the skill — nothing can switch it for you, since a running session cannot
change its own model.

That difference costs less than it sounds, and here is why: `loop-plan`,
`loop-council` and `loop-close` **dispatch subagents** whose model and effort are fixed
in their own definitions. So even in the app, on a mid-tier session, the planning and
the red-teaming are done by the strong model. The wrapper is a convenience; the
architecture is what protects the quality.

---

## The one file you fill in

`.loop/VERIFY.md` is the whole reason this is portable. Four slots, each a real
command from *your* project:

- **BUILD** — compiles / tests pass. Necessary, never sufficient.
- **OBSERVE** — the thing doing its thing, watched, with an artifact. A page rendered
  in a real browser with a clean console; a CLI run and its output; the new field in
  a response.
- **DATA** — query the store and confirm the effect, including the negative (the wrong
  value is refused, the unauthorized caller gets nothing).
- **MONEY** — only if money moves: the provider's test mode, for real.

Two evidence rules that catch most false greens: **an exit code is not evidence**, and
**HTTP 200 is not evidence** — plenty of servers answer 200 for a page that does not
exist. Verify by a string that only exists in the new behaviour.

A slot you cannot run becomes a declared **GAP**, and an item that needs it ships as
"verified except X" — never as done.

---

## Session roles, and an honest limit

Different work wants different thinking, so each role is a launch profile
(`.loop/roles/*.json`) that sets the model, the effort, and the agent applied to the
main thread:

| Role | Model / effort | Why |
|---|---|---|
| plan | strongest / xhigh | decides what every cheaper session will do |
| build | mid-tier / medium | the workhorse; the hard calls are already made |
| verify | mid-tier / high | its job is to not be fooled |
| close | strongest / xhigh | adversarial audit before anything is published |

Session 0 **asks which models you actually have** and writes those aliases into the
profiles — plans differ, and a managed install can restrict models. If you only have
one model, the method still works; it just loses the gradient. What it will never do is
leave a profile pointing at a model you do not have, because an unavailable model can
fall back silently, and a silent fallback is the exact failure this kit exists to prevent.

**The limit, stated plainly:** a session cannot change its own model once it is
running, and it cannot even read which model it is on. So a plan does not *switch*
the next session — it writes the exact command to launch it. The important
consequence: the expensive thinking does **not** live in the main thread. `plan`,
`council` and `close` dispatch subagents whose model and effort are fixed in their own
definitions, so a session launched carelessly still gets planning and red-teaming from
a strong model. Model choice is architecture here, not discipline.

---

## What is enforced, and what is only asked

Being clear about this is the point. Two hooks enforce the only two things a machine
can actually check:

- pushing to the protected branch is **blocked**
- the commands you declared forbidden are **blocked**

Everything else is a rule the agent follows, not a gate: **no hook can tell whether
something was really verified.** A gate on "did you verify?" can only grep for a
sentence the agent itself writes, which teaches it to write the sentence. So this kit
does not pretend. Both hooks are also bypassable by design (safe mode, disabled hooks,
managed settings) — they are guardrails against an honest mistake, not a security
boundary.

Two limitations worth knowing before they surprise you. The guard **only enforces in a
project that has run setup** — installing this must never change how git behaves in your
other repositories. And it matches on the command text, so something that merely *mentions*
a blocked command gets blocked too; rephrase it, or let the owner run it.

---

## Requirements

- Claude Code (the role profiles rely on `--settings`, `--model`, `--effort`, and the
  `agent` setting; `effort` in agent frontmatter is honored).
- POSIX `sh` for the wrapper and the two hooks. No `jq`, no `perl`. On Windows, use
  Git Bash or WSL.
- Nothing else. No database, no browser tooling, no payment provider — session 0 tells
  you which of those you have, and turns each one you lack into a declared gap instead
  of a silent one.

## Deliberately not included

Incident protocol, branch hygiene, migration ledgers, feature-flag dark-shipping,
multi-layer QA, team review workflows. They are real, and they are the next layer —
but a method nobody finishes reading is a method nobody adopts. Five rules, six
commands, four files.

## License

MIT.
