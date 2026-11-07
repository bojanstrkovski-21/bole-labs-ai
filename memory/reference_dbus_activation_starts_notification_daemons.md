---
name: reference_dbus_activation_starts_notification_daemons
description: "dunst and xfce4-notifyd start themselves by D-Bus activation; not launching them is not enough. Runtime-masking their systemd user units blocks it (verified on dbus-broker)"
metadata:
  type: reference
---

Packages such as `dunst` and `xfce4-notifyd` ship D-Bus activation files for `org.freedesktop.Notifications` (`SystemdService=dunst.service`). If any program sends a notification before the intended daemon (for example Quickshell's `NotificationServer`) has registered, the bus starts them. Result: Quickshell logs `Could not register notification server ... one is already registered` and its popups never show, even though no autostart script launches dunst.

**Fix (verified 2026-11-07, dbus-broker user bus):** mask the units while the session runs: `systemctl --user mask --runtime dunst.service` (also stop a running one). With Quickshell killed and the name free, `notify-send` failed with `Could not activate remote peer ... activation request failed: unit is masked`, nothing started, and `systemctl --user start dunst.service` fails with `Unit ... is masked`. `dbus-broker` does not fall back to the file's `Exec=`.

**Scope:** `--runtime` masks live in `$XDG_RUNTIME_DIR/systemd/user/`, vanish at the last logout and do not change other sessions. A permanent mask (`~/.config/systemd/user/dunst.service -> /dev/null`) affects every session. A different build that execs `dunst` directly from its own autostart (chadwm-boki `run.sh`) is not blocked by either mask.

**How to apply:** implemented in chadboki-qswm `autostart.sh` (`claim_notification_name`, which masks dunst, mako, swaync, xfce4-notifyd and fnott and stops them) and undone by `autostop.sh`. Check who owns the name with `busctl --user status org.freedesktop.Notifications | grep ^Comm=`. Related: [[project-dwm-quickshell]].
