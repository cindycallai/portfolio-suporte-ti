# Criar script de monitoramento

Crie um arquivo sudo nano /usr/local/bin/check-network.sh com o conteúdo:

#!/bin/bash

# IP para testar
TARGET="8.8.8.8"
# Número de pings consecutivos falhando antes de reiniciar
FAIL_LIMIT=3

FAIL_COUNT=0

while true; do
    ping -c 1 -W 2 $TARGET >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        ((FAIL_COUNT++))
        echo "$(date) - Falha de rede detectada ($FAIL_COUNT/$FAIL_LIMIT)" >> /var/log/network-watch.log
    else
        FAIL_COUNT=0
    fi

    if [ $FAIL_COUNT -ge $FAIL_LIMIT ]; then
        echo "$(date) - Reiniciando host devido falha de rede" >> /var/log/network-watch.log
        /sbin/reboot
    fi

    sleep 10
done

# TARGET é o host que será pingado (pode ser um gateway ou DNS confiável).
# FAIL_LIMIT é quantos pings consecutivos falharão antes de reiniciar.
# Depois, dê permissão de execução:
# sudo chmod +x /usr/local/bin/check-network.sh


# Criar serviço systemd

# Crie sudo nano /etc/systemd/system/network-watch.service:

[Unit]
Description=Monitora rede e reinicia host em caso de falha
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/check-network.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target

Ativar e iniciar serviço
sudo systemctl daemon-reload
sudo systemctl enable network-watch.service
sudo systemctl start network-watch.service
sudo systemctl status network-watch.service

Pronto. Agora seu host vai monitorar a rede e reiniciar sozinho se houver falha persistente.

