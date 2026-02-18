<!-- test/mock/README.md -->

# Projeto mock para testes de geração de código-fonte

## Objetivo

Este diretório contém um **schema mock** para testar o aplicativo node-gen em todas as possibilidades de geração, cobrindo a matriz mínima de cenários do plano de revisão.

## Modelo de dados

O schema contém **relações N-1, N-N** e **tipos de uso comum no mercado**.

### Relações

| Tipo | Exemplo |
|------|---------|
| **N-1** | `tb_product` → `tb_category` (produto pertence a uma categoria) |
| **N-1** | `tb_document` → `tb_product` (documento pertence a um produto) |
| **N-N** | `tb_sale` ↔ `tb_product` via `tb_sale_item` (venda tem muitos produtos, produto em muitas vendas; chave composta sale_id + product_id) |
| **N-N** | `tb_product` ↔ `tb_tag` via `tb_product_tag` (produto tem muitas tags, tag em muitos produtos) |

### Tipos de dados

| Tipo | Uso no schema |
|------|----------------|
| **Texto** | TEXT (nome, descrição, code, slug, full_description, mime_type, file_name) |
| **Números inteiros** | INTEGER (id, sort_order, stock_quantity, quantity, file_size); boolean como INTEGER 0/1 (is_active) |
| **Números decimais** | REAL (price, unit_price, total) |
| **Binário** | BLOB (`tb_document.content`) |
| **Datas** | TEXT com `datetime('now')` (created_at, updated_at) |
| **Identificador externo** | TEXT (external_id, UUID-like) |

### Tabelas

| Tabela | Papel |
|--------|--------|
| `tb_simple_item` | Tabela simples, sem FKs |
| `tb_category` | Tipos variados (nullable, decimal, datas, booleano) |
| `tb_product` | N-1 para category |
| `tb_sale` | Lado 1 da N-N venda–produto |
| `tb_sale_item` | Junção N-N venda–produto (PK composta) |
| `tb_tag` | Lado 2 da N-N produto–tag |
| `tb_product_tag` | Junção N-N produto–tag |
| `tb_document` | N-1 para product; BLOB e tipos diversos |

## Estrutura

- `schema.sql` — DDL SQLite com as tabelas do mock.
- `create-db.js` — script Node que cria `mock.sqlite` a partir de `schema.sql` (executar na raiz do repositório).
- `connection.json` — **dados de conexão do banco mock** (dbType, database, user, password). O projeto e2e (`test/e2e-generator-mock/`) usa este arquivo como **parâmetros de entrada** dos testes.
- `mock.sqlite` — banco gerado (criado ao rodar `create-db.js`).
- `README.md` — este arquivo.

## Comandos

### 1. Criar o banco mock

Na raiz do repositório:

```bash
node test/mock/create-db.js
```

Gera `test/mock/mock.sqlite`.

### 2. Rodar o node-gen contra o mock

Na raiz do repositório, com o gerador compilado (`npm run build` em `gen/` ou na raiz):

```bash
cd gen && node dist/main.js -a mock-app -d ../test/mock/mock.sqlite -u x -pw x -o ../test/build-mock-test -t sqlite -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

### 3. Verificar artefatos

Confira em `{outputDir}`: `db.reader.sqlite.json`, `src/app/entities/`, `src/app/{simple-item,category,product,sale,sale-item,tag,product-tag,document}/`, `src/app/app.module.ts`, `.env`, `package.json`, `README.md`, `public/diagram.png`.

## Referências

- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
- **E2E:** [test/e2e-generator-mock/README.md](../e2e-generator-mock/README.md).
