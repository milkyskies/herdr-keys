# herdr-keys

One keybinding scheme for [herdr](https://herdr.dev) across macOS (Ghostty) and Linux (kitty).

## The rule

> **cmd on macOS = ctrl on Linux. Add `shift` for tabs. Add `alt` for workspaces.**

Same letters on both machines. Only the base modifier changes.

| Action | macOS | Linux |
| --- | --- | --- |
| new tab | `cmd+shift+t` | `ctrl+shift+t` |
| close tab | `cmd+shift+w` | `ctrl+shift+w` |
| next tab | `cmd+shift+]` | `ctrl+shift+]` |
| previous tab | `cmd+shift+[` | `ctrl+shift+[` |
| new workspace | `cmd+alt+t` | `ctrl+alt+t` |
| close workspace | `cmd+alt+w` | `ctrl+alt+w` |
| next workspace | `cmd+alt+]` | `ctrl+alt+]` |
| previous workspace | `cmd+alt+[` | `ctrl+alt+[` |
| goto picker | `cmd+shift+p` | `ctrl+shift+p` |

Panes stay on the herdr prefix (`ctrl+space`, then `h`/`j`/`k`/`l`/`v`/`-`/`x`). The prefix layer is identical on both platforms and collides with nothing.

`herdr` accepts an array of keys per action, so a single `config.toml` carries both columns and syncs unchanged between machines.

## Why the terminal has to give the keys up

herdr draws tabs, workspaces and panes *inside* one terminal window. Both Ghostty and kitty ship with their own tabs and splits bound to the same chords. Whichever the terminal claims never reaches herdr, so every chord in the table above has to be released by the terminal first.

Symptom when you skip this: one key of a pair works and the other does nothing.

## macOS — Ghostty

Copy `ghostty/config` to `~/.config/ghostty/config`, then reload with `cmd+shift+,`.

Unbinds it performs, and what each one frees:

| Unbound | Was | Freed for |
| --- | --- | --- |
| `super+shift+t` | `undo` | new tab |
| `super+shift+w` | `close_window` | close tab |
| `super+shift+bracket_left` | `previous_tab` | previous tab |
| `super+shift+bracket_right` | `next_tab` | next tab |
| `super+shift+p` | `toggle_command_palette` | goto picker |
| `super+alt+w` | `close_tab:this` | close workspace |
| `super+t` | `new_tab` | nothing — kept dead so only one tab system exists |
| `super+w` | `close_surface` | nothing — same reason |

`super+alt+t` and `super+alt+[` / `]` are unbound in Ghostty already, so the workspace layer needs no further work.

**`macos-option-as-alt = left`** is required for the workspace layer, and means the `cmd+alt` chords only fire with the **left** option key. Right option stays free for typing `é`, `ñ`, and friends. Set it to `true` if you would rather have both.

Closing a Ghostty window no longer has a key, since `cmd+w` and `cmd+shift+w` both went to herdr. Use `cmd+q`, or add `keybind = super+alt+shift+w=close_window`.

## Linux — kitty

Append `kitty/kitty.conf` to `~/.config/kitty/kitty.conf`, then reload with `ctrl+shift+f5`.

| Unbound | Kitty default | Freed for |
| --- | --- | --- |
| `ctrl+shift+t` | `new_tab` | new tab |
| `ctrl+shift+w` | `close_window` | close tab |
| `ctrl+shift+q` | `close_tab` | avoids a stray second close |
| `ctrl+shift+bracket_left` | `previous_window` | previous tab |
| `ctrl+shift+bracket_right` | `next_window` | next tab |
| `ctrl+shift+p` | (varies by version) | goto picker |

Confirm the defaults on your own machine before trusting this table — kitty's keymap shifts between versions:

```sh
kitty --debug-config | grep -iE 'ctrl\+shift\+(t|w|q|p|bracket)'
```

Anything that prints is still claimed by kitty and needs a `no_op` line.

### GNOME

`ctrl+alt+t` is GNOME's global "open a terminal" shortcut and is intercepted before any terminal sees it. Free it at **Settings → Keyboard → View and Customize Shortcuts → Launchers → Launch terminal**.

If your desktop also grabs `ctrl+alt+[` / `]`, check **Navigation** in the same panel.

## Install

```sh
./install.sh
```

Symlinks `herdr/config.toml` into `~/.config/herdr/`, and the terminal config for the current platform into place. Existing files are backed up with a `.bak` suffix rather than overwritten.

## Verifying

Open herdr's help overlay. Every action in the table should show the chord for the platform you are on. An action showing a prefix binding instead means herdr never took the chord; an action showing the right chord that still does nothing means the terminal is still eating it.
