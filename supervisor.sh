#!/bin/bash
/usr/bin/docker start master
sleep 10
systemd-notify WATCHDOG=1 --ready
supervisor_log_path="/home/pi/sensor/logs/supervisor.log"
supervisor_echo() {
    echo "[$(date "+%d/%m/%Y %H:%M:%S")] $1" >> $supervisor_log_path
}
supervisor_echo "Supervisor started!"
diagnose_feed_path="/home/pi/sensor/controller/diagnose.feed"
notifyDelay=$(($WATCHDOG_USEC / 2000000))
count=0
while [[ $count -lt 4 ]]; do
    diagnose_feed=$(cat $diagnose_feed_path)
    flask_feed=$(curl -s http://localhost:8000/flask_feed)
    if [ "$flask_feed" != "1" ]; then
        supervisor_echo "Flask feed failed (count = $count)"
    fi
    if [ "$diagnose_feed" != "1" ]; then
        supervisor_echo "Diagnose feed failed (count = $count)"
    fi
    if [ "$diagnose_feed" != "1" ] || [ "$flask_feed" != "1" ]; then
        count=$((count + 1))
    else
        count=0
    fi
    flask_feed="0"
    echo "0" > $diagnose_feed_path
    systemd-notify WATCHDOG=1 --status="Service is alive and running..."
    sleep $notifyDelay
done
systemd-notify WATCHDOG=1 --status="Blocking Supervisor Script..."
/usr/bin/docker stop master
supervisor_echo "Processes not responding. Entering infinite loop to block..."
while true; do
    sleep 1
done


