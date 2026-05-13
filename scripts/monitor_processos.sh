#!/bin/bash

# O script utiliza o comando pgrep para verificar se o processo nginx está em execução, exibindo uma
# mensagem apropriada.

processo="nginx"
if pgrep $processo > /dev/null; then
  echo "$processo está em execução."
else
  echo "$processo não está em execução."
fi
