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

      const hasExternalId = table.columns.some((c) => c.columnName === 'external_id');
      const pkColumns = table.columns.filter((c) => c.isPrimaryKey);
      const firstPkScalar =
        pkColumns.length === 1
          ? pkColumns[0]
          : table.columns.find(
              (c) => c.isPrimaryKey && !table.relations.some((r) => r.columnName === c.columnName),
            );
      const hasSingleScalarKey = hasExternalId || pkColumns.length === 1;
      const primaryKeyColumn = hasExternalId ? '' : (firstPkScalar ? toSnakeCase(firstPkScalar.columnName) : 'id');
      const data = {
        entityName,
        kebabCaseName,
        toSnakeCase,
        hasExternalId,
        hasSingleScalarKey,
        primaryKeyColumn,
        imports: this.generateImports(table),
        createUpdateAssignments: this.generateCreateUpdateAssignments(table.columns),
        relationCheckAndAssignment: this.generateRelationCheckAndAssignment(table.relations, table),
        updateAssignments: this.generateUpdateAssignments(table.columns),
        relationUpdateAndAssignment: this.generateRelationUpdateAndAssignment(table.relations, table),
        toDTOAssignments: this.generateToDTOAssignments(table.columns),
        relationMappings: this.generateRelationMappings(table.relations),
      };

      const serviceContent = ejs.render(templateContent, data);

      const filePath = path.join(subDir, `${kebabCaseName}.service.ts`);
      fs.writeFileSync(filePath, serviceContent);
    }

    console.log(`Services have been generated in ${outputDir}`);
  }

  private generateImports(table: Table): string {
    return table.relations
      .filter((rel) => rel.foreignTableName !== table.tableName)
      .map((rel) => {
        const relatedEntityName = toPascalCase(rel.foreignTableName);
        return `import { ${relatedEntityName}Entity } from "@app/entities/${toSnakeCase(relatedEntityName)}";`;
      })
      .join('\n');
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

  private foreignTableHasExternalId(relation: Relation): boolean {
    const foreign = this.schema.find((t) => t.tableName === relation.foreignTableName);
    return !!foreign?.columns.some((c) => c.columnName === 'external_id');
  }

  private isRelationOptional(table: Table, rel: Relation): boolean {
    const col = table.columns.find((c) => c.columnName === rel.columnName);
    return !!col?.isNullable;
  }

  private generateRelationCheckAndAssignment(relations: Relation[], table: Table): string {
    return relations.map(rel => {
      const relatedEntityName = toPascalCase(rel.foreignTableName);
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      const byEid = this.foreignTableHasExternalId(rel);
      const whereKey = byEid ? 'external_id' : 'id';
      const dtoKey = byEid ? `${relationName}_eid` : `${relationName}_id`;
      const optional = this.isRelationOptional(table, rel);
      const block = `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { ${whereKey}: dto.${dtoKey} } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} not found");
    }

    newEntity.${relationName} = ${relationName};`;
      return optional ? `if (dto.${dtoKey} != null) {\n    ${block}\n    }` : block;
    }).join('\n\n    ');
  }

  private generateRelationUpdateAndAssignment(relations: Relation[], table: Table): string {
    return relations.map(rel => {
      const relatedEntityName = toPascalCase(rel.foreignTableName);
      const relationName = toSnakeCase(rel.columnName.replace('_id', ''));
      const byEid = this.foreignTableHasExternalId(rel);
      const whereKey = byEid ? 'external_id' : 'id';
      const dtoKey = byEid ? `${relationName}_eid` : `${relationName}_id`;
      const optional = this.isRelationOptional(table, rel);
      const block = `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { ${whereKey}: dto.${dtoKey} } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} not found");
    }

    entity.${relationName} = ${relationName};`;
      return optional ? `if (dto.${dtoKey} != null) {\n    ${block}\n    }` : block;
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
      const byEid = this.foreignTableHasExternalId(rel);
      const dtoKey = byEid ? `${relationName}_eid` : `${relationName}_id`;
      const entityKey = byEid ? 'external_id' : 'id';
      return `dto.${dtoKey} = entity.${relationName}.${entityKey};`;
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
