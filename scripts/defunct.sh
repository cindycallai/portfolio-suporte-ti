#!/bin/bash
ps -aux | grep "<defunct>" | grep "Z" >/dev/null

if [ $? -eq 0 ]; then
        echo 1

else
        echo 0

fi
