#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';

export class PackageJsonGenerator {
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.config = config;
  }

  generatePackageJsonFile() {
      const MICROSERVICE_VERSION = '1.0.0';
      const MICROSERVICE_DESCRIPTION = `Este é o repositório de ${this.config.app} que por sua vez é um de microserviço baseado no Nest.js. Ele inclui um conjunto de configurações, dependências e scripts para facilitar o desenvolvimento, teste e implantação de microserviços construídos com o Nest.js.`;

      const packageJsonContent = {
        name: this.config.app,
        version: MICROSERVICE_VERSION,
        description: MICROSERVICE_DESCRIPTION,
        scripts: {
          prebuild: "rimraf dist",
          build: "nest build",
          format: "prettier --write \"src/**/*.ts\"",
          start: "nest start",
          create: "node src/cmd.create.js",
          update: "node src/cmd.update.js",
          "git:commit": "npm run format && node add-header.js src && git add . && git commit -m \"path(front-web): auto-commit \"",
          clean: "rm -rf node_modules dist",
          "start:dev": "rm -rf dist && rm -rf node_modules && npm install && nest start --watch --verbose",
          "start:debug": "nest start --debug --watch",
          "start:prod": "node dist/main",
          lint: "eslint '{src,apps,libs,test}/**/*.ts' --fix",
          test: "rm -rf dist node_modules && npm install && npm cache clean --force && jest --clearCache && jest --detectOpenHandles",
          "test:watch": "jest --watch",
          "test:cov": "jest --coverage",
          "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
          "test:e2e": "jest --clearCache && jest"
        },
        dependencies: {
          "@nestjs/axios": "^3.0.2",
          "@nestjs/common": "10.2.10",
          "@nestjs/config": "^3.1.1",
          "@nestjs/core": "10.2.10",
          "@nestjs/jwt": "^10.2.0",
          "@nestjs/microservices": "10.2.10",
          "@nestjs/passport": "^10.0.3",
          "@nestjs/platform-express": "10.2.10",
          "@nestjs/serve-static": "^4.0.1",
          "@nestjs/swagger": "^7.4.0",
          "@nestjs/terminus": "^10.2.3",
          "@nestjs/typeorm": "^10.0.1",
          "@types/js-yaml": "^4.0.9",
          axios: "^1.6.7",
          bcrypt: "^5.1.1",
          child_process: "^1.0.2",
          "class-transformer": "^0.5.1",
          "class-validator": "^0.14.1",
          dotenv: "^16.4.1",
          glob: "^10.3.12",
          "js-yaml": "^4.1.0",
          passport: "^0.7.0",
          "passport-jwt": "^4.0.1",
          pg: "^8.11.5",
          "reflect-metadata": "0.1.13",
          rimraf: "5.0.5",
          rxjs: "7.8.1",
          typeorm: "^0.3.20",
          webpack: "^5.90.3"
        },
        devDependencies: {
          "@nestjs/cli": "10.3.0",
          "@nestjs/schematics": "10.0.3",
          "@nestjs/testing": "^10.2.10",
          "@types/amqplib": "0.10.4",
          "@types/express": "4.17.21",
          "@types/jest": "^29.5.12",
          "@types/node": "20.8.7",
          "@types/supertest": "2.0.16",
          "@typescript-eslint/eslint-plugin": "5.62.0",
          "@typescript-eslint/parser": "5.62.0",
          eslint: "8.42.0",
          "eslint-config-prettier": "9.1.0",
          "eslint-plugin-import": "2.29.1",
          jest: "29.7.0",
          prettier: "^3.0.3",
          supertest: "6.3.3",
          "ts-jest": "^29.1.2",
          "ts-loader": "9.5.1",
          "ts-node": "^10.9.1",
          "tsconfig-paths": "4.2.0",
          typescript: "^5.3.3"
        }
      };

      const buildDir = this.config.outputDir;

      console.log(`Build Directory: ${buildDir}`);

      if (!fs.existsSync(buildDir)) {
        console.log(`Creating directory: ${buildDir}`);
        fs.mkdirSync(buildDir, { recursive: true });
      } else {
        console.log(`Directory already exists: ${buildDir}`);
      }

      const filePath = path.join(buildDir, 'package.json');
      console.log(`File Path: ${filePath}`);

      try {
        fs.writeFileSync(filePath, JSON.stringify(packageJsonContent, null, 2));
        console.log(`package.json has been generated at ${filePath}`);
      } catch (error) {
        console.error(`Error writing file: ${error}`);
      }
  }
}