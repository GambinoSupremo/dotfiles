#!/usr/bin/env bash
# One-shot at login: arrange "comms" as Vesktop leftmost, Signal+Tidal merged
# into one column (niri opens every window in its own column, so merging needs
# the IPC event stream + consume). Requires jq; times out and arranges what arrived.

set -euo pipefail

readonly VESKTOP_APP_ID="vesktop"
readonly SIGNAL_APP_ID="signal"
readonly TIDAL_APP_ID="tidal-hifi"
readonly TIMEOUT_SECS=30
readonly LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/stack-comms.log"

# niri swallows spawn-at-startup children's stdio, so log to a file instead —
# otherwise failures here are invisible (nothing shows up in the journal).
: > "$LOG_FILE"
log() { echo "$(date -Iseconds) $*" >>"$LOG_FILE"; }

# Flatten the connect snapshot + incremental events into "app_id<TAB>id" lines;
# `?` makes other event types produce nothing.
# shellcheck disable=SC2016  # $vesk/$sig/$tid are jq --arg variables
jq_event_filter='
  (.WindowsChanged.windows[]?, .WindowOpenedOrChanged.window?)
  | select(.app_id == $vesk or .app_id == $sig or .app_id == $tid)
  | "\(.app_id)\t\(.id)"
'

# 1-based column index of a window by ID; floating windows report null.
column_of() {
    niri msg --json windows \
        | jq -r --argjson id "$1" \
            '.[] | select(.id == $id) | .layout.pos_in_scrolling_layout[0]'
}

is_tiled() {
    [[ "$(column_of "$1")" =~ ^[0-9]+$ ]]
}

# A window can appear in the event stream a beat before niri has laid it into
# a column (pos_in_scrolling_layout still null) — poll briefly to cover that
# race. Kept short: some apps (Vesktop) open a floating splash window under
# the same app_id first, which never tiles at all, and a later event carrying
# the real window's id will retrigger this — no point camping on a dead one.
wait_tiled() {
    local id="$1" attempt
    for attempt in $(seq 1 3); do
        is_tiled "$id" && return 0
        sleep 0.1
    done
    return 1
}

place_vesktop_first() {
    local vesktop_id="$1"
    if ! wait_tiled "$vesktop_id"; then
        log "Vesktop ($vesktop_id) never tiled, leaving it alone"
        return 1
    fi
    niri msg action focus-window --id "$vesktop_id"
    niri msg action move-column-to-first
    log "Vesktop ($vesktop_id) moved to first column"
}

stack_signal_tidal() {
    local signal_id="$1" tidal_id="$2"

    if ! wait_tiled "$signal_id" || ! wait_tiled "$tidal_id"; then
        log "Signal ($signal_id)/Tidal ($tidal_id) not tiled, leaving layout alone"
        return 1
    fi

    if [[ "$(column_of "$signal_id")" == "$(column_of "$tidal_id")" ]]; then
        log "Signal and Tidal already share a column"
        return 0
    fi

    # Force adjacency at the right edge (map order is racy), then pull Tidal in.
    niri msg action focus-window --id "$signal_id"
    niri msg action move-column-to-last
    niri msg action focus-window --id "$tidal_id"
    niri msg action move-column-to-last
    niri msg action consume-or-expel-window-left
    log "Signal ($signal_id) and Tidal ($tidal_id) merged into one column"
}

# Arranging steals focus onto comms; snap back to what was focused before.
restore_focus() {
    local focused_id="$1"
    if [[ "$focused_id" =~ ^[0-9]+$ ]]; then
        niri msg action focus-window --id "$focused_id"
    fi
}

arrange() {
    local vesktop_id="$1" signal_id="$2" tidal_id="$3"
    local focused_id ok=0
    focused_id="$(niri msg --json focused-window | jq -r '.id // empty')"

    if [[ -n "$vesktop_id" ]]; then
        place_vesktop_first "$vesktop_id" || ok=1
    fi
    if [[ -n "$signal_id" && -n "$tidal_id" ]]; then
        stack_signal_tidal "$signal_id" "$tidal_id" || ok=1
    fi

    restore_focus "$focused_id"
    return "$ok"
}

# FD 3 keeps the loop in the main shell — a plain pipe would subshell it
# and `exit` inside the loop wouldn't end the script.
exec 3< <(
    timeout "$TIMEOUT_SECS" niri msg --json event-stream \
        | jq --unbuffered -r \
            --arg vesk "$VESKTOP_APP_ID" \
            --arg sig "$SIGNAL_APP_ID" --arg tid "$TIDAL_APP_ID" \
            "$jq_event_filter"
)
stream_pid=$!
trap 'kill "$stream_pid" 2>/dev/null || true' EXIT

vesktop_id=""
signal_id=""
tidal_id=""

while IFS=$'\t' read -r -u 3 app_id win_id; do
    case "$app_id" in
        "$VESKTOP_APP_ID") vesktop_id="$win_id" ;;
        "$SIGNAL_APP_ID")  signal_id="$win_id" ;;
        "$TIDAL_APP_ID")   tidal_id="$win_id" ;;
    esac

    if [[ -n "$vesktop_id" && -n "$signal_id" && -n "$tidal_id" ]]; then
        if arrange "$vesktop_id" "$signal_id" "$tidal_id"; then
            log "arrangement complete"
            exit 0
        fi
        # Not fully tiled yet even after wait_tiled's polling — a later event
        # (e.g. the window finishing its map) will trigger another attempt.
        log "arrangement incomplete, waiting for another event to retry"
    fi
done

# Timeout before all three appeared (or never fully tiled) — arrange whatever
# subset showed up, then give up.
log "timed out after ${TIMEOUT_SECS}s waiting for Vesktop + Signal + Tidal; arranging what arrived"
arrange "$vesktop_id" "$signal_id" "$tidal_id" || true
exit 0
