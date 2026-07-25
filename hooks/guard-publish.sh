#!/bin/sh
# PreToolUse hook (matcher: Bash) — the only two laws a hook can actually enforce.
#
# Blocks: pushing to the protected branch, and the commands this project declared
# forbidden in .loop/VERIFY.md. Exit 2 blocks the call and shows stderr to the agent.
#
# What this canNOT do, and the README says so plainly: it cannot tell whether
# something was really verified. That is not enforceable by any hook — only
# deterministic facts are. Do not pretend otherwise.
#
# Bypassable by design (--safe-mode, disabled hooks, managed settings). This is a
# guardrail against an honest mistake, not a security boundary.

ROOT=${CLAUDE_PROJECT_DIR:-.}
VERIFY="$ROOT/.loop/VERIFY.md"
PAYLOAD=$(cat)

# Protected branch, as declared in VERIFY.md (falls back to the usual suspects).
BRANCH=$(sed -n 's/^- Protected branch[^`]*`\([^`]*\)`.*/\1/p' "$VERIFY" 2>/dev/null | head -1)
[ -z "$BRANCH" ] || [ "$BRANCH" = "______" ] && BRANCH="main master"

case "$PAYLOAD" in
  *"git push"*)
    for b in $BRANCH; do
      case "$PAYLOAD" in
        *"$b"*)
          echo "Blocked: pushing to the protected branch '$b' is the owner's action, not the agent's." >&2
          echo "Commit on a working branch instead, and report that it is ready to publish." >&2
          exit 2
          ;;
      esac
    done
    # A bare 'git push' on the protected branch is the same thing.
    CUR=$(git -C "$ROOT" branch --show-current 2>/dev/null)
    for b in $BRANCH; do
      if [ "$CUR" = "$b" ]; then
        echo "Blocked: the current branch is the protected branch '$b'. Publishing is the owner's call." >&2
        exit 2
      fi
    done
    ;;
esac

# Commands this project declared forbidden, comma-separated inside backticks.
#
# Note for anyone editing this: do NOT loop with `... | while read`. A pipeline runs
# in a subshell, so `exit 2` would only leave the subshell and the hook would print
# "Blocked" while returning 0 — a guard that says it blocks and does not. (That bug
# was in the first version of this file and was caught by actually running it.)
if [ -f "$VERIFY" ]; then
  FORBIDDEN=$(sed -n 's/^- Forbidden commands[^`]*`\([^`]*\)`.*/\1/p' "$VERIFY" 2>/dev/null | tr ',' '\n')
  OLDIFS=$IFS
  IFS='
'
  for cmd in $FORBIDDEN; do
    IFS=$OLDIFS
    cmd=$(printf '%s' "$cmd" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    case "$cmd" in
      ''|_____*) IFS='
'; continue ;;
    esac
    case "$PAYLOAD" in
      *"$cmd"*)
        echo "Blocked: '$cmd' is listed as a forbidden command in .loop/VERIFY.md." >&2
        echo "If it genuinely needs to run, the owner runs it." >&2
        exit 2
        ;;
    esac
    IFS='
'
  done
  IFS=$OLDIFS
fi

exit 0
