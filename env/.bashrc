# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# ─── Environment ──────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export KUBECONFIG=~/.kube/config
export PATH="./bin:$HOME/.vimpkg/bin:/run/current-system/sw/bin:/usr/local/go/bin:$PATH"

# ─── Navigation ──────────────────────────────────────────────────────────────
# Note: `cx` is an omarchy alias (claude), so we can't define cx() here.
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
alias cdx='codex --dangerously-bypass-approvals-and-sandbox'
alias cgx='gemini --yolo'
alias la=tree
alias cat=bat
alias cl='clear'
alias l="eza -l --icons --git -a"
alias ltree="eza --tree --level=2 --icons --git"
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias http="xh"

# Git (extends omarchy defaults: g, gcm, gcam, gcad, ga, gd)
# Note: omarchy owns `ga` (function) and `gd` (function).
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
alias gap='git add -p'
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

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ─── Open Design ─────────────────────────────────────────────────────────────
# Helper: run a tools-dev command from the repo with Node 24 forced onto PATH
_od() {
    local node_bin="$HOME/.local/share/mise/installs/node/24/bin"
    (cd ~/Personal/open-design && PATH="$node_bin:$PATH" "$node_bin/pnpm" tools-dev "$@")
}
od-start()   { _od start "${@:-web}" && _od status; }   # start daemon + web in background, show URLs
od-stop()    { _od stop "$@"; }                          # stop everything
od-status()  { _od status "$@"; }                        # show running URLs
od-restart() { _od restart "${@:-web}" && _od status; }
od-logs()    { _od logs "${@:-web}"; }
# Foreground mode (stays attached, Ctrl+C to quit):
open-design() { _od run web "$@"; }

export PATH="$PATH:/home/siam/.config/.foundry/bin"
