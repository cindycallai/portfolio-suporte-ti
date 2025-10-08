#!/bin/bash

# O script mostra as últimas 10 linhas do log do sistema relacionadas a mensagens de erro.

echo "Últimas 10 linhas de mensagens de erro:"
tail -n 10 /var/log/syslog | grep "error"
