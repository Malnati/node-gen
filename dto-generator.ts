import * as fs from 'fs';
import * as path from 'path';
import { Table, Column } from './interfaces';

class DTOGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson);
  }

  generateDTOs(outputDir: string) {
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

      const dtoContent = this.generateDTOContent(entityName, table.columns);
      const filePath = path.join(subDir, `${kebabCaseName}.dto.ts`);
      fs.writeFileSync(filePath, dtoContent);
    });

    console.log(`DTOs have been generated in ${outputDir}`);
  }

  private generateDTOContent(entityName: string, columns: Column[]): string {
    const queryDto = this.generateQueryDTO(entityName, columns);
    const persistDto = this.generatePersistDTO(entityName, columns);

    return `import { IsString, IsNotEmpty, MaxLength, IsOptional } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { I${entityName}QueryDTO, I${entityName}PersistDTO } from "./${this.toKebabCase(entityName)}.interface";

/**
 * The Data Transfer Object for ${entityName}.
 * 
 * Esta classe é utilizada para transferir valores entre o TypeORM e o Controller,
 * ocultando as chaves primárias e datas de criação, atualização e exclusão,
 * além de expor os external_id e as informações de negócio.
 */
${queryDto}

${persistDto}`;
  }

  private generateQueryDTO(entityName: string, columns: Column[]): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, true))
      .join('\n  ');

    return `export class ${entityName}QueryDTO implements I${entityName}QueryDTO {
  ${properties}
}`;
  }

  private generatePersistDTO(entityName: string, columns: Column[]): string {
    const properties = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateProperty(col, false))
      .join('\n  ');

    return `export class ${entityName}PersistDTO implements I${entityName}PersistDTO {
  ${properties}
}`;
  }

  private generateProperty(column: Column, isQuery: boolean): string {
    const type = this.mapType(column.dataType);
    const optional = column.isNullable ? '@IsOptional()\n  ' : '@IsNotEmpty()\n  ';
    const maxLength = column.characterMaximumLength ? `@MaxLength(${column.characterMaximumLength})\n  ` : '';
    
    const example = this.getExampleForColumn(column);
    
    const apiProperty = `@ApiProperty({
    example: ${example},
    description: "${column.columnComment || 'Descrição do campo.'}",
    type: () => ${type},
  })\n  `;

    return `${optional}${maxLength}${apiProperty}${this.toCamelCase(column.columnName)}: ${type};`;
  }

  private getExampleForColumn(column: Column): string {
    if (column.dataType === 'uuid' || column.columnName.endsWith('_eid') || column.columnName === 'external_id') {
      return `"b2e293e5-4a4a-4b29-b9a4-4b2b4a4a4b2b"`;
    }
    return `"${column.columnDefault || 'exemplo'}"`;
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

  private toCamelCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/[-_](.)/g, (match, group1) => group1.toUpperCase());
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

const generator = new DTOGenerator(schemaPath);
generator.generateDTOs(outputDir);