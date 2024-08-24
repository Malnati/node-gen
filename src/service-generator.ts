#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import { Table, Relation, Column, DbReaderConfig } from './interfaces';

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
      const entityName = this.toPascalCase(table.tableName);
      const kebabCaseName = this.toKebabCase(table.tableName);
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
    const imports = relations.map(rel => this.generateImportForRelation(rel)).join('\n');
    const relationCheckAndAssignment = relations.map(rel => this.generateRelationCheckAndAssignment(rel, entityName)).join('\n\n    ');

    const createUpdateAssignments = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateAssignment(col, 'newEntity', 'dto'))
      .join('\n    ');

    const toDTOAssignments = columns
      .filter(col => this.shouldIncludeColumn(col))
      .map(col => this.generateAssignment(col, 'dto', 'entity'))
      .join('\n    ');

    return `import { Injectable, Logger, NotFoundException } from "@nestjs/common";
import { DataSourceService } from "../config/datasource.service";
import { ${entityName}Entity } from "@app/entities/${entityName.toLowerCase()}";
import { ${entityName}QueryDTO, ${entityName}PersistDTO } from "./${kebabCaseName}.dto";
${imports}

@Injectable()
export class ${entityName}Service {
  private readonly logger = new Logger(${entityName}Service.name);

  constructor(private dataSourceService: DataSourceService) {}

  async create(dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Creating ${entityName.toLowerCase()}\`);
    const newEntity = new ${entityName}Entity();
    ${createUpdateAssignments}

    ${relationCheckAndAssignment}

    const savedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(newEntity);

    return this.toDTO(savedEntity);
  }

  async findByExternalId(external_id: string): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Finding ${entityName.toLowerCase()} with External ID: \${external_id}\`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({
        where: { external_id }
      });

    if (!entity) {
      throw new NotFoundException("${entityName} not found");
    }

    return this.toDTO(entity);
  }

  async findAll(): Promise<${entityName}QueryDTO[]> {
    this.logger.log("Finding all ${entityName.toLowerCase()}s");
    const entities = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .find();
    return entities.map((entity: ${entityName}Entity) => this.toDTO(entity));
  }

  async updateByExternalId(external_id: string, dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Updating ${entityName.toLowerCase()} with External ID: \${external_id}\`);
    let entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({ where: { external_id } });

    if (!entity) {
      throw new NotFoundException("${entityName} not found");
    }
    ${createUpdateAssignments.replace(/newEntity/g, 'entity')}

    ${relationCheckAndAssignment.replace(/newEntity/g, 'entity')}

    const updatedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(entity);

    return this.toDTO(updatedEntity);
  }

  async deleteByExternalId(external_id: string): Promise<void> {
    this.logger.log(\`Deleting ${entityName.toLowerCase()} with External ID: \${external_id}\`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({ where: { external_id } });

    if (!entity) {
      throw new NotFoundException("${entityName} not found");
    }

    await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .softDelete({ external_id: entity.external_id });
  }

  private toDTO(entity: ${entityName}Entity): ${entityName}QueryDTO {
    this.logger.log(\`Mapping entity to DTO: \${entity.external_id}\`);
    const dto = new ${entityName}QueryDTO();
    ${toDTOAssignments}
    ${this.generateRelationMapping(relations)}
    dto.external_id = entity.external_id;
    return dto;
  }
  }`;
  }

  private generateImportForRelation(relation: Relation): string {
    const relatedEntityName = this.toPascalCase(relation.foreignTableName);
    return `import { ${relatedEntityName}Entity } from "@app/entities/${this.toSnakeCase(relatedEntityName)}";`;
  }

  private generateRelationCheckAndAssignment(relation: Relation, entityName: string): string {
    const relatedEntityName = this.toPascalCase(relation.foreignTableName);
    const relationName = this.toSnakeCase(relation.columnName.replace('_id', ''));
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
      const relationName = this.toSnakeCase(rel.columnName.replace('_id', ''));
      return `dto.${relationName}_eid = entity.${relationName}.external_id;`;
    }).join('\n    ');
  }

  private generateAssignment(column: Column, target: string, source: string): string {
    const columnName = this.toSnakeCase(column.columnName);
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

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  private toSnakeCase(str: string): string {
    return str.replace(/([A-Z])/g, "_$1").toLowerCase().replace(/^_/, '');
  }

  private toKebabCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_/g, '-').toLowerCase();
  }
}
