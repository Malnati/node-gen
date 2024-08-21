#!/bin/bash

rm -rf ./build
cp -r ./static/. ./build/

npm run build && \
    npx ts-node src/main.ts \
                    --app "Log" \
                    --host "34.134.67.65" \
                    --port "5432" \
                    --database "biud_log" \
                    --user "biud_log" \
                    --password $1 \
                    --outputDir "./build" \
                    --components "entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme"

