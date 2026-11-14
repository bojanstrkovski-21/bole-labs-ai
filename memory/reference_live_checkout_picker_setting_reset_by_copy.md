---
name: reference_live_checkout_picker_setting_reset_by_copy
description: "A setting a picker edits in the live checkout (e.g. the theme #include in config.def.h) is silently reset by copying the repo version over it"
metadata:
  type: reference
---

Before deploying a build file over the live checkout, diff it and keep the picker-owned line (dwm-quickshell: the theme `#include` in `config.def.h`). A plain `cp` reverts the user's chosen theme. See [[feedback_diff_whole_config_before_partial_deploy]].
