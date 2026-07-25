#!/bin/sh
# SessionStart hook — mechanizes step 0 ("locate yourself").
#
# Whatever this prints on stdout is added to the session's context before the first
# token, so a session lands already oriented: what is next, what is parked, what
# landed recently, and which files another session may be holding.
#
# Never fails the session: exits 0 no matter what. If it cannot find the loop, it
# stays quiet rather than shouting at a project that does not use it.

ROOT=${CLAUDE_PROJECT_DIR:-.}
STATE="$ROOT/.loop/STATE.md"

[ -f "$STATE" ] || exit 0

# Placeholder lines from the template (they contain <angle brackets>) are filtered
# out everywhere: an unfilled template line read as a real gap sends a session
# chasing work that does not exist.
NOISE='<[^>]*>'

echo "## Where this project stands (from .loop/STATE.md)"
echo
sed -n '/^## Epic:/,/^### Slices/p' "$STATE" | grep -vE "$NOISE" | sed -n '1,15p'
echo
echo "### Open items, gaps and blocks"
OPEN=$(grep -E '^(\[ \]|GAP|PARKED|BLOCKED)' "$STATE" | grep -vE "$NOISE" | sed -n '1,20p')
[ -n "$OPEN" ] && echo "$OPEN" || echo "(none recorded)"
echo
CLOSED=$(grep -E '^\[x\]' "$STATE" | grep -vE "$NOISE" | sed -n '1,10p')
if [ -n "$CLOSED" ]; then
  echo "### Already done — do not rebuild these"
  echo "$CLOSED"
  echo
fi

if [ -f "$ROOT/.loop/GOTCHAS.md" ]; then
  echo "### Traps this project has already sprung (see .loop/GOTCHAS.md)"
  grep -E '^## ' "$ROOT/.loop/GOTCHAS.md" | sed -n '1,10p'
  echo
fi

echo "### Recent commits"
git -C "$ROOT" log --oneline -15 2>/dev/null
echo

HOT=$(git -C "$ROOT" status --porcelain 2>/dev/null | sed -n '1,15p')
if [ -n "$HOT" ]; then
  echo "### Uncommitted files — may belong to a parallel session, do not touch what is not yours"
  echo "$HOT"
  echo
fi

echo "Before building anything: read .loop/VERIFY.md and follow the loop skill."
echo "Anything already committed is not rebuilt. Confirm against the code, not against a document."

exit 0
