// /src/interface-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class InterfaceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateInterfaces() {
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

      const interfaceContent = this.generateInterfaceContent(entityName, table.columns);
      const filePath = path.join(subDir, `${kebabCaseName}.interface.ts`);
      fs.writeFileSync(filePath, interfaceContent);
    });

    console.log(`Interfaces have been generated in ${outputDir}`);
  }

  private generateInterfaceContent(entityName: string, columns: Column[]): string {
    const filteredColumns = columns.filter(col => this.shouldIncludeColumn(col));
    const queryDto = this.generateQueryDto(entityName, filteredColumns);
    const persistDto = this.generatePersistDto(entityName, filteredColumns);

    return loadTemplate('interface.template.ts', {
      entityName,
      queryDto,
      persistDto,
    });
  }

  private shouldIncludeColumn(column: Column): boolean {
    if (['id', 'created_at', 'updated_at', 'deleted_at'].includes(column.columnName)) {
      return false;
    }
    if (column.columnName.endsWith('_id') && column.columnName !== 'external_id') {
        return false;
    }
    return true;
  }

  private generateQueryDto(entityName: string, columns: Column[]): string {
    const properties = columns.map(col => this.generateProperty(col, true)).join('\n  ');

    return `/**\n   * DTO retornado em consultas de ${entityName}.\n   */\nexport interface I${entityName}QueryDTO {\n  ${properties}\n}`;
  }

  private generatePersistDto(entityName: string, columns: Column[]): string {
    const properties = columns.map(col => this.generateProperty(col, false)).join('\n  ');

    return `/**\n   * DTO utilizado para criar ou atualizar ${entityName}.\n   */\nexport interface I${entityName}PersistDTO {\n  ${properties}\n}`;
  }

  private generateProperty(column: Column, includeOptional: boolean): string {
    const type = this.mapType(column.dataType);
    const optional = includeOptional && column.isNullable ? '?' : '';
    return `${column.columnName}${optional}: ${type};`;
  }

  private mapType(dataType: string): string {
    const typeMapping: { [key: string]: string } = {
      'integer': 'number',
      'smallint': 'number',
      'bigint': 'number',
      'serial': 'number',
      'bigserial': 'number',
      'real': 'number',
      'double precision': 'number',
      'numeric': 'number',
      'decimal': 'number',
      'uuid': 'string',
      'character varying': 'string',
      'varchar': 'string',
      'char': 'string',
      'text': 'string',
      'boolean': 'boolean',
      'bool': 'boolean',
      'timestamp without time zone': 'Date',
      'timestamp with time zone': 'Date',
      'timestamptz': 'Date',
      'date': 'Date',
      'time': 'string',
      'time with time zone': 'string',
      'bytea': 'Buffer',
    };
    return typeMapping[dataType] ?? typeMapping[dataType.toLowerCase()] ?? 'any';
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
