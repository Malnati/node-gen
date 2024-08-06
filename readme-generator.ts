import * as fs from 'fs';
import * as path from 'path';
import { Table, Column } from './interfaces';

class ReadmeGenerator {
  private schema: Table[];

  constructor(schemaPath: string) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
  }

  generateReadme(outputDir: string) {
    const readmeContent = this.generateReadmeContent();
    const filePath = path.join(outputDir, 'README.md');
    fs.writeFileSync(filePath, readmeContent);
    console.log(`README.md has been generated at ${filePath}`);
  }

  private generateReadmeContent(): string {
    const sections = this.schema.map(table => this.generateTableSection(table)).join('\n\n---\n\n');
    return `# Repositório do micro-serviço Opt-Out

## Opt-Out Database

Este documento descreve a estrutura do banco de dados e os passos para sua criação, incluindo a definição das tabelas, colunas, comentários, funções e triggers. A motivação para a criação deste documento é fornecer um guia detalhado para a configuração do banco de dados, garantindo que todas as etapas sejam seguidas corretamente para uma implementação consistente. Este documento também explica as vantagens de utilizar colunas como \`external_id\`, funções e triggers diretamente no banco de dados, comparado com a implementação no backend.

### Vantagens das Abordagens

**external_id**:
- Garantia de unicidade: Utilizar \`external_id\` como identificador único externo garante que cada registro possa ser identificado de forma única, mesmo em sistemas distribuídos.
- Facilidade de integração: \`external_id\` facilita a integração com outros sistemas e serviços que exigem identificadores únicos que não mudam.

**Funções e Triggers**:
- Consistência dos dados: Triggers garantem que certas regras de negócios sejam aplicadas consistentemente em todo o banco de dados.
- Redução de lógica no backend: Ao mover a lógica de verificação e restrições para o banco de dados, reduz-se a complexidade do código no backend.
- Melhoria da performance: Operações críticas podem ser otimizadas diretamente no banco de dados, evitando a necessidade de múltiplas consultas e verificações no backend.

### Dicionário de Dados

### Diagrama

![Diagrama do Banco de Dados](public/diagram.png)

${sections}`;
  }

  private generateTableSection(table: Table): string {
    const columnsTable = this.generateColumnsTable(table.columns);
    const columnComments = this.generateColumnComments(table.columns);

    return `## Tabela \`public.${table.tableName}\`

Tabela que armazena informações sobre ${table.tableName.replace('tb_', '').replace('_', ' ')}.

### Estrutura da Tabela

${columnsTable}

### Comentários das Colunas

${columnComments}`;
  }

  private generateColumnsTable(columns: Column[]): string {
    const header = `| Coluna        | Tipo      | Nulo  |\n|---------------|-----------|-------|`;
    const rows = columns.map(column => {
      const nullable = column.isNullable ? 'SIM' : 'NÃO';
      return `| ${column.columnName} | ${this.mapType(column.dataType)} | ${nullable} |`;
    }).join('\n');

    return `${header}\n${rows}`;
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
      'character varying': 'varchar',
      'bytea': 'bytea'
    };
    return typeMapping[dataType] || dataType;
  }
}

// Usage
const schemaPath = path.join(__dirname, 'build', 'db.reader.postgres.json');
const outputDir = path.join(__dirname, 'build');

const generator = new ReadmeGenerator(schemaPath);
generator.generateReadme(outputDir);