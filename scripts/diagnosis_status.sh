#!/bin/bash
ps -aux | grep "python3 /home/pi/python3_scripts/start_diagnose.py" | grep "SLl" >/dev/null

if [ $? -eq 0 ]; then
        echo 1
else
        echo 0
fi
