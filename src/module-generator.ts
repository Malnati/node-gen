#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class ModuleGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

generateModules() {
    const outputDir = path.join(this.config.outputDir, 'src/app');

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
    return loadTemplate('module.template.ts', {
      entityName,
      kebabCaseName,
    });
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