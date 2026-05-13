#!/bin/bash

# Caminho do diretório de origem (para fazer backup)
read -p "Digite o caminho do diretório a ser backupado: " ORIGEM

# Verifica se o diretório de origem existe
if [[ ! -d "$ORIGEM" ]]; then
    echo "Erro: O diretório de origem não existe."
    exit 1
fi

# Caminho do diretório de destino (onde salvar o backup)
read -p "Digite o caminho do diretório de destino: " DESTINO

# Verifica se o diretório de destino existe, se não, cria
if [[ ! -d "$DESTINO" ]]; then
    echo "Diretório de destino não existe. Criando..."
    mkdir -p "$DESTINO" || { echo "Erro ao criar o diretório de destino."; exit 1; }
fi

# Nome do diretório sem o caminho completo
NOME_DIRETORIO=$(basename "$ORIGEM")

# Data atual para nome do arquivo
DATA=$(date +%Y-%m-%d_%H-%M-%S)

# Nome do arquivo de backup
ARQUIVO_BACKUP="$DESTINO/${NOME_DIRETORIO}_backup_${DATA}.tar.gz"

# Realiza o backup com tar e compressão gzip
tar -czf "$ARQUIVO_BACKUP" -C "$(dirname "$ORIGEM")" "$NOME_DIRETORIO"

# Verifica se o backup foi bem-sucedido
if [[ $? -eq 0 ]]; then
    echo "Backup criado com sucesso: $ARQUIVO_BACKUP"
else
    echo "Erro ao criar o backup."
    exit 1
fi
