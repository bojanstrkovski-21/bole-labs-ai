---
name: reference-pull-request-sections
description: Checklist for working one item in a to-do file
metadata:
  type: reference
---

Use this for `to-do.txt`, one item at a time. Check a box only when that step happened. Say "None" in Limitations when there is nothing to add. Do not copy this checklist into an issue, a pull request, or a discussion. Those drafts are a title plus the problem and the solution, with no checkboxes.

```markdown
## Problem

Describe the problem this change solves.

## Approach

Summarize the implementation and important design decisions.

## Automated validation

List the exact commands and CI checks that passed.

- [ ] Focused checks passed
- [ ] Complete local validation passed
- [ ] Pull-request CI passed on the latest commit
- [ ] Applicable security checks passed
- [ ] Local Codex review loop completed

## Manual testing

Describe the workflows, target environments, error states, accessibility
behavior, persistence, logs, upgrade behavior, or rollback behavior tested.

- [ ] Required manual testing is complete
- [ ] Screenshots or recordings are attached for visible changes

## Review

- [ ] Independent review is complete
- [ ] Latest Codex review has no actionable findings
- [ ] Actionable review threads are resolved

## Limitations and follow-up

Document skipped validation, accepted exceptions, known limitations, and
follow-up work. Use "None" when there are no known items.
```
