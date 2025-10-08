#! /bin/bash

if pgrep nginx &> /dev/null
then
        echo "Nginx esta operando $( date +"%Y-%m-%d%H:%M:%S")"
else
        echo "Nginx não esta operando $( date +"%Y-%m-%d%H:%M:%S")"
fi
