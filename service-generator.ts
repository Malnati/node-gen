import * as fs from 'fs';
import * as path from 'path';
import { Table, Relation } from './interfaces';

class ServiceGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson);
  }

  generateServices(outputDir: string) {
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

      const serviceContent = this.generateServiceContent(entityName, kebabCaseName, table.relations);
      const filePath = path.join(subDir, `${kebabCaseName}.service.ts`);
      fs.writeFileSync(filePath, serviceContent);
    });

    console.log(`Services have been generated in ${outputDir}`);
  }

  private generateServiceContent(entityName: string, kebabCaseName: string, relations: Relation[]): string {
    const imports = relations.map(rel => this.generateImportForRelation(rel)).join('\n');
    const relationCheckAndAssignment = relations.map(rel => this.generateRelationCheckAndAssignment(rel, entityName)).join('\n\n    ');

    return `import { Injectable, Logger, NotFoundException } from "@nestjs/common";
import { DataSourceService } from "../config/datasource.service";
import { ${entityName}Entity } from "../entities/${entityName}.entity";
import { ${entityName}QueryDTO, ${entityName}PersistDTO } from "./${kebabCaseName}.dto";
${imports}

@Injectable()
export class ${entityName}Service {
  private readonly logger = new Logger(${entityName}Service.name);

  constructor(private dataSourceService: DataSourceService) {}

  async create(dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Creating ${entityName.toLowerCase()} with label: \${dto.label}\`);
    const newEntity = new ${entityName}Entity();
    newEntity.label = dto.label;
    newEntity.url = dto.url;

    ${relationCheckAndAssignment}

    const savedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(newEntity);

    return this.toDTO(savedEntity);
  }

  async findByExternalId(externalId: string): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Finding ${entityName.toLowerCase()} with External ID: \${externalId}\`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({
        where: { externalId }
      });

    if (!entity) {
      throw new NotFoundException("${entityName} não encontrado");
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

  async updateByExternalId(externalId: string, dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Updating ${entityName.toLowerCase()} with External ID: \${externalId}\`);
    let entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({ where: { externalId } });

    if (!entity) {
      throw new NotFoundException("${entityName} não encontrado");
    }

    entity.label = dto.label;
    entity.url = dto.url;

    ${relationCheckAndAssignment.replace(/newEntity/g, 'entity')}

    const updatedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(entity);

    return this.toDTO(updatedEntity);
  }

  async deleteByExternalId(externalId: string): Promise<void> {
    this.logger.log(\`Deleting ${entityName.toLowerCase()} with External ID: \${externalId}\`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({ where: { externalId } });

    if (!entity) {
      throw new NotFoundException("${entityName} não encontrado");
    }

    entity.deletedAt = new Date();
    await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(entity);
  }

  private toDTO(entity: ${entityName}Entity): ${entityName}QueryDTO {
    this.logger.log(\`Mapping entity to DTO: \${entity.externalId}\`);
    const dto = new ${entityName}QueryDTO();
    dto.label = entity.label;
    dto.url = entity.url;
    ${this.generateRelationMapping(relations)}
    dto.externalId = entity.externalId;
    return dto;
  }
}

${this.generateRelationFunctions(relations)}
`;
  }

  private generateImportForRelation(relation: Relation): string {
    const relatedEntityName = this.toPascalCase(relation.foreignTableName);
    return `import { ${relatedEntityName}Entity } from "../entities/${relatedEntityName}.entity";`;
  }

  private generateRelationCheckAndAssignment(relation: Relation, entityName: string): string {
    const relatedEntityName = this.toPascalCase(relation.foreignTableName);
    const relationName = this.toCamelCase(relation.columnName);
    return `const ${relationName} = await this.dataSourceService
      .getDataSource()
      .getRepository(${relatedEntityName}Entity)
      .findOne({ where: { externalId: dto.${relationName}Eid } });

    if (!${relationName}) {
      throw new NotFoundException("${relatedEntityName} não encontrado");
    }

    newEntity.${relationName} = ${relationName};`;
  }

  private generateRelationMapping(relations: Relation[]): string {
    return relations.map(rel => {
      const relationName = this.toCamelCase(rel.columnName);
      return `dto.${relationName}Eid = entity.${relationName}.externalId;`;
    }).join('\n    ');
  }

  private generateRelationFunctions(relations: Relation[]): string {
    return relations.map(rel => {
      const relationName = this.toCamelCase(rel.columnName);
      return `private async find${relationName.charAt(0).toUpperCase() + relationName.slice(1)}ByExternalId(externalId: string): Promise<${this.toPascalCase(rel.foreignTableName)}Entity> {
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${this.toPascalCase(rel.foreignTableName)}Entity)
      .findOne({ where: { externalId } });

    if (!entity) {
      throw new NotFoundException("${this.toPascalCase(rel.foreignTableName)} não encontrado");
    }
    return entity;
  }`;
    }).join('\n\n  ');
  }

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
  }

  private toCamelCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toLowerCase());
  }

  private toKebabCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_/g, '-').toLowerCase();
  }
}

// Usage
const schemaPath = path.join(__dirname, 'build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, 'build');

const generator = new ServiceGenerator(schemaPath);
generator.generateServices(outputDir);