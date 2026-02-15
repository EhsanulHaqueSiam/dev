#!/usr/bin/env bash
# -----------------------------------------------------------------------
# Shared tool initialization for bash and zsh
# Source from .zshrc or .bashrc:
#   source ~/.config/dev-env/shell-init.sh
# -----------------------------------------------------------------------

# Detect shell
_shell=""
if [[ -n "${ZSH_VERSION:-}" ]]; then
	_shell="zsh"
elif [[ -n "${BASH_VERSION:-}" ]]; then
	_shell="bash"
fi

# Cargo/Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Go
if command -v go &>/dev/null; then
	export GOPATH="$HOME/go"
	export PATH="$PATH:${GOPATH}/bin"
fi

# Bun
if [[ -d "$HOME/.bun" ]]; then
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

# fnm (Fast Node Manager)
if command -v fnm &>/dev/null; then
	eval "$(fnm env)"
fi

# Atuin
if [[ -f "$HOME/.atuin/bin/env" ]]; then
	. "$HOME/.atuin/bin/env"
	if [[ "$_shell" == "zsh" ]]; then
		eval "$(atuin init zsh)"
	elif [[ "$_shell" == "bash" ]]; then
		eval "$(atuin init bash)"
	fi
fi

# Starship prompt
if command -v starship &>/dev/null; then
	export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
	if [[ "$_shell" == "zsh" ]]; then
		eval "$(starship init zsh)"
	elif [[ "$_shell" == "bash" ]]; then
		eval "$(starship init bash)"
	fi
fi

# Zoxide
if command -v zoxide &>/dev/null; then
	if [[ "$_shell" == "zsh" ]]; then
		eval "$(zoxide init zsh --cmd cd)"
	elif [[ "$_shell" == "bash" ]]; then
		eval "$(zoxide init bash --cmd cd)"
	fi
fi

# MiniConda
[[ -f /opt/miniconda3/etc/profile.d/conda.sh ]] && source /opt/miniconda3/etc/profile.d/conda.sh

# FZF
if command -v fzf &>/dev/null; then
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
	if [[ "$_shell" == "zsh" ]]; then
		[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
	elif [[ "$_shell" == "bash" ]]; then
		[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
	fi
fi

# uv completions
if command -v uv &>/dev/null; then
	if [[ "$_shell" == "zsh" ]]; then
		eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true
	elif [[ "$_shell" == "bash" ]]; then
		eval "$(uv generate-shell-completion bash 2>/dev/null)" || true
	fi
fi

# CUDA (only if NVIDIA GPU present)
if [[ -d /opt/cuda ]]; then
	export CUDA_HOME=/opt/cuda
	export PATH="$CUDA_HOME/bin:$PATH"
	export LD_LIBRARY_PATH="$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}"
fi

unset _shell
