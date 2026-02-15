# Dev Environment

Automated dev environment setup for Arch Linux. Install tools + deploy dotfiles.

## Quick Start

```bash
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev
cd ~/Personal/dev
./tui
```

On first run, the wizard prompts for your SSD path, projects directory, and source folders. Then use the menu to install tools and deploy configs.

Or run everything non-interactively:

```bash
./run                  # install everything + deploy configs
```

## Usage

### `./run` — Main entry point

Installs all tools from `runs/` then deploys configs via `dev-env`.

```bash
./run                  # install everything + deploy configs
./run rust             # install only scripts matching "rust"
./run bun              # install only scripts matching "bun"
./run node             # install only scripts matching "node"
./run --env            # skip installs, only deploy configs
./run --dry            # preview what would happen, no changes made
./run --dry rust       # dry run for a specific tool
DEV_ENV=~/Personal/dev ./run    # pass repo path explicitly (optional)
```

`DEV_ENV` is auto-detected from the script's location. You only need to set it if running from a different directory.

### `./dev-env` — Config deployer

Copies everything in `env/` to your home directory. Called automatically by `./run`, but can also run standalone.

```bash
./dev-env              # deploy all configs
./dev-env --dry        # preview what would be deployed
```

What it does:
- `env/.config/nvim/` → copies to `~/.config/nvim/`
- `env/.config/tmux/` → copies to `~/.config/tmux/`
- `env/.zshrc` → copies to `~/.zshrc`
- ...and so on for every config in `env/`

**Idempotent** — safe to re-run anytime. Existing configs are backed up to `~/.config-backup/` before replacing.

After the first deploy, `DEV_ENV_PATH` is saved to config so `dev-env` works from any directory.

#### Capturing config changes

Since configs are copies (not symlinks), edits to your live configs (e.g. `~/.config/nvim/`) are **not** automatically reflected in the repo. To sync changes back:

```bash
# Capture a single config into the repo
./dev-env capture ~/.config/nvim

# Re-capture all tracked configs from the live system
./dev-env update

# Preview what would be captured
./dev-env update --dry
```

Or edit configs directly in the repo and redeploy:

```bash
# Edit in repo, then push to system
nvim ~/Personal/dev/env/.config/nvim/lua/config/options.lua
./dev-env deploy
```

### `./backup` — Backup to external SSD

Syncs project directories to timestamped backups on the external SSD (configurable, default `/run/media/$USER/TRANSCEND`). Optimized for exFAT with parallel rsync.

#### Two Modes

**Full backup** — creates a new timestamped snapshot, auto-prunes old ones:
```bash
./backup                           # backup all sources
./backup Personal                  # backup only Personal
./backup --dry                     # preview, no changes
./backup --keep 3                  # override retention (default: 2)
./backup --jobs 8                  # override parallel workers (default: 4)
./backup --ssd /run/media/$USER/OTHER  # override SSD path
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
./restore --ssd /run/media/$USER/OTHER Personal  # override SSD path
```

#### Safety

- **Safe merge** — no `--delete` flag, so local files not in the backup are preserved
- **Confirmation required** — must type `yes` before any restore (skipped in `--dry` mode)
- **Parallel restore** — same worker pool as backup with `ionice` for I/O priority
- **Error reporting** — non-fatal sync errors are reported but don't abort the restore

### `./secrets` — Secrets Manager (SSH Keys + .env Files)

Unified secrets management with two backends: **age** (encrypted to SSD, offline) and **Bitwarden** (cloud vault, synced across devices).

#### SSH Keys

**age (SSD)** — encrypt SSH keys with a passphrase, store on external SSD:
```bash
./secrets ssh backup               # encrypt ~/.ssh/ → SSD
./secrets ssh restore              # decrypt ~/.ssh/ ← SSD
./secrets ssh backup --dry         # preview
```

**Bitwarden (cloud)** — store SSH keys as secure notes in your vault:
```bash
./secrets ssh backup --bw          # store SSH key → Bitwarden vault
./secrets ssh restore --bw         # retrieve SSH key ← Bitwarden vault
./secrets ssh backup --bw --dry    # preview
```

**List local keys:**
```bash
./secrets ssh list                 # list SSH keys in ~/.ssh/
```

**Deploy key to a remote server** (passwordless SSH):
```bash
./secrets ssh copy-id user@server                    # copy default key to server
./secrets ssh copy-id user@server id_ed25519.pub     # specify which key
./secrets ssh copy-id user@server --dry              # preview
```

Copies your public key to the server's `~/.ssh/authorized_keys`. You type your password once, then future connections are key-based. Also available interactively via `./tui` → Secrets → SSH Keys → Setup SSH on Remote Server.

#### .env Files

Automatically discovers `.env`, `.env.local`, `.env.production`, `.env.development` files across all projects (up to 4 levels deep), excluding `node_modules`, `.git`, `__pycache__`, `.venv`, `.conda`.

**All projects:**
```bash
./secrets env backup               # encrypt all .env files → SSD
./secrets env backup --bw          # store all .env files → Bitwarden
./secrets env restore              # decrypt all .env files ← SSD
./secrets env restore --bw         # retrieve all .env files ← Bitwarden
./secrets env list                 # list all .env files
```

**Per-project:**
```bash
./secrets env backup betascript           # only betascript's .env files → SSD
./secrets env backup betascript --bw      # only betascript's .env files → Bitwarden
./secrets env restore betascript          # restore only betascript ← SSD
./secrets env restore betascript --bw     # restore only betascript ← Bitwarden
./secrets env list betascript             # list only betascript's .env files
```

**Cross-project restore:**
```bash
./secrets env restore betascript --to DWDM-paper       # copy betascript's .env → DWDM-paper/ (SSD)
./secrets env restore betascript --to DWDM-paper --bw  # copy betascript's .env → DWDM-paper/ (Bitwarden)
```

**Preview:**
```bash
./secrets env backup --dry                # preview all-project backup
./secrets env backup betascript --dry     # preview per-project backup
./secrets env restore betascript --to DWDM-paper --dry  # preview cross-project
```

#### Aliases

Manage project aliases for `.env` operations:

```bash
./secrets alias list                      # show all aliases
./secrets alias set betascript bs         # set alias "bs" → betascript
./secrets alias remove betascript         # remove alias
```

#### SSD Override

All secrets commands accept `--ssd <path>` to override the SSD location:

```bash
./secrets ssh backup --ssd /mnt/usb
./secrets env restore --ssd /mnt/usb
```

#### List All Secrets

```bash
./secrets --list                   # show all secrets on SSD + Bitwarden status
```

#### How It Works

**age backend:**
1. SSH: tars `~/.ssh/` and encrypts with `age -p` (passphrase-based), saves to `$SSD/ssh-keys/`
2. Env: tars all `.env` files preserving relative paths, encrypts with age, saves to `$SSD/env-secrets/`
3. Restore decrypts and extracts back to original locations
4. SSH permissions auto-fixed (600 private, 644 public, 700 dir)
5. Existing `~/.ssh/` backed up to `~/.ssh.bak.*` before overwriting

**Bitwarden backend:**
1. SSH: stores private key in secure note's `.notes` field, public key as custom field
2. Env: each `.env` file stored as its own secure note (named `env - <relpath>`)
3. Updates existing items instead of creating duplicates
4. Requires `bw login` first, then auto-unlocks vault as needed
5. Free tier compatible (no attachments needed)

#### New Machine Workflow

```bash
# Option A: Restore from SSD (offline)
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev
cd ~/Personal/dev
./secrets ssh restore              # decrypt SSH keys from SSD
./secrets env restore              # decrypt .env files from SSD

# Option B: Restore from Bitwarden (cloud, no SSD needed)
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev
cd ~/Personal/dev
bw login                           # one-time Bitwarden login
./secrets ssh restore --bw         # pull SSH keys from vault
./secrets env restore --bw         # pull .env files from vault

# Either way, everything works immediately
ssh -T git@github.com
```

#### Security

- **age**: X25519 + ChaCha20-Poly1305 + scrypt for passphrase. Private keys never stored unencrypted on exFAT.
- **Bitwarden**: zero-knowledge E2EE vault. SSH keys stored as secure notes (encrypted at rest + in transit).
- Both `age` and `bitwarden-cli` auto-install if missing.
- Passphrase (age) or master password (Bitwarden) is the only way to decrypt.

### `./tui` — Interactive Terminal UI

Full interactive menu for all dev environment operations. Powered by [gum](https://github.com/charmbracelet/gum) — auto-installs if missing.

```bash
./tui
```

On first run, a **setup wizard** prompts for SSD path, projects directory, and source folders. These are saved to `~/.config/dev-env/config` and can be changed later via Settings.

Features:
- **Install Tools** — install all, install missing only, select individual tools with installed status and versions, dry run preview
- **Deploy Configs** — deploy all, deploy missing only, select individual configs with deploy status (deployed/not deployed/missing), capture a config, update all tracked configs, view status panel
- **Backup** — full backup, selective project backup, subfolder update, dry run, configure retention and workers
- **Restore** — restore from latest/specific backup, pick projects or subfolders, dry run preview
- **Secrets** — SSH keys and .env files with two backends (age SSD + Bitwarden cloud), list all secrets, view local SSH keys, alias management
- **Status** — SSD info, backup list with sizes, secrets overview, Bitwarden status, system specs, git status
- **Settings** — change SSD path, projects directory, source folders, edit config file, reset to defaults

### `./make_runs_executable` — Helper

Makes all scripts in `runs/` executable. Run this after cloning if permissions are lost.

```bash
./make_runs_executable
```

## Saving Config Changes

Configs are **copied**, not symlinked. Edits to your live configs (e.g. `~/.config/nvim/`) are local to your system and don't automatically appear in the repo.

To sync changes back to the repo:

```bash
# Option 1: Capture a single config
./dev-env capture ~/.config/nvim

# Option 2: Re-capture all tracked configs
./dev-env update

# Then commit
cd ~/Personal/dev
git add -A && git commit -m "update nvim config" && git push
```

To push repo changes to your system:

```bash
# Edit in repo, then deploy
./dev-env deploy
```

## New Machine Setup

```bash
# 1. Clone the repo
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev

# 2. Run the TUI — first-run wizard configures SSD path, projects dir, sources
cd ~/Personal/dev && ./tui

# 3. Install tools + deploy configs (via TUI menu or non-interactively)
./run

# 4. Open a new shell — tools auto-initialize via shell-init.sh
# (Cargo, Go, Bun, fnm, Atuin, Starship, Zoxide, Conda, FZF, uv, CUDA)

# 5. Unlock Bitwarden from terminal (if using Bitwarden backend)
bwu
```

### Partial Setup

Don't want everything? Install only what you need:

```bash
cd ~/Personal/dev

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
yay -S --noconfirm --needed mytool
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
cp -r ~/.config/mytool ~/Personal/dev/env/.config/mytool
```

2. Deploy it:

```bash
./run --env
```

This copies `env/.config/mytool/` to `~/.config/mytool/`. To sync future changes, use `dev-env capture` or `dev-env update`.

## Structure

```
dev/
├── run                    # Main orchestrator (installs + deploys)
├── dev-env                # Config deployer (copies env/ to ~/)
├── backup                 # Backup projects to external SSD
├── restore                # Restore projects from external SSD
├── secrets                # Secrets manager (SSH keys + .env files, age + Bitwarden)
├── tui                    # Interactive terminal UI (gum)
├── make_runs_executable   # chmod helper
│
├── lib/
│   └── config.sh          # Shared config loader (SSD path, projects dir, sources)
│
├── runs/                  # Individual tool installers
│   ├── age                # Modern encryption tool (secrets backup)
│   ├── atuin              # Shell history manager
│   ├── bitwarden-cli      # Bitwarden CLI + jq (secrets backup)
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
└── env/                   # Dotfiles (deployed to ~/)
    ├── .config/
    │   ├── atuin/         # Shell history config
    │   ├── dev-env/       # Dev environment runtime
    │   │   ├── shell-init.sh       # Shared tool init (bash+zsh)
    │   │   └── shell-functions.sh  # Shell functions (bwu, etc.)
    │   ├── ghostty/       # Terminal config (tokyo-night, FiraCode)
    │   ├── mpv/           # Media player (shaders, scripts, UI)
    │   ├── nvim/          # Neovim (LazyVim, 80+ plugins, 18 LSPs)
    │   ├── starship.toml  # Prompt theme
    │   ├── tmux/          # Multiplexer (catppuccin, 10+ plugins)
    │   ├── wezterm/       # Alt terminal config
    │   └── yazi/          # File manager (catppuccin, plugins)
    ├── .local/
    │   └── scripts/       # Custom scripts (dev-env launcher)
    ├── .bashrc            # Bash config (aliases, integrations)
    ├── .zshrc             # Zsh config (aliases, integrations)
    ├── .profile           # Login shell PATH setup
    └── .xprofile          # X11/Wayland environment
```

## How It Works

**`./run`** finds all executable scripts in `runs/`, runs them alphabetically, then calls `dev-env` to deploy configs. Each installer is independent — one failing won't stop the rest. A colored summary shows what passed, failed, or was skipped.

**`./dev-env`** walks through `env/` and copies configs to the system:
- Each directory in `env/.config/` gets copied to `~/.config/`
- Each standalone file in `env/.config/` (e.g. `starship.toml`) gets copied too
- Each file in `env/.local/scripts/` gets copied to `~/.local/scripts/`
- Home dotfiles are auto-detected from `env/` (any dotfile like `.zshrc`, `.profile`, `.xprofile`)
- Existing non-repo configs are backed up to `~/.config-backup/` before replacing
- Also installs itself to `~/.local/scripts/dev-env` so it works from anywhere
- Reloads Hyprland if available

Since configs are copies, changes flow one direction at a time — use `dev-env capture` or `dev-env update` to pull live changes into the repo, and `dev-env deploy` to push repo changes to the system.

**`./backup`** syncs project directories to the external SSD at `$SSD_PATH/backups/` (configurable via settings or `--ssd`). Two modes:
- **Full backup**: creates a timestamped directory (`2026-02-15_14-30-00/`), prunes old ones past retention limit
- **Subfolder update**: detects `/` in target (e.g. `Personal/dev`), updates the latest existing backup in-place without creating a new snapshot or pruning

Top-level items are synced in parallel (4 workers by default) with `ionice -c 2 -n 0` for I/O priority. All rsync flags are tuned for exFAT: no perms, no symlinks, no dir timestamps, inplace writes, whole-file transfers.

**`./restore`** syncs from the SSD back to `$HOME`. With no arguments, lists all available backups with sizes and contents. Uses safe merge (no `--delete`) so local files that don't exist in the backup are preserved. Requires typing `yes` to confirm. Also parallelized with the same worker pool.

**`./secrets`** manages SSH keys and `.env` files with two backends. The **age backend** encrypts to the SSD (offline, passphrase-based). The **Bitwarden backend** stores in your vault (cloud, synced across devices). SSH keys are stored as secure notes with private key in `.notes` and public key as a custom field. `.env` files are each stored as individual secure notes. Both backends auto-install their dependencies if missing.

**`./tui`** provides an interactive gum-based interface for everything. Auto-installs gum if missing. On first run, a wizard configures SSD path, projects directory, and sources. Shows real-time status: which tools are installed (with versions), which configs are deployed (with conflict detection), SSD info, secrets overview, and Bitwarden status. Settings menu allows changing all configuration at any time.

**`shell-init.sh`** is sourced by `.zshrc` (and can be sourced by `.bashrc`) to initialize all dev tools in any shell: Cargo, Go, Bun, fnm, Atuin, Starship, Zoxide, Conda, FZF, uv, and CUDA.

**`bwu`** is a shell function (from `shell-functions.sh`) that unlocks Bitwarden and exports `BW_SESSION`. Handles login, unlock, and sync in one command.

**SSD layout** (path configurable, default `/run/media/$USER/TRANSCEND`):
```
$SSD_PATH/
├── System Volume Information/    # NEVER TOUCHED
├── backups/
│   ├── 2026-02-15_14-30-00/
│   │   └── Personal/             # full snapshot
│   └── 2026-02-15_18-00-00/
│       └── Personal/             # full snapshot
├── ssh-keys/
│   └── ssh-keys_hostname_2026-02-15_14-30-00.tar.age  # age-encrypted SSH keys
└── env-secrets/
    ├── env-secrets_2026-02-15_14-30-00.tar.age         # all-projects archive
    └── env-secrets_betascript_2026-02-15_14-30-00.tar.age  # per-project archive
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
| `./dev-env capture <path>` | Capture a live config into the repo |
| `./dev-env update` | Re-capture all tracked configs from live system |
| `./dev-env update --dry` | Preview what update would capture |
| `DEV_ENV=/path ./run` | Override repo path |
| `./backup` | Full backup of all sources to SSD |
| `./backup <target>` | Full backup of specific project |
| `./backup <target/sub>` | Update subfolder in latest backup (in-place) |
| `./backup --dry` | Preview backup |
| `./backup --keep N` | Override retention count (default: 2) |
| `./backup --jobs N` | Override parallel workers (default: 4) |
| `./backup --ssd <path>` | Override SSD location |
| `./restore` | List available backups with sizes |
| `./restore <target>` | Restore from latest backup |
| `./restore <target/sub>` | Restore specific subfolder |
| `./restore --from <ts> <target>` | Restore from specific backup |
| `./restore --dry <target>` | Preview restore |
| `./restore --jobs N <target>` | Override parallel workers (default: 4) |
| `./restore --ssd <path>` | Override SSD location |
| `./secrets ssh backup` | Encrypt SSH keys → SSD (age) |
| `./secrets ssh backup --bw` | Store SSH keys → Bitwarden |
| `./secrets ssh restore` | Decrypt SSH keys ← SSD (age) |
| `./secrets ssh restore --bw` | Retrieve SSH keys ← Bitwarden |
| `./secrets ssh list` | List local SSH keys |
| `./secrets ssh copy-id <user@host>` | Copy public key to remote server |
| `./secrets env backup` | Encrypt all .env files → SSD (age) |
| `./secrets env backup --bw` | Store all .env files → Bitwarden |
| `./secrets env backup <project>` | Encrypt project's .env files → SSD |
| `./secrets env backup <project> --bw` | Store project's .env files → Bitwarden |
| `./secrets env restore` | Decrypt all .env files ← SSD (age) |
| `./secrets env restore --bw` | Retrieve all .env files ← Bitwarden |
| `./secrets env restore <project>` | Decrypt project's .env files ← SSD |
| `./secrets env restore <project> --bw` | Retrieve project's .env files ← Bitwarden |
| `./secrets env restore <src> --to <dest>` | Cross-project .env copy (SSD) |
| `./secrets env restore <src> --to <dest> --bw` | Cross-project .env copy (Bitwarden) |
| `./secrets env list` | List all .env files in projects |
| `./secrets env list <project>` | List project's .env files |
| `./secrets alias list` | List all project aliases |
| `./secrets alias set <project> <name>` | Set alias for a project |
| `./secrets alias remove <project>` | Remove project alias |
| `./secrets --list` | List all secrets on SSD/Bitwarden |
| `./secrets --ssd <path>` | Override SSD location |
| `./secrets --dry <command>` | Preview any secrets operation |
| `./tui` | Interactive terminal UI (all features) |

## Requirements

- **OS:** Arch Linux / Omarchy (uses `yay`/`pacman`)
- **Dependencies:** `git`, `curl`, `bash`
- **Required:** `yay` (AUR helper — pre-installed on Omarchy)
- **Optional:** `gum` (auto-installed by `./tui` if missing)
- **Optional:** `age` (auto-installed by `./secrets` if missing)
- **Optional:** `bitwarden-cli` + `jq` (auto-installed by `./secrets --bw` if missing)
