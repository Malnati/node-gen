rm -rf ./build

npx ts-node db.reader.postgres.ts
npx ts-node typeorm-entity-generator.ts
npx ts-node service-generator.ts
npx ts-node interface-generator.ts
npx ts-node controller-generator.ts
npx ts-node dto-generator.ts
npx ts-node module-generator.ts
npx ts-node app-module-generator.ts
npx ts-node main-generator.ts
npx ts-node env-generator.ts
npx ts-node package-json-generator.ts
npx ts-node readme-generator.ts

cp -r ./static/* ./build/