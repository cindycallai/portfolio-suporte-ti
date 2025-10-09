#!/bin/bash

# Solicita o usuário e a senha
read -p "Digite o usuario: " USERNAME
echo -n "Digite a senha: "
stty -echo
read PASSWORD
stty echo
echo

# URL do site
URL="http://localhost:8000/login"
echo "fiz login"
data_atual=$(date +%Y%m%d)

# Faz a requisicao e salva o token com a data atual
token=$(curl -s -X POST -d "email=$USERNAME&password=$PASSWORD" $URL | grep -o '"token": "[^"]*' | awk -F'"' '{print $4}')

# Verifica se o retorno do token nao e nulo
if [ -z "$token" ]; then
    echo "Falha na autenticacao. Por favor tente novamente"
    exit 1
fi

# Salva o token no arquivo
echo "$token" > /home/pi/sensor/zabbix/token.$data_atual.txt

echo "Token salvo em /home/pi/sensor/zabbix/token.$data_atual.txt"
