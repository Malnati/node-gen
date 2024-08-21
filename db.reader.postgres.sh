#!/bin/bash

rm -rf ./build
cp -r ./static/. ./build/

npm run build && \
    npx ts-node src/main.ts \
                    --host "34.134.67.65" \
                    --port "5432" \
                    --database "biud_log" \
                    --user "biud_log" \
                    --password $1 \
                    --outputDir "./build" \
                    --components "entities, services, interfaces, controllers, dtos, modules, app-module"

# ['entities'|'services'|'interfaces'|'controllers'|'dtos'|'modules'|'app-module'|'main'|'env'|'package.json'|'readme'];
# npx ts-node src/db.reader.postgres.ts
# npx ts-node src/typeorm-entity-generator.ts
# npx ts-node src/service-generator.ts
# npx ts-node src/interface-generator.ts
# npx ts-node src/controller-generator.ts
# npx ts-node src/dto-generator.ts
# npx ts-node src/module-generator.ts
# npx ts-node src/app-module-generator.ts
# npx ts-node src/main-generator.ts
# npx ts-node src/env-generator.ts
# npx ts-node src/package-json-generator.ts
# npx ts-node src/readme-generator.ts
