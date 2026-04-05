# Hyprland Keybind Help (Command Center)

## Open the viewer
- Press `SUPER+F2`.
- Launcher: `user/wm/hyprland/scripts/show-keybinds.sh`
- UI backend: `fuzzel` (no Python/Tk required).

## Why this replaced fuzzel
- Fuzzel list rows can clip long command/action text.
- This viewer uses wide multi-column rows in a native dialog.
- Keycodes are translated to readable names (`XF86AudioRaiseVolume`, `LMB`, etc.).

## UI layout
- Built-in searchable list in `fuzzel --list`.
- Table columns:
  - `Category`
  - `Shortcut`
  - `Action`
  - `Command`

## Actions
- `Run now`
- `Copy shortcut`
- `Copy action`
- `Copy command`
- `Back`

## Troubleshooting
- Missing `hyprctl`: binds cannot be loaded.
- Missing `jq`: bind metadata cannot be parsed.
- Missing `fuzzel`: UI cannot open.
- Missing `wl-copy`: copy actions fall back to notifications/stderr.
- No Wayland session: dispatcher actions may fail.

Quick checks:
- `command -v hyprctl`
- `command -v jq`
- `command -v fuzzel`
- `command -v wl-copy`

## Source files
- Launcher: `user/wm/hyprland/scripts/show-keybinds.sh`
- Launch keybind: `user/wm/hyprland/key-bindings.nix` (`SUPER,F2`)
