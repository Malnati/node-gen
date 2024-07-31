import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, Relation } from './interfaces';

class TypeORMEntityGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson);
  }

  generateEntities(outputDir: string) {
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir);
    }

    this.schema.forEach(table => {
      const entityContent = this.generateEntityContent(table);
      const filePath = path.join(outputDir, `${table.tableName}.ts`);
      fs.writeFileSync(filePath, entityContent);
    });

    console.log(`Entities have been generated in ${outputDir}`);
  }

  private generateEntityContent(table: Table): string {
    const columns = table.columns.map(col => this.generateColumnDefinition(col)).join('\n  ');
    const relations = table.relations.map(rel => this.generateRelationDefinition(rel)).join('\n  ');

    return `import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';

@Entity('${table.tableName}')
export class ${this.toPascalCase(table.tableName)} {
  ${columns}
  ${relations}
}`;
  }

  private generateColumnDefinition(column: Column): string {
    const options: string[] = [];

    if (column.isNullable) options.push('nullable: true');
    if (column.columnDefault) options.push(`default: "${column.columnDefault.replace(/"/g, '\\"')}"`);
    if (column.characterMaximumLength) options.push(`length: ${column.characterMaximumLength}`);

    return `@Column({ type: '${this.mapDataType(column.dataType)}', ${options.join(', ')} })
  ${column.columnName}: ${this.mapType(column.dataType)};`;
  }

  private generateRelationDefinition(relation: Relation): string {
    return `@ManyToOne(() => ${this.toPascalCase(relation.foreignTableName)})
  @JoinColumn({ name: '${relation.columnName}' })
  ${relation.columnName}: ${this.toPascalCase(relation.foreignTableName)};`;
  }

  private mapDataType(dataType: string): string {
    const typeMapping: { [key: string]: string } = {
      'integer': 'int',
      'bigint': 'bigint',
      'uuid': 'uuid',
      'timestamp without time zone': 'timestamp',
      'character varying': 'varchar',
      'bytea': 'bytea'
    };
    return typeMapping[dataType] || dataType;
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
}

// Usage
const schemaPath = path.join(__dirname, 'build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, 'entities');

const generator = new TypeORMEntityGenerator(schemaPath);
generator.generateEntities(outputDir);