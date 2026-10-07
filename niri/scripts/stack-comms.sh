#!/usr/bin/env bash
# At login: arrange "comms" as Vesktop leftmost, Signal+Tidal merged into one
# column (niri opens every window in its own column, so merging needs the IPC
# event stream + consume). Re-arranges when an app replaces its window (splash,
# duplicate launch) and exits once things settle. Requires jq.

set -euo pipefail

readonly VESKTOP_APP_ID="vesktop"
readonly SIGNAL_APP_ID="signal"
readonly TIDAL_APP_ID="tidal-hifi"
readonly TIMEOUT_SECS=30
readonly SETTLE_SECS=5
readonly LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/stack-comms.log"

# niri swallows spawn-at-startup children's stdio, so log to a file instead —
# otherwise failures here are invisible (nothing shows up in the journal).
: > "$LOG_FILE"
log() { echo "$(date -Iseconds) $*" >>"$LOG_FILE"; }

# Flatten events into "open<TAB>app_id<TAB>id" (snapshot + open/change) and
# "close<TAB>-<TAB>id" lines; `?` makes other event types produce nothing.
# shellcheck disable=SC2016  # $vesk/$sig/$tid are jq --arg variables
jq_event_filter='
  (.WindowClosed? | select(. != null) | "close\t-\t\(.id)"),
  ((.WindowsChanged.windows[]?, .WindowOpenedOrChanged.window?)
    | select(.app_id == $vesk or .app_id == $sig or .app_id == $tid)
    | "open\t\(.app_id)\t\(.id)")
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
    local id="$1"
    for _ in $(seq 1 3); do
        is_tiled "$id" && return 0
        sleep 0.1
    done
    return 1
}

place_vesktop_first() {
    local vesktop_id="$1"
    wait_tiled "$vesktop_id" || return 1
    niri msg action focus-window --id "$vesktop_id"
    niri msg action move-column-to-first
}

stack_signal_tidal() {
    local signal_id="$1" tidal_id="$2"

    wait_tiled "$signal_id" && wait_tiled "$tidal_id" || return 1
    # Already merged (e.g. on a re-arrange where only Vesktop changed).
    [[ "$(column_of "$signal_id")" != "$(column_of "$tidal_id")" ]] || return 0

    # Force adjacency at the right edge (map order is racy), then pull Tidal in.
    niri msg action focus-window --id "$signal_id"
    niri msg action move-column-to-last
    niri msg action focus-window --id "$tidal_id"
    niri msg action move-column-to-last
    niri msg action consume-or-expel-window-left
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
last_change=$SECONDS   # when a tracked id last changed
arranged=""            # id set of the last successful arrangement
failed=""              # id set that last failed, so a retry logs once

# niri window ids only grow, so a higher id is a newer window for that app.
track() {
    local -n slot="$1"
    if [[ -z "$slot" ]] || (( $2 > slot )); then
        slot="$2"
        last_change=$SECONDS
    fi
}

forget() {
    local name
    for name in vesktop_id signal_id tidal_id; do
        local -n slot="$name"
        if [[ "$slot" == "$1" ]]; then
            slot=""
            last_change=$SECONDS
        fi
    done
}

maybe_arrange() {
    [[ -n "$vesktop_id" && -n "$signal_id" && -n "$tidal_id" ]] || return 0
    local key="$vesktop_id $signal_id $tidal_id"
    [[ "$key" != "$arranged" ]] || return 0
    if arrange "$vesktop_id" "$signal_id" "$tidal_id"; then
        arranged="$key"
        log "arranged: Vesktop $vesktop_id, Signal $signal_id + Tidal $tidal_id"
    elif [[ "$key" != "$failed" ]]; then
        failed="$key"
        log "arrangement incomplete for $key, retrying"
    fi
}

while true; do
    # 1 s ticks so the settle check runs even when no events arrive.
    if IFS=$'\t' read -r -t 1 -u 3 kind app_id win_id; then
        case "$kind:$app_id" in
            "open:$VESKTOP_APP_ID") track vesktop_id "$win_id" ;;
            "open:$SIGNAL_APP_ID")  track signal_id "$win_id" ;;
            "open:$TIDAL_APP_ID")   track tidal_id "$win_id" ;;
            close:*)                forget "$win_id" ;;
        esac
    elif (( $? <= 128 )); then
        break   # stream ended: the TIMEOUT_SECS cap
    fi

    maybe_arrange
    if [[ -n "$arranged" && "$arranged" == "$vesktop_id $signal_id $tidal_id" ]] \
        && (( SECONDS - last_change >= SETTLE_SECS )); then
        log "settled, done"
        exit 0
    fi
done

# Cap reached: arrange the latest complete set, or whatever subset showed up.
log "stopped after ${TIMEOUT_SECS}s"
if [[ "$arranged" != "$vesktop_id $signal_id $tidal_id" ]]; then
    arrange "$vesktop_id" "$signal_id" "$tidal_id" || true
    log "arranged what arrived: Vesktop ${vesktop_id:-none}, Signal ${signal_id:-none}, Tidal ${tidal_id:-none}"
fi
exit 0
