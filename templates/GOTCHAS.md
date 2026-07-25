# Gotchas — things that fooled us

This file is the compound interest of the method. Every entry is an hour someone
already lost so that nobody loses it twice. Add one **the moment** something turns
out not to be what it looked like — not at the end of the session, when it feels
too small to write down.

Write the symptom first: that is what a future session will recognise, before it
knows the cause.

---

## <short name>

- **Symptom:** what you saw that looked fine, or looked broken.
- **Why it was convincing:** the reason the wrong conclusion was reasonable.
- **What was really happening:**
- **How to detect it next time:** the exact check, command, or query.
- **Where it bit:** `path/to/file` or which flow.

---

### Starters worth checking in most projects

- A tool running with more privileges than a real user hides permission bugs. Check
  with the actual role, signed out as well as signed in.
- A server that answers `200` for a path that does not exist makes a missing file
  look present. Verify by a string that only exists in the new behaviour.
- A cache, a service worker, or a CDN can serve the old thing after a correct
  change. Confirm you are looking at the new build before you debug the code.
- A command can exit `0` and have done nothing.
