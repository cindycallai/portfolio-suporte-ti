#!/bin/bash

# O script adiciona as últimas 5 linhas de mensagens de erro ao arquivo de log especificado e
# é configurado para ser executado a cada duas horas usando cron.
echo "Mensagens de erro - $(date)" >> /caminho/do/log_monitorado.txt
tail -n 5 /var/log/syslog | grep "error" >> /caminho/do/log_monitorado.txt

# Cron
# Adicione a seguinte linha ao crontab para executar o script a cada duas horas
# 0 */2 * * * /caminho/do/seu/script.sh
cindy@devops:~/scripts$ cat atualizar_sistema.sh
#!/bin/bash

# Nome do log com data e hora
LOG_FILE="/var/log/atualizacao_sistema_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Função para verificação de permissão
checar_permissao(){
        if ["$EUID" -ne 0 ]; then
                echo "Este script precise ser executado como root. Use sudo. " | tee -a "$LOG_FILE"
                exit 1
        fi
}
# Início
checar_permissao
echo "Iniciando atualização do sistema em $(date)" | tee -a "$LOG_FILE"

# Atualização
apt update | tee -a "$LOG_FILE"
apt upgrade -y | tee -a "$LOG_FILE"
apt autoremove -y | tee -a "$LOG_FILE"
apt autoclean -y | tee -a "$LOG_FILE"

echo "Atualização concluída em $(date)" | tee -a "$LOG_FILE"
