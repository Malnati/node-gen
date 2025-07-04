import { Controller, Get, Post, Put, Delete, Body, Param, NotFoundException, BadRequestException, InternalServerErrorException, UseGuards, ParseUUIDPipe, HttpCode, HttpStatus, Logger } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { {{entityName}}Service } from './{{kebabCaseName}}.service';
import { {{entityName}}QueryDTO, {{entityName}}PersistDTO } from './{{kebabCaseName}}.dto';
import { JwtAuthGuard } from '../middleware/jwt-auth.guard';

@ApiTags('{{kebabCaseName}}')
@UseGuards(JwtAuthGuard)
@Controller('{{kebabCaseName}}')
/** Controller responsible for {{camelCaseName}} operations. */
export class {{entityName}}Controller {
  private readonly logger = new Logger({{entityName}}Controller.name);

  constructor(private readonly {{kebabCaseServiceName}}Service: {{entityName}}Service) {}

  /**
   * Creates a new {{camelCaseName}}.
   */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
      summary: "Criação de um novo {{camelCaseName}}.",
      description: "Este endpoint cria um novo {{camelCaseName}} no sistema com as informações fornecidas.",
  })
  @ApiResponse({
      status: HttpStatus.CREATED,
      description: 'O {{camelCaseName}} foi criado com sucesso.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Dados inválidos' })
  @ApiResponse({ status: HttpStatus.CONFLICT, description: '{{entityName}} já existe' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async create(@Body() dto: {{entityName}}PersistDTO): Promise<{{entityName}}QueryDTO> {
      this.logger.log('Creating {{camelCaseName}}');
      try {
        return await this.{{kebabCaseServiceName}}Service.create(dto);
      } catch (error) {
        if (error.code === '23505') {
          this.logger.warn('Duplicate {{camelCaseName}}');
          throw new BadRequestException('{{entityName}} já existe');
        }
        this.logger.error(`Error creating {{camelCaseName}}: ${error.message}`);
        throw new InternalServerErrorException('Erro ao criar {{camelCaseName}}');
      }
  }

  /**
   * Busca um {{camelCaseName}} pelo External ID.
   */
  @Get(':external_id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Busca um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint busca um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O {{camelCaseName}} foi encontrado.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '{{entityName}} não encontrado' })
  async findByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string): Promise<{{entityName}}QueryDTO> {
      this.logger.log(`Finding {{camelCaseName}} with External ID: ${external_id}`);
      try {
        return await this.{{kebabCaseServiceName}}Service.findByExternalId(external_id);
      } catch (error) {
        this.logger.error(`Error finding {{camelCaseName}}: ${error.message}`);
        throw new NotFoundException('{{entityName}} não encontrado');
      }
  }

  /**
   * Busca todos os {{camelCaseName}}s cadastrados.
   */
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Busca todos os {{camelCaseName}}s.",
      description: "Este endpoint busca todos os {{camelCaseName}}s cadastrados no sistema.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'Lista de {{camelCaseName}}s.',
      type: [{{entityName}}QueryDTO],
  })
  async findAll(): Promise<{{entityName}}QueryDTO[]> {
      this.logger.log('Finding all {{camelCaseName}}s');
      return await this.{{kebabCaseServiceName}}Service.findAll();
  }

  /**
   * Atualiza um {{camelCaseName}} pelo External ID.
   */
  @Put(':external_id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Atualiza um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint atualiza os detalhes de um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O {{camelCaseName}} foi atualizado com sucesso.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Dados inválidos' })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '{{entityName}} não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async updateByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string, @Body() dto: {{entityName}}PersistDTO): Promise<{{entityName}}QueryDTO> {
      this.logger.log(`Updating {{camelCaseName}} with External ID: ${external_id}`);
      try {
        return await this.{{kebabCaseServiceName}}Service.updateByExternalId(external_id, dto);
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to update non-existing {{camelCaseName}}');
          throw new NotFoundException('{{entityName}} não encontrado');
        }
        this.logger.error(`Error updating {{camelCaseName}}: ${error.message}`);
        throw new InternalServerErrorException('Erro ao atualizar {{camelCaseName}}');
      }
  }

  /**
   * Deleta um {{camelCaseName}} pelo External ID.
   */
  @Delete(':external_id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
      summary: "Deleta um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint deleta um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.NO_CONTENT,
      description: 'O {{camelCaseName}} foi deletado com sucesso.',
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '{{entityName}} não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async deleteByExternalId(@Param('external_id', ParseUUIDPipe) external_id: string): Promise<void> {
      this.logger.log(`Deleting {{camelCaseName}} with External ID: ${external_id}`);
      try {
        await this.{{kebabCaseServiceName}}Service.deleteByExternalId(external_id);
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to delete non-existing {{camelCaseName}}');
          throw new NotFoundException('{{entityName}} não encontrado');
        }
        this.logger.error(`Error deleting {{camelCaseName}}: ${error.message}`);
        throw new InternalServerErrorException('Erro ao deletar {{camelCaseName}}');
      }
  }
}
