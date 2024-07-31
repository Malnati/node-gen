rm -rf ./build
npx ts-node db.reader.postgres.ts
npx ts-node typeorm-entity-generator.ts
npx ts-node service-generator.ts
npx ts-node interface-generator.ts