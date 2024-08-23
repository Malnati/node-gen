#!/bin/bash

# remove os arquivos antigos gerados pelo comando anterior
rm -rf $2

# copia apenas od diretorios do static para o diretorio de destino
rsync -av --include '*/' --exclude '*' ./static/. $2

# compila o projeto
npm run build

# executa o gerador de codigo
npx ts-node src/main.ts \
                --app "Log" \
                --host "34.134.67.65" \
                --port "5432" \
                --database "biud_log" \
                --user "biud_log" \
                --password $1 \
                --outputDir $2 \
                --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource"

# copia os arquivos estaticos para o diretorio de destino
cp -r ./static/. $2


# compila o projeto gerado
cd $2
npm install
npm run build
cd ..
