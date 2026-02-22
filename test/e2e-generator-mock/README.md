<!-- test/e2e-generator-mock/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte (`gen/`) contra o mock. Não altera o gerador; apenas invoca e valida.

**Parâmetros de entrada dos testes:** os dados de conexão vêm de um arquivo por tipo de banco em cada `test/e2e-generator-mock/projects/<name>/db/`:
- `connection.sqlite.json` — SQLite (mock local)
- `connection.mysql.json` — MySQL (host, port, user, password, database)
- `connection.postgres.json` — PostgreSQL
- `connection.sqlserver.json` — SQL Server

O script descobre **todos** os `connection.<dbType>.json` presentes em cada projeto (tipos permitidos: sqlite, postgres, mysql, sqlserver), executa uma chamada e2e para cada par projeto+banco e grava a saída em `output/<project>/<dbType>/`. A variável **`E2E_DB_TYPES`** não restringe essa matriz: são exercitados todos os arquivos de conexão encontrados por projeto. O nome do projeto vem do diretório em `projects/`; não há conexão única na raiz do mock.

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

1. **Descobrir conexões:** para cada projeto em `projects/`, lista todos os `connection.<dbType>.json` no diretório `db/` (sqlite, mysql, postgres, sqlserver). Não há filtro por `E2E_DB_TYPES`; todos os tipos encontrados são exercitados.
2. **Por cada banco:** (a) carrega a conexão; (b) para SQLite, garante mock (cria `mock.sqlite` via `create-db.js` se não existir); (c) executa o gerador com os parâmetros da conexão; saída em `output/<project>/<dbType>/`; (d) aferição dos artefatos (schema `db.reader.<dbType>.json`, entidades, módulos, etc.) e **build obrigatório** (`npm run build`) no output; (e) **subida da API** — inicia a aplicação gerada em processo (NODE_ENV=production), aguarda a porta de escuta, faz requisição HTTP ao endpoint `/health` e verifica resposta 200; em falha, exibe os logs (stdout/stderr) do processo.

## Estrutura

- `package.json` — scripts (`test`, `run`).
- `run.js` — script que executa o fluxo completo (uma chamada e2e por banco encontrado em `projects/todo/db/`).
- `projects/todo/db/connection.<dbType>.json` — dados de conexão por banco (sqlite, mysql, postgres, sqlserver). Ex.: `connection.sqlite.json`, `connection.postgres.json`.
- `projects/todo/db/database.sqlite.ddl` — DDL SQLite do mock (project, status, tag, todo, todo_tag, project_member, comment, attachment, note). Padrão distribuído com external_id e tenant. Ver DATA_DICTIONARY.md secção 25.
- `create-db.js` — cria `mock.sqlite` a partir de `projects/todo/db/database.sqlite.ddl`.
- `projects/todo/db/create-sqlite-fixture.js` — cria SQLite a partir de `database.sqlite.ddl` em diretório informado; usado pelo teste CLI em disco. Ver [plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
- `mock.sqlite` — banco gerado (criado por `create-db.js`; ignorado pelo git).
- Saída do gerador: `output/<project>/<dbType>/` na raiz do repositório (ex.: `output/e2e-mock-app/sqlite/`, `output/e2e-mock-app/postgres/`; ignorado pelo git). Vários projetos: use `E2E_APP_NAME` para alterar o nome do projeto.
- `README.md` — este arquivo.

## Referências

- **Plano:** [docs/issues/plan-test-project-generator-vs-mock.md](../../docs/issues/plan-test-project-generator-vs-mock.md).
- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
