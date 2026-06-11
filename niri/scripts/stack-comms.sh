#!/usr/bin/env bash
# ============================================================
# stack-comms.sh — merge Signal + Tidal into one column on the
# "comms" workspace at login (vesktop stays alone on the left).
#
# Niri-only; no MangoWM equivalent exists because MangoWM's
# master layout produces this arrangement natively. In niri,
# window rules can pin apps to a workspace and set the initial
# column width, but every new window always opens in its own
# column — stacking two windows into a shared column requires
# the IPC event stream + a consume action (see the niri FAQ).
#
# Mechanics:
#   1. Subscribe to `niri msg --json event-stream`. The first
#      event on connect is a WindowsChanged snapshot of all
#      current windows; after that, WindowOpenedOrChanged fires
#      for each new (or retitled) window. Both carry the same
#      Window object, so one jq filter flattens either shape
#      into "app_id<TAB>window_id" lines.
#   2. Once both window IDs are known, query window positions:
#      consume-or-expel-window-left merges the FOCUSED window
#      into whatever column is directly to its left, so we only
#      act when Signal and Tidal sit in adjacent columns (spawn
#      order makes this the normal case). If they are already in
#      the same column, there is nothing to do (idempotent).
#   3. Exit immediately afterwards — this is a one-shot, not a
#      daemon. `timeout` caps the wait in case an app never maps.
# ============================================================

set -euo pipefail

readonly SIGNAL_APP_ID="signal"
readonly TIDAL_APP_ID="tidal-hifi"
readonly TIMEOUT_SECS=30

# Flatten the connect-time snapshot (.WindowsChanged.windows[]) and
# incremental events (.WindowOpenedOrChanged.window) into one stream
# of "app_id<TAB>id" lines for the two apps we care about. The `?`
# suffixes make every other event type produce no output.
# shellcheck disable=SC2016  # $sig/$tid are jq --arg variables, not shell vars
jq_event_filter='
  (.WindowsChanged.windows[]?, .WindowOpenedOrChanged.window?)
  | select(.app_id == $sig or .app_id == $tid)
  | "\(.app_id)\t\(.id)"
'

# Column index (1-based, left to right) of a window by ID, from
# layout.pos_in_scrolling_layout = [column, tile_within_column].
column_of() {
    niri msg --json windows \
        | jq -r --argjson id "$1" \
            '.[] | select(.id == $id) | .layout.pos_in_scrolling_layout[0]'
}

stack_pair() {
    local signal_id="$1" tidal_id="$2"
    local signal_col tidal_col
    signal_col="$(column_of "$signal_id")"
    tidal_col="$(column_of "$tidal_id")"

    # Floating windows report a null position; bail rather than guess.
    if ! [[ "$signal_col" =~ ^[0-9]+$ && "$tidal_col" =~ ^[0-9]+$ ]]; then
        echo "stack-comms: unexpected window positions (signal=$signal_col tidal=$tidal_col), leaving layout alone" >&2
        return 1
    fi

    if (( signal_col == tidal_col )); then
        echo "stack-comms: Signal and Tidal already share a column" >&2
    elif (( tidal_col == signal_col + 1 )); then
        # Normal case: Tidal directly right of Signal — pull it in.
        niri msg action focus-window --id "$tidal_id"
        niri msg action consume-or-expel-window-left
    elif (( signal_col == tidal_col + 1 )); then
        # Mapped in reverse order: Signal directly right of Tidal.
        niri msg action focus-window --id "$signal_id"
        niri msg action consume-or-expel-window-left
    else
        echo "stack-comms: Signal (col $signal_col) and Tidal (col $tidal_col) are not adjacent, leaving layout alone" >&2
        return 1
    fi
}

# Read the filtered event stream on FD 3 so the loop runs in the main
# shell (a plain pipe would put it in a subshell and `exit` inside the
# loop would not end the script).
exec 3< <(
    timeout "$TIMEOUT_SECS" niri msg --json event-stream \
        | jq --unbuffered -r \
            --arg sig "$SIGNAL_APP_ID" --arg tid "$TIDAL_APP_ID" \
            "$jq_event_filter"
)
stream_pid=$!
trap 'kill "$stream_pid" 2>/dev/null || true' EXIT

signal_id=""
tidal_id=""

while IFS=$'\t' read -r -u 3 app_id win_id; do
    case "$app_id" in
        "$SIGNAL_APP_ID") signal_id="$win_id" ;;
        "$TIDAL_APP_ID")  tidal_id="$win_id" ;;
    esac

    if [[ -n "$signal_id" && -n "$tidal_id" ]]; then
        stack_pair "$signal_id" "$tidal_id"
        exit 0
    fi
done

# Stream ended (timeout) before both windows appeared — exit cleanly.
echo "stack-comms: timed out after ${TIMEOUT_SECS}s waiting for Signal + Tidal" >&2
exit 0
