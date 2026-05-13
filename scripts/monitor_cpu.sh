#!/bin/bash

# O script utiliza o comando ps para listar todos os processos em execução, ordena-os pelo uso de CPU
# em ordem decrescente e exibe as seis primeiras linhas, mostrando os cinco principais processos e o cabeçalho.

echo "Top 5 processos por uso de CPU:"
ps aux --sort=-%cpu | head -n 6

