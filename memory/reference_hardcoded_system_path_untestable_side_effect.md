---
name: reference_hardcoded_system_path_untestable_side_effect
description: "A script that hardcodes a real system path (e.g. /usr/share/applications) with no override can't be safely test-isolated on a dev machine where that real thing actually exists -- a \"does not exist\" test case can silently trigger a real, already-running instance instead"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-27T20:51:35.924Z
---

A test written to exercise a script's "resource not found" path (e.g. "no
matching .desktop file installed") assumes the resource genuinely doesn't
exist in the test environment. If the script itself hardcodes a real
system-wide search path (`/usr/share/applications/`, `/etc/...`, etc.)
with no environment-variable override, and the *actual dev/CI machine*
happens to have that real resource installed for real, the test doesn't
hit the "not found" branch at all — it falls through to the real system
path and drives the real, possibly already-running instance of whatever
that resource represents. Caught live: a script resolving a browser's
`.desktop` file via a hardcoded `/usr/share/applications/`, tested for the
"no usable browser installed" case, instead found the dev sandbox's real
Brave install and asked its real, already-open session to load a test
URL as a new tab.

**How to apply:** any script with a hardcoded absolute system path should
take that path from an environment variable with the real path as the
default (`${SOME_VAR:-/usr/share/applications}`), matching this project's
own established `DWM_TEST_*`/`DWM_HEALTH_*` convention. Before trusting a
new "resource unavailable" test case as safe, check whether the resource
it's testing the absence of might genuinely be present on the machine
actually running the test — a properly-isolated `$HOME`/`$PATH` sandbox
doesn't help if the code path in question reads from a literal absolute
path outside either of those.
