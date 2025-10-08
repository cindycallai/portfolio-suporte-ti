#!/bin/bash

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root (use sudo)."
    exit 1
fi

# Solicita o nome de usuário
read -p "Digite o nome de usuário: " username

# Verifica se o usuário já existe
if id "$username" &>/dev/null; then
    echo "O usuário '$username' já existe. Abortando."
    exit 1
fi

# Solicita o nome completo
read -p "Digite o nome completo do usuário: " fullname

# Solicita a senha (sem exibir na tela)
read -s -p "Digite a senha para o novo usuário: " password
echo
read -s -p "Confirme a senha: " password2
echo

# Verifica se as senhas coincidem
if [[ "$password" != "$password2" ]]; then
    echo "As senhas não coincidem. Abortando."
    exit 1
fi

# Pergunta se o usuário terá privilégios sudo
read -p "O usuário deve ter privilégios de administrador (sudo)? (s/n): " is_admin

# Cria o usuário com o nome completo
useradd -m -c "$fullname" "$username"

# Define a senha do usuário
echo "$username:$password" | chpasswd

# Adiciona ao grupo sudo, se necessário
if [[ "$is_admin" == "s" || "$is_admin" == "S" ]]; then
    usermod -aG sudo "$username"
    echo "Usuário '$username' adicionado ao grupo sudo."
fi

echo "Usuário '$username' criado com sucesso."
