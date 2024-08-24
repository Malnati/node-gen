#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';

export class AppModuleGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateAppModule() {
    const outputDir = path.join(this.config.outputDir, 'src/app');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const moduleImports = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      const kebabCaseName = toKebabCase(table.tableName);
      return `import { ${entityName}Module } from './${kebabCaseName}/${kebabCaseName}.module';`;
    }).join('\n');

    const moduleList = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      return `${entityName}Module`;
    }).join(',\n    ');

    const appModuleContent = this.generateAppModuleContent(moduleImports, moduleList);
    const filePath = path.join(outputDir, 'app.module.ts');
    fs.writeFileSync(filePath, appModuleContent);

    console.log(`AppModule has been generated in ${outputDir}`);
  }

  private generateAppModuleContent(moduleImports: string, moduleList: string): string {
    return `${moduleImports}

import { join } from "path";
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { ServeStaticModule } from "@nestjs/serve-static";
import { HealthModule } from "./health/health.module";
import { VersionModule } from "./version/version.module";
import { JwtAuthGuardModule } from "./middleware/jwt-auth.guard.module";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'test' ? '.env.test' : ['.env.local', '.env'],
    }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, "..", "..", "public"),
    }),
    VersionModule,
    JwtAuthGuardModule,
    HealthModule,
    ${moduleList}
  ],
})
export class AppModule {}`;
  }
}
