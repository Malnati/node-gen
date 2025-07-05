// /src/datasource-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig, Table } from './interfaces';
import { toPascalCase, toSnakeCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';

export class DataSourceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    const parsedSchema = JSON.parse(schemaJson);
    this.schema = parsedSchema.schema;
    this.config = config;
  }

  generateDataSourceFile() {
    const outputDir = path.join(this.config.outputDir, 'src/app/config');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const dataSourceFileContent = this.generateDataSourceFileContent();
    const filePath = path.join(outputDir, 'datasource.service.ts');
    fs.writeFileSync(filePath, dataSourceFileContent);

    console.log(`DataSource file has been generated in ${outputDir}`);
  }

  private generateDataSourceFileContent(): string {
    const entityImports = this.schema
      .map((table) => {
        const entityName = toPascalCase(table.tableName);
        return `import { ${entityName}Entity } from "@app/entities/${toSnakeCase(entityName)}";`;
      })
      .join('\n');

    const entitiesArray = this.schema
      .map((table) => {
        const entityName = toPascalCase(table.tableName);
        return `${entityName}Entity`;
      })
      .join(', ');

    return loadTemplate('datasource.template.ts', {
      entityImports,
      entitiesArray,
      dbType: this.config.dbType,
    });
  }

}