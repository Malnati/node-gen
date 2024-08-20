rm -rf ./build

npx ts-node src/db.reader.postgres.ts
npx ts-node src/typeorm-entity-generator.ts
npx ts-node src/service-generator.ts
npx ts-node src/interface-generator.ts
npx ts-node src/controller-generator.ts
npx ts-node src/dto-generator.ts
npx ts-node src/module-generator.ts
npx ts-node src/app-module-generator.ts
npx ts-node src/main-generator.ts
npx ts-node src/env-generator.ts
npx ts-node src/package-json-generator.ts
npx ts-node src/readme-generator.ts

cp -r ./static/* ./build/