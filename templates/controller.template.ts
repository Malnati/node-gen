import { Controller, Get, Post, Put, Delete, Body, Param, NotFoundException, BadRequestException, InternalServerErrorException, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { {{entityName}}Service } from './{{kebabCaseName}}.service';
import { {{entityName}}QueryDTO, {{entityName}}PersistDTO } from './{{kebabCaseName}}.dto';
import { JwtAuthGuard } from '../middleware/jwt-auth.guard';

@ApiTags('{{kebabCaseName}}')
@Controller('{{kebabCaseName}}')
export class {{entityName}}Controller {
  constructor(private readonly {{kebabCaseServiceName}}Service: {{entityName}}Service) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
      summary: "Criação de um novo {{camelCaseName}}.",
      description: "Este endpoint cria um novo {{camelCaseName}} no sistema com as informações fornecidas.",
  })
  @ApiResponse({
      status: 201,
      description: 'O {{camelCaseName}} foi criado com sucesso.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: 400, description: 'Dados inválidos' })
  @ApiResponse({ status: 409, description: '{{entityName}} já existe' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async create(@Body() dto: {{entityName}}PersistDTO): Promise<{{entityName}}QueryDTO> {
      try {
        return await this.{{kebabCaseServiceName}}Service.create(dto);
      } catch (error) {
        if (error.code === '23505') {
          throw new BadRequestException('{{entityName}} já existe');
        }
        throw new InternalServerErrorException('Erro ao criar {{camelCaseName}}');
      }
  }

  @Get(':external_id')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
      summary: "Busca um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint busca um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: 200,
      description: 'O {{camelCaseName}} foi encontrado.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: 404, description: '{{entityName}} não encontrado' })
  async findByExternalId(@Param('external_id') external_id: string): Promise<{{entityName}}QueryDTO> {
      try {
        return await this.{{kebabCaseServiceName}}Service.findByExternalId(external_id);
      } catch (error) {
        throw new NotFoundException('{{entityName}} não encontrado');
      }
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
      summary: "Busca todos os {{camelCaseName}}s.",
      description: "Este endpoint busca todos os {{camelCaseName}}s cadastrados no sistema.",
  })
  @ApiResponse({
      status: 200,
      description: 'Lista de {{camelCaseName}}s.',
      type: [{{entityName}}QueryDTO],
  })
  async findAll(): Promise<{{entityName}}QueryDTO[]> {
      return await this.{{kebabCaseServiceName}}Service.findAll();
  }

  @Put(':external_id')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
      summary: "Atualiza um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint atualiza os detalhes de um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: 200,
      description: 'O {{camelCaseName}} foi atualizado com sucesso.',
      type: {{entityName}}QueryDTO,
  })
  @ApiResponse({ status: 400, description: 'Dados inválidos' })
  @ApiResponse({ status: 404, description: '{{entityName}} não encontrado' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async updateByExternalId(@Param('external_id') external_id: string, @Body() dto: {{entityName}}PersistDTO): Promise<{{entityName}}QueryDTO> {
      try {
        return await this.{{kebabCaseServiceName}}Service.updateByExternalId(external_id, dto);
      } catch (error) {
        if (error instanceof NotFoundException) {
          throw new NotFoundException('{{entityName}} não encontrado');
        }
        throw new InternalServerErrorException('Erro ao atualizar {{camelCaseName}}');
      }
  }

  @Delete(':external_id')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
      summary: "Deleta um {{camelCaseName}} pelo External ID.",
      description: "Este endpoint deleta um {{camelCaseName}} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
      status: 204,
      description: 'O {{camelCaseName}} foi deletado com sucesso.',
  })
  @ApiResponse({ status: 404, description: '{{entityName}} não encontrado' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async deleteByExternalId(@Param('external_id') external_id: string): Promise<void> {
      try {
        await this.{{kebabCaseServiceName}}Service.deleteByExternalId(external_id);
      } catch (error) {
        if (error instanceof NotFoundException) {
          throw new NotFoundException('{{entityName}} não encontrado');
        }
        throw new InternalServerErrorException('Erro ao deletar {{camelCaseName}}');
      }
  }
}
