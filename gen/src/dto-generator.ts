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

      const dtoContent = this.generateDTOContent(entityName, table);
      const filePath = path.join(subDir, `${kebabCaseName}.dto.ts`);
      fs.writeFileSync(filePath, dtoContent);
    });

    console.log(`DTOs have been generated in ${outputDir}`);
  }

  private generateDTOContent(entityName: string, table: Table): string {
    const { columns, relations } = table;
    const usedValidators = new Set<string>();
    const queryDto = this.generateQueryDTO(entityName, table, usedValidators);
    const persistDto = this.generatePersistDTO(entityName, table, usedValidators);

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

  private generateQueryDTO(entityName: string, table: Table, usedValidators: Set<string>): string {
    const { columns, relations } = table;
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col, table))
      .map(col => this.generateProperty(col, usedValidators, false))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `/**
 * DTO usado para consultas de ${entityName}.
 */
export class ${entityName}QueryDTO implements I${entityName}QueryDTO {
  ${properties}
}`;
  }

  private generatePersistDTO(entityName: string, table: Table, usedValidators: Set<string>): string {
    const { columns, relations } = table;
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col, table))
      .map(col => this.generateProperty(col, usedValidators, true))
      .concat(relations.map(rel => this.generateRelationProperty(rel)))
      .join('\n  ');

    return `/**
 * DTO utilizado para criação/atualização de ${entityName}.
 */
export class ${entityName}PersistDTO implements I${entityName}PersistDTO {
  ${properties}
}`;
  }

  private generateProperty(column: Column, usedValidators: Set<string>, forPersist = false): string {
    const type = this.mapType(column.dataType);
    const validationDecorators = this.generateValidationDecorators(column, usedValidators, forPersist);
    const optionalSuffix = forPersist && column.columnName === 'external_id' ? '?' : '';
    const example = this.getExampleForColumn(column);
    const apiProperty = `@ApiProperty({
    example: ${example},
    description: "${column.columnComment || 'Descrição do campo.'}",
  })\n  `;
    return `${validationDecorators}${apiProperty}${toSnakeCase(column.columnName)}${optionalSuffix}: ${type};`;
  }

  private foreignTableHasExternalId(relation: Relation): boolean {
    const foreign = this.schema.find((t) => t.tableName === relation.foreignTableName);
    return !!foreign?.columns.some((c) => c.columnName === 'external_id');
  }

  private generateRelationProperty(relation: Relation): string {
    const relationName = toSnakeCase(relation.columnName.replace('_id', ''));
    const byEid = this.foreignTableHasExternalId(relation);
    const propName = byEid ? `${relationName}_eid` : `${relationName}_id`;
    const propType = byEid ? 'string' : 'number';
    const example = byEid ? '"b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b"' : '1';
    const desc = byEid
      ? `ID externo relacionado com ${relation.foreignTableName}.`
      : `ID relacionado com ${relation.foreignTableName}.`;
    return `
  @ApiProperty({
    example: ${example},
    description: "${desc}",
  })
  ${propName}: ${propType};`;
  }

  private generateValidationDecorators(column: Column, usedValidators: Set<string>, forPersist = false): string {
    const decorators: string[] = [];
    const forceOptional = forPersist && column.columnName === 'external_id';

    if (column.isNullable || forceOptional) {
      decorators.push('@IsOptional()');
      usedValidators.add('IsOptional');
    } else {
      decorators.push('@IsNotEmpty()');
      usedValidators.add('IsNotEmpty');
    }

    const mappedType = this.mapType(column.dataType);
    if (column.dataType === 'uuid') {
      decorators.push('@IsUUID()');
      usedValidators.add('IsUUID');
    }

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
    } else if (mappedType === 'boolean') {
      decorators.push('@IsBoolean()');
      usedValidators.add('IsBoolean');
    }

    return decorators.join('\n  ') + '\n  ';
  }

  private getExampleForColumn(column: Column): string {
    if (column.dataType === 'uuid' || column.columnName.endsWith('_eid') || column.columnName === 'external_id') {
      return `"b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b"`;
    }
    if (column.dataType === 'integer' || column.dataType === 'bigint' || column.dataType === 'smallint' || column.dataType === 'numeric' || column.dataType === 'decimal') {
      return `12345`;
    }
    if (column.dataType === 'boolean' || column.dataType === 'bool') {
      return `true`;
    }
    if (column.dataType === 'character varying' || column.dataType === 'varchar' || column.dataType === 'text') {
      return `"exemplo"`;
    }
    if (column.dataType.includes('timestamp') || column.dataType === 'date' || column.dataType === 'timestamptz') {
      return `"2024-01-01T00:00:00Z"`;
    }
    return `"${column.columnDefault || 'exemplo'}"`;
  }

  private shouldIncludeColumn(column: Column, table: Table): boolean {
    const excludedColumns = ['id', 'created_at', 'updated_at', 'deleted_at'];
    if (excludedColumns.includes(column.columnName)) {
      return false;
    }
    if (column.columnName.endsWith('_id') && column.columnName !== 'external_id') {
      const isRelation = table.relations.some((r) => r.columnName === column.columnName);
      if (isRelation) return false;
    }
    return true;
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
}
