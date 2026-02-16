#!/usr/bin/env bash
# -----------------------------------------------------------------------
# Dev environment one-line setup
#
# Add this to your .bashrc or .zshrc:
#   [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh" ] && \
#       . "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh"
# -----------------------------------------------------------------------

_devenv_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env"

# PATH — make `dev` command available
[[ ":$PATH:" != *":$HOME/.local/scripts:"* ]] && \
	export PATH="$HOME/.local/scripts:$PATH"

# Detect shell
_devenv_shell=""
if [[ -n "${ZSH_VERSION:-}" ]]; then
	_devenv_shell="zsh"
elif [[ -n "${BASH_VERSION:-}" ]]; then
	_devenv_shell="bash"
fi

# Tool initialization (cargo, go, bun, starship, zoxide, etc.)
[[ -f "$_devenv_dir/shell-init.sh" ]] && . "$_devenv_dir/shell-init.sh"

# Shell functions (bwu, etc.)
[[ -f "$_devenv_dir/shell-functions.sh" ]] && . "$_devenv_dir/shell-functions.sh"

# Tab completions for `dev` command
if [[ "$_devenv_shell" == "zsh" ]]; then
	[[ -f "$_devenv_dir/completions.zsh" ]] && . "$_devenv_dir/completions.zsh"
elif [[ "$_devenv_shell" == "bash" ]]; then
	[[ -f "$_devenv_dir/completions.bash" ]] && . "$_devenv_dir/completions.bash"
fi

unset _devenv_dir _devenv_shell
