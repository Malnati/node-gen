#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';

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
    return loadTemplate('app-module.template.ts', {
      moduleImports,
      moduleList,
    });
  }
}
