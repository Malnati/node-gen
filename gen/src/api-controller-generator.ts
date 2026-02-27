// gen/src/api-controller-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class ApiControllerGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateControllers() {
    // Nova estrutura: <output>/api/src/modules/<entity>/
    const outputDir = path.join(this.config.outputDir, 'api', 'src', 'modules');

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

      const controllerContent = this.generateControllerContent(entityName, kebabCaseName, table);
      const filePath = path.join(subDir, `${kebabCaseName}.controller.ts`);
      fs.writeFileSync(filePath, controllerContent);
    });

    console.log(`API Controllers have been generated in ${outputDir}`);
  }

  private toCamelCase(str: string): string {
    if (str.startsWith('tb_')) {
      str = str.substring(3); // Remove the 'tb_' prefix
    }

    const normalized = str.replace(/[-_](.)/g, (match, group1) => group1.toUpperCase());
    return normalized.charAt(0).toLowerCase() + normalized.slice(1);
  }

  private generateControllerContent(entityName: string, kebabCaseName: string, table: Table): string {
    const camelCaseName = this.toCamelCase(entityName);
    const kebabCaseServiceName = this.toCamelCase(kebabCaseName);
    const hasExternalId = table.columns.some((c) => c.columnName === 'external_id');
    const firstPkScalar = table.columns.find(
      (c) => c.isPrimaryKey && !table.relations.some((r) => r.columnName === c.columnName),
    );
    const hasSingleScalarKey = hasExternalId || !!firstPkScalar;
    const idParam = hasExternalId ? 'external_id' : 'id';
    const idParamType = hasExternalId ? 'string' : 'number';
    const idPipe = hasExternalId ? 'ParseUUIDPipe' : 'ParseIntPipe';
    const idLabel = hasExternalId ? 'External ID' : 'ID';
    const findMethod = hasExternalId ? 'findByExternalId' : 'findById';
    const updateMethod = hasExternalId ? 'updateByExternalId' : 'updateById';
    const deleteMethod = hasExternalId ? 'deleteByExternalId' : 'deleteById';

    const getByIdRoute = hasSingleScalarKey
      ? `
  /**
   * Busca um ${camelCaseName} pelo ${idLabel}.
   */
  @Get(':${idParam}')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Busca um ${camelCaseName} pelo ${idLabel}.",
      description: "Este endpoint busca um ${camelCaseName} no sistema pelo ${idLabel} fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O ${camelCaseName} foi encontrado.',
      type: ${entityName}QueryDTO,
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '${entityName} não encontrado' })
  async ${findMethod}(@Param('${idParam}', ${idPipe}) ${idParam}: ${idParamType}): Promise<${entityName}QueryDTO> {
      this.logger.log(\`Finding ${camelCaseName} with ${idLabel}: \${${idParam}}\`);
      try {
        return await this.${kebabCaseServiceName}Service.${findMethod}(${idParam});
      } catch (error) {
        this.logger.error(\`Error finding ${camelCaseName}: \${error.message}\`);
        throw new NotFoundException('${entityName} não encontrado');
      }
  }`
      : '';

    const putByIdRoute = hasSingleScalarKey
      ? `
  /**
   * Atualiza um ${camelCaseName} pelo ${idLabel}.
   */
  @Put(':${idParam}')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
      summary: "Atualiza um ${camelCaseName} pelo ${idLabel}.",
      description: "Este endpoint atualiza os detalhes de um ${camelCaseName} no sistema pelo ${idLabel} fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.OK,
      description: 'O ${camelCaseName} foi atualizado com sucesso.',
      type: ${entityName}QueryDTO,
  })
  @ApiResponse({ status: HttpStatus.BAD_REQUEST, description: 'Dados inválidos' })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '${entityName} não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async ${updateMethod}(@Param('${idParam}', ${idPipe}) ${idParam}: ${idParamType}, @Body() dto: ${entityName}PersistDTO): Promise<${entityName}QueryDTO> {
      this.logger.log(\`Updating ${camelCaseName} with ${idLabel}: \${${idParam}}\`);
      try {
        return await this.${kebabCaseServiceName}Service.${updateMethod}(${idParam}, dto);
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to update non-existing ${camelCaseName}');
          throw new NotFoundException('${entityName} não encontrado');
        }
        this.logger.error(\`Error updating ${camelCaseName}: \${error.message}\`);
        throw new InternalServerErrorException('Erro ao atualizar ${camelCaseName}');
      }
  }`
      : '';

    const deleteByIdRoute = hasSingleScalarKey
      ? `
  /**
   * Deleta um ${camelCaseName} pelo ${idLabel}.
   */
  @Delete(':${idParam}')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
      summary: "Deleta um ${camelCaseName} pelo ${idLabel}.",
      description: "Este endpoint deleta um ${camelCaseName} no sistema pelo ${idLabel} fornecido.",
  })
  @ApiResponse({
      status: HttpStatus.NO_CONTENT,
      description: 'O ${camelCaseName} foi deletado com sucesso.',
  })
  @ApiResponse({ status: HttpStatus.NOT_FOUND, description: '${entityName} não encontrado' })
  @ApiResponse({ status: HttpStatus.INTERNAL_SERVER_ERROR, description: 'Erro interno no servidor' })
  async ${deleteMethod}(@Param('${idParam}', ${idPipe}) ${idParam}: ${idParamType}): Promise<void> {
      this.logger.log(\`Deleting ${camelCaseName} with ${idLabel}: \${${idParam}}\`);
      try {
        await this.${kebabCaseServiceName}Service.${deleteMethod}(${idParam});
      } catch (error) {
        if (error instanceof NotFoundException) {
          this.logger.warn('Attempt to delete non-existing ${camelCaseName}');
          throw new NotFoundException('${entityName} não encontrado');
        }
        this.logger.error(\`Error deleting ${camelCaseName}: \${error.message}\`);
        throw new InternalServerErrorException('Erro ao deletar ${camelCaseName}');
      }
  }`
      : '';

    return loadTemplate('api-controller.template.ejs', {
      entityName,
      kebabCaseName,
      camelCaseName,
      kebabCaseServiceName,
      getByIdRoute,
      putByIdRoute,
      deleteByIdRoute,
    });
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
