#!/bin/bash
# Glitch Lab - Session 8
# Experimenting with advanced ImageMagick techniques

echo "Creating base canvas..."
convert -size 400x400 xc:black \
    -fill '#0a0a0a' -draw "rectangle 50,50 350,350" \
    -fill '#1a1a1a' -draw "rectangle 100,100 300,300" \
    base.png

echo "Base created: base.png"

# Technique 1: Heavy wave distortion
echo "Technique 1: Heavy wave..."
convert base.png \
    -wave 80x200 \
    -modulate 150,80 \
    -fill '#ff3366' -colorize 20% \
    glitch_heavy_wave.png

echo "Created: glitch_heavy_wave.png"

# Technique 2: Radial blur + channel shift
echo "Technique 2: Radial chromatic..."
convert base.png \
    -radial-blur 5 \
    -channel R -roll +10+0 \
    -channel G -roll -5+0 \
    -channel B -roll +0+5 \
    +channel \
    -brightness-contrast 20x30 \
    glitch_radial_chromatic.png

echo "Created: glitch_radial_chromatic.png"

# Technique 3: Noise-driven displacement
echo "Technique 3: Noise displacement..."
convert base.png \
    -noise 10 \
    -blur 0x2 \
    -modulate 120,150 \
    -fill '#00d4aa' -colorize 15% \
    glitch_noise_disp.png

echo "Created: glitch_noise_disp.png"

# Technique 4: Scanline simulation
echo "Technique 4: Scanlines..."
convert base.png \
    -resize 400x400! \
    -ordered-dither h4x4a \
    -modulate 80,120 \
    -stroke '#ff3366' -strokewidth 1 \
    -draw "line 0,50 400,50" \
    -draw "line 0,150 400,150" \
    -draw "line 0,250 400,250" \
    -draw "line 0,350 400,350" \
    glitch_scanlines.png

echo "Created: glitch_scanlines.png"

# Technique 5: Data corruption aesthetic
echo "Technique 5: Data corruption..."
convert base.png \
    -roll +30+0 \
    -crop 350x400+0+0 +repage \
    -resize 400x400! \
    -ordered-dither 2x2 \
    -fill '#ff0000' -colorize 10% \
    -brightness-contrast 10x50 \
    glitch_data_corrupt.png

echo "Created: glitch_data_corrupt.png"

echo ""
echo "All techniques complete!"
echo "Files created:"
ls -la glitch_*.png
