// static-templates.ts
export const entityTemplate = (tableName: string, columns: string, relations: string) => `
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import 'reflect-metadata';
import { ApiProperty } from '@nestjs/swagger';

@Entity('${tableName}')
export class ${toPascalCase(tableName)}Entity {
  ${columns}
  ${relations}
}`;

export const columnTemplate = (columnDecorator: string, apiPropertyDecorator: string, columnName: string, columnType: string) => `
${columnDecorator}
${apiPropertyDecorator}
${columnName}: ${columnType};`;

export const relationTemplate = (foreignTableName: string, columnName: string) => `
@ManyToOne(() => ${toPascalCase(foreignTableName)}Entity)
@JoinColumn({ name: '${columnName}' })
@ApiProperty({ description: "Relacionamento com ${foreignTableName}." })
${columnName}: ${toPascalCase(foreignTableName)}Entity;`;

export const typeMapping: { [key: string]: string } = {
  'integer': 'int',
  'bigint': 'bigint',
  'uuid': 'uuid',
  'timestamp without time zone': 'timestamp',
  'character varying': 'varchar',
  'bytea': 'bytea'
};

export const jsTypeMapping: { [key: string]: string } = {
  'integer': 'number',
  'bigint': 'number',
  'uuid': 'string',
  'timestamp without time zone': 'Date',
  'character varying': 'string',
  'bytea': 'Buffer'
};

export function toPascalCase(str: string): string {
  str = removeTbPrefix(str);
  return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
}

export function removeTbPrefix(str: string): string {
  return str.startsWith('tb_') ? str.substring(3) : str;
}
