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

Syncs project directories to timestamped backups on the external SSD (`/run/media/siam/TRANSCEND`). Optimized for exFAT with parallel rsync.

#### Two Modes

**Full backup** — creates a new timestamped snapshot, auto-prunes old ones:
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

The mode is auto-detected: if the target contains a `/` (e.g. `Personal/dev`), it runs in subfolder mode. Otherwise it creates a new full snapshot.

#### Performance

- **Parallel rsync** — 4 concurrent workers (configurable with `--jobs`), each top-level directory/file gets its own rsync process
- **`ionice -c 2 -n 0`** — best-effort I/O scheduling priority for maximum throughput
- **`--whole-file`** — skips rsync delta algorithm (pointless for local disk-to-disk copies)
- **`--inplace`** — writes directly to destination files, skips temp file + rename (faster on exFAT, avoids fragmentation)
- **Typical speed** — ~32GB in ~42s (~760 MB/s)

#### exFAT Optimization

The SSD uses exFAT which doesn't support Unix metadata. All rsync flags are tuned for this:

| Flag | Why |
|------|-----|
| `-r --times` | Recursive with modification times |
| `--modify-window=1` | exFAT has 2-second timestamp granularity |
| `--no-links` | exFAT can't store symlinks |
| `--no-perms` | exFAT ignores Unix permissions |
| `--no-owner` | exFAT ignores file ownership |
| `--no-group` | exFAT ignores group ownership |
| `--omit-dir-times` | exFAT directory timestamps are unreliable |
| `--whole-file` | Skip delta algorithm (local copy) |
| `--inplace` | Write directly, no temp files |

#### Excludes

These directories/files are automatically excluded from backups:

`.git/`, `node_modules/`, `__pycache__/`, `.venv/`, `venv/`, `.conda/`, `*.pyc`, `target/`, `dist/`, `build/`, `.cache/`, `.next/`, `.nuxt/`, `.ror/`, `.playwright-mcp/`, `.DS_Store`, `Thumbs.db`, `wandb/`, `.uv-cache/`, `.plugin_symlinks/`

#### Auto-Pruning

After each full backup, old snapshots are automatically deleted to keep only the latest N (default 2). Subfolder updates never trigger pruning. Override with `--keep`:

```bash
./backup --keep 5                  # keep 5 most recent backups
./backup --keep 1                  # keep only the latest
```

#### Safety

- SSD mount is verified before any operation
- `System Volume Information/` is never touched (backups write only inside `backups/`)
- Dry run mode (`--dry`) previews changes without writing anything
- Summary shows elapsed time, backup size, remaining backups, and free space

### `./restore` — Restore from external SSD

Restores project directories from the SSD back to `$HOME`. Safe merge — adds/overwrites but never removes local files (no `--delete`).

#### List Available Backups

```bash
./restore                          # shows all backups with sizes and contents
```

Output:
```
[restore] available backups on SSD:

  2026-02-15_14-30-00  32G  [Personal]
  2026-02-15_18-00-00  32G  [Personal]

[restore] usage: ./restore <target>  (e.g. ./restore Personal)
```

#### Restore from Latest

```bash
./restore Personal                 # restore all of Personal from latest backup
./restore Personal/dev             # restore only the dev/ subfolder
```

#### Restore from Specific Backup

```bash
./restore --from 2026-02-15_14-30-00 Personal       # specific timestamp
./restore --from 2026-02-15_14-30-00 Personal/dev    # specific subfolder from specific backup
```

#### Preview and Configure

```bash
./restore --dry Personal           # preview what would change, no writes
./restore --jobs 8 Personal        # override parallel workers (default: 4)
```

#### Safety

- **Safe merge** — no `--delete` flag, so local files not in the backup are preserved
- **Confirmation required** — must type `yes` before any restore (skipped in `--dry` mode)
- **Parallel restore** — same worker pool as backup with `ionice` for I/O priority
- **Error reporting** — non-fatal sync errors are reported but don't abort the restore

### `./ssh-backup` / `./ssh-restore` — SSH Key Management

Encrypts SSH keys with [age](https://github.com/FiloSottile/age) and stores them on the SSD. Private keys are never stored in plaintext on the exFAT drive.

**Backup SSH keys:**
```bash
./ssh-backup                       # encrypt ~/.ssh/ → save to SSD
./ssh-backup --dry                 # preview what would be backed up
./ssh-backup --list                # list existing SSH backups on SSD
```

**Restore SSH keys:**
```bash
./ssh-restore                      # restore from latest backup
./ssh-restore --list               # list available backups
./ssh-restore --from <filename>    # restore specific backup
./ssh-restore --dry                # preview without restoring
```

**How it works:**
1. `ssh-backup` tars `~/.ssh/` and encrypts it with `age -p` (passphrase-based)
2. The encrypted `.tar.age` file is saved to `$SSD/ssh-keys/` with hostname + timestamp
3. `ssh-restore` decrypts the archive and restores files to `~/.ssh/`
4. Permissions are automatically fixed (600 for private keys, 644 for public, 700 for dir)
5. Existing `~/.ssh/` is backed up to `~/.ssh.bak.*` before overwriting

**New machine workflow:**
```bash
# 1. Plug in SSD, clone repo
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev

# 2. Restore SSH keys (age auto-installs if missing)
cd ~/Personal/dev && ./ssh-restore

# 3. Now git, GitHub, and all servers work immediately
ssh -T git@github.com
```

**Security:**
- Uses age encryption (X25519 + ChaCha20-Poly1305 + scrypt for passphrase)
- Private keys are never stored unencrypted on the exFAT SSD
- age auto-installs if missing (paru/pacman)
- Passphrase is the only way to decrypt — choose a strong one

### `./tui` — Interactive Terminal UI

Full interactive menu for all dev environment operations. Powered by [gum](https://github.com/charmbracelet/gum) — auto-installs if missing.

```bash
./tui
```

Features:
- **Install Tools** — install all, install missing only, select individual tools with installed status and versions, dry run preview
- **Deploy Configs** — deploy all, deploy unlinked only, select individual configs with symlink status (linked/not linked/conflict), view status panel
- **Backup** — full backup, selective project backup, subfolder update, dry run, configure retention and workers
- **Restore** — restore from latest/specific backup, pick projects or subfolders, dry run preview
- **SSH Keys** — backup/restore SSH keys with age encryption, list backups, view local keys
- **Status** — SSD info, backup list with sizes, system specs (CPU, rsync, gum), git status

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
├── ssh-backup             # Encrypt SSH keys to SSD (age)
├── ssh-restore            # Decrypt SSH keys from SSD (age)
├── tui                    # Interactive terminal UI (gum)
├── make_runs_executable   # chmod helper
│
├── runs/                  # Individual tool installers
│   ├── age                # Modern encryption tool (SSH key backup)
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
- Each standalone file in `env/.config/` (e.g. `starship.toml`) gets symlinked too
- Each file in `env/.local/scripts/` gets symlinked to `~/.local/scripts/`
- Home dotfiles are auto-detected from `env/` (any dotfile like `.zshrc`, `.profile`, `.xprofile`)
- Already-linked configs are detected and skipped (idempotent)
- Existing non-symlinked configs are backed up to `~/.config-backup/` before replacing
- Reloads Hyprland if available

Symlinks mean changes flow both ways — edit configs in place, commit from the repo.

**`./backup`** syncs project directories to the Transcend exFAT SSD at `/run/media/siam/TRANSCEND/backups/`. Two modes:
- **Full backup**: creates a timestamped directory (`2026-02-15_14-30-00/`), prunes old ones past retention limit
- **Subfolder update**: detects `/` in target (e.g. `Personal/dev`), updates the latest existing backup in-place without creating a new snapshot or pruning

Top-level items are synced in parallel (4 workers by default) with `ionice -c 2 -n 0` for I/O priority. All rsync flags are tuned for exFAT: no perms, no symlinks, no dir timestamps, inplace writes, whole-file transfers.

**`./restore`** syncs from the SSD back to `$HOME`. With no arguments, lists all available backups with sizes and contents. Uses safe merge (no `--delete`) so local files that don't exist in the backup are preserved. Requires typing `yes` to confirm. Also parallelized with the same worker pool.

**`./tui`** provides an interactive gum-based interface for everything. Auto-installs gum if missing. Shows real-time status: which tools are installed (with versions), which configs are linked (with conflict detection), SSD info, and backup inventory.

**SSD layout:**
```
/run/media/siam/TRANSCEND/
├── System Volume Information/    # NEVER TOUCHED
├── backups/
│   ├── 2026-02-15_14-30-00/
│   │   └── Personal/             # full snapshot
│   └── 2026-02-15_18-00-00/
│       └── Personal/             # full snapshot
└── ssh-keys/
    └── ssh-keys_hostname_2026-02-15_14-30-00.tar.age  # age-encrypted
```

**Expanding the system:**
- Add a tool: create `runs/mytool` (auto-detected by TUI and `./run`)
- Add a config: create `env/.config/mytool/` (auto-detected by TUI and `./dev-env`)
- Add a dotfile: create `env/.mydotfile` (auto-detected by TUI and `./dev-env`)
- No code changes needed — everything is discovered dynamically

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
| `./ssh-backup` | Encrypt SSH keys to SSD |
| `./ssh-backup --dry` | Preview SSH backup |
| `./ssh-backup --list` | List SSH backups on SSD |
| `./ssh-restore` | Restore SSH keys from latest backup |
| `./ssh-restore --list` | List available SSH backups |
| `./ssh-restore --from <file>` | Restore specific SSH backup |
| `./ssh-restore --dry` | Preview SSH restore |
| `./tui` | Interactive terminal UI (all features) |

## Requirements

- **OS:** Arch Linux (uses `paru`/`pacman`)
- **Dependencies:** `git`, `curl`, `bash`
- **Optional:** `paru` (AUR helper — most installers use it)
- **Optional:** `gum` (auto-installed by `./tui` if missing)
