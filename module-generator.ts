#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table } from './interfaces';

class ModuleGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
  }

  generateModules(outputDir: string) {
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach(table => {
      const entityName = this.toPascalCase(table.tableName);
      const kebabCaseName = this.toKebabCase(table.tableName);
      const subDir = path.join(outputDir, kebabCaseName);
      if (!fs.existsSync(subDir)) {
        fs.mkdirSync(subDir, { recursive: true });
      }

      const moduleContent = this.generateModuleContent(entityName, kebabCaseName);
      const filePath = path.join(subDir, `${kebabCaseName}.module.ts`);
      fs.writeFileSync(filePath, moduleContent);
    });

    console.log(`Modules have been generated in ${outputDir}`);
  }

  private generateModuleContent(entityName: string, kebabCaseName: string): string {
    return `import { Module } from "@nestjs/common";
import { HttpModule } from "@nestjs/axios";
import { ${entityName}Service } from "./${kebabCaseName}.service";
import { EnvironmentModule } from "../config/environment.module";
import { ${entityName}Controller } from "./${kebabCaseName}.controller";
import { JwtAuthGuardModule } from "../middleware/jwt-auth.guard.module";
import { JwtAuthGuard } from "../middleware/jwt-auth.guard";

@Module({
  imports: [
    HttpModule,
    EnvironmentModule, // Importa o EnvironmentModule para usar o EnvironmentService e o DataSourceService
    JwtAuthGuardModule, // Importa o JwtAuthGuardModule para usar o JwtAuthGuard
  ],
  providers: [${entityName}Service, JwtAuthGuard], // Registra-os como um provedores para ser utilizado por este módulo
  exports: [${entityName}Service], // Exporta o ${entityName}Service para que possa ser injetado em outros módulos
  controllers: [${entityName}Controller],
})
export class ${entityName}Module {}`;
  }

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  private toCamelCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/[-_](.)/g, (match, group1) => group1.toUpperCase());
  }

  private toKebabCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_/g, '-').toLowerCase();
  }
}

// Usage
const schemaPath = path.join(__dirname, 'build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, 'build');

const generator = new ModuleGenerator(schemaPath);
generator.generateModules(outputDir);