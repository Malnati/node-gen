#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table } from './interfaces';

class AppModuleGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
  }

  generateAppModule(outputDir: string) {
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const moduleImports = this.schema.map(table => {
      const entityName = this.toPascalCase(table.tableName);
      const kebabCaseName = this.toKebabCase(table.tableName);
      return `import { ${entityName}Module } from './${kebabCaseName}/${kebabCaseName}.module';`;
    }).join('\n');

    const moduleList = this.schema.map(table => {
      const entityName = this.toPascalCase(table.tableName);
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
      envFilePath: process.env.NODE_ENV === "test" ? ".env.test" : ".env",
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

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  private toKebabCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_/g, '-').toLowerCase();
  }
}

// Usage
const schemaPath = path.join(__dirname, '../build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, '../build/src/app');

const generator = new AppModuleGenerator(schemaPath);
generator.generateAppModule(outputDir);