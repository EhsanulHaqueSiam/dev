# ~/.config/tmux/tmux.conf

## Install
Once everything has been installed it's time to run TPM, install first:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Run
`Ctrl+I`


# 🧠 Tmux Custom Keybindings

This document explains all the custom Tmux shortcuts defined in your configuration. These replace the default keybindings after unbinding all keys.

---

## 🔐 Session & Server

| Key Combo  | Action                            |
| ---------- | --------------------------------- |
| `Ctrl + X` | Lock the Tmux server              |
| `Ctrl + D` | Detach from current session       |
| `S`        | Choose session (session switcher) |
| `*`        | List all clients connected        |

---

## 🪟 Windows

| Key Combo        | Action                         |
| ---------------- | ------------------------------ |
| `Ctrl + C`       | Create new window (at `$HOME`) |
| `H`              | Go to previous window          |
| `L`              | Go to next window              |
| `Ctrl + A`       | Switch to last window          |
| `Ctrl + W` / `w` | List all windows               |
| `r`              | Rename current window          |
| `R`              | Reload tmux config file        |
| `"`              | Choose window from list        |

---

## 🧱 Panes

| Key Combo | Action                                |                         |
| --------- | ------------------------------------- | ----------------------- |
| \`        | \`                                    | Split pane horizontally |
| `s`       | Split pane vertically (stay in dir)   |                         |
| `v`       | Split pane horizontally (stay in dir) |                         |
| `z`       | Toggle zoom for current pane          |                         |
| `*`       | Toggle synchronize-panes mode         |                         |
| `P`       | Toggle pane border status             |                         |
| `c`       | Kill current pane                     |                         |
| `x`       | Swap current pane with the one below  |                         |

---

## 🧭 Pane Navigation

| Key Combo | Action             |
| --------- | ------------------ |
| `h`       | Move to left pane  |
| `j`       | Move to below pane |
| `k`       | Move to above pane |
| `l`       | Move to right pane |

---

## ⬆️ Resize Panes (with prefix)

| Key Combo | Action                  |
| --------- | ----------------------- |
| `,`       | Resize pane left by 20  |
| `.`       | Resize pane right by 20 |
| `-`       | Resize pane down by 7   |
| `=`       | Resize pane up by 7     |

---

## 📜 Copy Mode (Vi-style)

| Key Combo          | Action          |
| ------------------ | --------------- |
| `v` (in copy mode) | Begin selection |

---

## 🧼 Other

| Key Combo        | Action                             |
| ---------------- | ---------------------------------- |
| `:`              | Enter Tmux command prompt          |
| `K`              | Clear the terminal in current pane |
| `Ctrl + L` / `l` | Refresh the Tmux client display    |

---

## Notes

* All default bindings are removed first via `unbind-key -a`, so only the above ones are active.
* Some keys are context-specific (e.g. `v` inside copy-mode).
* Most bindings assume the default prefix is still `Ctrl + B`. If you've changed that, apply the prefix before these keys.

---

Let me know if you want this styled with emojis, icons, or reorganized for cheat-sheet printing.

