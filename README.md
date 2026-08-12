# herdr-keys

One keybinding scheme for [herdr](https://herdr.dev) across macOS (Ghostty) and Linux (kitty).

## The rule

> **cmd on macOS = ctrl on Linux. Add `shift` for tabs. Add `alt` for workspaces.**

Same letters on both machines. Only the base modifier changes.

| Action | macOS | Linux |
| --- | --- | --- |
| new tab | `cmd+shift+t` | `ctrl+shift+t` |
| close tab | `cmd+shift+w` | `ctrl+shift+w` |
| next tab | `cmd+shift+n` | `ctrl+shift+n` |
| previous tab | `cmd+shift+p` | `ctrl+shift+p` |
| new workspace | `cmd+alt+t` | `ctrl+alt+t` |
| close workspace | `cmd+alt+w` | `ctrl+alt+w` |
| next workspace | `cmd+alt+n` | `ctrl+alt+n` |
| previous workspace | `cmd+alt+p` | `ctrl+alt+p` |
| goto picker | `cmd+shift+g` | `ctrl+shift+g` |

Panes stay on the herdr prefix (`ctrl+space`, then `h`/`j`/`k`/`l`/`v`/`-`/`x`). The prefix layer is identical on both platforms and collides with nothing.

`herdr` accepts an array of keys per action, so a single `config.toml` carries both columns and syncs unchanged between machines.

## Letters only, never brackets

Every binding here is a letter, and that is deliberate. `[` and `]` look like the obvious choice for previous/next, and they break on a **Japanese (JIS) keyboard**.

Terminals report the *physical* key position using US layout names. On JIS the bracket keys are not where ANSI puts them:

- the key **labelled `[`** occupies ANSI's `]` position, so it reports as `bracket_right` and fires your **next** binding
- the key **labelled `]`** occupies ANSI's `'` position, so it reports as `quote` and matches **nothing**

The symptom is unmistakable: one bracket jumps the wrong direction and the other is dead. Letters occupy identical physical positions on JIS and ANSI, so they sidestep the problem entirely.

This also lines up with herdr's own defaults, which use `prefix+n` / `prefix+p` for tabs and `prefix+g` for goto.

## Why the terminal has to give the keys up

herdr draws tabs, workspaces and panes *inside* one terminal window. Both Ghostty and kitty ship with their own tabs and splits bound to the same chords. Whichever the terminal claims never reaches herdr, so every chord in the table above has to be released by the terminal first.

Symptom when you skip this: the chord does nothing at all, in either direction.

## macOS — Ghostty

Copy `ghostty/config` to `~/.config/ghostty/config`, then reload with `cmd+shift+,`.

| Unbound | Was | Freed for |
| --- | --- | --- |
| `super+shift+t` | `undo` | new tab |
| `super+shift+w` | `close_window` | close tab |
| `super+shift+p` | `toggle_command_palette` | previous tab |
| `super+alt+w` | `close_tab:this` | close workspace |
| `super+t` | `new_tab` | nothing — kept dead so only one tab system exists |
| `super+w` | `close_surface` | nothing — same reason |

`super+shift+n`, `super+shift+g` and the whole `super+alt` letter range are unbound in Ghostty already, so nothing else is needed.

**`macos-option-as-alt = left`** is required for the workspace layer, and means the `cmd+alt` chords only fire with the **left** option key. Right option stays free for typing `é`, `ñ`, and friends. Set it to `true` if you would rather have both.

Closing a Ghostty window no longer has a key, since `cmd+w` and `cmd+shift+w` both went to herdr. Use `cmd+q`, or add `keybind = super+alt+shift+w=close_window`.

## Linux — kitty

Append `kitty/kitty.conf` to `~/.config/kitty/kitty.conf`, then reload with `ctrl+shift+f5`.

| Unbound | Kitty default | Freed for |
| --- | --- | --- |
| `ctrl+shift+t` | `new_tab` | new tab |
| `ctrl+shift+w` | `close_window` | close tab |
| `ctrl+shift+q` | `close_tab` | avoids a stray second close |
| `ctrl+shift+n` | `new_os_window` | next tab |
| `ctrl+shift+p` | (varies by version) | previous tab |
| `ctrl+shift+g` | (varies by version) | goto picker |

Confirm the defaults on your own machine before trusting this table — kitty's keymap shifts between versions:

```sh
kitty --debug-config | grep -iE 'ctrl\+shift\+(t|w|q|n|p|g)'
```

Anything that prints is still claimed by kitty and needs a `no_op` line.

### GNOME

`ctrl+alt+t` is GNOME's global "open a terminal" shortcut and is intercepted before any terminal sees it. Free it at **Settings → Keyboard → View and Customize Shortcuts → Launchers → Launch terminal**.

## Install

```sh
./install.sh
```

Symlinks `herdr/config.toml` into `~/.config/herdr/`, and the terminal config for the current platform into place. Existing files are backed up with a `.bak` suffix rather than overwritten.

## Verifying

Open herdr's help overlay. Every action in the table should show the chord for the platform you are on. An action showing a prefix binding instead means herdr never took the chord; an action showing the right chord that still does nothing means the terminal is still eating it.

Detach with `ctrl+space` then `q` — the session, tabs and running agents all survive. `herdr server stop` is the one that actually kills them.
