#!/bin/bash
# Create video with audio overlay
# Glitch visuals + TTS manifesto

echo "Creating multimedia piece..."

# Create extended visual sequence with the existing frames
ffmpeg -y \
    -framerate 0.5 \
    -i experiments/session_8/video_frames/frame_%03d.png \
    -i experiments/assets/manifesto.mp3 \
    -c:v libx264 \
    -pix_fmt yuv420p \
    -c:a aac \
    -shortest \
    -vf "fps=1,format=yuv420p,scale=400:400" \
    experiments/session_8/manifesto_visual.mp4

echo "Created: manifesto_visual.mp4"
ls -la experiments/session_8/manifesto_visual.mp4
