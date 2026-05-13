#!/bin/bash

# Limite de uso de disco (%) para alerta
LIMITE=15

echo "Monitorando uso de disco em: $(date)"
echo "Partições com uso maior que ${LIMITE}%:"
echo "--------------------------------------------------"

# Coleta informações de uso do disco (ignora sistemas virtuais como tmpfs)
df -hP | awk -v limite=$LIMITE 'NR>1 {
    uso=$5;
    gsub("%", "", uso);
    if (uso+0 >= limite) {
        printf "Dispositivo: %-20s Uso: %s Montado em: %s\n", $1, $5, $6;
    }
}'

echo "--------------------------------------------------"
