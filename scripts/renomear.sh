#! /bin/bash

# armazenando argumentos passados no script

DIRETORIO="$1"
TIPO="$2"         # "prefixo" ou "sufixo"
TEXTO="$3"

# - Esse `if` verifica se **algum dos três argumentos está vazio**:
# - `-z "$DIRETORIO"` → verifica se a variável `DIRETORIO` está vazia.
# - `||` → significa "OU".
# - O mesmo se aplica a `TIPO` e `TEXTO`.
# - Se **qualquer um dos três** não for passado (ou estiver em branco), entra no bloco `then`.
# Esse trecho **garante que o usuário forneça os três argumentos obrigatórios**, ou o script mostra uma mensagem de ajuda e termina.

if [ -z "$DIRETORIO" ] || [ -z "$TIPO" ] || [ -z "$TEXTO" ]; then
  echo "Uso: $0 /caminho/para/diretorio prefixo|sufixo texto"
  exit 1
fi

# - `-d "$DIRETORIO"`: testa se o valor da variável `DIRETORIO` **é um diretório válido e existente**.
# - `! -d` (com o `!`) inverte o teste, ou seja, verifica **se NÃO é um diretório**.

# Se a condição for verdadeira (ou seja, **o diretório não existe** ou o caminho não é um diretório), o script executa o bloco `then`.

if [ ! -d "$DIRETORIO" ]; then
  echo "Diretório inválido: $DIRETORIO"
  exit 1
fi

for arquivo in *; do
# - Um loop `for` que percorre **todos os arquivos e pastas no diretório atual** (o `*` representa todos os nomes de arquivos).
# - Cada item será armazenado na variável `arquivo`.

  if [ -f "$arquivo" ]; then
# - Verifica se o item atual ($arquivo) é um arquivo comum (e não uma pasta, link, etc.).
# - Só continua se for um arquivo.
    nome_base="${arquivo%.*}"
    extensao="${arquivo##*.}"

# - Extrai o **nome do arquivo sem a extensão**.
# - Exemplo: `foto.jpg` → `nome_base="foto"`

   if [ "$arquivo" = "$extensao" ]; then
        extensao=""
   else
        extensao=".$extensao"
   fi
# - Isso trata o caso de **arquivos sem extensão**:
# - Se o nome do arquivo for igual à "extensão" extraída, é porque não havia extensão (ex: `README`).
# - Caso tenha, adiciona um ponto (`.`) antes dela para facilitar na hora de reconstruir o nome.

   if [ "$TIPO" = "prefixo" ]; then
        novo_nome="${TEXTO}${arquivo}"
# - Se o tipo escolhido for "prefixo", o novo nome será o TEXTO antes do nome original do arquivo.
# - Exemplo: TEXTO="novo_" e arquivo="imagem.png" → novo_nome="novo_imagem.png"

   elif [ "$TIPO" = "sufixo" ]; then
        novo_nome="${nome_base}${TEXTO}${extensao}"
# - Se for `"sufixo"`, o `TEXTO` é adicionado **depois do nome base**, mas **antes da extensão**.
# - Exemplo: `imagem.png`, `TEXTO="_editado"` → `novo_nome="imagem_editado.png"`

    else
      echo "Tipo inválido: use 'prefixo' ou 'sufixo'"
      exit 1
    fi
# - Caso o valor de TIPO não seja nem "prefixo" nem "sufixo", mostra erro e encerra o script.

    mv -i "$arquivo" "$novo_nome"
    echo "Renomeado: $arquivo -> $novo_nome"
 fi

done
# - `mv -i` renomeia o arquivo, pedindo confirmação se o novo nome já existir.
# - Em seguida, mostra no terminal o nome antigo e o novo nome do arquivo.

# Esse script vai **renomear todos os arquivos no diretório atual**, adicionando um prefixo ou sufixo conforme a escolha do usuário.
# Ele é útil, por exemplo, para preparar arquivos com marcação padronizada.
