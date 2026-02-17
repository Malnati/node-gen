// /templates/service.ejs
import { Injectable, Logger, NotFoundException } from "@nestjs/common";
import { Repository } from "typeorm";
import { DataSourceService } from "../config/datasource.service";
import { UserEntity } from "@app/entities/user";
import { UserQueryDTO, UserPersistDTO } from "./user.dto";


@Injectable()
/**
 * Service responsible for managing User entities.
 *
 * Provides CRUD operations and mapping helpers for
 * `@app/entities/user` objects.
 */
export class UserService {
  private readonly logger = new Logger(UserService.name);
  /** Repository for database access */
  private repository: Repository<UserEntity>;

  constructor(private dataSourceService: DataSourceService) {
    this.repository = this.dataSourceService
      .getDataSource()
      .getRepository(UserEntity);
  }

  /**
   * Creates a new User.
   *
   * @param dto Payload used to persist the entity.
   * @returns Persisted User data.
   * @throws Error When the insert operation fails.
   */
  async create(dto: UserPersistDTO): Promise<UserQueryDTO> {
    this.logger.log(`Creating user`);
    try {
      const newEntity = new UserEntity();
      newEntity.name = dto.name;

      // Validate and assign related entities
      

      const savedEntity = await this.repository.manager.transaction(async manager =>
        manager.getRepository(UserEntity).save(newEntity)
      );

      return this.toDTO(savedEntity);
    } catch (error) {
      this.logger.error(`Error creating user: ${error.message}`);
      throw error;
    }
  }

  /**
   * Finds a User by external ID.
   *
   * @param external_id Identifier of the entity.
   * @returns Corresponding User data.
   * @throws NotFoundException When the entity does not exist.
   * @throws Error When the lookup fails.
   */
  async findByExternalId(external_id: string): Promise<UserQueryDTO> {
    this.logger.log(`Finding user with External ID: ${external_id}`);
    try {
      const entity = await this.repository.findOne({ where: { external_id } });

      if (!entity) {
        throw new NotFoundException("User not found");
      }

      return this.toDTO(entity);
    } catch (error) {
      this.logger.error(`Error finding user: ${error.message}`);
      throw error;
    }
  }

  /**
   * Retrieves all User records.
   *
   * @returns Array of User DTOs.
   * @throws Error When the query fails.
   */
  async findAll(): Promise<UserQueryDTO[]> {
    this.logger.log("Finding all users");
    try {
      const entities = await this.repository.find();
      return entities.map((entity: UserEntity) => this.toDTO(entity));
    } catch (error) {
      this.logger.error(`Error listing users: ${error.message}`);
      throw error;
    }
  }

  /**
   * Updates a User identified by external ID.
   *
   * @param external_id Identifier of the entity.
   * @param dto Payload with updated values.
   * @returns Updated User data.
   * @throws NotFoundException When the entity does not exist.
   * @throws Error When the update fails.
   */
  async updateByExternalId(external_id: string, dto: UserPersistDTO): Promise<UserQueryDTO> {
    this.logger.log(`Updating user with External ID: ${external_id}`);
    try {
      let entity = await this.repository.findOne({ where: { external_id } });

      if (!entity) {
        throw new NotFoundException("User not found");
      }
      entity.name = dto.name;

      // Validate and assign related entities
      

      const updatedEntity = await this.repository.manager.transaction(async manager =>
        manager.getRepository(UserEntity).save(entity)
      );

      return this.toDTO(updatedEntity);
    } catch (error) {
      this.logger.error(`Error updating user: ${error.message}`);
      throw error;
    }
  }

  /**
   * Deletes a User by external ID.
   *
   * @param external_id Identifier of the entity.
   * @throws NotFoundException When the entity does not exist.
   * @throws Error When the delete fails.
   */
  async deleteByExternalId(external_id: string): Promise<void> {
    this.logger.log(`Deleting user with External ID: ${external_id}`);
    try {
      const entity = await this.repository.findOne({ where: { external_id } });

      if (!entity) {
        throw new NotFoundException("User not found");
      }

      await this.repository.softDelete({ external_id: entity.external_id });
    } catch (error) {
      this.logger.error(`Error deleting user: ${error.message}`);
      throw error;
    }
  }

  /**
   * Maps an entity instance to its DTO representation.
   *
   * @param entity Entity being converted.
   * @returns The corresponding DTO.
   */
  private toDTO(entity: UserEntity): UserQueryDTO {
    this.logger.log(`Mapping entity to DTO: ${entity.external_id}`);
    const dto = new UserQueryDTO();
    dto.name = entity.name;
    
    dto.external_id = entity.external_id;
    return dto;
  }
}
