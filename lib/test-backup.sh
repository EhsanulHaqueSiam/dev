#!/usr/bin/env bash
# Self-check for the snapshot/prune logic. Runs entirely in a temp dir against a
# fake "SSD" — never touches the real drive or any real source.
#   ./lib/test-backup.sh
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SB=$(mktemp -d)
trap 'rm -rf "$SB"' EXIT

fails=0
check() { # check <desc> <expected> <actual>
	if [[ "$2" == "$3" ]]; then
		echo "  ok    $1"
	else
		echo "  FAIL  $1"
		echo "          expected: $2"
		echo "          actual:   $3"
		fails=$(( fails + 1 ))
	fi
}

# Fake home with two sources, and a fake SSD that always looks mounted
export HOME="$SB/home"
export XDG_CONFIG_HOME="$SB/home/.config"
SSD="$SB/ssd"
mkdir -p "$HOME/.config/dev-env" "$SSD/backups" "$SB/bin"
mkdir -p "$HOME/Personal/proj/.git" "$HOME/Work/client"
echo hello > "$HOME/Personal/proj/main.py"
echo committed > "$HOME/Personal/proj/.git/HEAD"
echo work > "$HOME/Work/client/notes.md"
printf 'SSD_PATH="%s"\nSSD_PATHS="%s"\nPROJECTS_DIR="%s"\nSOURCES="Personal,Work"\n' \
	"$SSD" "$SSD" "$HOME/Personal" > "$HOME/.config/dev-env/config"
printf '#!/usr/bin/env bash\nexit 0\n' > "$SB/bin/mountpoint"
chmod +x "$SB/bin/mountpoint"
export PATH="$SB/bin:$PATH"

run() { "$REPO/backup" "$@" 2>&1; }
snapshots() { find "$SSD/backups" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tr '\n' ' '; }

echo "== snapshot resolution =="
# A stray non-timestamp dir sorts after every timestamp; it must not be a snapshot.
mkdir -p "$SSD/backups/2026-01-01_00-00-00" "$SSD/backups/dev"
source "$REPO/lib/config.sh"
BACKUP_ROOT="$SSD/backups"
check "stray dir is not counted"  "1" "$(list_snapshots | wc -l)"
check "latest ignores stray dir"  "2026-01-01_00-00-00" "$(basename "$(latest_snapshot)")"
rm -rf "$SSD/backups/dev" "$SSD/backups/2026-01-01_00-00-00"

echo "== full backup =="
out=$(run --keep 2)
check "backup succeeded" "0" "$?"
newest=$(find "$SSD/backups" -mindepth 1 -maxdepth 1 -type d | sort | tail -1)
check "both sources present" "Personal Work" "$(find "$newest" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort | tr '\n' ' ' | sed 's/ $//')"
check ".git is backed up"    "committed" "$(cat "$newest/Personal/proj/.git/HEAD" 2>/dev/null)"

echo "== prune is gated =="
# Partial run (one source named) must not evict complete snapshots.
before=$(snapshots)
out=$(run Personal --keep 1)
check "partial run skips prune" "1" "$(grep -c 'skipping prune: partial snapshot' <<< "$out")"
check "old snapshots survive"   "kept" "$([[ "$(snapshots)" == "$before"* ]] && echo kept || echo lost)"

# A stray dir must not consume a retention slot.
mkdir -p "$SSD/backups/dev"
run --keep 1 >/dev/null
check "stray dir untouched by prune" "yes" "$([[ -d "$SSD/backups/dev" ]] && echo yes || echo no)"
check "keep=1 leaves one snapshot"   "1" "$(list_snapshots | wc -l)"
rm -rf "$SSD/backups/dev"

echo "== sync mode =="
echo "changed" >> "$HOME/Personal/proj/main.py"
out=$(run --sync); rc=$?
check "sync exits clean"          "0" "$rc"
check "sync defines its helpers"  "0" "$(grep -c 'command not found' <<< "$out")"
newest=$(latest_snapshot)
check "sync updated the snapshot" "hello
changed" "$(cat "$newest/Personal/proj/main.py" 2>/dev/null)"

echo "== dry run writes nothing =="
before=$(snapshots)
run --dry >/dev/null
check "no new snapshot on --dry" "$before" "$(snapshots)"
run --sync --dry >/dev/null 2>&1
check "no new dirs on --sync --dry" "$before" "$(snapshots)"

echo "== bad input is rejected =="
run --nonsense >/dev/null 2>&1
check "unknown flag exits 1" "1" "$?"
"$REPO/restore" .. >/dev/null 2>&1
check "restore rejects '..'" "1" "$?"

echo
if (( fails == 0 )); then
	echo "all checks passed"
else
	echo "$fails check(s) failed"
fi
exit $(( fails > 0 ))
