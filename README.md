# Dev Environment

Automated dev environment setup for Arch Linux. Install tools + deploy dotfiles with symlinks.

## Quick Start

```bash
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/dev
cd ~/dev
./run
```

That's it. All tools get installed and configs get symlinked into place.

Or use the interactive TUI for a menu-driven experience:

```bash
./tui
```

## Usage

### `./run` — Main entry point

Installs all tools from `runs/` then deploys configs via `dev-env`.

```bash
./run                  # install everything + deploy configs
./run rust             # install only scripts matching "rust"
./run bun              # install only scripts matching "bun"
./run node             # install only scripts matching "node"
./run --env            # skip installs, only deploy configs (symlinks)
./run --dry            # preview what would happen, no changes made
./run --dry rust       # dry run for a specific tool
DEV_ENV=~/dev ./run    # pass repo path explicitly (optional)
```

`DEV_ENV` is auto-detected from the script's location. You only need to set it if running from a different directory.

### `./dev-env` — Config deployer

Symlinks everything in `env/` to your home directory. Called automatically by `./run`, but can also run standalone.

```bash
./dev-env              # deploy all configs
./dev-env --dry        # preview what would be linked
```

What it does:
- `env/.config/nvim/` → symlinks to `~/.config/nvim/`
- `env/.config/tmux/` → symlinks to `~/.config/tmux/`
- `env/.zshrc` → symlinks to `~/.zshrc`
- ...and so on for every config in `env/`

**Idempotent** — running it again skips already-linked configs. Safe to re-run anytime.

### `./backup` — Backup to external SSD

Syncs project directories to timestamped backups on the external SSD (`/run/media/siam/TRANSCEND`). Two modes:

**Full backup** — creates a new timestamped directory, prunes old ones:
```bash
./backup                           # backup all sources (Personal)
./backup Personal                  # backup only Personal
./backup --dry                     # preview, no changes
./backup --keep 3                  # override retention (default: 2)
./backup --jobs 8                  # override parallel workers (default: 4)
```

**Subfolder update** — updates the latest existing backup in-place (no new snapshot, no pruning):
```bash
./backup Personal/dev              # update just dev/ inside latest backup
./backup Personal/portfolio        # update just portfolio/ inside latest
```

Optimized for the exFAT SSD:
- **Parallel rsync** — 4 concurrent workers with `ionice` I/O priority
- **exFAT flags** — `--no-perms --no-owner --no-group --no-links` (exFAT doesn't support these)
- **`--inplace`** — writes directly to files, skips temp file + rename (faster on exFAT)
- **`--whole-file`** — skips delta algorithm (pointless for local copies)
- **`--modify-window=1`** — handles exFAT 2-second timestamp granularity
- **Excludes** — `.git/`, `node_modules/`, `__pycache__/`, `.venv/`, `target/`, `dist/`, `build/`, `.cache/`, `wandb/`, `.uv-cache/`, etc.

Backups are automatically pruned — only the latest N are kept (default 2).

### `./restore` — Restore from external SSD

Restores project directories from the SSD back to `$HOME`. Safe merge — adds/overwrites but never removes local files (no `--delete`).

```bash
./restore                                      # list available backups with sizes
./restore Personal                             # restore all of Personal from latest
./restore Personal/dev                         # restore only dev/ subfolder
./restore --from 2026-02-15_14-30-00 Personal  # from a specific backup
./restore --dry Personal                       # preview, no changes
./restore --jobs 8 Personal                    # override parallel workers (default: 4)
```

Parallel restore with the same worker pool as backup. Requires typing `yes` to confirm (skipped in `--dry` mode).

### `./tui` — Interactive Terminal UI

Full interactive menu for all dev environment operations. Powered by [gum](https://github.com/charmbracelet/gum) — auto-installs if missing.

```bash
./tui
```

Features:
- **Install Tools** — select all or pick individual tools from `runs/`
- **Deploy Configs** — symlink configs with dry run preview
- **Backup** — full backup, selective project backup, subfolder update, dry run, configure
- **Restore** — restore from latest/specific backup, pick projects or subfolders, dry run
- **Status** — SSD info, backup list, system specs, git status

### `./make_runs_executable` — Helper

Makes all scripts in `runs/` executable. Run this after cloning if permissions are lost.

```bash
./make_runs_executable
```

## Saving Config Changes

Configs are **symlinked**, not copied. When you edit `~/.config/nvim/` (or any config), you're editing the repo directly.

```bash
# Edit your config normally
nvim ~/.config/nvim/lua/config/options.lua

# Changes are already in the repo — just commit
cd ~/dev
git add -A && git commit -m "update nvim config" && git push
```

No sync scripts needed. Symlinks keep everything in sync automatically.

## New Machine Setup

```bash
# 1. Clone the repo
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/dev

# 2. Run everything
cd ~/dev && ./run

# 3. Done — all tools installed, all configs linked
```

### Partial Setup

Don't want everything? Install only what you need:

```bash
cd ~/dev

# Install individual tools
./run neovim
./run bun
./run rust
./run tmux
./run zsh

# Deploy configs without installing tools
./run --env
```

## Adding a New Tool

1. Create a script in `runs/`:

```bash
# runs/mytool
#!/usr/bin/env bash
paru -S --noconfirm --needed mytool
```

2. Make it executable:

```bash
chmod +x runs/mytool
```

3. If it has configs, add them to `env/.config/mytool/`

4. Run it:

```bash
./run mytool
```

## Adding a New Config

1. Copy or create the config in `env/.config/`:

```bash
cp -r ~/.config/mytool ~/dev/env/.config/mytool
```

2. Deploy it:

```bash
./run --env
```

This replaces `~/.config/mytool/` with a symlink to the repo. Future edits go straight to the repo.

## Structure

```
dev/
├── run                    # Main orchestrator (installs + deploys)
├── dev-env                # Config deployer (symlinks env/ to ~/)
├── backup                 # Backup projects to external SSD
├── restore                # Restore projects from external SSD
├── tui                    # Interactive terminal UI (gum)
├── make_runs_executable   # chmod helper
│
├── runs/                  # Individual tool installers
│   ├── atuin              # Shell history manager
│   ├── bat                # Cat clone with syntax highlighting
│   ├── bun                # JavaScript/TypeScript runtime
│   ├── discord            # Communication
│   ├── expressvpn         # VPN client
│   ├── eza                # Modern ls replacement
│   ├── fnm                # Fast Node.js version manager
│   ├── gcalcli            # Google Calendar CLI
│   ├── gemini             # Google Gemini CLI
│   ├── ghostty            # Terminal emulator
│   ├── go                 # Go toolchain
│   ├── gum                # Glamorous shell scripts (TUI dependency)
│   ├── miniconda          # Python environment manager
│   ├── neovim             # Editor + clipboard + build deps
│   ├── node               # Node.js + npm
│   ├── nvidiaDriver       # NVIDIA GPU drivers + CUDA
│   ├── ollama             # Local LLM runner
│   ├── omarchy            # Shell framework
│   ├── python             # Python runtime
│   ├── rust               # Rust toolchain (rustup)
│   ├── starship           # Cross-shell prompt
│   ├── ticktick           # Task manager
│   ├── tldr               # Simplified man pages
│   ├── tmux               # Terminal multiplexer + TPM
│   ├── uv                 # Fast Python package manager
│   ├── xh                 # HTTP client (httpie alternative)
│   ├── yazi               # Terminal file manager
│   └── zsh                # Z shell + plugins
│
└── env/                   # Dotfiles (symlinked to ~/)
    ├── .config/
    │   ├── atuin/         # Shell history config
    │   ├── ghostty/       # Terminal config (tokyo-night, FiraCode)
    │   ├── mpv/           # Media player (shaders, scripts, UI)
    │   ├── nvim/          # Neovim (LazyVim, 80+ plugins, 18 LSPs)
    │   ├── starship.toml  # Prompt theme
    │   ├── tmux/          # Multiplexer (catppuccin, 10+ plugins)
    │   ├── wezterm/       # Alt terminal config
    │   └── yazi/          # File manager (catppuccin, plugins)
    ├── .local/
    │   └── scripts/       # Custom scripts (dev-env launcher)
    ├── .zshrc             # Shell config (aliases, integrations)
    ├── .profile           # Login shell PATH setup
    └── .xprofile          # X11/Wayland environment
```

## How It Works

**`./run`** finds all executable scripts in `runs/`, runs them alphabetically, then calls `dev-env` to deploy configs. Each installer is independent — one failing won't stop the rest. A colored summary shows what passed, failed, or was skipped.

**`./dev-env`** walks through `env/` and creates symlinks:
- Each directory in `env/.config/` gets symlinked to `~/.config/`
- Each file in `env/.local/scripts/` gets symlinked to `~/.local/scripts/`
- Home dotfiles (`.zshrc`, `.profile`, `.xprofile`) get symlinked to `~/`
- Reloads Hyprland if available

Symlinks mean changes flow both ways — edit configs in place, commit from the repo.

**`./backup`** syncs project directories to the Transcend exFAT SSD at `/run/media/siam/TRANSCEND/backups/`. Each full backup creates a timestamped directory (`2026-02-15_14-30-00/`). Subfolder backups (`Personal/dev`) update the latest existing backup in-place instead. Top-level items are synced in parallel (4 workers by default) with `ionice` for I/O priority. Old backups are pruned to keep only the latest 2 (configurable with `--keep`).

**`./restore`** syncs from the SSD back to `$HOME`. With no arguments, lists all available backups with sizes. Uses safe merge (no `--delete`) so local files that don't exist in the backup are preserved. Also parallelized for speed.

SSD layout:
```
/run/media/siam/TRANSCEND/
├── System Volume Information/    # NEVER TOUCHED
└── backups/
    ├── 2026-02-15_14-30-00/
    │   └── Personal/             # full snapshot
    └── 2026-02-15_18-00-00/
        └── Personal/             # full snapshot
```

## Flags Reference

| Flag | Description |
|------|-------------|
| `./run` | Install all tools + deploy configs |
| `./run <filter>` | Only run scripts matching the filter |
| `./run --env` | Deploy configs only, skip installs |
| `./run --dry` | Preview mode, no changes |
| `./run --dry <filter>` | Preview a specific tool |
| `./dev-env` | Deploy configs standalone |
| `./dev-env --dry` | Preview config deployment |
| `DEV_ENV=/path ./run` | Override repo path |
| `./backup` | Full backup of all sources to SSD |
| `./backup <target>` | Full backup of specific project |
| `./backup <target/sub>` | Update subfolder in latest backup (in-place) |
| `./backup --dry` | Preview backup |
| `./backup --keep N` | Override retention count (default: 2) |
| `./backup --jobs N` | Override parallel workers (default: 4) |
| `./restore` | List available backups with sizes |
| `./restore <target>` | Restore from latest backup |
| `./restore <target/sub>` | Restore specific subfolder |
| `./restore --from <ts> <target>` | Restore from specific backup |
| `./restore --dry <target>` | Preview restore |
| `./restore --jobs N <target>` | Override parallel workers (default: 4) |
| `./tui` | Interactive terminal UI (all features) |

## Requirements

- **OS:** Arch Linux (uses `paru`/`pacman`)
- **Dependencies:** `git`, `curl`, `bash`
- **Optional:** `paru` (AUR helper — most installers use it)
- **Optional:** `gum` (auto-installed by `./tui` if missing)
