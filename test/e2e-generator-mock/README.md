<!-- test/e2e-generator-mock/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte (`gen/`) contra o mock. Não altera o gerador; apenas invoca e valida.

**Parâmetros de entrada dos testes:** os dados de conexão vêm de um arquivo por tipo de banco em `test/e2e-generator-mock/projects/todo/db/`:
- `connection.sqlite.json` — SQLite (mock local)
- `connection.mysql.json` — MySQL (host, port, user, password, database)
- `connection.postgres.json` — PostgreSQL
- `connection.sqlserver.json` — SQL Server

O script descobre todos os `connection.<dbType>.json` presentes, executa uma chamada e2e para cada banco e grava a saída em `output/<project>/<dbType>/` (ex.: `output/e2e-mock-app/sqlite/`). O nome do projeto vem de `E2E_APP_NAME` (default `e2e-mock-app`), permitindo vários projetos com múltiplos bancos. Não há conexão única na raiz do mock.

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** em `gen/` executar `npm run build` (ou na raiz do repositório `npm run build`) para gerar `gen/dist/main.js`.
- **Mock disponível:** para SQLite o script usa `connection.sqlite.json` e cria `mock.sqlite` automaticamente se não existir (via `create-db.js`). Para MySQL, PostgreSQL e SQL Server é necessário ter o serviço rodando e o schema aplicado; os arquivos em `projects/todo/db/` (ex.: `database.mysql.ddl`, `database.postgres.ddl`) servem de referência.

## Comandos

Execução a partir da **raiz do repositório** (recomendado):

```bash
node test/e2e-generator-mock/run.js
```

Ou via npm na raiz:

```bash
npm run test:e2e
```

Ou a partir do próprio diretório:

```bash
cd test/e2e-generator-mock && node run.js
```

## O que o script faz

1. **Descobrir conexões:** lista `projects/todo/db/connection.<dbType>.json` (sqlite, mysql, postgres, sqlserver, etc.).
2. **Por cada banco:** (a) carrega a conexão; (b) para SQLite, garante mock (cria `mock.sqlite` via `create-db.js` se não existir); (c) executa o gerador com os parâmetros da conexão; saída em `output/<project>/<dbType>/`; (d) aferição dos artefatos (schema `db.reader.<dbType>.json`, entidades, módulos, etc.) e opcionalmente `npm run build` no output.

## Estrutura

- `package.json` — scripts (`test`, `run`).
- `run.js` — script que executa o fluxo completo (uma chamada e2e por banco encontrado em `projects/todo/db/`).
- `projects/todo/db/connection.<dbType>.json` — dados de conexão por banco (sqlite, mysql, postgres, sqlserver). Ex.: `connection.sqlite.json`, `connection.postgres.json`.
- `projects/todo/db/schema.sql` — DDL SQLite do mock (8 tabelas: N-1, N-N, tipos diversos). Ver [plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- `create-db.js` — cria `mock.sqlite` a partir de `projects/todo/db/schema.sql`.
- `projects/todo/db/create-sqlite-fixture.js` — cria SQLite a partir de `database.sqlite.ddl` em diretório informado; usado pelo teste CLI em disco. Ver [plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
- `mock.sqlite` — banco gerado (criado por `create-db.js`; ignorado pelo git).
- Saída do gerador: `output/<project>/<dbType>/` na raiz do repositório (ex.: `output/e2e-mock-app/sqlite/`, `output/e2e-mock-app/postgres/`; ignorado pelo git). Vários projetos: use `E2E_APP_NAME` para alterar o nome do projeto.
- `README.md` — este arquivo.

## Referências

- **Plano:** [docs/issues/plan-test-project-generator-vs-mock.md](../../docs/issues/plan-test-project-generator-vs-mock.md).
- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
