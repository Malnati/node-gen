// gen/src/mfe-parcel-paging-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig, Column, MFEParcelPagingConfig, PagingColumn, FilterField } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { renderTemplate } from './utils/TemplateEngine';

interface ValidationResult {
  valid: boolean;
  errors: string[];
  warnings: string[];
}

/**
 * MFE Parcel Paging Generator
 * 
 * Gera um Micro-frontend do tipo Parcel focado exclusivamente na apresentação
 * de uma interface de pesquisa paginada, com filtros, colunas, paginação e ordenação,
 * consumindo um endpoint de pesquisa paginada existente.
 * 
 * Validações rigorosas:
 * - Erros (throw) para atributos obrigatórios ausentes
 * - Avisos (warnings) para atributos opcionais não especificados
 */
export class MFEParcelPagingGenerator {
  private schema: Table[];
  private config: DbReaderConfig;
  private mfeConfigs: MFEParcelPagingConfig[] = [];
  private basePort = 7200;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  /**
   * Valida os metadados extraídos da base de dados
   * Aplica erros para atributos obrigatórios e avisos para atributos opcionais
   */
  private validateMetadata(table: Table): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validação: tableName obrigatório
    if (!table.tableName || table.tableName.trim() === '') {
      errors.push('Table name is required');
    }

    // Validação: pelo menos uma coluna para exibição
    const displayableColumns = table.columns.filter(c => 
      !c.isPrimaryKey && 
      c.columnName !== 'created_at' && 
      c.columnName !== 'updated_at' && 
      c.columnName !== 'deleted_at'
    );

    if (displayableColumns.length === 0) {
      errors.push('At least one displayable column is required (excluding id, created_at, updated_at, deleted_at)');
    }

    // Validação: endpoint de paging deve ser inferido
    // O endpoint é construído a partir do nome da tabela

    // Avisos para colunas sem tipo mapeado
    displayableColumns.forEach(col => {
      const tsType = this.getTypeScriptType(col);
      if (tsType === 'any') {
        warnings.push(`Column '${col.columnName}' has unmapped type '${col.dataType}' - using 'string' as fallback`);
      }
    });

    // Aviso para colunas sem tipo de filtro definido
    displayableColumns.forEach(col => {
      const inputType = this.getFilterInputType(col);
      if (inputType === 'text' && !this.isTextFilterable(col)) {
        warnings.push(`Column '${col.columnName}' may not be suitable for filtering`);
      }
    });

    return {
      valid: errors.length === 0,
      errors,
      warnings,
    };
  }

  private isTextFilterable(column: Column): boolean {
    const dt = column.dataType.toLowerCase();
    return ['varchar', 'text', 'char', 'nvarchar', 'ntext'].includes(dt);
  }

  async generate(): Promise<MFEParcelPagingConfig[]> {
    const outputDir = path.join(this.config.outputDir, 'frontend');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach((table, index) => {
      // Valida metadados antes de gerar
      const validation = this.validateMetadata(table);
      
      // Emite avisos
      validation.warnings.forEach(warning => {
        console.warn(`[mfe-parcel-paging-generator] Warning for table '${table.tableName}': ${warning}`);
      });

      // Se há erros críticos, lança exceção
      if (!validation.valid) {
        const errorMsg = `Validation failed for table '${table.tableName}': ${validation.errors.join(', ')}`;
        console.error(`[mfe-parcel-paging-generator] ${errorMsg}`);
        throw new Error(errorMsg);
      }

      const mfeConfig = this.generateMFE(table, outputDir, index);
      this.mfeConfigs.push(mfeConfig);
    });

    console.log(`MFE Parcel Paging has been generated in ${outputDir}`);
    console.log(`Generated ${this.mfeConfigs.length} MFE Parcel Paging configurations`);

    return this.mfeConfigs;
  }

  private generateMFE(table: Table, outputDir: string, index: number): MFEParcelPagingConfig {
    const kebabName = toKebabCase(table.tableName);
    const pascalName = toPascalCase(table.tableName);
    const camelName = this.toCamelCase(pascalName);
    const mfeDir = path.join(outputDir, `${kebabName}-paging-mfe`);
    const port = this.basePort + index;
    const route = `/${kebabName}-paging`;
    const endpointPaging = `${route}/paging`;

    if (!fs.existsSync(mfeDir)) {
      fs.mkdirSync(mfeDir, { recursive: true });
    }

    const idInfo = this.getIdInfo(table);
    
    // Colunas para display na tabela
    const columns = table.columns
      .filter(c => !c.isPrimaryKey && c.columnName !== 'created_at' && c.columnName !== 'updated_at' && c.columnName !== 'deleted_at')
      .map(c => ({
        columnName: c.columnName,
        displayName: this.getDisplayName(c.columnName),
        typescriptType: this.getTypeScriptType(c),
        sortable: true,
        filterable: this.isColumnFilterable(c),
      }));

    // Campos para filtros
    const filterFields = this.generateFilterFields(table);

    // Colunas ordenáveis
    const sortableColumns = columns
      .filter(c => c.sortable)
      .map(c => c.columnName);

    // Ordenação padrão
    const defaultSort = idInfo.idParam || 'id';

    const mfeConfig: MFEParcelPagingConfig = {
      name: `@mfe/${kebabName}-paging`,
      kebabName,
      pascalName,
      camelName,
      port,
      route,
      apiEndpoint: route,
      endpointPaging,
      idType: idInfo.idType,
      idParam: idInfo.idParam,
      columns,
      filterFields,
      sortableColumns,
      tableName: table.tableName,
      defaultSort,
    };

    this.copyStaticMFE(mfeDir);
    this.generateAppTsx(mfeDir, mfeConfig);
    this.generateApiClient(mfeDir, mfeConfig);
    this.generateViteConfig(mfeDir, mfeConfig);
    this.generateDockerfile(mfeDir, mfeConfig);
    this.updatePackageJson(mfeDir, mfeConfig);
    this.updateIndexHtml(mfeDir, mfeConfig);
    this.generateReadme(mfeDir, mfeConfig);
    this.generateDataProvider(mfeDir, mfeConfig);

    return mfeConfig;
  }

  private copyStaticMFE(destDir: string): void {
    // Copia do projeto estático base
    const staticSource = path.resolve(__dirname, '..', 'static', 'mfe-parcel-paging');
    
    if (!fs.existsSync(staticSource)) {
      console.warn(`[mfe-parcel-paging-generator] Static source not found: ${staticSource}`);
      // Fallback: usa o static-mfe genérico
      const fallbackSource = path.resolve(__dirname, '..', 'static-mfe');
      if (fs.existsSync(fallbackSource)) {
        fs.cpSync(fallbackSource, destDir, { recursive: true });
      } else {
        throw new Error(`Cannot find static MFE source at ${staticSource} or fallback at ${fallbackSource}`);
      }
      return;
    }

    fs.cpSync(staticSource, destDir, {
      recursive: true,
      filter: (src) => {
        const rel = path.relative(staticSource, src);
        // Exclui App.tsx que será gerado
        if (rel === 'src/App.tsx') return false;
        if (rel === 'Dockerfile') return false;
        if (rel === 'package.json') return false;
        if (rel === 'README.md') return false;
        return true;
      },
    });
    console.log(`[mfe-parcel-paging-generator] Copied static MFE Parcel Paging to ${destDir}`);
  }

  private generateAppTsx(dir: string, config: MFEParcelPagingConfig): void {
    const appTsxPath = path.join(dir, 'src', 'App.tsx');
    
    // Gera o template com os dados da tabela
    const content = renderTemplate('mfe-parcel-page.ejs', {
      pascalName: config.pascalName,
      kebabName: config.kebabName,
      camelName: config.camelName,
      route: config.route,
      endpointPaging: config.endpointPaging,
      columns: config.columns,
      filterFields: config.filterFields,
      sortableColumns: config.sortableColumns,
      defaultSort: config.defaultSort,
      idParam: config.idParam,
      idType: config.idType,
    });
    
    fs.writeFileSync(appTsxPath, content);
    console.log(`[mfe-parcel-paging-generator] Generated App.tsx at ${appTsxPath}`);
  }

  private generateApiClient(dir: string, config: MFEParcelPagingConfig): void {
    const apiDir = path.join(dir, 'src', 'api');
    if (!fs.existsSync(apiDir)) {
      fs.mkdirSync(apiDir, { recursive: true });
    }
    this.renderFileFromTemplate(path.join(apiDir, 'client.ts'), 'mfe-parcel-paging-client.ejs', config);
  }

  private generateDataProvider(dir: string, config: MFEParcelPagingConfig): void {
    const apiDir = path.join(dir, 'src', 'api');
    this.renderFileFromTemplate(path.join(apiDir, 'dataProvider.ts'), 'mfe-parcel-paging-data-provider.ejs', config);
  }

  private generateViteConfig(dir: string, config: MFEParcelPagingConfig): void {
    this.renderFileFromTemplate(path.join(dir, 'vite.config.ts'), 'mfe-parcel-paging-vite-config.ejs', config);
  }

  private generateDockerfile(dir: string, config: MFEParcelPagingConfig): void {
    this.renderFileFromTemplate(path.join(dir, 'Dockerfile'), 'mfe-parcel-paging-dockerfile.ejs', config);
  }

  private renderFileFromTemplate(filePath: string, templateName: string, config: MFEParcelPagingConfig): void {
    const content = renderTemplate(templateName, {
      ...config,
      typedColumns: config.columns.map(col => ({
        ...col,
        interfaceName: toPascalCase(col.columnName),
      })),
      columnsWithIndent: config.columns
        .map(col => `${col.columnName}: ${col.typescriptType};`)
        .join('\n  '),
    });
    fs.writeFileSync(filePath, content);
  }

  private updatePackageJson(dir: string, config: MFEParcelPagingConfig): void {
    this.renderFileFromTemplate(path.join(dir, 'package.json'), 'mfe-parcel-paging-package-json.ejs', config);
  }

  private updateIndexHtml(dir: string, config: MFEParcelPagingConfig): void {
    const htmlPath = path.join(dir, 'index.html');
    let content = fs.readFileSync(htmlPath, 'utf-8');
    content = content.replace(/<%= appName %>/g, config.pascalName);
    content = content.replace(/<%- importMap %>/g, '{}');
    fs.writeFileSync(htmlPath, content);
  }

  private generateReadme(dir: string, config: MFEParcelPagingConfig): void {
    this.renderFileFromTemplate(path.join(dir, 'README.md'), 'mfe-parcel-paging-readme.ejs', config);
  }

  private getIdInfo(table: Table): { idType: string; idParam: string } {
    const hasExternalId = table.columns.some(c => c.columnName === 'external_id');
    if (hasExternalId) {
      return { idType: 'string', idParam: 'external_id' };
    }
    const pkColumn = table.columns.find(c => c.isPrimaryKey);
    if (pkColumn) {
      const isNumeric = ['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double'].includes(pkColumn.dataType.toLowerCase());
      return { idType: isNumeric ? 'number' : 'string', idParam: 'id' };
    }
    return { idType: 'number', idParam: 'id' };
  }

  private toCamelCase(str: string): string {
    return str.charAt(0).toLowerCase() + str.slice(1);
  }

  private getDisplayName(columnName: string): string {
    return columnName
      .replace(/_/g, ' ')
      .replace(/([A-Z])/g, ' $1')
      .replace(/^./, s => s.toUpperCase())
      .trim();
  }

  private getTypeScriptType(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date', 'datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'string';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'boolean';
    }
    if (['uuid', 'uniqueidentifier'].includes(dt)) {
      return 'string';
    }
    // Default fallback
    return 'string';
  }

  private getFilterInputType(column: Column): FilterField['inputType'] {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date'].includes(dt)) {
      return 'date';
    }
    if (['datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'datetime';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'boolean';
    }
    return 'text';
  }

  private isColumnFilterable(column: Column): boolean {
    // Colunas automaticamente filtráveis
    const dt = column.dataType.toLowerCase();
    const filterableTypes = ['varchar', 'text', 'char', 'nvarchar', 'ntext', 'int', 'bigint', 'smallint', 'date', 'datetime', 'timestamp', 'boolean', 'bool'];
    return filterableTypes.includes(dt);
  }

  private generateFilterFields(table: Table): FilterField[] {
    const filterableColumns = table.columns.filter(c => 
      !c.isPrimaryKey && 
      c.columnName !== 'created_at' && 
      c.columnName !== 'updated_at' && 
      c.columnName !== 'deleted_at' &&
      c.columnName !== 'external_id' &&
      this.isColumnFilterable(c)
    );

    return filterableColumns.map(c => ({
      name: c.columnName,
      label: this.getDisplayName(c.columnName),
      inputType: this.getFilterInputType(c),
      required: !c.isNullable,
    }));
  }
}
