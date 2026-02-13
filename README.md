# Dev Environment

Automated dev environment setup for Arch Linux. Install tools + deploy dotfiles with symlinks.

## Quick Start

```bash
# Fresh machine
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/dev
cd ~/dev

# Install everything + deploy configs (auto-detects repo path)
./run

# Or pass the path explicitly without exporting
DEV_ENV=~/dev ./run

# Install specific tool only
./run rust
./run bun

# Deploy configs only (no installs)
./run --env

# Dry run (preview without changes)
./run --dry
```

No need to `export DEV_ENV` — if not set, `./run` auto-detects its own directory.

## Saving Config Changes

Configs are **symlinked**, not copied. Edit `~/.config/nvim/` (or any config) and it updates the repo directly.

```bash
cd ~/dev
git add -A && git commit -m "update nvim config" && git push
```

## New Machine Restore

```bash
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/dev
cd ~/dev && ./run
```

That's it. All tools install and configs symlink into place.

## Structure

```
dev/
├── run                    # Main orchestrator (installs + deploys)
├── dev-env                # Config deployer (symlinks env/ to ~/)
├── runs/                  # Individual tool installers
│   ├── atuin              # Shell history
│   ├── bat                # Better cat
│   ├── bun                # JS/TS runtime
│   ├── discord            # Communication
│   ├── expressvpn         # VPN
│   ├── fnm                # Node version manager
│   ├── gemini             # Google Gemini CLI
│   ├── ghostty            # Terminal emulator
│   ├── miniconda          # Python env manager
│   ├── neovim             # Editor + dependencies
│   ├── node               # Node.js + npm
│   ├── nvidiaDriver       # GPU drivers
│   ├── ollama             # Local LLMs
│   ├── omarchy            # Shell framework
│   ├── python             # Python runtime
│   ├── rust               # Rust toolchain
│   ├── starship           # Prompt
│   ├── ticktick           # Task manager
│   ├── tldr               # Simplified man pages
│   ├── tmux               # Terminal multiplexer
│   ├── uv                 # Python package manager
│   ├── yazi               # File manager
│   └── zsh                # Shell + plugins
└── env/                   # Dotfiles (symlinked to ~/)
    ├── .config/
    │   ├── atuin/         # Shell history config
    │   ├── ghostty/       # Terminal config
    │   ├── mpv/           # Media player
    │   ├── nvim/          # Neovim (LazyVim)
    │   ├── starship.toml  # Prompt config
    │   ├── tmux/          # Multiplexer config
    │   ├── wezterm/       # Alt terminal config
    │   └── yazi/          # File manager config
    ├── .local/scripts/    # Custom scripts
    ├── .zshrc             # Shell config
    ├── .profile           # Login shell
    └── .xprofile          # X11/Wayland setup
```

## How It Works

**`./run`** iterates through `runs/` scripts alphabetically, executing each one. Then calls `dev-env` to deploy configs.

**`./dev-env`** symlinks everything in `env/` to your home directory:
- `env/.config/*` → `~/.config/*` (directory symlinks)
- `env/.zshrc` → `~/.zshrc` (file symlinks)

Symlinks mean changes flow both ways — edit in place, commit from repo.

**Flags:**
- `./run --dry` — preview without executing
- `./run --env` — deploy configs only, skip installs
- `./run <filter>` — only run scripts matching filter

## Requirements

- Arch Linux (uses `paru`/`pacman`)
- `git`, `curl`, `bash`
