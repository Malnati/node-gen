#!/bin/bash

echo ""
echo "Deve gerar o projeto $1"
echo "Deve conectar ao banco de dados $2"
echo "Deve copiar os arquivos para $4"
echo ""

# remove os arquivos antigos gerados pelo comando anterior
# rm -rf $4

# copia apenas od diretorios do static para o diretorio de destino
# rsync -av --include '*/' --exclude '*' ./static/. $4

# compila o projeto do gerador
npm run build

# executa o gerador de codigo
npx ts-node src/main.ts \
                --app $1 \
                --host "34.134.67.65" \
                --port "5432" \
                --database $2 \
                --user $2 \
                --password $3 \
                --outputDir $4 \
                --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource"


# copia os arquivos estaticos para o diretorio de destino
# cp -r ./static/. $4


# compila o projeto gerado
# cd $4
# npm install
# npm run build
# cd ..
