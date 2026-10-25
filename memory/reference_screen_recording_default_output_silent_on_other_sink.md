---
name: reference_screen_recording_default_output_silent_on_other_sink
description: "Recording the default output is silent when sound plays on another sink (Bluetooth while HDMI is default); record the monitor of the playing sink. gpu-screen-recorder also captures windows on hidden dwm tags"
metadata:
  type: reference
---

gpu-screen-recorder `-a default_output` records the default sink's monitor. If
the default is an HDMI monitor without speakers while the sound plays on
Bluetooth headphones, the file has an audio track at about -91 dB (silence).
Confirmed by playing a tone to one sink and recording each `<sink>.monitor`
with `parecord`.

Better: take the monitor of every sink that has a playing stream
(`pactl list short sink-inputs` -> sink index -> `pactl list short sinks` ->
`<name>.monitor`), else the default sink, else merge monitors with `|`.
`pactl list sinks` shows port type HDMI/DisplayPort, but says "available" even
for a monitor without speakers, so it cannot tell speakerless HDMI apart; offer
a "show HDMI" toggle instead.

Also confirmed: `gpu-screen-recorder -w <window id>` keeps recording a window
whose dwm tag is hidden (a ticking clock kept ticking), so a chosen window can
stay on its own tag. Use `ffmpeg -af volumedetect` to check a file's audio.
Found in dwm-quickshell Session 47.
