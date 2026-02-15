#!/bin/bash

# Tmux calendar/meeting status script for Linux
# Uses gcalcli (Google Calendar CLI) — install with: pip install gcalcli
# First run: gcalcli init  (authenticates with Google)

ALERT_IF_IN_NEXT_MINUTES=10
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE="󱁕 "
NERD_FONT_MEETING="󰤙"

# Check if gcalcli is available
if ! command -v gcalcli &>/dev/null; then
	echo "$NERD_FONT_FREE"
	exit 0
fi

get_next_meeting() {
	# Get the next non-all-day event from gcalcli
	# Output format: date time title
	next_meeting=$(gcalcli agenda \
		--nostarted \
		--tsv \
		--no-military \
		"$(date '+%Y-%m-%dT%H:%M')" \
		"$(date '+%Y-%m-%dT23:59')" \
		2>/dev/null | head -n 1)
}

parse_result() {
	if [ -z "$next_meeting" ]; then
		time=""
		title=""
		return
	fi

	# TSV format: start_date start_time end_date end_time title
	start_date=$(echo "$next_meeting" | cut -f1)
	time=$(echo "$next_meeting" | cut -f2)
	end_date=$(echo "$next_meeting" | cut -f3)
	end_time=$(echo "$next_meeting" | cut -f4)
	title=$(echo "$next_meeting" | cut -f5-)
}

calculate_times() {
	if [ -z "$time" ]; then
		minutes_till_meeting=9999
		epoc_diff=9999
		return
	fi

	# GNU date: parse meeting time
	epoc_meeting=$(date -d "$start_date $time" +%s 2>/dev/null || echo 0)
	epoc_now=$(date +%s)
	epoc_diff=$((epoc_meeting - epoc_now))
	minutes_till_meeting=$((epoc_diff / 60))
}

display_popup() {
	tmux display-popup \
		-S "fg=#eba0ac" \
		-w50% \
		-h50% \
		-d '#{pane_current_path}' \
		-T meeting \
		"gcalcli agenda --details=all '$(date '+%Y-%m-%dT%H:%M')' '$(date '+%Y-%m-%dT23:59')' 2>/dev/null | head -n 20"
}

print_tmux_status() {
	if [ -z "$time" ]; then
		echo "$NERD_FONT_FREE"
		return
	fi

	if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES \
		&& $minutes_till_meeting -gt -60 ]]; then
		echo "$NERD_FONT_MEETING $time $title (${minutes_till_meeting}m)"
	else
		echo "$NERD_FONT_FREE"
	fi

	if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS \
		&& $epoc_diff -lt $((ALERT_POPUP_BEFORE_SECONDS + 10)) ]]; then
		display_popup
	fi
}

main() {
	get_next_meeting
	parse_result
	calculate_times
	print_tmux_status
}

main
