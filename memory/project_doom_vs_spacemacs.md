---
name: project-doom-vs-spacemacs
description: Repo purpose and status for archboki-doom-emacs-project (Doom Emacs vs Spacemacs comparison)
metadata: 
  node_type: memory
  type: project
  originSessionId: d24addad-e30c-4c35-acd3-8a49d16a3360
---

`archboki-doom-emacs-project` (this working directory) is a research repo
comparing how Doom Emacs and Spacemacs are built — architecture, config
model, keybindings, package management — ending in a comparison table and a
recommendation on ease of use.

**Status as of 2026-07-12**: initial version complete and pushed by the user
to `https://codeberg.org/bojanstrkovski-21/archboki-doom-emacs-project`
(main branch). Content lives in `DOOM_VS_SPACEMACS.md`. Conclusion reached:
Spacemacs is easier to *learn* (guided wizard, which-key, mnemonic
bindings), Doom Emacs is easier to *live with* long-term (thinner
abstraction, faster, closer to vanilla Emacs) — recommended Doom given the
user already runs [[reference_codeberg_conventions|archboki-doom-emacs-config]]
day to day.

**How to apply**: if the user returns to this repo asking to expand it
(e.g. deeper dive on a specific layer/module, or config performance
benchmarks), treat `DOOM_VS_SPACEMACS.md` as the existing baseline to extend
rather than redo the research from scratch.
