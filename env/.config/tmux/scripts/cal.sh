#!/bin/bash
# Linux calendar status for tmux (replaces macOS icalBuddy)
# Supports: khal, calcurse, gcalcli — shows "free" if none installed

ALERT_IF_IN_NEXT_MINUTES=10
NERD_FONT_FREE="󱁕 "
NERD_FONT_MEETING="󰤙"

time="" title="" minutes_till_meeting=9999

get_meeting_khal() {
    local line
    line=$(khal list now 23:59 --format "{start-time} {title}" \
        --day-format "" 2>/dev/null | head -1)
    [[ -z "$line" ]] && return 1
    time="${line%% *}"
    title="${line#* }"
}

get_meeting_calcurse() {
    local line
    line=$(calcurse -a --format-apt "%S %m\n" 2>/dev/null | \
        awk -v now="$(date +%H:%M)" '$1 >= now' | head -1)
    [[ -z "$line" ]] && return 1
    time="${line%% *}"
    title="${line#* }"
}

get_meeting_gcalcli() {
    local line
    line=$(gcalcli agenda \
        --nostarted --tsv --no-military \
        "$(date '+%Y-%m-%dT%H:%M')" "$(date '+%Y-%m-%dT23:59')" \
        2>/dev/null | head -1)
    [[ -z "$line" ]] && return 1
    time=$(echo "$line" | cut -f2)
    title=$(echo "$line" | cut -f5-)
    local start_date
    start_date=$(echo "$line" | cut -f1)
    # reformat for date -d
    time="$start_date $time"
}

calculate_minutes() {
    local meet_epoch now_epoch
    meet_epoch=$(date -d "$time" +%s 2>/dev/null) || return 1
    now_epoch=$(date +%s)
    minutes_till_meeting=$(( (meet_epoch - now_epoch) / 60 ))
}

main() {
    if command -v khal &>/dev/null; then
        get_meeting_khal
    elif command -v calcurse &>/dev/null; then
        get_meeting_calcurse
    elif command -v gcalcli &>/dev/null; then
        get_meeting_gcalcli
    fi

    if [[ -n "$time" ]]; then
        calculate_minutes
        if (( minutes_till_meeting < ALERT_IF_IN_NEXT_MINUTES \
            && minutes_till_meeting > -60 )); then
            echo "$NERD_FONT_MEETING $time $title (${minutes_till_meeting}m)"
            return
        fi
    fi

    echo "$NERD_FONT_FREE"
}

main
