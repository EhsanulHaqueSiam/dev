# Dev Environment

Automated dev environment setup for Arch Linux. One command installs 30 tools, deploys all your dotfiles, backs up projects to an external SSD, and manages secrets with encryption.

## Getting Started

### Fresh machine (nothing installed yet)

```bash
curl -fsSL https://raw.githubusercontent.com/EhsanulHaqueSiam/dev/main/bootstrap | bash
```

This installs git, clones the repo, runs all installers, deploys configs, and optionally restores your secrets from SSD. Everything from zero to working in one command.

### Already have git

```bash
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/Personal/dev
cd ~/Personal/dev
./run
```

### Just want the interactive menu

```bash
cd ~/Personal/dev
./tui
```

First run shows a setup wizard for your SSD path and projects directory. After that, everything is available from the menu.

---

## Day-to-Day Commands

These are the commands you'll use most often. Every command supports `--dry` to preview without making changes and `--help` for detailed usage.

After the first `./dev-env deploy`, add this one line to your `.bashrc` or `.zshrc` to enable the `dev` command with tab completion:

```bash
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh"
```

Then open a new shell:

```bash
dev run                    # install everything + deploy configs
dev env compare            # side-by-side diff of repo vs live configs
dev backup --dry           # preview backup
dev secrets ssh backup     # encrypt SSH keys to SSD
dev restore Personal       # restore from latest backup
dev help                   # show all commands
```

Tab completion works for all subcommands: `dev <TAB>`, `dev secrets <TAB>`, `dev secrets ssh <TAB>`.

> **Note:** If you deploy the repo's `.bashrc`/`.zshrc` (via `./dev-env`), this line is already included. The one-liner is for people who keep their own shell config.

You can also run scripts directly from the repo:

### Install tools

```bash
./run                  # install everything + deploy configs
./run rust             # install just one tool
./run --env            # deploy configs only, skip installs
```

### Deploy your configs

```bash
./dev-env              # copy repo configs → system
./dev-env compare      # side-by-side diff of repo vs live configs
./dev-env diff         # show which configs have drifted
./dev-env doctor       # diagnose broken symlinks, permissions, drift
```

### Save config changes back to the repo

Configs are **copies**, not symlinks. After editing a live config (e.g. `~/.config/nvim/`), pull it back:

```bash
./dev-env capture ~/.config/nvim    # capture one config
./dev-env update                    # re-capture all tracked configs
./dev-env update ghostty            # re-capture only ghostty
./dev-env update --commit           # re-capture + auto-commit
```

### Backup projects to SSD

```bash
./backup                           # full snapshot of all sources
./backup Personal/dev              # update just one subfolder in latest backup
./backup --sync                    # incremental sync (no new snapshot)
```

### Restore projects from SSD

```bash
./restore                          # list available backups
./restore Personal                 # restore from latest
./restore --from 2026-02-15 Personal   # restore from specific backup
```

### Manage secrets

```bash
./secrets ssh backup               # encrypt SSH keys → SSD
./secrets ssh restore              # decrypt SSH keys ← SSD
./secrets env backup               # encrypt .env files → SSD
./secrets env restore              # decrypt .env files ← SSD
./secrets --health                 # health check dashboard
```

Add `--bw` to any command to use Bitwarden instead of SSD:

```bash
./secrets ssh backup --bw          # store SSH keys → Bitwarden vault
./secrets env restore --bw         # pull .env files ← Bitwarden vault
```

---

## Scripts Reference

### `./bootstrap` -- Fresh machine setup

Installs git, clones this repo, runs `./run`, and prompts to restore secrets. Designed to be piped from curl on a brand-new machine.

### `./run` -- Install tools + deploy configs

Finds all scripts in `runs/`, runs them alphabetically, then deploys configs. Each installer is independent -- one failing won't stop the rest.

```bash
./run                  # install everything
./run rust             # install only rust
./run --env            # configs only, skip installs
./run --dry            # preview mode
```

### `./dev-env` -- Config manager

Copies everything in `env/` to your home directory. Existing configs are backed up to `~/.config-backup/` before replacing.

| Command | What it does |
|---------|-------------|
| `./dev-env` | Deploy all configs from repo to system |
| `./dev-env capture <path>` | Pull a live config into the repo |
| `./dev-env update` | Re-capture all tracked configs from system |
| `./dev-env update <name>` | Re-capture only configs matching name |
| `./dev-env update --commit` | Re-capture + git commit |
| `./dev-env diff` | Show modified configs (repo vs live) |
| `./dev-env compare` | Side-by-side diff (uses delta if installed) |
| `./dev-env doctor` | Diagnose issues: broken symlinks, bad SSH permissions, missing deps, config drift, stale backups |

How configs map:

```
env/.config/nvim/  -->  ~/.config/nvim/
env/.config/tmux/  -->  ~/.config/tmux/
env/.zshrc         -->  ~/.zshrc
env/.bashrc        -->  ~/.bashrc
```

### `./backup` -- Backup to external SSD

Parallel rsync optimized for exFAT. Two modes, auto-detected:

- **Full snapshot**: `./backup` or `./backup Personal` -- creates timestamped directory, auto-prunes old ones
- **Subfolder update**: `./backup Personal/dev` -- updates latest backup in-place (no new snapshot)

```bash
./backup                           # full backup
./backup --sync                    # incremental sync
./backup --verify                  # verify latest backup integrity
./backup --keep 5                  # keep 5 snapshots (default: 2)
./backup --jobs 8                  # parallel workers (default: 4)
./backup --ssd /mnt/other          # override SSD path
./backup --dry                     # preview
```

### `./restore` -- Restore from SSD

Safe merge -- overwrites matching files but never deletes local files not in the backup.

```bash
./restore                          # list all backups
./restore Personal                 # restore from latest
./restore Personal/dev             # restore one subfolder
./restore --from <timestamp> Personal  # specific backup
./restore --pick                   # interactively pick files
./restore --dry Personal           # preview
```

### `./secrets` -- Secrets manager

Two backends: **age** (encrypted to SSD, offline) and **Bitwarden** (cloud vault). Manages SSH keys, .env files, and Claude Code config.

#### SSH keys

```bash
./secrets ssh backup               # encrypt → SSD
./secrets ssh backup --bw          # store → Bitwarden
./secrets ssh restore              # decrypt ← SSD
./secrets ssh restore --bw         # retrieve ← Bitwarden
./secrets ssh list                 # show local keys
./secrets ssh copy-id user@server  # deploy key to remote
```

#### .env files

Auto-discovers `.env`, `.env.local`, `.env.production`, `.env.development` across all projects.

```bash
./secrets env backup               # all projects → SSD
./secrets env backup myproject     # one project → SSD
./secrets env restore              # all projects ← SSD
./secrets env restore myproject    # one project ← SSD
./secrets env list                 # list all .env files
./secrets env restore src --to dest    # cross-project copy
```

#### Claude Code config

Backs up `.claude.json`, `.claude/settings.json`, and `.claude/CLAUDE.md` (MCP servers, plugins, API keys).

```bash
./secrets claude backup            # encrypt → SSD
./secrets claude backup --bw       # store → Bitwarden
./secrets claude restore           # decrypt ← SSD
./secrets claude restore --bw      # retrieve ← Bitwarden
./secrets claude list              # show config files
```

#### Migrate between backends

```bash
./secrets migrate all age-to-bw    # copy everything SSD → Bitwarden
./secrets migrate all bw-to-age    # copy everything Bitwarden → SSD
./secrets migrate ssh age-to-bw    # just SSH keys
./secrets migrate env bw-to-age    # just env files
```

#### Dashboards

```bash
./secrets --health                 # health check (backup ages, missing keys, etc.)
./secrets --diff                   # what changed since last backup
./secrets --list                   # list everything on SSD + Bitwarden
```

#### Aliases

Give projects short names for env commands:

```bash
./secrets alias set my-long-project-name proj   # set alias
./secrets alias list                             # view all
./secrets alias remove my-long-project-name      # remove
```

### `./tui` -- Interactive terminal UI

Full menu-driven interface for everything above. Powered by [gum](https://github.com/charmbracelet/gum) (auto-installs if missing).

```bash
./tui                  # interactive mode
./tui --run backup     # run a specific action non-interactively
./tui --run status     # show system status
./tui --run dashboard  # live refreshing dashboard
./tui --list           # list all available actions
```

**Menus:** Install Tools, Deploy Configs, Backup, Restore, Secrets, Status, Live Dashboard, Settings

**Settings:** SSD path, multiple SSDs (add/remove/switch), projects directory, source folders -- all changeable at any time.

---

## New Machine Checklist

```bash
# 1. Bootstrap (or clone manually)
curl -fsSL https://raw.githubusercontent.com/EhsanulHaqueSiam/dev/main/bootstrap | bash

# 2. Restore secrets (if you have your SSD)
./secrets ssh restore              # SSH keys
./secrets env restore              # .env files
./secrets claude restore           # Claude config

# 3. Or restore from Bitwarden (no SSD needed)
bwu                                # unlock Bitwarden
./secrets ssh restore --bw
./secrets env restore --bw
./secrets claude restore --bw

# 4. Open a new shell -- tools auto-initialize
#    (Cargo, Go, Bun, fnm, Atuin, Starship, Zoxide, Conda, FZF, uv, CUDA)

# 5. Verify
ssh -T git@github.com
./secrets --health
./dev-env doctor
```

---

## Extending

### Add a new tool

```bash
# 1. Create installer
cat > runs/mytool << 'EOF'
#!/usr/bin/env bash
if command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm --needed mytool
fi
EOF
chmod +x runs/mytool

# 2. Run it
./run mytool
```

### Add a new config

```bash
# 1. Copy config into repo
cp -r ~/.config/mytool ~/Personal/dev/env/.config/mytool

# 2. Deploy (or just run --env)
./dev-env
```

Both are auto-discovered -- no code changes needed. The TUI, `./run`, and `./dev-env` pick them up automatically.

---

## Repo Structure

```
dev/
├── bootstrap              # Fresh machine setup (curl-pipeable)
├── run                    # Main orchestrator (installs + deploys)
├── dev-env                # Config manager (deploy/capture/update/diff/compare/doctor)
├── backup                 # Backup projects → SSD (parallel rsync, exFAT-optimized)
├── restore                # Restore projects ← SSD (safe merge)
├── secrets                # Secrets manager (SSH + .env + Claude, age + Bitwarden)
├── tui                    # Interactive terminal UI (gum)
│
├── lib/
│   └── config.sh          # Shared config (SSD path, projects dir, multi-SSD support)
│
├── runs/                  # Tool installers (one script per tool)
│   ├── age                # Encryption tool        ├── miniconda     # Python envs
│   ├── atuin              # Shell history           ├── neovim        # Editor
│   ├── bat                # Better cat              ├── node          # Node.js + npm
│   ├── bitwarden-cli      # Password manager        ├── nvidiaDriver  # GPU drivers
│   ├── bun                # JS/TS runtime           ├── ollama        # Local LLMs
│   ├── discord            # Communication           ├── omarchy       # Shell framework
│   ├── expressvpn         # VPN                     ├── python        # Python runtime
│   ├── eza                # Better ls               ├── rust          # Rust toolchain
│   ├── fnm                # Node version manager    ├── starship      # Prompt
│   ├── gcalcli            # Google Calendar         ├── ticktick      # Task manager
│   ├── gemini             # Gemini CLI              ├── tldr          # Man pages
│   ├── ghostty            # Terminal                ├── tmux          # Multiplexer
│   ├── go                 # Go toolchain            ├── uv            # Python packages
│   ├── gum                # TUI framework           ├── xh            # HTTP client
│   └── ...                                          ├── yazi          # File manager
│                                                    └── zsh           # Z shell
│
└── env/                   # Dotfiles (copied to ~/ on deploy)
    ├── .config/
    │   ├── atuin/             # Shell history config
    │   ├── dev-env/
    │   │   ├── init.sh              # One-line shell setup (source this)
    │   │   ├── shell-init.sh        # Tool init (Cargo, Go, Bun, fnm, etc.)
    │   │   ├── shell-functions.sh   # Shell functions (bwu, etc.)
    │   │   ├── completions.bash     # Bash tab-completions for dev command
    │   │   └── completions.zsh      # Zsh tab-completions for dev command
    │   ├── ghostty/           # Terminal (tokyo-night, FiraCode)
    │   ├── mpv/               # Media player
    │   ├── nvim/              # Neovim (LazyVim, 80+ plugins, 18 LSPs)
    │   ├── starship.toml      # Prompt theme
    │   ├── tmux/              # Multiplexer (catppuccin, plugins)
    │   ├── wezterm/           # Alt terminal config
    │   └── yazi/              # File manager (catppuccin, plugins)
    ├── .local/scripts/
    │   ├── dev                # Unified command (routes to scripts)
    │   └── dev-env            # Config manager wrapper
    ├── .bashrc                # Bash config
    ├── .zshrc                 # Zsh config (aliases, vi mode, integrations)
    ├── .profile               # Login shell PATH
    └── .xprofile              # X11/Wayland environment
```

---

## How It Works

**Config flow** -- configs are copies, not symlinks. Changes flow one direction at a time:

```
Repo (env/)  --deploy-->  System (~/)  --capture/update-->  Repo (env/)
```

**Backup flow** -- parallel rsync tuned for exFAT (no perms, no symlinks, inplace writes, `--whole-file`):

```
System (~/Personal/)  --backup-->  SSD ($SSD/backups/2026-02-15_14-30-00/)
                      <--restore--
```

**Secrets flow** -- two independent backends:

```
Local (~/.ssh, .env)  --age encrypt-->  SSD ($SSD/ssh-keys/, $SSD/env-secrets/)
Local (~/.ssh, .env)  --bw store-->     Bitwarden vault (secure notes)
```

**Shell init** -- A single `~/.config/dev-env/init.sh` handles everything: adds the `dev` command to PATH, loads tool initialization (Cargo, Go, Bun, fnm, Atuin, Starship, Zoxide, Conda, FZF, uv, CUDA), shell functions, and tab completions. Each tool is guarded -- only initialized if installed. Users with their own shell config just source this one file.

**SSD layout:**

```
$SSD/
├── backups/
│   └── 2026-02-15_14-30-00/Personal/    # project snapshots
├── ssh-keys/
│   └── ssh-keys_hostname_2026-02-15.tar.age
├── env-secrets/
│   └── env-secrets_2026-02-15.tar.age
└── claude-config/
    └── claude-config_2026-02-15.tar.age
```

---

## Cheat Sheet

```bash
# Setup
./run                              # install everything + deploy configs
./tui                              # interactive menu

# Configs
./dev-env                          # deploy configs
./dev-env update                   # pull live changes into repo
./dev-env compare                  # diff repo vs live
./dev-env doctor                   # diagnose issues

# Backup & Restore
./backup                           # backup to SSD
./backup --sync                    # incremental sync
./restore Personal                 # restore from SSD

# Secrets
./secrets ssh backup               # encrypt SSH keys
./secrets ssh restore              # decrypt SSH keys
./secrets env backup               # encrypt .env files
./secrets env restore              # decrypt .env files
./secrets claude backup            # encrypt Claude config
./secrets --health                 # health check
./secrets --diff                   # what changed

# Add --bw for Bitwarden, --dry for preview, --ssd <path> to override SSD
```

## Requirements

- **OS:** Arch Linux (uses `pacman`/`yay`)
- **Dependencies:** `git`, `bash` (everything else is auto-installed)
- **Optional:** External SSD for backups and age-encrypted secrets
- **Optional:** Bitwarden account for cloud-synced secrets
