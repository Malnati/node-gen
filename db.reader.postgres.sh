#!/bin/bash

rm -rf ./build
cp -r ./static/. ./build/

npm run build && \
    npx ts-node src/main.ts \
                    --app "Payment" \
                    --host "34.134.67.65" \
                    --port "5432" \
                    --database "biud_payment" \
                    --user "biud_payment" \
                    --password "**********" \
                    --outputDir "/home/jupiter/Projetos/BIUD/biud-microservice-payment" \
                    --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource"