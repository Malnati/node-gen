// gen/src/api-interface-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';
import { toKebabCase, toPascalCase } from './utils/string';

export class ApiInterfaceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateInterfaces() {
    // Nova estrutura: <output>/src/app/modules/<entity>/
    const outputDir = path.join(this.config.outputDir, 'src', 'modules');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach(table => {
      const entityName = toPascalCase(table.tableName);
      const kebabCaseName = toKebabCase(table.tableName);
      const subDir = path.join(outputDir, kebabCaseName);
      if (!fs.existsSync(subDir)) {
        fs.mkdirSync(subDir, { recursive: true });
      }

      const interfaceContent = this.generateInterfaceContent(entityName, kebabCaseName, table);
      const filePath = path.join(subDir, `${kebabCaseName}.interface.ts`);
      fs.writeFileSync(filePath, interfaceContent);
    });

    console.log(`API Interfaces have been generated in ${outputDir}`);
  }

  private generateInterfaceContent(entityName: string, kebabCaseName: string, table: Table): string {
    const queryInterfaceProperties = this.generateInterfaceProperties(table, false);
    const persistInterfaceProperties = this.generateInterfaceProperties(table, true);

    const queryDto = `export interface I${entityName}QueryDTO {\n  ${queryInterfaceProperties}\n}`;
    const persistDto = `export interface I${entityName}PersistDTO {\n  ${persistInterfaceProperties}\n}`;

    return loadTemplate('api-interface.template.ejs', {
      entityName,
      kebabCaseName,
      queryDto,
      persistDto,
    });
  }

  private generateInterfaceProperties(table: Table, isPersist: boolean): string {
    const excludeColumns = ['id', 'created_at', 'updated_at', 'deleted_at'];
    
    const columns = isPersist 
      ? table.columns.filter(col => !excludeColumns.includes(col.columnName))
      : table.columns.filter(col => col.columnName !== 'deleted_at');

    return columns.map(col => {
      const type = this.mapColumnTypeToTS(col);
      const optional = col.isNullable || col.columnName.endsWith('_id') ? '?' : '';
      return `${col.columnName}${optional}: ${type};`;
    }).join('\n  ');
  }

  private mapColumnTypeToTS(col: Column): string {
    const dataType = col.dataType?.toLowerCase();
    
    if (dataType?.includes('int') || dataType?.includes('bigint')) {
      return 'number';
    }
    if (dataType?.includes('uuid') || dataType?.includes('varchar') || dataType?.includes('text') || dataType?.includes('char')) {
      return 'string';
    }
    if (dataType?.includes('timestamp') || dataType?.includes('date')) {
      return 'string';
    }
    if (dataType?.includes('bool')) {
      return 'boolean';
    }
    if (dataType?.includes('json')) {
      return 'any';
    }
    if (dataType?.includes('float') || dataType?.includes('decimal') || dataType?.includes('double')) {
      return 'number';
    }
    return 'any';
  }
}
