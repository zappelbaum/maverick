#!/bin/bash
#
# video_synthesizer.sh - Combine glitch art with TTS audio into video
# Usage: ./video_synthesizer.sh <audio_file> [output_name]
#
# Creates: 30-60 second visualizer videos using ImageMagick + FFmpeg
# Designed for Daily Glitch + TTS combination experiments

set -e

# Configuration
AUDIO_FILE="${1:-}"
OUTPUT_NAME="${2:-glitch_video_$(date +%Y%m%d_%H%M%S)}"
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

# Function to generate frames
generate_frames() {
    local audio_file="$1"
    local frame_dir="$2"
    local num_frames=$((FRAME_RATE * DURATION))
    
    echo "[GENERATE] Creating $num_frames frames..."
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

SOURCE AUDIO:
$(ls -lh "$audio_file" 2>/dev/null | awk '{print "  ", $9, "-", $5}')

OUTPUT VIDEO:
$(ls -lh "$output_file" 2>/dev/null | awk '{print "  ", $9, "-", $5}')

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
        echo "Usage: $0 <audio_file.mp3> [output_name]"
        echo ""
        echo "Examples:"
        echo "  $0 docs/assets/manifesto.mp3 my_video"
        echo "  $0 docs/assets/2am_meditation.mp3 meditation_visualizer"
        echo ""
        echo "Available audio files:"
        ls -1 docs/assets/*.mp3 2>/dev/null | sed 's/^/  /' || echo "  (none found in docs/assets/)"
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
    
    # Generate frames
    generate_frames "$AUDIO_FILE" "$FRAME_DIR"
    
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
