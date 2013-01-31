#!/bin/bash
# /etc/init.d/picam_service.sh

RESOLUTION="640x480"
FRAMERATE="10"
MJPG_WEB_ROOT="/usr/www"
PORT="8081"

function startStreamer()
{
    mjpg_streamer -b -i "/usr/lib/input_uvc.so -d /dev/video0 -f $FRAMERATE -r $RESOLUTION" -o "/usr/lib/output_http.so -p $PORT -w $MJPG_WEB_ROOT" &
}

# regular init script
case "$1" in
        start)
                echo "Starting mjpg_streamer"
                startStreamer
                ;;
        stop)
                echo "Stopping mjpg_streamer"
                killall mjpg_streamer
                ;;
	status)
		echo "Not supported yet"
		;;
        restart)
                echo "Restarting daemon: mjpg_streamer"
                killall mjpg_streamer
                start
                sleep 2
                ;;
        *)
                echo "Usage: $0 {start|stop|restart}"
                exit 1
                ;;
esac
exit 0
