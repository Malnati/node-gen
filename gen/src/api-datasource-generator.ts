// gen/src/api-datasource-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { toPascalCase, toSnakeCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';

export class ApiDataSourceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateDataSourceFile() {
    // Nova estrutura: <output>/api/src/modules/config/
    const outputDir = path.join(this.config.outputDir, 'api', 'src', 'modules', 'config');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const entityImports = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      const kebabName = toSnakeCase(entityName).replace(/_/g, '-');
      return `import { ${entityName}Entity } from "../${kebabName}/${kebabName}.entity";`;
    }).join('\n');

    const entitiesArray = this.schema.map(table => {
      const entityName = toPascalCase(table.tableName);
      return `${entityName}Entity`;
    }).join(',\n    ');

    const datasourceContent = this.generateDataSourceContent(entityImports, entitiesArray);
    const filePath = path.join(outputDir, 'datasource.service.ts');
    fs.writeFileSync(filePath, datasourceContent);

    console.log(`API DataSource file has been generated in ${outputDir}`);
  }

  private generateDataSourceContent(entityImports: string, entitiesArray: string): string {
    return loadTemplate('api-datasource.template.ejs', {
      entityImports,
      entitiesArray,
    });
  }
}
