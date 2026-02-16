# General Bash Settings
# --------------------

# Source omarchy defaults if available
[[ -f ~/.local/share/omarchy/default/bash/aliases ]] && source ~/.local/share/omarchy/default/bash/aliases
[[ -f ~/.local/share/omarchy/default/bash/functions ]] && source ~/.local/share/omarchy/default/bash/functions
[[ -f ~/.local/share/omarchy/default/bash/prompt ]] && source ~/.local/share/omarchy/default/bash/prompt
[[ -f ~/.local/share/omarchy/default/bash/envs ]] && source ~/.local/share/omarchy/default/bash/envs

# Path and Language Settings
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.vimpkg/bin:$HOME/.cargo/bin:/run/current-system/sw/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:/usr/bin/node:/usr/bin/python3

# Navigation Enhancements
# --------------------
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | wl-copy; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# Yazi
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Aliases
# --------------------
# General
alias vim=nvim
alias la=tree
alias cat=bat
alias cl='clear'

# File system (eza)
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias l="eza -l --icons --git -a"
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ltree="eza --tree --level=2 --icons --git"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias g='git'
alias d='docker'
alias r='rails'
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
open() { xdg-open "$@" >/dev/null 2>&1 & }

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Find packages without leaving the terminal
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Kubernetes (K8S)
export KUBECONFIG=~/.kube/config
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs -f"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'

# HTTP Requests
alias http="xh"

# Set complete path
export PATH="./bin:$HOME/.local/bin:$HOME/.local/share/omarchy/bin:$PATH"
# Omarchy
export OMARCHY_PATH="$HOME/.local/share/omarchy"

# Dev environment (dev command, completions, tool init)
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh" ]] && \
    . "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh"
