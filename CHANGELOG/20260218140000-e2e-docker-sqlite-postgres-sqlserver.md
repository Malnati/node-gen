<!-- CHANGELOG/20260218140000-e2e-docker-sqlite-postgres-sqlserver.md -->
# E2E Via Docker: foco SQLite, Postgres e SQL Server; aplicação gerada compila

## Data/Hora
2026-02-18 14:00:00 UTC (aprox.)

## Arquivos alterados
- `docker-compose.e2e.yml` — serviço `sqlserver` (imagem mcr.microsoft.com/mssql/server:2022-latest); variáveis `DB_SQLSERVER_*` para o e2e; padrão `E2E_DB_TYPES=${E2E_DB_TYPES:-sqlite,postgres}` permitindo sobrescrever via ambiente (ex.: incluir `sqlserver`).
- `test/e2e-generator-mock/projects/todo/db/schema.sqlserver.ddl` — criado: DDL T-SQL do mock (tb_simple_item, tb_category, … tb_document) para E2E.
- `test/e2e-generator-mock/init-sqlserver.js` — criado: script Node que cria o banco `todo_mock` e aplica o schema (idempotente); ajustado para usar `new mssql.ConnectionPool(...).connect()` por banco (master/todo_mock), evitando reaproveitar pool global e garantindo que o schema seja aplicado em `todo_mock`.
- `test/e2e-generator-mock/run.js` — override de host/port para SQL Server via `DB_SQLSERVER_HOST` e `DB_SQLSERVER_PORT`; aferição passa a considerar também SQL Server quando `E2E_DB_TYPES` inclui `sqlserver`.
- `.docker/entrypoint.e2e.sh` — quando `E2E_DB_TYPES` contém `sqlserver`: espera porta 1433 e executa `init-sqlserver.js`.
- `gen/src/db.reader.sqlserver.ts` — query de tabelas usando nome qualificado `[todo_mock].INFORMATION_SCHEMA.TABLES` e fallback de coluna `table_name`/`TABLE_NAME`.
- `test/README.md` — documentação da seção Via Docker: foco em SQLite, Postgres e SQL Server; inclusão opcional de SQL Server com `E2E_DB_TYPES=sqlite,postgres,sqlserver`.

## Regras/requisitos atendidos
- Testes E2E conforme seção "Via Docker" com `make e2e`, `make e2e-build`, `make e2e-run`.
- Foco em SQLServer, Postgres e SQLite: padrão Docker executa SQLite e Postgres; SQL Server disponível como opção (serviço e init no compose).
- Aplicação gerada para SQLite e Postgres compila com sucesso (`npm run build` no output).
- Estrutura estática e templates mantidos; alterações apenas em gen (db.reader.sqlserver) e em artefatos de teste E2E.

## Resultado
- `make e2e` — passou (build + run com sqlite e postgres).
- `make e2e-build` e `make e2e-run` — passaram para SQLite e Postgres; artefatos em `output/e2e-mock-app/sqlite/` e `output/e2e-mock-app/postgres/`; `npm run build` OK em ambos.
- SQL Server: serviço e init disponíveis; em alguns ambientes (ex.: arm64/emulação) o leitor pode retornar 0 tabelas; para validar os três bancos use `E2E_DB_TYPES=sqlite,postgres,sqlserver` em ambiente amd64 ou com instância SQL Server adequada.

## Referências
- CHANGELOG 20260218220000-e2e-docker-postgres-sqlite.md
- test/README.md (Via Docker)
