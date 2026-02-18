<!-- CHANGELOG/20260218185000-e2e-postgres-todo-mock.md -->
# Changelog — E2E Postgres todo_mock e validação 12/12

**Data (UTC):** 2026-02-18 18:50:00

## Arquivos modificados

- `test/e2e-generator-mock/init-postgres.js` — inclusão de `todo_mock` em `EXTRA_DBS` com schema `todo/db/schema.postgres.ddl` e tabela de checagem `tb_simple_item`.
- `test/e2e-generator-mock/pg-init/00-init-extra.sh` — criação do banco `todo_mock` e aplicação de `01-schema.sql` no primeiro init do container Postgres.

## Regras/requisitos atendidos

- Via Docker: `make e2e`, `make e2e-build`, `make e2e-run` conforme seção "Via Docker".
- Foco em MySQL, SQL Server, Postgres e SQLite para todos os projetos (todo, selling, schedule).
- Aplicações geradas compilam com sucesso; ajustes restritos a templates/geradores e, quando necessário, a arquivos em `gen/static` e config do gen.

## Resumo

- **Problema:** Em todo/postgres o generator conectava em `database=todo_mock`, mas esse banco não era criado no Postgres (apenas `selling_mock` e `schedule_mock` em `init-postgres.js` e em `00-init-extra.sh`), resultando em 0 tabelas e FALHA na aferição (5/9).
- **Solução:** Inclusão de `todo_mock` no init do Postgres: em `init-postgres.js` (executado pelo entrypoint E2E) e em `pg-init/00-init-extra.sh` (init do container com volume novo).
- **Resultado:** Os 12 cenários E2E (3 projetos × 4 bancos) passam, incluindo `npm run build` em todos os outputs.

## Pendências

Nenhuma.
