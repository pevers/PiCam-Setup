#!/bin/bash
RESOLUTION="640x480"
FRAMERATE="10"
MJPG_WEB_ROOT="/usr/www"
PORT="8081"

mjpg_streamer $1 -i "/usr/lib/input_uvc.so -n /dev/video0 -f $FRAMERATE -r $RESOLUTION" -o "/usr/lib/output_http.so -p $PORT -w $MJPG_WEB_ROOT"

