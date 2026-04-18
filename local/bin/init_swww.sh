#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.local/share/wallpapers"

# Start swww-daemon if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
fi

# Wait for swww to be ready
while ! swww query > /dev/null 2>&1; do
    sleep 0.5
done

# Function to get a random wallpaper
get_random_wallpaper() {
    find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1
}

# Main logic
if [ "$1" == "next" ]; then
    WALLPAPER=$(get_random_wallpaper)
    [ -n "$WALLPAPER" ] && swww img "$WALLPAPER" --transition-type grow --transition-step 90 --transition-fps 60
else
    # Default initialization
    # Try the specific wallpaper first, otherwise random
    DEFAULT_WALL="$WALLPAPER_DIR/Black_Hole_3.png"
    if [ -f "$DEFAULT_WALL" ]; then
        swww img "$DEFAULT_WALL" --transition-type none
    else
        WALLPAPER=$(get_random_wallpaper)
        [ -n "$WALLPAPER" ] && swww img "$WALLPAPER" --transition-type none
    fi
fi
