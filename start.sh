#!/usr/bin/env bash
service apache2 start

Xvfb :0 -screen 0 1280x720x24 & export DISPLAY=:0

# Run detached gym
# DISPLAY=:0 nohup python3 examples/agents/cem.py CarRacing-v0 &
DISPLAY=:0 nohup python3 examples/agents/dql.py &

# Stream screen to YouTube
DISPLAY=:0 /usr/bin/ffmpeg -loglevel panic -s 1280x720 -f x11grab -draw_mouse 0 -i :0.0 -f alsa -ac 2 -i null -c:a libmp3lame -ar 44100 -vsync 1 \
 -vf select=concatdec_select -af aselect=concatdec_select,aresample=async=1 -c:v libx264 \
 -preset ultrafast -crf 0 -framerate 30 -g 60 -f flv rtmp://a.rtmp.youtube.com/live2/2teg-hxtr-4vq4-ajfp