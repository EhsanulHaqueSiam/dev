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
		cat > "$DEV_ENV_CONFIG_FILE" <<EOF
SSD_PATH="$_DEFAULT_SSD_PATH"
SSD_PATHS="$_DEFAULT_SSD_PATH"
PROJECTS_DIR="$_DEFAULT_PROJECTS_DIR"
SOURCES="$_DEFAULT_SOURCES"
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

	# Parse SSD_PATHS into array (all known SSDs)
	IFS=',' read -ra SSD_LIST <<< "${SSD_PATHS:-$SSD}"

	# Derived paths (from active SSD)
	BACKUP_ROOT="$SSD/backups"
	SSH_BACKUP_DIR="$SSD/ssh-keys"
	ENV_BACKUP_DIR="$SSD/env-secrets"
	ENV_ALIAS_FILE="$DEV_ENV_CONFIG_DIR/env-aliases"
}

# Switch the active SSD
switch_ssd() {
	local new_ssd="$1"
	save_config "SSD_PATH" "$new_ssd"
	load_config
}

# Add an SSD path to the list
add_ssd() {
	local new_path="$1"
	# Check if already in the list
	for p in "${SSD_LIST[@]}"; do
		[[ "$p" == "$new_path" ]] && return 0
	done
	local current
	current=$(IFS=','; echo "${SSD_LIST[*]}")
	save_config "SSD_PATHS" "${current},${new_path}"
	load_config
}

# Remove an SSD path from the list
remove_ssd() {
	local remove_path="$1"
	local new_list=()
	for p in "${SSD_LIST[@]}"; do
		[[ "$p" != "$remove_path" ]] && new_list+=("$p")
	done
	if [[ ${#new_list[@]} -eq 0 ]]; then
		return 1
	fi
	save_config "SSD_PATHS" "$(IFS=','; echo "${new_list[*]}")"
	# If active SSD was removed, switch to first remaining
	if [[ "$SSD" == "$remove_path" ]]; then
		save_config "SSD_PATH" "${new_list[0]}"
	fi
	load_config
}

# List all SSDs with their mount status
list_ssds() {
	for p in "${SSD_LIST[@]}"; do
		local status="not mounted"
		if mountpoint -q "$p" 2>/dev/null; then
			local free
			free=$(df -h "$p" | awk 'NR==2 {print $4}')
			status="mounted (${free} free)"
		fi
		local active=""
		[[ "$p" == "$SSD" ]] && active=" *"
		echo "${p}|${status}${active}"
	done
}

save_config() {
	# Upsert key=value into config file
	local key="$1" value="$2"
	mkdir -p "$DEV_ENV_CONFIG_DIR"
	if [[ -f "$DEV_ENV_CONFIG_FILE" ]] && grep -q "^${key}=" "$DEV_ENV_CONFIG_FILE" 2>/dev/null; then
		sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$DEV_ENV_CONFIG_FILE"
	else
		echo "${key}=\"${value}\"" >> "$DEV_ENV_CONFIG_FILE"
	fi
}

check_ssd() {
	mountpoint -q "$SSD" 2>/dev/null
}

# Auto-mount SSD if connected but not mounted
try_mount_ssd() {
	# Already mounted
	if mountpoint -q "$SSD" 2>/dev/null; then
		return 0
	fi

	# Find the SSD partition by label
	local ssd_label
	ssd_label=$(basename "$SSD")
	local dev
	dev=$(lsblk -rno NAME,LABEL 2>/dev/null | awk -v lbl="$ssd_label" '$2 == lbl {print "/dev/"$1; exit}')

	if [[ -z "$dev" ]]; then
		return 1  # SSD not connected
	fi

	# Connected but not mounted — try udisksctl (no sudo needed)
	if command -v udisksctl &>/dev/null; then
		echo -e "\033[1;33m[config]\033[0m SSD detected at $dev but not mounted — mounting..."
		udisksctl mount -b "$dev" --no-user-interaction 2>/dev/null && return 0
	fi

	# Fallback: manual mount (needs sudo)
	if [[ ! -d "$SSD" ]]; then
		sudo mkdir -p "$SSD"
	fi
	echo -e "\033[1;33m[config]\033[0m SSD detected at $dev but not mounted — mounting (sudo)..."
	sudo mount -t exfat "$dev" "$SSD" 2>/dev/null && return 0

	return 1
}

# -----------------------------------------------------------------------
# Backup timestamp tracking
# -----------------------------------------------------------------------
TIMESTAMP_FILE="$DEV_ENV_CONFIG_DIR/last-backup"

record_backup_time() {
	mkdir -p "$DEV_ENV_CONFIG_DIR"
	date +%s > "$TIMESTAMP_FILE"
}

check_backup_age() {
	local warn_days="${1:-7}"
	if [[ ! -f "$TIMESTAMP_FILE" ]]; then
		echo "no backup recorded yet"
		return
	fi
	local last now days_ago
	last=$(cat "$TIMESTAMP_FILE")
	now=$(date +%s)
	days_ago=$(( (now - last) / 86400 ))
	if (( days_ago >= warn_days )); then
		echo "last backup was ${days_ago} days ago"
	fi
}

# Auto-load on source
load_config
