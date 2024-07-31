import * as fs from 'fs';
import * as path from 'path';
import { Table } from './interfaces';

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

      const serviceContent = this.generateServiceContent(entityName, kebabCaseName);
      const filePath = path.join(subDir, `${kebabCaseName}.service.ts`);
      fs.writeFileSync(filePath, serviceContent);
    });

    console.log(`Services have been generated in ${outputDir}`);
  }

  private generateServiceContent(entityName: string, kebabCaseName: string): string {
    return `import { Injectable, Logger, NotFoundException } from "@nestjs/common";
import { DataSourceService, cacheDuration } from "../config/datasource.service";
import { ${entityName}Entity } from "../entities/${entityName}.entity";
import { ${entityName}QueryDTO, ${entityName}PersistDTO } from "./${kebabCaseName}.dto";

@Injectable()
export class ${entityName}Service {
  private readonly logger = new Logger(${entityName}Service.name);

  constructor(private dataSourceService: DataSourceService) {}

  async create(dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Creating ${entityName.toLowerCase()} with label: \${dto.label}\`);
    const newEntity = new ${entityName}Entity();
    newEntity.label = dto.label;
    newEntity.url = dto.url;

    const optin = await this.dataSourceService
      .getDataSource()
      .getRepository(OptinEntity)
      .findOne({ where: { externalId: dto.optinEid } });

    if (!optin) {
      throw new NotFoundException("Opt-in não encontrado");
    }

    newEntity.optin = optin;

    const savedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(newEntity);

    await this.dataSourceService.getDataSource().queryResultCache?.remove(["${entityName.toLowerCase()}_cache"]);
    return this.toDTO(savedEntity);
  }

  async findByExternalId(externalId: string): Promise<${entityName}QueryDTO> {
    this.logger.log(\`Finding ${entityName.toLowerCase()} with External ID: \${externalId}\`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .findOne({
        where: { externalId },
        cache: {
          id: \`${entityName.toLowerCase()}_cache_\${externalId}\`,
          milliseconds: cacheDuration
        }
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
      .find({
        cache: {
          id: "${entityName.toLowerCase()}_cache",
          milliseconds: cacheDuration 
        }
      });
    return entities.map((entity) => this.toDTO(entity));
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

    const optin = await this.dataSourceService
      .getDataSource()
      .getRepository(OptinEntity)
      .findOne({ where: { externalId: dto.optinEid } });

    if (!optin) {
      throw new NotFoundException("Opt-in não encontrado");
    }

    entity.optin = optin;

    const updatedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(${entityName}Entity)
      .save(entity);

    await this.dataSourceService.getDataSource().queryResultCache?.remove(["${entityName.toLowerCase()}_cache"]);
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

    await this.dataSourceService.getDataSource().queryResultCache?.remove(["${entityName.toLowerCase()}_cache"]);
  }

  private toDTO(entity: ${entityName}Entity): ${entityName}QueryDTO {
    this.logger.log(\`Mapping entity to DTO: \${entity.externalId}\`);
    const dto = new ${entityName}QueryDTO();
    dto.label = entity.label;
    dto.url = entity.url;
    dto.optinEid = entity.optin.externalId;
    dto.externalId = entity.externalId;
    return dto;
  }
}`;
  }

  private toPascalCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3);  // Remove the 'tb_' prefix
    }
    return str.replace(/_./g, match => match.charAt(1).toUpperCase()).replace(/^./, match => match.toUpperCase());
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