source ~/.local/share/omarchy/default/bash/shell
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/init
source ~/.local/share/omarchy/default/bash/envs
[[ $- == *i* ]] && bind -f ~/.local/share/omarchy/default/bash/inputrc

# ─── Environment ──────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export KUBECONFIG=~/.kube/config
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export PATH="./bin:$HOME/.local/bin:$HOME/.local/share/omarchy/bin:$HOME/.vimpkg/bin:$HOME/.cargo/bin:/run/current-system/sw/bin:/usr/local/go/bin:$PATH"

# ─── Navigation ──────────────────────────────────────────────────────────────
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

# ─── Custom aliases ──────────────────────────────────────────────────────────
alias vim=nvim
alias la=tree
alias cat=bat
alias cl='clear'
alias l="eza -l --icons --git -a"
alias ltree="eza --tree --level=2 --icons --git"
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias http="xh"

# Git (extends omarchy defaults: g, gcm, gcam, gcad)
alias gc="git commit -m"
alias gca="git commit -a -m"
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

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Kubernetes
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

# ─── Dev environment ─────────────────────────────────────────────────────────
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh" ]] && \
    . "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/init.sh"

. "$HOME/.local/share/../bin/env"
. "$HOME/.cargo/env"
