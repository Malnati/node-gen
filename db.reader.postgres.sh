#!/bin/bash

rm -rf $2
cp -r ./static/. $2

npm run build && \
    npx ts-node src/main.ts \
                    --app "Log" \
                    --host "34.134.67.65" \
                    --port "5432" \
                    --database "biud_log" \
                    --user "biud_log" \
                    --password $1 \
                    --outputDir $2 \
                    --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource"
