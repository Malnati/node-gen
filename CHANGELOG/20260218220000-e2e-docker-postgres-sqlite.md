<!-- CHANGELOG/20260218220000-e2e-docker-postgres-sqlite.md -->

# E2E Via Docker: Postgres e SQLite; aplicação gerada compila

**Data/Hora UTC:** 2026-02-18 22:00:00

## Arquivos modificados / criados

- `test/e2e-generator-mock/projects/todo/db/schema.postgres.ddl` — criado: DDL PostgreSQL equivalente ao `schema.sql` (tb_simple_item, tb_category, … tb_document) para E2E no container.
- `docker-compose.e2e.yml` — adicionado serviço `postgres` (imagem postgres:16-alpine, healthcheck, init com `schema.postgres.ddl`); serviço `e2e` com `E2E_DB_TYPES=sqlite,postgres`, `DB_POSTGRES_HOST=postgres`, `DB_POSTGRES_PORT=5432` e `depends_on: postgres (condition: service_healthy)`.
- `test/e2e-generator-mock/run.js` — override de host/port para Postgres via `DB_POSTGRES_HOST` e `DB_POSTGRES_PORT` ao carregar conexão.
- `test/README.md` — documentação da seção "Via Docker" atualizada: E2E executa SQLite e Postgres; saídas em `output/sqlite/` e `output/postgres/`.

## Regras/requisitos atendidos

- Testes E2E conforme seção "Via Docker" com `make e2e`, `make e2e-build`, `make e2e-run`.
- Foco em Postgres e SQLite: ambos executados no container; aplicação gerada para cada um compila (`npm run build` no output).
- Estrutura estática e templates mantidos; nenhuma alteração em `gen/static` além da documentação referida.

## Comandos executados e resultado

- `make e2e-build` — passou (imagem node-gen-e2e:latest construída).
- `make e2e-run` — passou (Postgres e SQLite: gerador executado, artefatos e `npm run build` OK em `output/postgres/` e `output/sqlite/`).
- `make e2e` — passou (build + run).

## Referências

- CHANGELOG 20260218210000-e2e-via-docker-sqlite-only.md (E2E apenas SQLite no container).
- test/README.md (Via Docker).
- AGENTS.md (política de CHANGELOG).
