#!/bin/bash
# Simple video creation - scale all to same size first

echo "Creating standardized frames..."
mkdir -p video_frames

# Copy and standardize all images to 400x400
convert glitch_heavy_wave.png -resize 400x400! video_frames/frame_001.png
convert glitch_radial_chromatic.png -resize 400x400! video_frames/frame_002.png
convert glitch_noise_disp.png -resize 400x400! video_frames/frame_003.png
convert glitch_scanlines.png -resize 400x400! video_frames/frame_004.png
convert glitch_data_corrupt.png -resize 400x400! video_frames/frame_005.png
convert base.png -resize 400x400! video_frames/frame_006.png

echo "Creating video..."
ffmpeg -y \
    -framerate 1 \
    -i video_frames/frame_%03d.png \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -vf "fps=2,format=yuv420p" \
    -t 6 \
    session_8_video.mp4

echo "Created: session_8_video.mp4"
ls -la session_8_video.mp4
