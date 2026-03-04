// gen/src/mfe-parcel-paging-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig, Column } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';
import { renderTemplate } from './utils/TemplateEngine';

export interface MFEParcelPagingConfig {
  name: string;
  kebabName: string;
  pascalName: string;
  camelName: string;
  port: number;
  route: string;
  apiEndpoint: string;
  endpointPaging: string;
  idType: string;
  idParam: string;
  columns: PagingColumn[];
  filterFields: FilterField[];
  sortableColumns: string[];
  tableName: string;
  defaultSort: string;
}

export interface PagingColumn {
  columnName: string;
  displayName: string;
  typescriptType: string;
  sortable: boolean;
  filterable: boolean;
}

export interface FilterField {
  name: string;
  label: string;
  inputType: 'text' | 'number' | 'date' | 'datetime' | 'select' | 'boolean';
  required: boolean;
  options?: { label: string; value: string }[];
}

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
  private staticMfePath: string;
  private mfeConfigs: MFEParcelPagingConfig[] = [];
  private basePort = 7200;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
    this.staticMfePath = path.resolve(__dirname, '..', 'static', 'mfe-parcel-paging');
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

    const clientContent = `// api/client.ts
// Auto-generated API client for ${config.pascalName} paging endpoint

export interface PagingRequest {
  page?: number;
  pageSize?: number;
  sort?: string;
  order?: 'ASC' | 'DESC';
  filters?: Record<string, any>;
}

export interface PagingResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

${config.columns.map(col => `
export interface ${toPascalCase(col.columnName)} {
  ${col.columnName}: ${col.typescriptType};
}`).join('')}

export interface ${config.pascalName}Record {
  id: ${config.idType};
  ${config.columns.map(col => `${col.columnName}: ${col.typescriptType};`).join('\n  ')}
}

const API_BASE = '${config.endpointPaging}';

export const ${config.camelName}PagingApi = {
  async getPage(request: PagingRequest): Promise<PagingResponse<${config.pascalName}Record>> {
    const params = new URLSearchParams();
    
    if (request.page) params.append('page', String(request.page));
    if (request.pageSize) params.append('pageSize', String(request.pageSize));
    if (request.sort) params.append('sort', request.sort);
    if (request.order) params.append('order', request.order);
    
    if (request.filters) {
      Object.entries(request.filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null && value !== '') {
          params.append(\`filter[\${key}]\`, String(value));
        }
      });
    }

    const response = await fetch(\`\${API_BASE}?\${params.toString()}\`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(\`Failed to fetch ${config.pascalName} data: \${response.statusText}\`);
    }

    return response.json();
  },
};
`;

    fs.writeFileSync(path.join(apiDir, 'client.ts'), clientContent);
  }

  private generateDataProvider(dir: string, config: MFEParcelPagingConfig): void {
    const apiDir = path.join(dir, 'src', 'api');
    
    const dataProviderContent = `// api/dataProvider.ts
// Auto-generated data provider for ${config.pascalName} using Shadcn Admin Kit patterns

import { ${config.camelName}PagingApi, type PagingRequest, type PagingResponse, type ${config.pascalName}Record } from './client';

export const ${config.camelName}DataProvider = {
  async getList(params: {
    pagination?: { page: number; perPage: number };
    sort?: { field: string; order: 'ASC' | 'DESC' };
    filter?: Record<string, any>;
  }): Promise<PagingResponse<${config.pascalName}Record>> {
    const request: PagingRequest = {
      page: params.pagination?.page || 1,
      pageSize: params.pagination?.perPage || 10,
      sort: params.sort?.field || '${config.defaultSort}',
      order: params.sort?.order || 'ASC',
      filters: params.filter,
    };

    return ${config.camelName}PagingApi.getPage(request);
  },
};
`;

    fs.writeFileSync(path.join(apiDir, 'dataProvider.ts'), dataProviderContent);
  }

  private generateViteConfig(dir: string, config: MFEParcelPagingConfig): void {
    const content = `import path from "path"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: {
    port: ${config.port},
    headers: {
      "Access-Control-Allow-Origin": "*",
    },
  },
  build: {
    outDir: "dist",
    rollupOptions: {
      output: {
        format: "system",
      },
    },
  },
})
`;
    fs.writeFileSync(path.join(dir, 'vite.config.ts'), content);
  }

  private generateDockerfile(dir: string, config: MFEParcelPagingConfig): void {
    const content = `FROM node:18-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci --ignore-scripts

# Copy source
COPY . .

# Build the application
RUN npm run build

# Production stage with Nginx
FROM nginx:alpine

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

# Configure Nginx for SPA routing and MFE
RUN printf 'server {
  listen ${config.port};
  
  location / {
    root /usr/share/nginx/html;
    index index.html;
    try_files $uri $uri/ /index.html;
    
    # CORS headers for MFE
    add_header Access-Control-Allow-Origin * always;
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
    add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
    
    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
      expires 1y;
      add_header Cache-Control "public, immutable";
    }
  }
  
  # Health check endpoint
  location /health {
    return 200 "OK";
    add_header Content-Type text/plain;
  }
}' > /etc/nginx/conf.d/default.conf

EXPOSE ${config.port}

CMD ["nginx", "-g", "daemon off;"]
`;
    fs.writeFileSync(path.join(dir, 'Dockerfile'), content);
  }

  private updatePackageJson(dir: string, config: MFEParcelPagingConfig): void {
    const pkgPath = path.join(dir, 'package.json');
    const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf-8'));
    pkg.name = `${config.kebabName}-paging-mfe`;
    pkg.scripts = {
      ...pkg.scripts,
      'serve:mfe': `npx serve dist -l ${config.port}`,
      'docker:build': `docker build -t ${config.kebabName}-paging-mfe:latest .`,
      'docker:run': `docker run -p ${config.port}:${config.port} ${config.kebabName}-paging-mfe:latest`,
    };
    fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2));
  }

  private updateIndexHtml(dir: string, config: MFEParcelPagingConfig): void {
    const htmlPath = path.join(dir, 'index.html');
    let content = fs.readFileSync(htmlPath, 'utf-8');
    content = content.replace(/<%= appName %>/g, config.pascalName);
    content = content.replace(/<%- importMap %>/g, '{}');
    fs.writeFileSync(htmlPath, content);
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
