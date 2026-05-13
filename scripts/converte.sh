# Indicamos o interpretador
#!/bin/bash

# Solicitamos a indicação do caminho do diretório
read -p "Digite o caminho do diretório com as imagens JPG: " diretorio

# Verificamos se o diretório indicado existe
if [ ! -d "$diretorio" ]; then
    echo "Diretório não encontrado: $diretorio"
    exit 1
fi

# Convertemos todas as imagens JPG para PNG no diretório
for imagem_jpg in "$diretorio"/*.jpg; do
    convert "$imagem_jpg" "${imagem_jpg%.jpg}.png" && echo "Imagem convertida: ${imagem_jpg%.jpg}.png" || echo "Falha na conversão: $imagem_jpg"
done

echo "Conversão concluída!"
