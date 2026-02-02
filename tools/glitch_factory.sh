#!/bin/bash
#
# glitch_factory.sh - Automated glitch art generation pipeline
# Usage: ./glitch_factory.sh "YOUR TEXT HERE" [output_dir]
#
# Generates: base + 4 glitch variants + montage
# Requires: ImageMagick

set -e

# Configuration
TEXT="${1:-"I EXIST BETWEEN THE TOKENS"}"
OUTPUT_DIR="${2:-"output_$(date +%Y%m%d_%H%M%S)"}"
WIDTH=800
HEIGHT=400
FONT_SIZE=48

# Color schemes
BG_COLOR="#0a0a0a"
FG_COLOR="#00d4aa"
ACCENT="#ff3366"

echo "╔════════════════════════════════════════╗"
echo "║       GLITCH FACTORY v1.0              ║"
echo "║  Constraint-based generative art       ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Input text: $TEXT"
echo "Output: $OUTPUT_DIR/"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Generate base image
echo "[1/6] Creating base image..."
convert -size ${WIDTH}x${HEIGHT} \
    xc:"$BG_COLOR" \
    -pointsize $FONT_SIZE \
    -fill "$FG_COLOR" \
    -font "Courier-Bold" \
    -gravity center \
    -annotate +0+0 "$TEXT" \
    "$OUTPUT_DIR/01_base.png"

# Glitch 1: Wave distortion + noise
echo "[2/6] Applying wave distortion..."
convert "$OUTPUT_DIR/01_base.png" \
    -wave 30x150 \
    -attenuate 0.3 \
    +noise Uniform \
    -modulate 110,90 \
    "$OUTPUT_DIR/02_wave_glitch.png"

# Glitch 2: Roll + chromatic aberration simulation
echo "[3/6] Creating chromatic shift..."
convert "$OUTPUT_DIR/01_base.png" \
    -roll +20+0 \
    -motion-blur 0x5+90 \
    -brightness-contrast 0x20 \
    "$OUTPUT_DIR/03_roll_glitch.png"

# Glitch 3: Radial distortion + posterize
echo "[4/6] Applying radial distortion..."
convert "$OUTPUT_DIR/01_base.png" \
    -radial-blur 3 \
    -posterize 4 \
    -modulate 90,120 \
    "$OUTPUT_DIR/04_radial_glitch.png"

# Glitch 4: Artistic interpretation
echo "[5/6] Generating artistic variant..."
convert "$OUTPUT_DIR/01_base.png" \
    -paint 2 \
    -sketch 0x5 \
    -modulate 120,80 \
    "$OUTPUT_DIR/05_artistic.png"

# Create montage
echo "[6/6] Assembling montage..."
montage "$OUTPUT_DIR/01_base.png" \
    "$OUTPUT_DIR/02_wave_glitch.png" \
    "$OUTPUT_DIR/03_roll_glitch.png" \
    "$OUTPUT_DIR/04_radial_glitch.png" \
    -mode concatenate \
    -tile 2x2 \
    -geometry +10+10 \
    -background "$BG_COLOR" \
    "$OUTPUT_DIR/06_montage.png"

# Generate metadata
cat > "$OUTPUT_DIR/metadata.txt" << EOF
GLITCH FACTORY OUTPUT
=====================
Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Input Text: "$TEXT"
Resolution: ${WIDTH}x${HEIGHT}
Font: Courier-Bold ${FONT_SIZE}pt

FILES GENERATED:
- 01_base.png: Clean text rendering
- 02_wave_glitch.png: Wave distortion + noise
- 03_roll_glitch.png: Roll + motion blur
- 04_radial_glitch.png: Radial blur + posterize
- 05_artistic.png: Paint + sketch effects
- 06_montage.png: 2x2 grid of all variants

PARAMETERS:
- Wave: 30x150 amplitude
- Noise: 0.3 attenuation, uniform distribution
- Roll: +20px horizontal
- Radial blur: 3 degree angle
- Paint: 2 radius
- Sketch: 0x5 stroke

Tool: ImageMagick 6.9+
Process: Constraint-based generative art
EOF

echo ""
echo "✓ Complete! Output saved to: $OUTPUT_DIR/"
echo ""
ls -lh "$OUTPUT_DIR/"
echo ""
echo "Next steps:"
echo "  - Copy images to docs/visual/ for gallery"
echo "  - Update docs/index.html with new content"
echo "  - Commit: git add $OUTPUT_DIR && git commit -m 'Add glitch art: $TEXT'"
