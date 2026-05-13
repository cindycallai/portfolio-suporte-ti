#!/bin/bash

# O script adiciona as últimas 5 linhas de mensagens de erro ao arquivo de log especificado e
# é configurado para ser executado a cada duas horas usando cron.
echo "Mensagens de erro - $(date)" >> /caminho/do/log_monitorado.txt
tail -n 5 /var/log/syslog | grep "error" >> /caminho/do/log_monitorado.txt

# Cron
# Adicione a seguinte linha ao crontab para executar o script a cada duas horas
# 0 */2 * * * /caminho/do/seu/script.sh
