#!/bin/sh
# /etc/init.d/picam_service.sh

start()
{
 mjpg_streamer -b -i "/usr/lib/input_uvc.so -d /dev/video0" -o "/usr/lib/output_http.so -p 8080 -w /var/www/mjpg_streamer -n"
}

# regular init script
case "$1" in
        start)
                echo "Starting mjpg_streamer"
                start
                ;;
        stop)
                f_message "Stopping mjpg_streamer"
                killall mjpg_streamer
                ;;
        restart)
                f_message "Restarting daemon: mjpg_streamer"
                killall mjpg_streamer
                start
                sleep 2
                ;;
        status)
                pid=`ps -A | grep mjpg_streamer | grep -v "grep" | grep -v mjpg_streamer. | awk ‘{print $1}’ | head -n 1`
                if [ -n "$pid" ];
                then
                        echo "mjpg_streamer is running with pid ${pid}"
                else
                        echo "Could not find mjpg_streamer running"
                fi
                ;;
        *)
                echo "Usage: $0 {start|stop|status|restart}"
                exit 1
                ;;
esac
exit 0
