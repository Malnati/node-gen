
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
	const primaryKeys = table.columns.filter(col => col.columnName.includes('id')); // Identifica colunas de chave primária (exemplo simplificado)

	const columns = table.columns
	  .filter(col => !this.isRelationColumn(col.columnName, table.relations))
	  .map(col => this.generateColumnDefinition(col, primaryKeys.includes(col)))
	  .join('\n  ');

	const relations = table.relations.map(rel => this.generateRelationDefinition(rel)).join('\n  ');
	const imports = this.generateImports(table);
	const customMethods = this.generateCustomMethods(table);

	return entityTemplate(table.tableName, columns, relations, imports, customMethods);
  }

  private generateColumnDefinition(column: Column, isPrimaryKey: boolean = false): string {
    const options: string[] = [];
    const typeOptions: string[] = [];

    if (column.isNullable) typeOptions.push('nullable: true');
    if (column.columnDefault) options.push(`default: "${column.columnDefault.replace(/"/g, '\\"')}"`);
    if (column.characterMaximumLength) options.push(`length: ${column.characterMaximumLength}`);

    let columnDecorator = `@Column({ type: '${typeMapping[column.dataType] || column.dataType}', ${options.join(', ')} })`;

    if (isPrimaryKey) {
        columnDecorator = `@PrimaryColumn({ type: '${typeMapping[column.dataType] || column.dataType}', ${options.join(', ')} })`;
    }

    if (column.columnName === 'created_at') {
        columnDecorator = `@CreateDateColumn()`;
    }

    if (column.columnName === 'updated_at') {
        columnDecorator = `@UpdateDateColumn()`;
    }

    if (column.columnName === 'deleted_at') {
        columnDecorator = `@DeleteDateColumn()`;
    }

    const apiPropertyDecorator = `@ApiProperty({ description: "${column.columnComment || ''}", ${typeOptions.join(', ')} })`;

    return columnTemplate(columnDecorator, apiPropertyDecorator, column.columnName, jsTypeMapping[column.dataType] || 'any');
  }

  private generateRelationDefinition(relation: Relation): string {
    let relationType: 'ManyToOne' | 'OneToOne' | 'OneToMany' | 'ManyToMany' = 'ManyToOne';

    if (relation.relationType === 'OneToOne') {
      relationType = 'OneToOne';
    } else if (relation.relationType === 'OneToMany') {
      relationType = 'OneToMany';
    } else if (relation.relationType === 'ManyToMany') {
      relationType = 'ManyToMany';
    }

    const propertyName = this.removeIdSuffix(relation.columnName);
    return relationTemplate(relationType, relation.foreignTableName, propertyName, relationType === 'ManyToOne' || relationType === 'OneToOne');
  }

  private generateImports(table: Table): string {
	const typeormImports = new Set<string>([
	  'Entity',
	  'Column',
	  'CreateDateColumn',
	  'UpdateDateColumn',
	  'DeleteDateColumn',
	  'PrimaryColumn',
	  'JoinColumn'
	]);

	table.relations.forEach(relation => {
	  typeormImports.add(relation.relationType);
	});

	const entityImports = table.relations.map(relation =>
	  `import { ${toPascalCase(relation.foreignTableName)}Entity } from './${removeTbPrefix(relation.foreignTableName)}';`
	).join('\n');

	const typeormImportsString = `import { ${Array.from(typeormImports).join(', ')} } from 'typeorm';`;

	return `${typeormImportsString}\nimport 'reflect-metadata';\nimport { ApiProperty } from '@nestjs/swagger';\n${entityImports}`;
  }
  
  private generateCustomMethods(table: Table): string {
	const column = table.columns.find(col =>
        !["id", "external_id", "updated_at", "created_at", "deleted_at"].includes(col.columnName)
    );

    const columnName = column ? ` - \${this.${this.removeIdSuffix(column.columnName)}}` : '';

    return `
    toString() {
      return \`\${this.external_id}${columnName}\`;
    }`;
  }

  private isRelationColumn(columnName: string, relations: Relation[]): boolean {
    return relations.some(relation => relation.columnName === columnName);
  }

  private removeIdSuffix(columnName: string): string {
    return columnName.endsWith('_id') && columnName !== 'external_id' ? columnName.slice(0, -3) : columnName;
  }
}
