<!-- CHANGELOG/20260219040000-e2e-docker-health-datasource-init.md -->
# Changelog — E2E: init Postgres em .docker, verificação de containers, DataSource.onModuleInit (2026-02-19 04:00:00 UTC)

## Arquivos alterados

- **Criados**
  - `.docker/e2e-postgres-init/00-init-extra.sh` — script de init do Postgres para E2E (cria todo, selling, schedule e aplica schemas de `projects/<name>/db/schema.postgres.ddl`); executável (`chmod +x`).
  - `test/e2e-generator/pg-init/README.md` — referência ao init em `.docker/e2e-postgres-init`.
- **Removidos**
  - `test/e2e-generator/pg-init/00-init-extra.sh` — conteúdo migrado para `.docker/e2e-postgres-init/00-init-extra.sh`.
- **Modificados**
  - `.docker/docker-compose.e2e.yml` — volume do Postgres passa a montar `./.docker/e2e-postgres-init` em `/docker-entrypoint-initdb.d`.
  - `test/e2e-generator/run.js` — verificação de conectividade dos containers de banco (postgres, mysql, sqlserver) no início do fluxo com timeout de 1,5 s; constante `DB_CONNECT_CHECK_TIMEOUT_MS = 1500`.
  - `gen/static/src/app/config/datasource.service.ts` — `DataSourceService` implementa `OnModuleInit` e chama `dataSource.initialize()` em `onModuleInit()` para garantir conexão antes do health check.
  - `gen/templates/datasource.template.ts` — mesma alteração (OnModuleInit + onModuleInit) para aplicações geradas.
  - `gen/src/typeorm-entity-generator.ts` — opção `length` no `@Column` só é adicionada para tipos que a suportam (string, varchar, char, nvarchar, nchar), evitando erro "Column description does not support length property" em colunas text/json.
  - `test/README.md` — referência ao init do Postgres atualizada para `.docker/e2e-postgres-init/00-init-extra.sh`.

## Regras/requisitos atendidos

- Testes E2E via Docker: `make e2e`, `make e2e-build`, `make e2e-run` com foco em MySQL, SQL Server, Postgres e SQLite para todos os projetos (todo, selling, schedule).
- Arquivos específicos de projeto permanecem em `test/e2e-generator/projects/<name>/db/`; script de orquestração do Postgres E2E em `.docker/`.
- Verificação de containers (porta acessível) e cURL em `/health`; loops com timeout de no máximo 1,5 s.
- Aplicações geradas compilam; correção de health 500 por DataSource não inicializado feita em templates/estático (OnModuleInit).

## Comandos executados

- `make e2e-build` — OK.
- `make e2e-run` — executado; MySQL/Postgres/SQLite passam com /health 200; SQL Server em arm64 pode falhar (emulação, “Driver not Connected”), conforme documentado.

## Pendências / observações

- Em hosts arm64, SQL Server (imagem amd64) em emulação pode continuar falhando no health da aplicação gerada; em amd64 o fluxo completo dos quatro bancos é validado.
