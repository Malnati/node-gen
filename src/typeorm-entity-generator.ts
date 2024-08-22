
// src/typeorm-entity-generator.ts

import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, Relation, DbReaderConfig } from './interfaces';
import { entityTemplate, columnTemplate, relationTemplate, typeMapping, jsTypeMapping, toPascalCase, removeTbPrefix } from './static-templates';

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
			const filePath = path.join(outputDir, `${removeTbPrefix(table.tableName)}.ts`);
			fs.writeFileSync(filePath, entityContent);
		});

		console.log(`Entities have been generated in ${outputDir}`);
	}

	private generateEntityContent(table: Table): string {
		const columns = table.columns.map(col => this.generateColumnDefinition(col)).join('\n  ');
		const relations = table.relations.map(rel => this.generateRelationDefinition(rel)).join('\n  ');

		return entityTemplate(table.tableName, columns, relations);
	}

	private generateColumnDefinition(column: Column): string {
		const options: string[] = [];
		const typeOptions: string[] = [];

		if (column.isNullable) typeOptions.push('nullable: true');
		if (column.columnDefault) options.push(`default: "${column.columnDefault.replace(/"/g, '\\"')}"`);
		if (column.characterMaximumLength) options.push(`length: ${column.characterMaximumLength}`);

		const columnDecorator = column.columnName === 'id'
			? '@PrimaryGeneratedColumn()'
			: `@Column({ type: '${typeMapping[column.dataType] || column.dataType}', ${options.join(', ')} })`;

		const apiPropertyDecorator = `@ApiProperty({ description: "${column.columnComment || ''}", ${typeOptions.join(', ')} })`;

		return columnTemplate(columnDecorator, apiPropertyDecorator, column.columnName, jsTypeMapping[column.dataType] || 'any');
	}

	private generateRelationDefinition(relation: Relation): string {
		return relationTemplate(relation.foreignTableName, relation.columnName);
	}
}
