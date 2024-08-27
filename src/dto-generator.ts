#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, Relation, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase, toSnakeCase } from './utils/string';


export class DTOGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateDTOs() {
    const outputDir = path.join(this.config.outputDir, 'src/app');

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

      const dtoContent = this.generateDTOContent(entityName, table.columns, table.relations);
      const filePath = path.join(subDir, `${kebabCaseName}.dto.ts`);
      fs.writeFileSync(filePath, dtoContent);
    });

    console.log(`DTOs have been generated in ${outputDir}`);
  }

  private generateDTOContent(entityName: string, columns: Column[], relations: Relation[]): string {
    const queryDto = this.generateQueryDTO(entityName, columns, relations);
    const persistDto = this.generatePersistDTO(entityName, columns, relations);

    return `import { IsString, IsNotEmpty, MaxLength, IsOptional, IsNumber, IsUUID, IsDate } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { I${entityName}QueryDTO, I${entityName}PersistDTO } from "./${toKebabCase(entityName)}.interface";

/**
 * Data Transfer Object for ${entityName}.
 * 
 * Utilizado para transferir dados entre a camada de persistência e a camada de controle,
 * ocultando chaves primárias e datas automáticas, enquanto expõe os external_id e outras
 * informações de negócio relevantes.
 */
${queryDto}

${persistDto}`;
  }

  private generateQueryDTO(entityName: string, columns: Column[], relations: Relation[]): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, true))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `export class ${entityName}QueryDTO implements I${entityName}QueryDTO {
  ${properties}
}`;
  }

  private generatePersistDTO(entityName: string, columns: Column[], relations: Relation[]): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, false))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `export class ${entityName}PersistDTO implements I${entityName}PersistDTO {
  ${properties}
}`;
  }

  private generateProperty(column: Column, isQuery: boolean): string {
    const type = this.mapType(column.dataType);
    const validationDecorators = this.generateValidationDecorators(column);
    
    const example = this.getExampleForColumn(column);
    const apiProperty = `@ApiProperty({
    example: ${example},
    description: "${column.columnComment || 'Descrição do campo.'}",
  })\n  `;
    return `${validationDecorators}${apiProperty}${toSnakeCase(column.columnName)}: ${type};`;
  }

  private generateRelationProperty(relation: Relation): string {
    const relationName = toSnakeCase(relation.columnName.replace('_id', ''));
    return `
  @ApiProperty({
    example: "b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b",
    description: "ID externo relacionado com ${relation.foreignTableName}.",
  })
  ${relationName}_eid: string;`;
  }

  private generateValidationDecorators(column: Column): string {
    const decorators = [];

    if (column.isNullable) {
      decorators.push('@IsOptional()');
    } else {
      decorators.push('@IsNotEmpty()');
    }

    const mappedType = this.mapType(column.dataType);
    if (mappedType === 'string') {
      decorators.push('@IsString()');
      if (column.characterMaximumLength) {
        decorators.push(`@MaxLength(${column.characterMaximumLength})`);
      }
    } else if (mappedType === 'number') {
      decorators.push('@IsNumber()');
    } else if (mappedType === 'Date') {
      decorators.push('@IsDate()');
    } else if (mappedType === 'UUID') {
      decorators.push('@IsUUID()');
    }

    return decorators.join('\n  ') + '\n  ';
  }

  private getExampleForColumn(column: Column): string {
    if (column.dataType === 'uuid' || column.columnName.endsWith('_eid') || column.columnName === 'external_id') {
      return `"b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b"`;
    } else if (column.dataType === 'integer' || column.dataType === 'bigint') {
      return `12345`;
    } else if (column.dataType === 'character varying') {
      return `"exemplo"`;
    } else if (column.dataType.includes('timestamp')) {
      return `"2024-01-01T00:00:00Z"`;
    }
    return `"${column.columnDefault || 'exemplo'}"`;
  }

  private shouldIncludeColumn(column: Column): boolean {
    const excludedColumns = ['id', 'created_at', 'updated_at', 'deleted_at'];
    if (excludedColumns.includes(column.columnName)) {
      return false;
    }
    if (column.columnName.endsWith('_id') && column.columnName !== 'external_id') {
      return false;
    }
    return true;
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
}
