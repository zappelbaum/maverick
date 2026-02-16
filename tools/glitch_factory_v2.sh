#!/bin/bash
#
# glitch_factory_v2.sh - Intelligent Glitch Art Pipeline
# Version: 2.0
# Purpose: Remove friction from glitch art creation with presets & batch processing
#
# Usage: ./glitch_factory_v2.sh [options]
#   -m, --mode MODE       Preset: subtle|aggressive|retro|chromatic|liminal
#   -t, --text "TEXT"     Input text (or use -i for image)
#   -i, --image FILE      Input image instead of text
#   -b, --batch DIR       Process all images in directory
#   -s, --seed NUM        Random seed for reproducibility
#   -v, --video           Output video sequence instead of static
#   -o, --output DIR      Custom output directory
#   --daily               Auto-commit to Daily Glitch format
#   --montage             Create comparison montage
#   --no-meta             Skip metadata generation
#

set -e

# === CONFIGURATION ===
VERSION="2.0"
WIDTH=800
HEIGHT=400
FONT_SIZE=48
DEFAULT_MODE="aggressive"

# Colors
c_reset="\033[0m"
c_cyan="\033[36m"
c_magenta="\033[35m"
c_green="\033[32m"
c_yellow="\033[33m"
c_red="\033[31m"

# === ARGUMENT PARSING ===
MODE="$DEFAULT_MODE"
TEXT=""
INPUT_IMAGE=""
BATCH_DIR=""
SEED=""
VIDEO_MODE=false
OUTPUT_DIR=""
DAILY_MODE=false
MONTAGE=true
META=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--mode) MODE="$2"; shift 2 ;;
        -t|--text) TEXT="$2"; shift 2 ;;
        -i|--image) INPUT_IMAGE="$2"; shift 2 ;;
        -b|--batch) BATCH_DIR="$2"; shift 2 ;;
        -s|--seed) SEED="$2"; shift 2 ;;
        -v|--video) VIDEO_MODE=true; shift ;;
        -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
        --daily) DAILY_MODE=true; shift ;;
        --no-montage) MONTAGE=false; shift ;;
        --no-meta) META=false; shift ;;
        -h|--help)
            echo "Glitch Factory v$VERSION"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Modes:"
            echo "  subtle      - Gentle distortion, readable text"
            echo "  aggressive  - Heavy corruption, barely legible"
            echo "  retro       - CRT scanlines, phosphor glow, green tint"
            echo "  chromatic   - RGB channel separation"
            echo "  liminal     - Uncanny, dreamlike, unsettling"
            echo ""
            echo "Examples:"
            echo "  $0 -t 'HELLO WORLD' -m retro"
            echo "  $0 -i photo.jpg -m aggressive --daily"
            echo "  $0 -b ./photos/ -m subtle"
            echo "  $0 -t 'GLITCH' -m chromatic -s 42 --video"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# === MODE PRESETS ===
declare -A PRESET_WAVE
declare -A PRESET_NOISE
declare -A PRESET_ROLL
declare -A PRESET_BLUR
declare -A PRESET_MODULATE
declare -A PRESET_POSTERIZE
declare -A PRESET_COLOR

# Subtle: Readable, professional
echo ""
echo "hello from glitch factory"
echo ""
