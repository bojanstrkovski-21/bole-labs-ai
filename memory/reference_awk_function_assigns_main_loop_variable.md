---
name: reference_awk_function_assigns_main_loop_variable
description: "An awk function that assigns a variable also used by the main loop clobbers it; use function-local parameters"
metadata:
  type: reference
---

awk variables are global unless declared as extra parameters: `function emit(   np, k)`. A profile-record parser lost its counter `n` because a helper assigned `n`. Related: [[reference_awk_func_reserved_word]].
