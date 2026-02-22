<!-- test/e2e-generator/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte (`gen/`) contra o mock. Não altera o gerador; apenas invoca e valida.

**Parâmetros de entrada dos testes:** os dados de conexão vêm de um arquivo por tipo de banco em cada `test/e2e-generator/projects/<name>/db/`:
- `connection.sqlite.json` — SQLite (mock local)
- `connection.mysql.json` — MySQL (host, port, user, password, database)
- `connection.postgres.json` — PostgreSQL
- `connection.sqlserver.json` — SQL Server

O script descobre **todos** os `connection.<dbType>.json` presentes em cada projeto (tipos permitidos: sqlite, postgres, mysql, sqlserver), executa uma chamada e2e para cada par projeto+banco e grava a saída em `output/<project>/<dbType>/`. A variável **`E2E_DB_TYPES`** não restringe essa matriz: são exercitados todos os arquivos de conexão encontrados por projeto. O nome do projeto vem do diretório em `projects/`; não há conexão única na raiz do mock.

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** em `gen/` executar `npm run build` (ou na raiz do repositório `npm run build`) para gerar `gen/dist/main.js`.
- **Mock disponível:** para SQLite o script usa `connection.sqlite.json` e cria `mock.sqlite` (ou `mock-<project>.sqlite`) via `db.js`. Para MySQL, PostgreSQL e SQL Server é necessário ter o serviço rodando; `db.js` cria os bancos e aplica DDL/dados conforme os arquivos em `projects/<name>/db/`.

## Comandos

Execução a partir da **raiz do repositório** (recomendado):

```bash
# Inicializar bancos (criação/carga; todos os projetos ou lista)
node test/e2e-generator/run.js db
node test/e2e-generator/run.js db todo selling

# Executar E2E (geração, aferição, endpoints; todos os projetos ou lista)
node test/e2e-generator/run.js e2e
node test/e2e-generator/run.js e2e todo
```

Ou via npm na raiz:

```bash
npm run test:e2e
```

**db.js** (chamado diretamente ou via `run.js db`):
- `--full` (padrão): limpar e executar DDL e carga por completo.
- `--resume` ou `--incremental`: verificar o que já existe e seguir de onde parou (banco/schema/tabelas/carga).
- `--load`: incluir carga de dados (database.\*.sql) quando aplicável.
- `--apply-comments`: aplicar COMMENT ON do Postgres aos DDLs MySQL/SQL Server/SQLite.

## O que cada script faz

- **run.js:** orquestrador. Primeiro argumento: `db` ou `e2e`. Restante: lista opcional de projetos (se vazio, todos). Chama `db.js` ou `e2e.js` com essa lista.
- **db.js:** criação/carga de bancos. Cria mocks SQLite (todo: `mock.sqlite`; outros: `mock-<project>.sqlite` via create-sqlite-fixture.js); inicializa Postgres, MySQL e SQL Server (cria DBs, aplica DDL e opcionalmente dados). Modo full (padrão) ou incremental (--resume). Opcional: apply-ddl-comments.
- **e2e.js:** para cada projeto e cada connection: garante mock (via db.js --resume se necessário), executa o gerador, aferição dos artefatos, build no output, subida da API e verificação de /health e endpoints (e confirmação no banco após POST).

## Estrutura

- `run.js`, `run.json` — orquestrador e constantes.
- `db.js`, `db.json` — criação/carga de bancos e constantes.
- `e2e.js`, `e2e.json` — geração, aferição, testes de endpoints e constantes (incl. PROJECT_EXPECTED).
- `projects/<name>/db/` — `connection.<dbType>.json`, DDLs e opcionalmente `create-sqlite-fixture.js`, `database.*.sql`.
- Saída do gerador: `output/<project>/<dbType>/` na raiz do repositório.
- `README.md` — este arquivo.

## Referências

- **Plano:** [docs/issues/plan-test-project-generator-vs-mock.md](../../docs/issues/plan-test-project-generator-vs-mock.md).
- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
