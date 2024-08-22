#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, Relation, DbReaderConfig } from './interfaces';

export class TypeORMEntityGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    const parsedSchema = JSON.parse(schemaJson);
    this.schema = parsedSchema.schema;
    this.config = config;
  }

  generateEntities() {
    const outputDir = path.join(this.config.outputDir, 'src/app/entities');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true }); 
    }

    this.schema.forEach(table => {
      const entityContent = this.generateEntityContent(table);
      const filePath = path.join(outputDir, `${this.removeTbPrefix(table.tableName)}.ts`);
      fs.writeFileSync(filePath, entityContent);
    });

    console.log(`Entities have been generated in ${outputDir}`);
  }

  private generateEntityContent(table: Table): string {
    const columns = table.columns.map(col => this.generateColumnDefinition(col)).join('\n  ');
    const relations = table.relations.map(rel => this.generateRelationDefinition(rel)).join('\n  ');

    return `import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn, DeleteDateColumn } from 'typeorm';
import 'reflect-metadata';
import { ApiProperty } from '@nestjs/swagger';

@Entity('${table.tableName}')
export class ${this.toPascalCase(table.tableName)}Entity {
  ${columns}
  ${relations}
}`;
  }

  private generateColumnDefinition(column: Column): string {
    const options: string[] = [];
    const typeOptions: string[] = [];

    if (column.isNullable) typeOptions.push('nullable: true');
    if (column.columnDefault) options.push(`default: "${column.columnDefault.replace(/"/g, '\\"')}"`);
    if (column.characterMaximumLength) options.push(`length: ${column.characterMaximumLength}`);

    let columnDecorator = `@Column({ type: '${this.mapDataType(column.dataType)}', ${options.join(', ')} })`;

    if (column.columnName === 'id') {
      columnDecorator = `@PrimaryGeneratedColumn()`;
    }

    if (column.columnName === 'created_at') {
      columnDecorator = `@CreateDateColumn({type: '${this.mapDataType(column.dataType)}', nullable: true})`;
    }

    if (column.columnName === 'updated_at') {
      columnDecorator = `@UpdateDateColumn({type: '${this.mapDataType(column.dataType)}', nullable: true})`;
    }

    if (column.columnName === 'external_id') {
      columnDecorator = `@Column({ type: 'uuid', unique: true })`;
    }

    if (column.columnName === 'deleted_at') {
      columnDecorator = `@DeleteDateColumn({type: '${this.mapDataType(column.dataType)}', nullable: true})`;
    }

    const apiPropertyDecorator = `@ApiProperty({ description: "${column.columnComment || ''}", ${typeOptions.join(', ')} })`;

    return `${columnDecorator}
    ${apiPropertyDecorator}
    ${column.columnName}: ${this.mapType(column.dataType)};`;
  }

  private generateRelationDefinition(relation: Relation): string {
    return `@ManyToOne(() => ${this.toPascalCase(relation.foreignTableName)}Entity)
  @JoinColumn({ name: '${relation.columnName}' })
  @ApiProperty({ description: "Relacionamento com ${relation.foreignTableName}." })
  ${relation.columnName}: ${this.toPascalCase(relation.foreignTableName)}Entity;`;
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
    str = this.removeTbPrefix(str);
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  private removeTbPrefix(str: string): string {
    return str.startsWith('tb_') ? str.substring(3) : str;
  }
}