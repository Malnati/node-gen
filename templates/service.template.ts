import { Injectable, Logger, NotFoundException } from "@nestjs/common";
import { DataSourceService } from "../config/datasource.service";
import { <%= entityName %>Entity } from "@app/entities/<%= snakeEntityName %>";
import { <%= entityName %>QueryDTO, <%= entityName %>PersistDTO } from "./<%= kebabCaseName %>.dto";
<%- imports %>

@Injectable()
export class <%= entityName %>Service {
  private readonly logger = new Logger(<%= entityName %>Service.name);

  constructor(private dataSourceService: DataSourceService) {}

  async create(dto: <%= entityName %>PersistDTO): Promise<<%= entityName %>QueryDTO> {
    this.logger.log(`Creating <%= entityName.toLowerCase() %>`);
    const newEntity = new <%= entityName %>Entity();
    <%- createUpdateAssignments %>

    <%- relationCheckAndAssignment %>

    const savedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .save(newEntity);

    return this.toDTO(savedEntity);
import { {{entityName}}Entity } from "@app/entities/{{snakeEntityName}}";
import { {{entityName}}QueryDTO, {{entityName}}PersistDTO } from "./{{kebabCaseName}}.dto";
{{imports}}

@Injectable()
export class {{entityName}}Service {
  private readonly logger = new Logger({{entityName}}Service.name);

  constructor(private dataSourceService: DataSourceService) {}

  async create(dto: {{entityName}}PersistDTO): Promise<{{entityName}}QueryDTO> {
    this.logger.log(`Creating {{entityLower}}`);
    const newEntity = new {{entityName}}Entity();
    {{createUpdateAssignments}}

    {{relationCheckAndAssignment}}

    const savedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository({{entityName}}Entity)
      .save(newEntity);

    return this.toDTO(savedEntity);
  }

  async findByExternalId(external_id: string): Promise<<%= entityName %>QueryDTO> {
    this.logger.log(`Finding <%= entityName.toLowerCase() %> with External ID: ${external_id}`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
  async findByExternalId(external_id: string): Promise<{{entityName}}QueryDTO> {
    this.logger.log(`Finding {{entityLower}} with External ID: ${external_id}`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository({{entityName}}Entity)
      .findOne({
        where: { external_id }
      });

    if (!entity) {
      throw new NotFoundException("<%= entityName %> not found");
    }

    return this.toDTO(entity);
  }

  async findAll(): Promise<<%= entityName %>QueryDTO[]> {
    this.logger.log("Finding all <%= entityName.toLowerCase() %>s");
    const entities = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .find();
    return entities.map((entity: <%= entityName %>Entity) => this.toDTO(entity));
  }

  async updateByExternalId(external_id: string, dto: <%= entityName %>PersistDTO): Promise<<%= entityName %>QueryDTO> {
    this.logger.log(`Updating <%= entityName.toLowerCase() %> with External ID: ${external_id}`);
    let entity = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .findOne({ where: { external_id } });

    if (!entity) {
      throw new NotFoundException("<%= entityName %> not found");
    }
    <%- updateAssignments %>

    <%- relationUpdateAndAssignment %>

    const updatedEntity = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .save(entity);

    return this.toDTO(updatedEntity);
  }

  async deleteByExternalId(external_id: string): Promise<void> {
    this.logger.log(`Deleting <%= entityName.toLowerCase() %> with External ID: ${external_id}`);
    const entity = await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .findOne({ where: { external_id } });

    if (!entity) {
      throw new NotFoundException("<%= entityName %> not found");
    }

    await this.dataSourceService
      .getDataSource()
      .getRepository(<%= entityName %>Entity)
      .softDelete({ external_id: entity.external_id });
  }

  private toDTO(entity: <%= entityName %>Entity): <%= entityName %>QueryDTO {
    this.logger.log(`Mapping entity to DTO: ${entity.external_id}`);
    const dto = new <%= entityName %>QueryDTO();
    <%- toDTOAssignments %>
    <%- relationMappings %>
    dto.external_id = entity.external_id;
    return dto;
  }
}
