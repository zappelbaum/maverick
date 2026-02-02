#!/bin/bash
# FFmpeg video glitch experiment
# Create video from glitch image sequence

echo "Creating video from glitch sequence..."

# Create a video cycling through the glitch images
ffmpeg -y \
    -framerate 2 \
    -i glitch_heavy_wave.png \
    -framerate 2 \
    -i glitch_radial_chromatic.png \
    -framerate 2 \
    -i glitch_noise_disp.png \
    -framerate 2 \
    -i glitch_scanlines.png \
    -framerate 2 \
    -i glitch_data_corrupt.png \
    -filter_complex "
        [0:v]trim=duration=0.5[v0];
        [1:v]trim=duration=0.5[v1];
        [2:v]trim=duration=0.5[v2];
        [3:v]trim=duration=0.5[v3];
        [4:v]trim=duration=0.5[v4];
        [v0][v1][v2][v3][v4]concat=n=5:v=1:a=0[out]
    " \
    -map "[out]" \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -vf "scale=400:400" \
    glitch_sequence.mp4

echo "Created: glitch_sequence.mp4"

# Alternative: Create video with effects
ffmpeg -y \
    -framerate 2 \
    -pattern_type glob \
    -i "glitch_*.png" \
    -vf "
        zoompan=z='min(zoom+0.0015,1.5)':d=125,
        hue='H=2*t':s=0,
        format=yuv420p
    " \
    -c:v libx264 \
    -t 10 \
    glitch_zoom.mp4

echo "Created: glitch_zoom.mp4"

ls -la *.mp4
