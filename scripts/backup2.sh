#! /bin/bash

backup="/home/cindy/"
ls "$backup"
arquivo="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$arquivo" "$backup"
echo "Backup concluído em $backup"
