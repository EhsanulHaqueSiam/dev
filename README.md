# Dev Environment Setup 🛠️

Automated development environment setup scripts for Linux systems. Quickly bootstrap a new machine with all essential development tools.

## 🚀 Quick Start

```bash
# Set your dev environment path
export DEV_ENV=$(pwd)

# Run all setup scripts
./run

# Run specific tool setup (e.g., only rust)
./run rust

# Dry run to see what would be installed
./run --dry
```

## 📦 Included Tools

| Tool | Description |
|------|-------------|
| `atuin` | Shell history manager |
| `bat` | Cat clone with syntax highlighting |
| `fnm` | Fast Node.js version manager |
| `ghostty` | Terminal emulator |
| `miniconda` | Python environment manager |
| `node` | Node.js runtime |
| `ollama` | Local LLM runner |
| `python` | Python setup |
| `rust` | Rust toolchain |
| `starship` | Cross-shell prompt |
| `tmux` | Terminal multiplexer |
| `uv` | Fast Python package manager |
| `yazi` | Terminal file manager |
| `zsh` | Z shell configuration |

## 📁 Structure

```
├── run                 # Main runner script
├── dev-env            # Environment setup
├── runs/              # Individual tool installers
│   ├── atuin
│   ├── bat
│   ├── rust
│   ├── zsh
│   └── ...
└── env/               # Environment configs
```

## ⚙️ How It Works

1. Scripts in `runs/` are executed in order
2. Each script installs/configures one tool
3. Use grep filter to run specific scripts
4. `--dry` flag previews without changes

## 🖥️ Requirements

- Linux (tested on Arch Linux)
- Bash shell
- `curl` and `git`

## 👤 Author

**Ehsanul Haque Siam** - [@EhsanulHaqueSiam](https://github.com/EhsanulHaqueSiam)