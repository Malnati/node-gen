// /src/readme-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, Column, DbReaderConfig } from './interfaces';
import { loadTemplate } from './utils/template-loader';

export class ReadmeGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
  }

  generateReadme() {
    const outputDir = this.config.outputDir;

    const readmeContent = this.generateReadmeContent();
    const filePath = path.join(outputDir, 'README.md');
    fs.writeFileSync(filePath, readmeContent);
    console.log(`README.md has been generated at ${filePath}`);
  }

  private generateReadmeContent(): string {
    const sections = this.schema.map(table => this.generateTableSection(table)).join('\n\n---\n\n');
    return loadTemplate('readme.template.ts', {
      appName: this.config.app,
      sections,
    });
  }

  private generateTableSection(table: Table): string {
    const columnsTable = this.generateColumnsTable(table.columns);
    const columnComments = this.generateColumnComments(table.columns);

    return `## Tabela \`public.${table.tableName}\`

Tabela que armazena informações sobre ${table.tableName.replace(/^tb_/, '').replace(/_/g, ' ')}.

### Estrutura da Tabela

${columnsTable}

### Comentários das Colunas

${columnComments}`;
  }

  private generateColumnsTable(columns: Column[]): string {
    const header = '| Coluna | Tipo | Nulo | Comentário |';
    const divider = '|---|---|---|---|';
    const rows = columns.map(column => {
      return `| ${column.columnName} | ${this.mapType(column.dataType)} | ${column.isNullable ? 'SIM' : 'NÃO'} | ${column.columnComment || '-'} |`;
    }).join('\n');
  
    return `${header}\n${divider}\n${rows}`;
  }

  private generateColumnComments(columns: Column[]): string {
    return columns.map(column => {
      return `- **${column.columnName}**: ${column.columnComment || 'Sem comentário.'}`;
    }).join('\n');
  }

  private mapType(dataType: string): string {
    const typeMapping: { [key: string]: string } = {
      'integer': 'serial4',
      'bigint': 'int8',
      'uuid': 'uuid',
      'timestamp without time zone': 'timestamp',
      'timestamp with time zone': 'timestamptz',
      'date': 'date',
      'character varying': 'varchar',
      'text': 'text',
      'boolean': 'bool',
      'numeric': 'numeric',
      'decimal': 'decimal',
      'bytea': 'bytea'
    };
    return typeMapping[dataType] || dataType;
  }
}