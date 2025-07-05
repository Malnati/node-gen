// /src/service-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import * as ejs from 'ejs';
import { Table, Relation, Column, DbReaderConfig } from './interfaces';
import { toKebabCase, toPascalCase, toSnakeCase } from './utils/string';

export class ServiceGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  async generateServices() {
    const outputDir = path.join(this.config.outputDir, 'src/app');

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const templatePath = path.join(__dirname, '../templates/service.ejs');
    const templateContent = fs.readFileSync(templatePath, 'utf8');

    for (const table of this.schema) {
      const entityName = toPascalCase(table.tableName);
      const kebabCaseName = toKebabCase(table.tableName);
      const subDir = path.join(outputDir, kebabCaseName);

      if (!fs.existsSync(subDir)) {
        fs.mkdirSync(subDir, { recursive: true });
      }

      const data = {
        entityName,
        kebabCaseName,
        toSnakeCase,
        imports: this.generateImports(table.relations),
        createUpdateAssignments: this.generateCreateUpdateAssignments(table.columns),
        relationCheckAndAssignment: this.generateRelationCheckAndAssignment(table.relations, entityName),
        updateAssignments: this.generateUpdateAssignments(table.columns),
        relationUpdateAndAssignment: this.generateRelationUpdateAndAssignment(table.relations, entityName),
        toDTOAssignments: this.generateToDTOAssignments(table.columns),
        relationMappings: this.generateRelationMappings(table.relations),
      };

      const serviceContent = ejs.render(templateContent, data);

      const filePath = path.join(subDir, `${kebabCaseName}.service.ts`);
      fs.writeFileSync(filePath, serviceContent);
    }

    console.log(`Services have been generated in ${outputDir}`);
  }

  private generateImports(relations: Relation[]): string {
    return relations.map(rel => {
      const relatedEntityName = toPascalCase(rel.foreignTableName);
      return `import { ${relatedEntityName}Entity } from "@app/entities/${toSnakeCase(relatedEntityName)}";`;
    }).join('\n');
  }

  private generateCreateUpdateAssignments(columns: Column[]): string {
    return columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => {
        const columnName = toSnakeCase(col.columnName);
        return `newEntity.${columnName} = dto.${columnName};`;
      })
      .join('\n    ');
  }

  private generateUpdateAssignments(columns: Column[]): string {
    return columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => {
        const columnName = toSnakeCase(col.columnName);
        return `entity.${columnName} = dto.${columnName};`;
      })
      .join('\n    ');
  }

  private generateRelationCheckAndAssignment(relations: Relation[], entityName: string): string {
    return relations.map(rel => {
      const relatedEntityName = toPascalCase(rel.foreignTableName);
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      return `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { external_id: dto.${relationName}_eid } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} not found");
    }

    newEntity.${relationName} = ${relationName};`;
    }).join('\n\n    ');
  }

  private generateRelationUpdateAndAssignment(relations: Relation[], entityName: string): string {
    return relations.map(rel => {
      const relatedEntityName = toPascalCase(rel.foreignTableName);
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      return `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { external_id: dto.${relationName}_eid } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} not found");
    }

    entity.${relationName} = ${relationName};`;
    }).join('\n\n    ');
  }

  private generateToDTOAssignments(columns: Column[]): string {
    return columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => {
        const columnName = toSnakeCase(col.columnName);
        return `dto.${columnName} = entity.${columnName};`;
      })
      .join('\n    ');
  }

  private generateRelationMappings(relations: Relation[]): string {
    return relations.map(rel => {
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      return `dto.${relationName}_eid = entity.${relationName}.external_id;`;
    }).join('\n    ');
  }

  private shouldIncludeColumn(column: Column): boolean {
    if (['id', 'created_at', 'updated_at', 'deleted_at', 'external_id'].includes(column.columnName)) {
      return false;
    }
    if (column.columnName.endsWith('_id') && column.columnName !== 'external_id') {
      return false;
    }
    return true;
  }
}
