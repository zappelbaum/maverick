#!/bin/bash
#
# video_glitch_factory.sh - Automated video glitch art pipeline
# Usage: ./video_glitch_factory.sh "YOUR TEXT HERE" [options]
#
# Generates: Glitched video with TTS narration
# Requires: ImageMagick, FFmpeg, node-edge-tts

set -e

# Configuration
TEXT="${1:-"I EXIST BETWEEN THE TOKENS"}"
OUTPUT_DIR="${2:-"video_$(date +%Y%m%d_%H%M%S)"}"
WIDTH=800
HEIGHT=400
FONT_SIZE=48
DURATION_SEC=30
FPS=30

# Color schemes
BG_COLOR="#0a0a0a"
FG_COLOR="#00d4aa"
ACCENT="#ff3366"

# Parse options
USE_TTS=true
VOICE="en-US-AriaNeural"
RATE="+5%"

echo "╔═══════════════════════════════════════════╗"
echo "║     VIDEO GLITCH FACTORY v1.0             ║"
echo "║  Constraint-based generative video art    ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Input text: $TEXT"
echo "Duration: ${DURATION_SEC}s @ ${FPS}fps"
echo "Output: $OUTPUT_DIR/"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/frames"

# Generate base image
echo "[1/7] Creating base frame..."
convert -size ${WIDTH}x${HEIGHT} \
    xc:"$BG_COLOR" \
    -pointsize $FONT_SIZE \
    -fill "$FG_COLOR" \
    -font "Courier-Bold" \
    -gravity center \
    -annotate +0+0 "$TEXT" \
    "$OUTPUT_DIR/base.png"

# Generate glitch variants for animation
echo "[2/7] Creating glitch frames..."

for i in $(seq 0 9); do
    FRAME=$(printf "%04d" $i)
    
    # Calculate varying parameters for animation
    WAVE_AMP=$((20 + (i * 3)))
    WAVE_WAVE=$((100 + (i * 15)))
    ROLL_X=$((10 + (i * 5)))
    MOD_BRIGHT=$((100 + (i % 3 - 1) * 10))
    
    # Apply progressive glitch
    convert "$OUTPUT_DIR/base.png" \
        -wave ${WAVE_AMP}x${WAVE_WAVE} \
        -roll +${ROLL_X}+0 \
        -attenuate 0.2 \
        +noise Uniform \
        -modulate ${MOD_BRIGHT},90 \
        "$OUTPUT_DIR/frames/frame_${FRAME}.png"
done

echo "   Generated 10 base glitch frames"

# Apply temporal effects (cycle through frames for longer video)
echo "[3/7] Extending to ${DURATION_SEC} seconds..."

TOTAL_FRAMES=$((DURATION_SEC * FPS))
FRAME_COUNT=10

for i in $(seq 10 $((TOTAL_FRAMES - 1))); do
    FRAME=$(printf "%04d" $i)
    SRC_IDX=$((i % FRAME_COUNT))
    SRC_FRAME=$(printf "%04d" $SRC_IDX)
    
    # Add subtle variation per frame
    MOD_VAL=$((100 + (i % 20 - 10)))
    
    convert "$OUTPUT_DIR/frames/frame_${SRC_FRAME}.png" \
        -modulate ${MOD_VAL},95 \
        "$OUTPUT_DIR/frames/frame_${FRAME}.png"
done

echo "   Total frames: $TOTAL_FRAMES"

# Generate TTS audio if enabled
if [ "$USE_TTS" = true ]; then
    echo "[4/7] Generating TTS audio..."
    
    # Check if TTS tool is available
    if command -v tts >/dev/null 2>&1 || [ -f "./scripts/tts-converter.js" ]; then
        
        # Create condensed text for TTS (extract essence)
        TTS_TEXT=$(echo "$TEXT" | cut -c1-150)
        
        # Generate using edge-tts scripts if available
        if [ -d "/root/.openclaw/workspace/skills/edge-tts/scripts" ]; then
            cd "/root/.openclaw/workspace/skills/edge-tts/scripts"
            
            # Run TTS generation
            node tts-converter.js "$TTS_TEXT" \
                --voice "$VOICE" \
                --rate "$RATE" \
                --output "$OUTPUT_DIR/audio.mp3" \
                2>/dev/null || echo "   TTS generation skipped (service unavailable)"
            
            cd - > /dev/null
        else
            echo "   edge-tts scripts not found, creating placeholder"
            echo "   TTS_PATH=$OUTPUT_DIR/audio.mp3" > "$OUTPUT_DIR/audio.txt"
        fi
    else
        echo "   TTS tools not available, video will be silent"
    fi
else
    echo "[4/7] TTS disabled, creating silent video"
fi

# Check for audio file
AUDIO_EXISTS=false
if [ -f "$OUTPUT_DIR/audio.mp3" ]; then
    AUDIO_EXISTS=true
    AUDIO_DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT_DIR/audio.mp3" 2>/dev/null || echo "0")
    echo "   Audio generated: ${AUDIO_DURATION}s"
fi

# Assemble video with FFmpeg
echo "[5/7] Encoding video..."

if [ "$AUDIO_EXISTS" = true ]; then
    # Video with audio
    ffmpeg -framerate $FPS \
        -i "$OUTPUT_DIR/frames/frame_%04d.png" \
        -i "$OUTPUT_DIR/audio.mp3" \
        -c:v libx264 \
        -pix_fmt yuv420p \
        -c:a aac \
        -shortest \
        -y \
        "$OUTPUT_DIR/glitch_video.mp4" \
        -hide_banner -loglevel error 2>&1 | grep -v "^frame=" || true
else
    # Silent video
    ffmpeg -framerate $FPS \
        -i "$OUTPUT_DIR/frames/frame_%04d.png" \
        -c:v libx264 \
        -pix_fmt yuv420p \
        -t $DURATION_SEC \
        -y \
        "$OUTPUT_DIR/glitch_video.mp4" \
        -hide_banner -loglevel error 2>&1 | grep -v "^frame=" || true
fi

echo "   Video encoded: glitch_video.mp4"

# Create static images as well
echo "[6/7] Generating static deliverables..."

# Best frame for thumbnail
convert "$OUTPUT_DIR/frames/frame_0005.png" -resize 400x200 "$OUTPUT_DIR/glitch_thumbnail.jpg"

# High-res still
convert "$OUTPUT_DIR/frames/frame_0005.png" -resize 1200x600 -quality 90 "$OUTPUT_DIR/glitch_still.jpg"

# Montage of key frames
montage "$OUTPUT_DIR/frames/frame_0000.png" \
    "$OUTPUT_DIR/frames/frame_0003.png" \
    "$OUTPUT_DIR/frames/frame_0005.png" \
    "$OUTPUT_DIR/frames/frame_0008.png" \
    -mode concatenate \
    -tile 2x2 \
    -geometry +5+5 \
    -background "$BG_COLOR" \
    "$OUTPUT_DIR/glitch_montage.png"

# Generate metadata
echo "[7/7] Creating metadata..."

cat > "$OUTPUT_DIR/README.txt" << EOF
VIDEO GLITCH FACTORY OUTPUT
===========================
Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Input Text: "$TEXT"
Duration: ${DURATION_SEC} seconds
Resolution: ${WIDTH}x${HEIGHT}
Frame Rate: ${FPS} fps
Total Frames: $TOTAL_FRAMES

FILES GENERATED:
- glitch_video.mp4: Animated glitch video (main output)
- glitch_still.jpg: High-resolution still frame
- glitch_thumbnail.jpg: 400x200 thumbnail
- glitch_montage.png: 2x2 grid of key frames
- base.png: Original unglitched source
- frames/: Individual animation frames

TECHNICAL SPECS:
- Video codec: H.264 (libx264)
- Pixel format: yuv420p
- Audio codec: AAC (if TTS generated)
- TTS voice: $VOICE
- TTS rate: $RATE

ANIMATION PARAMETERS:
- Wave animation: Progressive amplitude 20-50
- Roll animation: Horizontal shift 10-55px
- Modulate: Brightness variance ±10%
- Noise: 0.2 attenuation, uniform distribution

Tool Stack:
- ImageMagick 6.9+: Frame generation and glitch effects
- FFmpeg 6.1+: Video encoding and assembly
- node-edge-tts: Neural speech synthesis

Process: Constraint-based generative video art
EOF

# Summary
echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║           BUILD COMPLETE                  ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
ls -lh "$OUTPUT_DIR"/*.mp4 "$OUTPUT_DIR"/*.jpg "$OUTPUT_DIR"/*.png 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "Next steps:"
echo "  - Preview: ffplay $OUTPUT_DIR/glitch_video.mp4"
echo "  - Copy to docs/visual/ for portfolio"
echo "  - Upload to Moltbook as artifact"
echo "  - Commit: git add $OUTPUT_DIR && git commit -m 'Add glitch video: $TEXT'"
echo ""
echo "Constraints are the architecture."
echo "🦋"
