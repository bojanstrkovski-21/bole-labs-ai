# Motion

Adapted in our own words from Omarchy's `agents/skills/motion.md` (omacom/omarchy
v4.5.0, MIT) and Emil Kowalski's animation standards (emilkowalski/skills, MIT).
Values are defaults; a project's own motion tokens win.

## Should it animate?

Ask how often the user sees it.

| Frequency | Decision |
| --- | --- |
| Hundreds of times a day, or triggered by a keystroke (launcher, command palette, OSD) | No animation |
| Tens of times a day (hover, list navigation) | Remove, or keep tiny and fast |
| Occasional (modals, drawers, toasts) | Standard animation |
| Rare or first-time (onboarding, celebration) | May add delight |

A valid reason for motion: it shows where something came from or went, confirms
an input, or keeps a change from jumping. "It looks nice" on something seen
constantly is not a reason. Inside something the user stays and watches, keys
and pointer get the same motion.

## Easing and duration

- Entering or exiting: strong ease-out. A good default is
  `cubic-bezier(0.23, 1, 0.32, 1)`. Moving on screen: ease-in-out. Hover colour:
  plain `ease`. Constant motion (spinner, progress): linear.
- Never ease-in on UI: it is slowest at the moment the eye is on it. No
  overshoot or bounce except for drag-to-dismiss and playful interactions.
- UI motion stays under 300 ms: button press 100-160 ms, tooltips and small
  popovers 125-200 ms, dropdowns 150-250 ms, modals and drawers 200-500 ms.
- Exits are faster than entrances, about two thirds as long. Text fading out
  under something fading in takes half the fade-in time, or both show at once.

## Physicality

- Never scale from 0. Start at 0.9-0.97 with opacity 0.
- Popovers grow from their trigger (`transform-origin` at the trigger); modals
  stay centered.
- Pressable things scale to about 0.97 on press with a 160 ms ease-out.
- Scaling an item scales its hit area too: undo it on the hit target so edge
  presses still land.

## Reduced motion and performance

- Route every duration through one token that returns 0 when the user (or the
  OS) asks for reduced motion. A bare literal duration bypasses it; add a test
  or lint that fails on one. Looping animations also stop when reduced motion
  is on, or their zero-length steps spin the CPU.
- Animate `transform` and `opacity` by default. Never `transition: all`; list
  the exact properties.
- Do not animate height while the content lays out to that height every frame:
  size the content to its final height and crop with `clip` while the frame
  catches up.
- A flag that zeroes durations globally cuts short unrelated animations already
  running; keep instant paths local to the change.

## Verifying motion

Motion goes wrong in a frame or two. Record the change and inspect it frame by
frame (see `$frontend-testing`), and test on a mid-range device, not only a fast
machine.
