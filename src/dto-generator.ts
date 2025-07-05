// /src/dto-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, Relation, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase, toSnakeCase } from './utils/string';
import { loadTemplate } from './utils/template-loader';


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
    const usedValidators = new Set<string>();
    const queryDto = this.generateQueryDTO(entityName, columns, relations, usedValidators);
    const persistDto = this.generatePersistDTO(entityName, columns, relations, usedValidators);

    const validatorsImport = usedValidators.size
      ? `import { ${Array.from(usedValidators).sort().join(', ')} } from "class-validator";`
      : '';

    return loadTemplate('dto.template.ts', {
      entityName,
      kebabCaseName: toKebabCase(entityName),
      queryDto,
      persistDto,
      validatorsImport,
    });
  }

  private generateQueryDTO(entityName: string, columns: Column[], relations: Relation[], usedValidators: Set<string>): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, true, usedValidators))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `/**
 * DTO usado para consultas de ${entityName}.
 */
export class ${entityName}QueryDTO implements I${entityName}QueryDTO {
  ${properties}
}`;
  }

  private generatePersistDTO(entityName: string, columns: Column[], relations: Relation[], usedValidators: Set<string>): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, false, usedValidators))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `/**
 * DTO utilizado para criação/atualização de ${entityName}.
 */
export class ${entityName}PersistDTO implements I${entityName}PersistDTO {
  ${properties}
}`;
  }

  private generateProperty(column: Column, isQuery: boolean, usedValidators: Set<string>): string {
    const type = this.mapType(column.dataType);
    const validationDecorators = this.generateValidationDecorators(column, usedValidators);
    
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

  private generateValidationDecorators(column: Column, usedValidators: Set<string>): string {
    const decorators: string[] = [];

    if (column.isNullable) {
      decorators.push('@IsOptional()');
      usedValidators.add('IsOptional');
    } else {
      decorators.push('@IsNotEmpty()');
      usedValidators.add('IsNotEmpty');
    }

    const mappedType = this.mapType(column.dataType);
    if (mappedType === 'string') {
      decorators.push('@IsString()');
      usedValidators.add('IsString');
      if (column.characterMaximumLength) {
        decorators.push(`@MaxLength(${column.characterMaximumLength})`);
        usedValidators.add('MaxLength');
      }
    } else if (mappedType === 'number') {
      decorators.push('@IsNumber()');
      usedValidators.add('IsNumber');
    } else if (mappedType === 'Date') {
      decorators.push('@IsDate()');
      usedValidators.add('IsDate');
    } else if (mappedType === 'UUID') {
      decorators.push('@IsUUID()');
      usedValidators.add('IsUUID');
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
