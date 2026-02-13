# Dev Environment

Automated dev environment setup for Arch Linux. Install tools + deploy dotfiles with symlinks.

## Quick Start

```bash
git clone git@github.com:EhsanulHaqueSiam/dev.git ~/dev
cd ~/dev
./run
```

That's it. All tools get installed and configs get symlinked into place.

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
├── make_runs_executable   # chmod helper
│
├── runs/                  # Individual tool installers
│   ├── atuin              # Shell history manager
│   ├── bat                # Cat clone with syntax highlighting
│   ├── bun                # JavaScript/TypeScript runtime
│   ├── discord            # Communication
│   ├── expressvpn         # VPN client
│   ├── fnm                # Fast Node.js version manager
│   ├── gemini             # Google Gemini CLI
│   ├── ghostty            # Terminal emulator
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

## Requirements

- **OS:** Arch Linux (uses `paru`/`pacman`)
- **Dependencies:** `git`, `curl`, `bash`
- **Optional:** `paru` (AUR helper — most installers use it)
