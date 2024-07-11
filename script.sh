#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
CONTENT="teste de script corrido por DAG"
FILE_PATH="$CURRENT_DIR/teste.txt"

echo "$CONTENT" > "$FILE_PATH"
echo "Arquivo $FILE_PATH criado com sucesso."

