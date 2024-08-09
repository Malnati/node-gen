#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, Column } from './interfaces';

class InterfaceGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
  }

  generateInterfaces(outputDir: string) {
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

    return `${queryDto}

${persistDto}`;
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

    return `export interface I${entityName}QueryDTO {
  ${properties}
}`;
  }

  private generatePersistDto(entityName: string, columns: Column[]): string {
    const properties = columns.map(col => this.generateProperty(col, false)).join('\n  ');

    return `export interface I${entityName}PersistDTO {
  ${properties}
}`;
  }

  private generateProperty(column: Column, includeOptional: boolean): string {
    const type = this.mapType(column.dataType);
    const optional = includeOptional && column.isNullable ? '?' : '';
    return `${column.columnName}${optional}: ${type};`;
  }

  private mapType(dataType: string): string {
    const typeMapping: { [key: string]: string } = {
      'integer': 'number',
      'bigint': 'number',
      'uuid': 'string',
      'timestamp without time zone': 'Date',
      'character varying': 'string',
      'bytea': 'Buffer'
    };
    return typeMapping[dataType] || 'any';
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
const schemaPath = path.join(__dirname, 'build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, 'build');

const generator = new InterfaceGenerator(schemaPath);
generator.generateInterfaces(outputDir);