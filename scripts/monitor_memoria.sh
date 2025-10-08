#!/bin/bash

# Ordena os processos pelo uso de memória
echo "Top 5 processos por uso de memória:"
ps aux --sort=-%mem | head -n 6
