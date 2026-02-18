// /templates/controller.template.ts
import { Controller, Get, Post, Put, Delete, Body, Param, NotFoundException, BadRequestException, InternalServerErrorException, UseGuards, ParseUUIDPipe, HttpCode, HttpStatus, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { UserService } from './user.service';
import { UserQueryDTO, UserPersistDTO } from './user.dto';
import { JwtAuthGuard } from '../middleware/jwt-auth.guard';

@ApiTags('user')
@UseGuards(JwtAuthGuard)
@Controller('user')
/** Controller responsible for user operations. */
export class UserController {
  private readonly logger = new Logger(UserController.name);

  constructor(private readonly userService: UserService) {}

  /**
   * Creates a new user.
   */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
      summary: "Criação de um novo user.",
      description: "Este endpoint cria um novo user no sistema com as informações fornecidas.",
  })
  @ApiResponse({
      status: HttpStatus.CREATED,
      description: 'O user foi criado com sucesso.',
      type: UserQueryDTO,
  })
  @ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Dados inválidos' })
  @ApiResponse({ status: HttpStatus.CONFLICT, description: 'User já existe' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async create(@Body() dto: UserPersistDTO): Promise<UserQueryDTO> {
      this.logger.log('Creating user');
      try {
        return await this.userService.create(dto);
      } catch (error) {
        if (error.code === '23505') {
          this.logger.warn('Duplicate user');
          throw new BadRequestException('User já existe');
        }
        this.logger.error(`Error creating user: ${error.message}`);
        throw new InternalServerErrorException('Erro ao criar user');
      }
  }

  /**
   * Busca um user pelo External ID.
   */
  @Get(':external_id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Busca um user pelo External ID.",
      description: "Este endpoint busca um user no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O user foi encontrado.',
      type: UserQueryDTO,
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'User não encontrado' })
  async findByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string): Promise<UserQueryDTO> {
      this.logger.log(`Finding user with External ID: ${external_id}`);
      try {
        return await this.userService.findByExternalId(external_id);
      } catch (error) {
        this.logger.error(`Error finding user: ${error.message}`);
        throw new NotFoundException('User não encontrado');
      }
  }

  /**
   * Busca todos os users cadastrados.
   */
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Busca todos os users.",
      description: "Este endpoint busca todos os users cadastrados no sistema.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'Lista de users.',
      type: [UserQueryDTO],
  })
  async findAll(): Promise<UserQueryDTO[]> {
      this.logger.log('Finding all users');
      return await this.userService.findAll();
  }

  /**
   * Atualiza um user pelo External ID.
   */
  @Put(':external_id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Atualiza um user pelo External ID.",
      description: "Este endpoint atualiza os detalhes de um user no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O user foi atualizado com sucesso.',
      type: UserQueryDTO,
  })
  @ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Dados inválidos' })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'User não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async updateByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string, @Body() dto: UserPersistDTO): Promise<UserQueryDTO> {
      this.logger.log(`Updating user with External ID: ${external_id}`);
      try {
        return await this.userService.updateByExternalId(external_id, dto);
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to update non-existing user');
          throw new NotFoundException('User não encontrado');
        }
        this.logger.error(`Error updating user: ${error.message}`);
        throw new InternalServerErrorException('Erro ao atualizar user');
      }
  }

  /**
   * Deleta um user pelo External ID.
   */
  @Delete(':external_id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
      summary: "Deleta um user pelo External ID.",
      description: "Este endpoint deleta um user no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.NO_CONTENT,
      description: 'O user foi deletado com sucesso.',
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: 'User não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async deleteByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string): Promise<void> {
      this.logger.log(`Deleting user with External ID: ${external_id}`);
      try {
        await this.userService.deleteByExternalId(external_id);
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to delete non-existing user');
          throw new NotFoundException('User não encontrado');
        }
        this.logger.error(`Error deleting user: ${error.message}`);
        throw new InternalServerErrorException('Erro ao deletar user');
      }
  }
}
