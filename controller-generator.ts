import * as fs from 'fs';
import * as path from 'path';
import { Table, Relation, Column } from './interfaces';

class ControllerGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson);
  }

  generateControllers(outputDir: string) {
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

      const controllerContent = this.generateControllerContent(entityName, kebabCaseName);
      const filePath = path.join(subDir, `${kebabCaseName}.controller.ts`);
      fs.writeFileSync(filePath, controllerContent);
    });

    console.log(`Controllers have been generated in ${outputDir}`);
  }

  private generateControllerContent(entityName: string, kebabCaseName: string): string {
    return `import { Controller, Get, Post, Put, Delete, Body, Param, NotFoundException, BadRequestException, InternalServerErrorException, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { ${entityName}Service } from './${kebabCaseName}.service';
import { ${entityName}QueryDTO, ${entityName}PersistDTO } from './${kebabCaseName}.dto';
import { JwtAuthGuard } from '../middleware/jwt-auth.guard';

@ApiTags('${kebabCaseName}')
@Controller('${kebabCaseName}')
export class ${entityName}Controller {
  constructor(private readonly ${kebabCaseName}Service: ${entityName}Service) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: "Criação de um novo ${kebabCaseName}.",
    description: "Este endpoint cria um novo ${kebabCaseName} no sistema com as informações fornecidas.",
  })
  @ApiResponse({
    status: 201,
    description: 'O ${kebabCaseName} foi criado com sucesso.',
    type: ${entityName}QueryDTO,
  })
  @ApiResponse({ status: 400, description: 'Dados inválidos' })
  @ApiResponse({ status: 409, description: '${entityName} já existe' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async create(@Body() dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    try {
      return await this.${kebabCaseName}Service.create(dto);
    } catch (error) {
      if (error.code === '23505') {
        throw new BadRequestException('${entityName} já existe');
      }
      throw new InternalServerErrorException('Erro ao criar ${kebabCaseName}');
    }
  }

  @Get(':externalId')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: "Busca um ${kebabCaseName} pelo External ID.",
    description: "Este endpoint busca um ${kebabCaseName} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
    status: 200,
    description: 'O ${kebabCaseName} foi encontrado.',
    type: ${entityName}QueryDTO,
  })
  @ApiResponse({ status: 404, description: '${entityName} não encontrado' })
  async findByExternalId(@Param('externalId') externalId: string): Promise<${entityName}QueryDTO> {
    try {
      return await this.${kebabCaseName}Service.findByExternalId(externalId);
    } catch (error) {
      throw new NotFoundException('${entityName} não encontrado');
    }
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: "Busca todos os ${kebabCaseName}s.",
    description: "Este endpoint busca todos os ${kebabCaseName}s cadastrados no sistema.",
  })
  @ApiResponse({
    status: 200,
    description: 'Lista de ${kebabCaseName}s.',
    type: [${entityName}QueryDTO],
  })
  async findAll(): Promise<${entityName}QueryDTO[]> {
    return await this.${kebabCaseName}Service.findAll();
  }

  @Put(':externalId')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: "Atualiza um ${kebabCaseName} pelo External ID.",
    description: "Este endpoint atualiza os detalhes de um ${kebabCaseName} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
    status: 200,
    description: 'O ${kebabCaseName} foi atualizado com sucesso.',
    type: ${entityName}QueryDTO,
  })
  @ApiResponse({ status: 400, description: 'Dados inválidos' })
  @ApiResponse({ status: 404, description: '${entityName} não encontrado' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async updateByExternalId(@Param('externalId') externalId: string, @Body() dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
    try {
      return await this.${kebabCaseName}Service.updateByExternalId(externalId, dto);
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw new NotFoundException('${entityName} não encontrado');
      }
      throw new InternalServerErrorException('Erro ao atualizar ${kebabCaseName}');
    }
  }

  @Delete(':externalId')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: "Deleta um ${kebabCaseName} pelo External ID.",
    description: "Este endpoint deleta um ${kebabCaseName} no sistema pelo External ID fornecido.",
  })
  @ApiResponse({
    status: 204,
    description: 'O ${kebabCaseName} foi deletado com sucesso.',
  })
  @ApiResponse({ status: 404, description: '${entityName} não encontrado' })
  @ApiResponse({ status: 500, description: 'Erro interno no servidor' })
  async deleteByExternalId(@Param('externalId') externalId: string): Promise<void> {
    try {
      await this.${kebabCaseName}Service.deleteByExternalId(externalId);
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw new NotFoundException('${entityName} não encontrado');
      }
      throw new InternalServerErrorException('Erro ao deletar ${kebabCaseName}');
    }
  }
}
`;
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

const generator = new ControllerGenerator(schemaPath);
generator.generateControllers(outputDir);