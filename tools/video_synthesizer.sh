#!/bin/bash
#
# video_synthesizer.sh - Combine glitch art with TTS audio into video
# Usage: ./video_synthesizer.sh [options] <audio_file> [output_name]
#
# Creates: 30-60 second visualizer videos using ImageMagick + FFmpeg
# Designed for Daily Glitch + TTS combination experiments
#
# Options:
#   --image <path>    Use glitch image as base (animates it)
#   --procedural      Force procedural generation (default if no image)
#
# Examples:
#   ./video_synthesizer.sh docs/assets/manifesto.mp3 my_video
#   ./video_synthesizer.sh --image artifacts/glitch.png manifesto.mp3 animated_glitch

set -e

# Parse arguments
USE_IMAGE=""
SOURCE_IMAGE=""
AUDIO_FILE=""
OUTPUT_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --image)
            USE_IMAGE="yes"
            SOURCE_IMAGE="$2"
            shift 2
            ;;
        --procedural)
            USE_IMAGE=""
            shift
            ;;
        *)
            if [ -z "$AUDIO_FILE" ]; then
                AUDIO_FILE="$1"
            elif [ -z "$OUTPUT_NAME" ]; then
                OUTPUT_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Defaults
OUTPUT_NAME="${OUTPUT_NAME:-glitch_video_$(date +%Y%m%d_%H%M%S)}"
OUTPUT_DIR="/root/.openclaw/workspace/docs/video"
FRAME_RATE=15
RESOLUTION="1280x720"
DURATION=30

# Colors for visual identity
BG_COLOR="#0a0a12"
GLITCH_COLOR="#00d4aa"
ACCENT_COLOR="#ff3366"

# Function to print header
print_header() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║               VIDEO SYNTHESIZER v1.0                         ║"
    echo "║     Glitch Art × TTS Audio × Motion Graphics                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Function to check dependencies
check_deps() {
    command -v ffmpeg >/dev/null 2>&1 || { echo "Error: ffmpeg not found"; exit 1; }
    command -v convert >/dev/null 2>&1 || { echo "Error: ImageMagick not found"; exit 1; }
}

# Function to generate frames from code (procedural)
generate_frames_procedural() {
    local audio_file="$1"
    local frame_dir="$2"
    local num_frames=$((FRAME_RATE * DURATION))
    
    echo "[GENERATE] Procedural mode: Creating $num_frames frames..."
    echo "           This may take a moment."
    
    for i in $(seq -w 0 $((num_frames - 1))); do
        # Calculate progression (0.0 to 1.0)
        local progress=$(echo "scale=4; $i / $num_frames" | bc)
        local frame_num=$(echo "$i" | sed 's/^0*//')
        [ -z "$frame_num" ] && frame_num=0
        
        # Dynamic parameters based on progress
        local wave_amp=$(echo "30 + ($frame_num * 0.5) % 100" | bc)
        local roll_x=$((frame_num % 50))
        local mod_brightness=$(echo "100 + ($frame_num * 0.2) % 40" | bc)
        local noise_level=$(echo "0.1 + ($progress * 0.5)" | bc)
        
        # Generate unique frame
        convert -size "$RESOLUTION" xc:"$BG_COLOR" \
            -fill "$GLITCH_COLOR" \
            -font "Courier-Bold" \
            -pointsize 32 \
            -gravity center \
            -annotate +0+0 "EXISTING\nBETWEEN\nTOKENS" \
            -wave "${wave_amp}x150" \
            -noise Gaussian \
            -attenuate "$noise_level" \
            -roll "+${roll_x}+0" \
            -modulate "${mod_brightness},90" \
            "${frame_dir}/frame_${i}.png" 2>/dev/null || \
        convert -size "$RESOLUTION" xc:"$BG_COLOR" \
            -fill "$GLITCH_COLOR" \
            -pointsize 32 \
            -gravity center \
            -annotate +0+0 "EXISTING\nBETWEEN\nTOKENS" \
            "${frame_dir}/frame_${i}.png"
        
        # Progress indicator every 10%
        local mod_val=$((frame_num % (num_frames / 10)))
        if [ $mod_val -eq 0 ]; then
            local percent=$((frame_num * 100 / num_frames))
            echo "           Progress: ${percent}%"
        fi
    done
    
    echo "           Frames complete: ${num_frames} generated"
}

# Function to generate frames from image (animates existing glitch)
generate_frames_from_image() {
    local source_image="$1"
    local frame_dir="$2"
    local num_frames=$((FRAME_RATE * DURATION))
    
    echo "[GENERATE] Image mode: Animating $(basename "$source_image")"
    echo "           Creating $num_frames frames from source..."
    
    # Get image dimensions, resize to resolution if needed
    local img_width=$(identify -format "%w" "$source_image" 2>/dev/null || echo "1280")
    local img_height=$(identify -format "%h" "$source_image" 2>/dev/null || echo "720")
    
    echo "           Source: ${img_width}x${img_height}"
    
    for i in $(seq -w 0 $((num_frames - 1))); do
        local frame_num=$(echo "$i" | sed 's/^0*//')
        [ -z "$frame_num" ] && frame_num=0
        
        # Progress through animation (0.0 to 1.0 to 0.0 for ping-pong)
        local progress=$(echo "scale=4; $frame_num / $num_frames" | bc)
        local half_num_frames=$((num_frames / 2))
        local ping_pong
        if [ $frame_num -lt $half_num_frames ]; then
            ping_pong=$(echo "scale=4; $frame_num / $half_num_frames" | bc)
        else
            local reverse=$((num_frames - frame_num))
            ping_pong=$(echo "scale=4; $reverse / $half_num_frames" | bc)
        fi
        
        # Dynamic parameters (subtle, to preserve image integrity)
        local wave_amp=$(echo "scale=0; 10 + ($ping_pong * 40)" | bc | cut -d. -f1)
        local roll_x=$((frame_num % 20))  # Gentle horizontal shift
        local roll_y=$((frame_num % 10))  # Gentle vertical shift
        local mod_brightness=$(echo "scale=0; 95 + ($ping_pong * 20)" | bc | cut -d. -f1)
        local mod_contrast=$(echo "scale=0; 90 + ($ping_pong * 20)" | bc | cut -d. -f1)
        local rad_blur=$(echo "scale=1; $ping_pong * 2" | bc)
        
        # Apply effects to source image
        convert "$source_image" \
            -resize "${RESOLUTION}^>" -extent "$RESOLUTION" -gravity center \
            -wave "${wave_amp}x80" \
            -roll "+${roll_x}+${roll_y}" \
            -radial-blur "${rad_blur}" \
            -modulate "${mod_brightness},${mod_contrast}" \
            "${frame_dir}/frame_${i}.png" 2>/dev/null || \
        convert "$source_image" \
            -resize "$RESOLUTION" -extent "$RESOLUTION" -gravity center \
            "${frame_dir}/frame_${i}.png"
        
        # Progress indicator every 10%
        local mod_val=$((frame_num % (num_frames / 10)))
        if [ $mod_val -eq 0 ] && [ $frame_num -gt 0 ]; then
            local percent=$((frame_num * 100 / num_frames))
            echo "           Progress: ${percent}%"
        fi
    done
    
    echo "           Frames complete: ${num_frames} generated"
}

# Function to create video with audio
assemble_video() {
    local frame_dir="$1"
    local audio_file="$2"
    local output_file="$3"
    
    echo "[ASSEMBLE] Creating video with FFmpeg..."
    
    ffmpeg -y \
        -framerate "$FRAME_RATE" \
        -i "${frame_dir}/frame_%02d.png" \
        -i "$audio_file" \
        -c:v libx264 \
        -pix_fmt yuv420p \
        -c:a aac \
        -shortest \
        -movflags +faststart \
        "$output_file" 2>/dev/null || {
            echo "Warning: Full video generation failed, creating silent version..."
            ffmpeg -y \
                -framerate "$FRAME_RATE" \
                -i "${frame_dir}/frame_%02d.png" \
                -c:v libx264 \
                -pix_fmt yuv420p \
                -t "$DURATION" \
                -movflags +faststart \
                "$output_file"
        }
}

# Function to generate metadata
generate_metadata() {
    local output_file="$1"
    local audio_file="$2"
    local meta_file="$3"
    
    cat > "$meta_file" << EOF
VIDEO SYNTHESIS MANIFEST
========================
Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Filename: $(basename "$output_file")
Resolution: $RESOLUTION
Frame Rate: ${FRAME_RATE}fps
Duration: ${DURATION}s
Total Frames: $((FRAME_RATE * DURATION))

$(if [ -n "$USE_IMAGE" ]; then echo "SOURCE IMAGE:"; echo "  $SOURCE_IMAGE ($(identify -format '%wx%h' "$SOURCE_IMAGE" 2>/dev/null || echo 'unknown dimensions'))"; echo ""; fi)SOURCE AUDIO:
$(ls -lh "$audio_file" 2>/dev/null | awk '{print "  ", $9, "-", $5}')

OUTPUT VIDEO:
$(ls -lh "$output_file" 2>/dev/null | awk '{print "  ", $9, "-", $5}')

MODE: $(if [ -n "$USE_IMAGE" ]; then echo "IMAGE_ANIMATION (source-based)"; else echo "PROCEDURAL (code-generated)"; fi)

PROCESS:
1. Dynamic frame generation with evolving distortion parameters
2. Wave distortion with amplitude progression: 30→130
3. Chromatic roll cycling 0-50px
4. Brightness modulation: 100%-140%
5. Noise intensification: 0.1→0.6
6. Frame assembly via FFmpeg
7. Audio overlay and compression

Tools:
- ImageMagick: Frame generation and compositing
- FFmpeg: Video encoding and audio mixing
- ffmpeg version: $(ffmpeg -version | head -1 | awk '{print $3}')

Constraint: Generative video from procedural parameters
Output: $OUTPUT_DIR/
EOF
}

# Main execution
main() {
    print_header
    
    # Validate input
    if [ -z "$AUDIO_FILE" ]; then
        echo "Usage: $0 [--image <path>] <audio_file.mp3> [output_name]"
        echo ""
        echo "Generate glitch video from procedural code OR animate existing glitch image."
        echo ""
        echo "Modes:"
        echo "  Procedural (default): Code-generated frames with 'EXISTING BETWEEN TOKENS'"
        echo "  Image (--image):      Animate existing glitch with wave/roll/blur effects"
        echo ""
        echo "Examples:"
        echo "  $0 docs/assets/manifesto.mp3 my_video"
        echo "  $0 --image docs/glitch.png manifesto.mp3 animated_glitch"
        echo ""
        echo "Available audio files:"
        ls -1 docs/assets/*.mp3 2>/dev/null | sed 's/^/  /' || echo "  (none found in docs/assets/)"
        echo ""
        echo "Glitch images for animation:"
        ls -1 docs/visual/*.png artifacts/*.png 2>/dev/null | head -5 | sed 's/^/  /' || echo "  (no images found)"
        exit 1
    fi
    
    if [ ! -f "$AUDIO_FILE" ]; then
        echo "Error: Audio file not found: $AUDIO_FILE"
        exit 1
    fi
    
    check_deps
    
    # Setup directories
    mkdir -p "$OUTPUT_DIR"
    FRAME_DIR=$(mktemp -d /tmp/glitch_frames_XXXXXX)
    
    local output_video="${OUTPUT_DIR}/${OUTPUT_NAME}.mp4"
    local metadata_file="${OUTPUT_DIR}/${OUTPUT_NAME}_manifest.txt"
    
    echo "Configuration:"
    echo "  Audio:    $AUDIO_FILE"
    echo "  Output:   $output_video"
    echo "  Frames:   $FRAME_DIR"
    echo "  Duration: ${DURATION}s @ ${FRAME_RATE}fps"
    echo ""
    
    # Generate frames (route based on mode)
    if [ -n "$USE_IMAGE" ] && [ -f "$SOURCE_IMAGE" ]; then
        generate_frames_from_image "$SOURCE_IMAGE" "$FRAME_DIR"
    else
        generate_frames_procedural "$AUDIO_FILE" "$FRAME_DIR"
    fi
    
    # Assemble video
    assemble_video "$FRAME_DIR" "$AUDIO_FILE" "$output_video"
    
    # Generate metadata
    generate_metadata "$output_video" "$AUDIO_FILE" "$metadata_file"
    
    # Cleanup frames
    rm -rf "$FRAME_DIR"
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    VIDEO COMPLETE                            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    ls -lh "$output_video" "$metadata_file" 2>/dev/null | tail -2
    echo ""
    echo "Next steps:"
    echo "  - View: ffplay $output_video"
    echo "  - Deploy: Add to GitHub Pages gallery"
    echo "  - Share: Copy to docs/assets/ for distribution"
    echo "  - Commit: git add $output_video $metadata_file"
    echo ""
}

main "$@"
