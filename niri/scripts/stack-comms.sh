#!/usr/bin/env bash
# ============================================================
# stack-comms.sh — arrange the "comms" workspace at login:
# Vesktop alone in the leftmost column, Signal + Tidal merged
# into one shared column to its right (Signal top, Tidal bottom).
#
# Niri-only; no MangoWM equivalent exists because MangoWM's
# master layout produces this arrangement natively. In niri,
# window rules can pin apps to a workspace and set the initial
# column width, but every new window always opens in its own
# column — stacking two windows into a shared column requires
# the IPC event stream + a consume action (see the niri FAQ).
#
# Requires jq (nixos/base/packages.nix) — without it the event
# stream parses to nothing and the script exits without acting.
#
# Mechanics:
#   1. Subscribe to `niri msg --json event-stream`. The first
#      event on connect is a WindowsChanged snapshot of all
#      current windows; after that, WindowOpenedOrChanged fires
#      for each new (or retitled) window. Both carry the same
#      Window object, so one jq filter flattens either shape
#      into "app_id<TAB>window_id" lines.
#   2. Once all three window IDs are known, arrange explicitly
#      (Electron startup races make map order unreliable, so
#      adjacency is forced rather than assumed):
#        - Vesktop's column  → move-column-to-first
#        - Signal's column   → move-column-to-last
#        - Tidal's column    → move-column-to-last
#          (Tidal is now rightmost with Signal directly left)
#        - consume-or-expel-window-left merges Tidal into
#          Signal's column, below it.
#      If Signal and Tidal already share a column, the merge is
#      skipped (idempotent — consume-or-expel would EXPEL then).
#   3. Exit immediately afterwards — this is a one-shot, not a
#      daemon. `timeout` caps the wait in case an app never maps;
#      on timeout, whatever pair/subset arrived is still arranged.
# ============================================================

set -euo pipefail

readonly VESKTOP_APP_ID="vesktop"
readonly SIGNAL_APP_ID="signal"
readonly TIDAL_APP_ID="tidal-hifi"
readonly TIMEOUT_SECS=30

# Flatten the connect-time snapshot (.WindowsChanged.windows[]) and
# incremental events (.WindowOpenedOrChanged.window) into one stream
# of "app_id<TAB>id" lines for the three apps we care about. The `?`
# suffixes make every other event type produce no output.
# shellcheck disable=SC2016  # $vesk/$sig/$tid are jq --arg variables, not shell vars
jq_event_filter='
  (.WindowsChanged.windows[]?, .WindowOpenedOrChanged.window?)
  | select(.app_id == $vesk or .app_id == $sig or .app_id == $tid)
  | "\(.app_id)\t\(.id)"
'

# Column index (1-based, left to right) of a window by ID, from
# layout.pos_in_scrolling_layout = [column, tile_within_column].
# Floating windows report null.
column_of() {
    niri msg --json windows \
        | jq -r --argjson id "$1" \
            '.[] | select(.id == $id) | .layout.pos_in_scrolling_layout[0]'
}

is_tiled() {
    [[ "$(column_of "$1")" =~ ^[0-9]+$ ]]
}

place_vesktop_first() {
    local vesktop_id="$1"
    if ! is_tiled "$vesktop_id"; then
        echo "stack-comms: Vesktop is not tiled, leaving it alone" >&2
        return 0
    fi
    niri msg action focus-window --id "$vesktop_id"
    niri msg action move-column-to-first
}

stack_signal_tidal() {
    local signal_id="$1" tidal_id="$2"

    if ! is_tiled "$signal_id" || ! is_tiled "$tidal_id"; then
        echo "stack-comms: Signal/Tidal not tiled, leaving layout alone" >&2
        return 0
    fi

    if [[ "$(column_of "$signal_id")" == "$(column_of "$tidal_id")" ]]; then
        echo "stack-comms: Signal and Tidal already share a column" >&2
        return 0
    fi

    # Force adjacency at the right edge: Signal to last, then Tidal to
    # last (Tidal rightmost, Signal directly left), then pull Tidal in.
    niri msg action focus-window --id "$signal_id"
    niri msg action move-column-to-last
    niri msg action focus-window --id "$tidal_id"
    niri msg action move-column-to-last
    niri msg action consume-or-expel-window-left
}

# Arranging steals focus onto the comms workspace; remember what was
# focused beforehand so the user's view snaps back afterwards.
restore_focus() {
    local focused_id="$1"
    if [[ "$focused_id" =~ ^[0-9]+$ ]]; then
        niri msg action focus-window --id "$focused_id"
    fi
}

arrange() {
    local vesktop_id="$1" signal_id="$2" tidal_id="$3"
    local focused_id
    focused_id="$(niri msg --json focused-window | jq -r '.id // empty')"

    [[ -n "$vesktop_id" ]] && place_vesktop_first "$vesktop_id"
    if [[ -n "$signal_id" && -n "$tidal_id" ]]; then
        stack_signal_tidal "$signal_id" "$tidal_id"
    fi

    restore_focus "$focused_id"
}

# Read the filtered event stream on FD 3 so the loop runs in the main
# shell (a plain pipe would put it in a subshell and `exit` inside the
# loop would not end the script).
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
        arrange "$vesktop_id" "$signal_id" "$tidal_id"
        exit 0
    fi
done

# Stream ended (timeout) before all three windows appeared — arrange
# whatever subset showed up, then exit cleanly.
echo "stack-comms: timed out after ${TIMEOUT_SECS}s waiting for Vesktop + Signal + Tidal; arranging what arrived" >&2
arrange "$vesktop_id" "$signal_id" "$tidal_id"
exit 0
