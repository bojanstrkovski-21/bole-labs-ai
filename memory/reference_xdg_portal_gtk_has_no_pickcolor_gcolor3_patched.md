---
name: reference_xdg_portal_gtk_has_no_pickcolor_gcolor3_patched
description: "xdg-desktop-portal(-gtk) on X11 has no Screenshot/PickColor; Arch's gcolor3 eyedropper works because it is patched with a native X11 grab fallback (gcolor3-160.patch)"
metadata:
  node_type: memory
  type: reference
---

The portal call `org.freedesktop.portal.Screenshot.PickColor` needs a backend that implements `org.freedesktop.impl.portal.Screenshot` (GNOME, KDE, ...). `xdg-desktop-portal-gtk` (1.15.3) does NOT: its `gtk.portal` lists FileChooser/AppChooser/Print/Notification/Inhibit/Access/Account/Email/DynamicLauncher/Lockdown/Settings only, so on a plain X11 WM the call returns `UnknownMethod`.

Why gcolor3's eyedropper still works on Arch: upstream gcolor3 (v2.4.0, 2020) is portal-only, but `extra/gcolor3` applies Arch patches (gitlab.archlinux.org/archlinux/packaging/packages/gcolor3), notably `gcolor3-160.patch` "color-selection: Fallback to X11": on portal failure it grabs the pointer/keyboard (`gdk_seat_grab`, dropper cursor, invisible 1x1 popup) and reads the pixel from the root window (`gdk_pixbuf_get_from_window`). Tell-tale: the binary contains "Failed to pick color with XdpPortal" (upstream's string differs).

How it was found: `dbus-monitor --session` while using the app showed the PickColor call and the instant UnknownMethod error; `strings` on the binary showed the patched message. Lesson: when "the source says X but the installed program does Y", check distro patches (PKGBUILD) before doubting observations. Found in dwm-quickshell Session 46 (2026-10-24).
