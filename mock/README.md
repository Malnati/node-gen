<!-- mock/README.md -->

# Projeto mock para testes de geração de código-fonte

## Objetivo

Este diretório contém um **schema mock** para testar o aplicativo node-gen em todas as possibilidades de geração, cobrindo a matriz mínima de cenários do plano de revisão.

## Cenários cobertos

| Cenário | Tabelas / elementos |
|---------|----------------------|
| Tabela simples sem relacionamentos | `tb_simple_item` |
| Nullable, enum-like (TEXT), decimal (REAL), datas, UUID/external_id | `tb_category` (external_id, status, price, created_at, updated_at nullable) |
| Múltiplas relações e chaves compostas | `tb_product` (FK → tb_category), `tb_sale`, `tb_sale_item` (PK composta sale_id + product_id, FKs) |
| Nomes limítrofes (prefixo `tb_`, snake_case) | Todas as tabelas com prefixo `tb_` e colunas em snake_case |

## Estrutura

- `schema.sql` — DDL SQLite com as tabelas do mock.
- `create-db.js` — script Node que cria `mock.sqlite` a partir de `schema.sql` (executar na raiz do repositório).
- `connection.json` — **dados de conexão do banco mock** (dbType, database, user, password). O projeto de testes e2e (`e2e-generator-mock/`) usa este arquivo como **parâmetros de entrada** dos testes: o gerador é invocado com esses dados.
- `mock.sqlite` — banco gerado (criado ao rodar `create-db.js`).
- `README.md` — este arquivo.

## Comandos

### 1. Criar o banco mock

Na raiz do repositório:

```bash
node mock/create-db.js
```

Gera `mock/mock.sqlite`.

### 2. Rodar o node-gen contra o mock

Na raiz do repositório, com o gerador compilado (`npm run build`):

```bash
node dist/main.js -a mock-app -d ./mock/mock.sqlite -u x -pw x -o ./build-mock-test -t sqlite -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

Para copiar estáticos Nest (tsconfig etc.), use `-T ./static`:

```bash
node dist/main.js -a mock-app -d ./mock/mock.sqlite -u x -pw x -o ./build-mock-test -t sqlite -T ./static -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

### 3. Verificar artefatos

Confira em `{outputDir}`: `db.reader.sqlite.json`, `src/app/entities/`, `src/app/{simple-item,category,product,sale,sale-item}/`, `src/app/app.module.ts`, `.env`, `package.json`, `README.md`, `public/diagram.png`.

## Referências

- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](docs/issues/plan-mock-project-codegen.md).
- **Teste do CLI:** [docs/issues/plan-cli-test-execution.md](docs/issues/plan-cli-test-execution.md).
- **Plano de revisão (matriz):** [docs/template-review-plan.md](docs/template-review-plan.md).
