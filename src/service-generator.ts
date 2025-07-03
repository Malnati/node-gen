#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, Relation, Column, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase, toSnakeCase } from './utils/string';
import { renderTemplate } from './utils/TemplateEngine';
import { loadTemplate } from './utils/template-loader';

export class ServiceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateServices() {
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

      const serviceContent = this.generateServiceContent(entityName, kebabCaseName, table.relations, table.columns);
      const filePath = path.join(subDir, `${kebabCaseName}.service.ts`);
      fs.writeFileSync(filePath, serviceContent);
    });

    console.log(`Services have been generated in ${outputDir}`);
  }

  private generateServiceContent(entityName: string, kebabCaseName: string, relations: Relation[], columns: Column[]): string {
    const templatePath = path.join('templates', 'service.template.ts');
    const imports = relations.map(rel => this.generateImportForRelation(rel)).join('\n');
    const relationCheckAndAssignment = relations.map(rel => this.generateRelationCheckAndAssignment(rel, entityName)).join('\n\n    ');

    const createUpdateAssignments = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateAssignment(col, 'newEntity', 'dto'))
      .join('\n    ');

    const updateAssignments = createUpdateAssignments.replace(/newEntity/g, 'entity');

    const toDTOAssignments = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateAssignment(col, 'dto', 'entity'))
      .join('\n    ');

    return renderTemplate(templatePath, {
      entityName,
      kebabCaseName,
      snakeEntityName: toSnakeCase(entityName),
      imports,
      createUpdateAssignments,
      relationCheckAndAssignment,
      updateAssignments,
      relationUpdateAndAssignment: relationCheckAndAssignment.replace(/newEntity/g, 'entity'),
      toDTOAssignments,
      relationMappings: this.generateRelationMapping(relations),
    });
  }

  private generateImportForRelation(relation: Relation): string {
    const relatedEntityName = toPascalCase(relation.foreignTableName);
    return `import { ${relatedEntityName}Entity } from "@app/entities/${toSnakeCase(relatedEntityName)}";`;
  }

  private generateRelationCheckAndAssignment(relation: Relation, entityName: string): string {
    const relatedEntityName = toPascalCase(relation.foreignTableName);
    const relationName = toSnakeCase(relation.columnName.replace('_id', ''));
    return `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { external_id: dto.${relationName}_eid } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} not found");
    }

    newEntity.${relationName} = ${relationName};`;
  }

  private generateRelationMapping(relations: Relation[]): string {
    return relations.map(rel => {
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      return `dto.${relationName}_eid = entity.${relationName}.external_id;`;
    }).join('\n    ');
  }

  private generateAssignment(column: Column, target: string, source: string): string {
    const columnName = toSnakeCase(column.columnName);
    return `${target}.${columnName} = ${source}.${columnName};`;
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
}
