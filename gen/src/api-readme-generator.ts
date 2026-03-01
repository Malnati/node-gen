// gen/src/api-readme-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';

export class ApiReadmeGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateReadme() {
    // Nova estrutura: <output>/api/
    const outputDir = path.join(this.config.outputDir, 'api');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const entityNames = this.schema.map(table => toPascalCase(table.tableName)).join(', ');
    const moduleNames = this.schema.map(table => toKebabCase(table.tableName)).join(', ');

    const readmeContent = loadTemplate('api-readme.template.ejs', {
      appName: this.config.app,
      entityNames,
      moduleNames,
    });

    const filePath = path.join(outputDir, 'README.md');
    fs.writeFileSync(filePath, readmeContent);

    console.log(`API README has been generated in ${outputDir}`);
  }
}
