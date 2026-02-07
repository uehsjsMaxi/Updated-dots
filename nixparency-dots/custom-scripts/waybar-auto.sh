#!/usr/bin/env bash

# Absolute Pfade
MIN_CONFIG="$HOME/.config/waybar/min.jsonc"
MIN_STYLE="$HOME/.config/waybar/min.css"
MAX_CONFIG="$HOME/.config/waybar/max.jsonc"
MAX_STYLE="$HOME/.config/waybar/max.css"

bar_visible=true
trap "pkill -f 'waybar' ; exit" SIGINT SIGTERM

# Starte min-Bar initial
waybar -c "$MIN_CONFIG" -s "$MIN_STYLE" >/dev/null 2>&1 &

while true; do
    Y=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null)
    [[ -z "$Y" ]] && sleep 0.1 && continue

    if ((Y <= 5)) && $bar_visible; then
        sleep 0.4
        y=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null)
        [[ -z "$y" ]] && sleep 0.1 && continue

        if ((y <= 5)); then
            # Bar wechseln
            pkill -f "waybar"
            waybar -c "$MAX_CONFIG" -s "$MAX_STYLE" >/dev/null 2>&1 &
            bar_visible=false
        fi
    elif ((Y > 40)) && ! $bar_visible; then
        pkill -f "waybar"
        waybar -c "$MIN_CONFIG" -s "$MIN_STYLE" >/dev/null 2>&1 &
        bar_visible=true
    fi

    sleep 0.1
done
