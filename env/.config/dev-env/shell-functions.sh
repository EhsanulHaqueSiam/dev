#!/usr/bin/env bash
# -----------------------------------------------------------------------
# Dev environment shell functions
# Source from .zshrc or .bashrc:
#   [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/shell-functions.sh" ]] && \
#       source "${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/shell-functions.sh"
# -----------------------------------------------------------------------

_BW_SESSION_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env/.bw_session"

# Load saved BW_SESSION if not already set
if [[ -z "${BW_SESSION:-}" && -f "$_BW_SESSION_FILE" ]]; then
	BW_SESSION=$(cat "$_BW_SESSION_FILE" 2>/dev/null)
	export BW_SESSION
fi

# bwu — unlock Bitwarden and export BW_SESSION
bwu() {
	if ! command -v bw &>/dev/null; then
		echo "bitwarden-cli not installed"
		return 1
	fi

	local status
	status=$(bw status 2>/dev/null | jq -r '.status' 2>/dev/null || echo "unauthenticated")

	case "$status" in
		unauthenticated)
			echo "Logging in to Bitwarden..."
			BW_SESSION=$(bw login --raw) || { echo "Login failed"; return 1; }
			export BW_SESSION
			;;
		locked)
			echo "Unlocking Bitwarden vault..."
			BW_SESSION=$(bw unlock --raw) || { echo "Unlock failed"; return 1; }
			export BW_SESSION
			;;
		unlocked)
			echo "Bitwarden vault already unlocked"
			;;
		*)
			echo "Unknown Bitwarden status: $status"
			return 1
			;;
	esac

	# Save session to file so new shells pick it up
	mkdir -p "$(dirname "$_BW_SESSION_FILE")"
	echo "$BW_SESSION" > "$_BW_SESSION_FILE"
	chmod 600 "$_BW_SESSION_FILE"

	bw sync --quiet 2>/dev/null || true
	echo "Bitwarden ready"
}
