#!/usr/bin/env bash
# -----------------------------------------------------------------------
# Shared config loader for dev environment scripts
# Source this file: source "$script_dir/lib/config.sh"
# -----------------------------------------------------------------------

DEV_ENV_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/dev-env"
DEV_ENV_CONFIG_FILE="$DEV_ENV_CONFIG_DIR/config"

# Defaults (use $USER, never hardcode a username)
_DEFAULT_SSD_PATH="/run/media/$USER/TRANSCEND"
_DEFAULT_PROJECTS_DIR="$HOME/Personal"
_DEFAULT_SOURCES="Personal"

load_config() {
	# Create config file with defaults if missing
	if [[ ! -f "$DEV_ENV_CONFIG_FILE" ]]; then
		mkdir -p "$DEV_ENV_CONFIG_DIR"
		cat > "$DEV_ENV_CONFIG_FILE" <<-EOF
		SSD_PATH=$_DEFAULT_SSD_PATH
		PROJECTS_DIR=$_DEFAULT_PROJECTS_DIR
		SOURCES=$_DEFAULT_SOURCES
		EOF
	fi

	# Source the config
	# shellcheck disable=SC1090
	source "$DEV_ENV_CONFIG_FILE"

	# Apply defaults for any missing values
	SSD="${SSD_PATH:-$_DEFAULT_SSD_PATH}"
	PROJECTS_DIR="${PROJECTS_DIR:-$_DEFAULT_PROJECTS_DIR}"

	# Parse SOURCES into array
	IFS=',' read -ra SOURCES <<< "${SOURCES:-$_DEFAULT_SOURCES}"

	# Derived paths
	BACKUP_ROOT="$SSD/backups"
	SSH_BACKUP_DIR="$SSD/ssh-keys"
	ENV_BACKUP_DIR="$SSD/env-secrets"
	ENV_ALIAS_FILE="$DEV_ENV_CONFIG_DIR/env-aliases"
}

save_config() {
	# Upsert key=value into config file
	local key="$1" value="$2"
	mkdir -p "$DEV_ENV_CONFIG_DIR"
	if [[ -f "$DEV_ENV_CONFIG_FILE" ]] && grep -q "^${key}=" "$DEV_ENV_CONFIG_FILE" 2>/dev/null; then
		sed -i "s|^${key}=.*|${key}=${value}|" "$DEV_ENV_CONFIG_FILE"
	else
		echo "${key}=${value}" >> "$DEV_ENV_CONFIG_FILE"
	fi
}

check_ssd() {
	mountpoint -q "$SSD" 2>/dev/null
}

# Auto-load on source
load_config
