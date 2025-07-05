// /src/controller-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class ControllerGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateControllers() {
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

      const controllerContent = this.generateControllerContent(entityName, kebabCaseName);
      const filePath = path.join(subDir, `${kebabCaseName}.controller.ts`);
      fs.writeFileSync(filePath, controllerContent);
    });

    console.log(`Controllers have been generated in ${outputDir}`);
  }

  private toCamelCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3); // Remove the 'tb_' prefix
    }
    return str.replace(/[-_](.)/g, (match, group1) => group1.toUpperCase());
  }

  private generateControllerContent(entityName: string, kebabCaseName: string): string {
    const camelCaseName = this.toCamelCase(entityName);
    const kebabCaseServiceName = this.toCamelCase(kebabCaseName);

    return loadTemplate('controller.template.ts', {
      entityName,
      kebabCaseName,
      camelCaseName,
      kebabCaseServiceName,
    });
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
