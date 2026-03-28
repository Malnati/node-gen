// gen/src/api-dto-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';
import { toKebabCase, toPascalCase } from './utils/string';

export class ApiDTOGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateDTOs() {
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

      const dtoContent = this.generateDTOContent(entityName, kebabCaseName, table);
      const filePath = path.join(subDir, `${kebabCaseName}.dto.ts`);
      fs.writeFileSync(filePath, dtoContent);
    });

    console.log(`API DTOs have been generated in ${outputDir}`);
  }

  private generateDTOContent(entityName: string, kebabCaseName: string, table: Table): string {
    const queryDtoProperties = this.generateQueryDtoProperties(table);
    const persistDtoProperties = this.generatePersistDtoProperties(table);
    
    const validatorsImport = this.hasDateValidation(table) 
      ? `import { IsDateString, IsOptional } from "class-validator";`
      : `import { IsOptional } from "class-validator";`;

    return loadTemplate('api-dto.template.ejs', {
      entityName,
      kebabCaseName,
      validatorsImport,
      queryDto: queryDtoProperties,
      persistDto: persistDtoProperties,
    });
  }

  private hasDateValidation(table: Table): boolean {
    return table.columns.some(col => 
      col.dataType?.toLowerCase().includes('timestamp') || 
      col.dataType?.toLowerCase().includes('date')
    );
  }

  private generateQueryDtoProperties(table: Table): string {
    const properties = table.columns
      .filter(col => col.columnName !== 'deleted_at')
      .map(col => {
        const type = this.mapColumnTypeToTS(col);
        const isOptional = col.isNullable;
        const isDate = col.dataType?.toLowerCase().includes('timestamp') || col.dataType?.toLowerCase().includes('date');
        
        let decorator = `@ApiProperty({ description: "${col.columnComment || ''}"`;
        if (col.isPrimaryKey) {
          decorator += `, type: '${type}'`;
        }
        if (isOptional) {
          decorator += `, required: false`;
        }
        decorator += ` })`;
        
        if (isDate && isOptional) {
          return `${decorator}\n@IsOptional()\n@IsDateString()\n${col.columnName}?: ${type};`;
        } else if (isOptional) {
          return `${decorator}\n@IsOptional()\n${col.columnName}?: ${type};`;
        } else if (isDate) {
          return `${decorator}\n@IsDateString()\n${col.columnName}: ${type};`;
        }
        return `${decorator}\n${col.columnName}: ${type};`;
      })
      .join('\n\n');

    return `export class ${toPascalCase(table.tableName)}QueryDTO {\n${properties}\n}`;
  }

  private generatePersistDtoProperties(table: Table): string {
    const filteredColumns = table.columns.filter(col => 
      col.columnName !== 'id' && 
      col.columnName !== 'created_at' && 
      col.columnName !== 'updated_at' && 
      col.columnName !== 'deleted_at'
    );

    const properties = filteredColumns
      .map(col => {
        const type = this.mapColumnTypeToTS(col);
        const isOptional = col.isNullable || col.columnName.endsWith('_id');
        const isDate = col.dataType?.toLowerCase().includes('timestamp') || col.dataType?.toLowerCase().includes('date');
        
        let decorator = `@ApiProperty({ description: "${col.columnComment || ''}"`;
        if (isOptional) {
          decorator += `, required: false`;
        }
        decorator += ` })`;
        
        if (isDate && isOptional) {
          return `${decorator}\n@IsOptional()\n@IsDateString()\n${col.columnName}?: ${type};`;
        } else if (isOptional) {
          return `${decorator}\n@IsOptional()\n${col.columnName}?: ${type};`;
        } else if (isDate) {
          return `${decorator}\n@IsDateString()\n${col.columnName}: ${type};`;
        }
        return `${decorator}\n${col.columnName}: ${type};`;
      })
      .join('\n\n');

    return `export class ${toPascalCase(table.tableName)}PersistDTO {\n${properties}\n}`;
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
