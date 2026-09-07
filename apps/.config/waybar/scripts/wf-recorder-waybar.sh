#!/usr/bin/env bash
# -----------------------------------------------------
# Waybar controller for wf-recorder
#
# States: stopped -> recording <-> paused -> stopped
#
# NOTE: wf-recorder (v0.6.x) has NO native pause support -
# it only handles SIGINT/SIGTERM/SIGHUP (graceful stop).
# So "pause" gracefully finalizes the current part file and
# "resume" starts a NEW part. On STOP, all parts of the
# session are concatenated with ffmpeg into a single output
# file and the intermediate parts are removed.
#
# Usage (called from waybar custom module):
#   wf-recorder-waybar.sh            -> print waybar JSON status
#   wf-recorder-waybar.sh toggle     -> left click: start / pause / resume
#   wf-recorder-waybar.sh stop       -> right click: stop, concat, finalize
# -----------------------------------------------------

set -u

REC_BIN="wf-recorder"

# Where final recordings go (override for testing)
OUT_DIR="${WF_RECORDER_OUT_DIR:-$HOME/Videos}"

# Icons (Font Awesome glyphs present in JetBrains Mono Nerd Font)
# utf-8 bytes written literally: U+F03D video, U+F111 record dot, U+F04C pause
ICON_STOPPED="$(printf '\xef\x81\xbd')"
ICON_RECORDING="$(printf '\xef\x84\x91')"
ICON_PAUSED="$(printf '\xef\x81\x8c')"

# Runtime state (cleared on reboot/session end)
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar-wf-recorder"
mkdir -p "$STATE_DIR" "$OUT_DIR"
STATE_FILE="$STATE_DIR/state"
LOCK_FILE="$STATE_DIR/lock"

NOTIFY=0
command -v notify-send >/dev/null 2>&1 && NOTIFY=1

notify() {
    [ "$NOTIFY" -eq 1 ] && notify-send -t 2000 -i camera-video "$@"
}

read_state() {          # $1 = key, $2 = fallback
    local v=""
    [ -f "$STATE_FILE" ] && v="$(sed -n "s/^$1=//p" "$STATE_FILE" | head -n1)"
    echo "${v:-${2-}}"
}

write_state() {         # $@ = KEY=value pairs
    : >"$STATE_FILE"
    for kv in "$@"; do echo "$kv" >>"$STATE_FILE"; done
}

clear_state() {
    rm -f "$STATE_FILE"
}

is_running() {
    pgrep -x "$REC_BIN" >/dev/null 2>&1
}

wait_for_exit() {       # $1 = max tenth-of-a-second ticks
    local i=0
    while is_running && [ $i -lt "${1:-60}" ]; do sleep 0.1; i=$((i + 1)); done
}

get_state() {
    if is_running; then
        # An externally started wf-recorder also counts as "recording";
        # heal a stale "paused" marker if someone restarted it behind our back.
        if [ "$(read_state STATUS stopped)" = "paused" ]; then
            write_state \
                "STATUS=recording" \
                "SESSION=$(read_state SESSION "")" \
                "PART=$(read_state PART 1)"
        fi
        echo "recording"
    elif [ "$(read_state STATUS)" = "paused" ]; then
        echo "paused"
    else
        echo "stopped"
    fi
}

# Directory holding the part files for the current session.
session_dir() {         # $1 = session id
    echo "$STATE_DIR/session_$1"
}

part_file() {           # $1 = session dir, $2 = part number
    printf '%s/part_%03d.mp4' "$1" "$2"
}

start_recording() {     # (no args) begins a NEW session, part 1
    local session sdir file
    session="$(date +%Y-%m-%d_%H-%M-%S)"
    sdir="$(session_dir "$session")"
    mkdir -p "$sdir"
    file="$(part_file "$sdir" 1)"

    # 9>&- : do not leak our flock fd into the recorder process
    setsid "$REC_BIN" --file="$file" </dev/null >/dev/null 2>&1 9>&- &
    disown
    sleep 0.6
    if is_running; then
        write_state "STATUS=recording" "SESSION=$session" "PART=1"
        notify "Recording started"
    else
        rmdir "$sdir" 2>/dev/null
        clear_state
        notify "Recording failed!" "Could not start $REC_BIN"
    fi
}

resume_recording() {    # continue current session with a new part
    local session sdir part file
    session="$(read_state SESSION "")"
    part="$(( $(read_state PART 1) + 1 ))"
    if [ -z "$session" ]; then
        # No session to resume; behave like a fresh start.
        start_recording
        return
    fi
    sdir="$(session_dir "$session")"
    mkdir -p "$sdir"
    file="$(part_file "$sdir" "$part")"

    setsid "$REC_BIN" --file="$file" </dev/null >/dev/null 2>&1 9>&- &
    disown
    sleep 0.6
    if is_running; then
        write_state "STATUS=recording" "SESSION=$session" "PART=$part"
        notify "Recording resumed" "(part $part)"
    else
        clear_state
        notify "Recording failed!" "Could not resume $REC_BIN"
    fi
}

do_pause() {
    pkill -x "$REC_BIN" >/dev/null 2>&1       # SIGTERM -> graceful finalize
    wait_for_exit 60
    write_state \
        "STATUS=paused" \
        "SESSION=$(read_state SESSION "")" \
        "PART=$(read_state PART 1)"
    notify "Recording paused" "Click to resume"
}

# Concatenate all parts of a session into one final mp4.
finalize_session() {    # $1 = session id
    local session="$1" sdir out list parts
    [ -z "$session" ] && return 1
    sdir="$(session_dir "$session")"
    [ -d "$sdir" ] || return 1

    # Collect parts in order.
    mapfile -t parts < <(find "$sdir" -maxdepth 1 -name 'part_*.mp4' -type f | sort)
    if [ "${#parts[@]}" -eq 0 ]; then
        rmdir "$sdir" 2>/dev/null
        return 1
    fi

    out="$OUT_DIR/recording_$session.mp4"

    if [ "${#parts[@]}" -eq 1 ]; then
        # Single part: just move it, no concat needed.
        mv -f "${parts[0]}" "$out"
    else
        # Multiple parts: concat losslessly with the ffmpeg concat demuxer.
        list="$sdir/concat.txt"
        : >"$list"
        for p in "${parts[@]}"; do
            printf "file '%s'\n" "$p" >>"$list"
        done
        if ffmpeg -y -f concat -safe 0 -i "$list" -c copy "$out" >/dev/null 2>&1; then
            :
        else
            # Fallback: re-encode if stream copy fails (e.g. mismatched params).
            ffmpeg -y -f concat -safe 0 -i "$list" "$out" >/dev/null 2>&1
        fi
    fi

    # Clean up the session directory (parts + concat list).
    rm -rf "$sdir"
    echo "$out"
}

do_stop() {
    local session
    if is_running; then
        pkill -x "$REC_BIN" >/dev/null 2>&1
        wait_for_exit 60                       # SIGTERM -> graceful finalize
    fi
    session="$(read_state SESSION "")"
    clear_state

    local out
    out="$(finalize_session "$session")"
    if [ -n "$out" ]; then
        notify "Recording saved" "$(basename "$out")"
    fi
}

emit_status() {
    local cls icon tip
    case "$(get_state)" in
        recording)
            cls="recording"; icon="$ICON_RECORDING"
            tip="REC (part $(read_state PART 1))\nLeft: pause  -  Right: stop & save"
            ;;
        paused)
            cls="paused"; icon="$ICON_PAUSED"
            tip="Paused - Left click resumes\nRight: stop & save"
            ;;
        *)
            cls="stopped"; icon="$ICON_STOPPED"
            tip="Start screen recording\n(wf-recorder)"
            ;;
    esac
    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$icon" "$cls" "$tip"
}

case "${1:-status}" in
    toggle)
        exec 9>"$LOCK_FILE"
        flock -n 9 || exit 0                  # ignore rapid double clicks
        case "$(get_state)" in
            stopped)   start_recording ;;
            recording) do_pause ;;
            paused)    resume_recording ;;
        esac
        ;;
    stop)
        exec 9>"$LOCK_FILE"
        flock -n 9 || exit 0
        do_stop
        ;;
esac

emit_status
