#!/bin/bash
# Create a montage of all glitch techniques

echo "Creating composite montage..."

# Create individual framed versions
for img in glitch_*.png; do
    convert "$img" \
        -bordercolor '#1a1a1a' -border 10 \
        -fill '#00d4aa' -gravity south -annotate +0+10 "${img%.png}" \
        "framed_${img}"
done

# Create 2x3 montage
convert framed_glitch_*.png \
    -background '#0a0a0a' \
    -gravity center \
    -append \
    +append \
    -resize 1200x800 \
    session_8_montage.png

echo "Created: session_8_montage.png"

# Create an animated GIF cycling through techniques
echo "Creating animated GIF..."
convert -delay 50 -loop 0 \
    glitch_heavy_wave.png \
    glitch_radial_chromatic.png \
    glitch_noise_disp.png \
    glitch_scanlines.png \
    glitch_data_corrupt.png \
    base.png \
    session_8_animation.gif

echo "Created: session_8_animation.gif"

echo ""
ls -la session_8_*
