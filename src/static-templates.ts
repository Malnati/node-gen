// src/static-templates.ts

export const entityTemplate = (
  tableName: string,
  columns: string,
  relations: string,
  imports: string,
  customMethods: string = ''
) => `
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, OneToOne, OneToMany, ManyToMany, JoinColumn, CreateDateColumn, UpdateDateColumn, DeleteDateColumn } from 'typeorm';
import 'reflect-metadata';
import { ApiProperty } from '@nestjs/swagger';
${imports}

@Entity('${tableName}')
export class ${toPascalCase(tableName)}Entity {
${columns}
${relations}

${customMethods}
}`;

export const columnTemplate = (
  columnDecorator: string,
  apiPropertyDecorator: string,
  columnName: string,
  columnType: string
) => `
${columnDecorator}
${apiPropertyDecorator}
${columnName}: ${columnType};`;

export const relationTemplate = (
  relationType: 'ManyToOne' | 'OneToOne' | 'OneToMany' | 'ManyToMany',
  foreignTableName: string,
  columnName: string,
  joinColumn: boolean = true
) => {
  const relationDecorator = `@${relationType}(() => ${toPascalCase(foreignTableName)}Entity)`;
  const joinColumnDecorator = joinColumn ? `@JoinColumn({ name: '${columnName}' })` : '';
  const apiPropertyDecorator = `@ApiProperty({ description: "Relacionamento com ${foreignTableName}." })`;

  return `
${relationDecorator}
${joinColumnDecorator}
${apiPropertyDecorator}
${columnName}: ${toPascalCase(foreignTableName)}Entity${relationType === 'OneToMany' || relationType === 'ManyToMany' ? '[]' : ''};`;
};

export const typeMapping: { [key: string]: string } = {
  'integer': 'int',
  'bigint': 'bigint',
  'uuid': 'uuid',
  'timestamp without time zone': 'timestamp',
  'character varying': 'varchar',
  'bytea': 'bytea',
  'boolean': 'boolean',
  'json': 'json',
  'jsonb': 'jsonb',
  'text': 'text',
  'double precision': 'float'
};

export const jsTypeMapping: { [key: string]: string } = {
  'integer': 'number',
  'bigint': 'number',
  'uuid': 'string',
  'timestamp without time zone': 'Date',
  'character varying': 'string',
  'bytea': 'Buffer',
  'boolean': 'boolean',
  'json': 'any', // 'any' é usado para JSON, pois pode ser um objeto ou array
  'jsonb': 'any',
  'text': 'string',
  'double precision': 'number'
};

export function toPascalCase(str: string): string {
  str = removeTbPrefix(str);
  return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
}

export function removeTbPrefix(str: string): string {
  return str.startsWith('tb_') ? str.substring(3) : str;
}
