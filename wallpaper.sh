#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/Backgrounds/GruvBox"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)
swww img "$WALLPAPER" --transition-type grow --transition-duration 1
