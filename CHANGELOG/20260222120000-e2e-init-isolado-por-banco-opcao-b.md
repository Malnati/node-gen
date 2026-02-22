<!-- CHANGELOG/20260222120000-e2e-init-isolado-por-banco-opcao-b.md -->
# E2E init isolado por banco (Opção B)

**Data/Hora UTC:** 2026-02-22 (estimado).

## Arquivos alterados

- `test/e2e-generator/projects/selling/db/init.mysql.sql` — criação do banco `schedule` e grant para usuário `e2e` (uso pelos scripts 03/04 do MySQL).
- `test/e2e-generator/projects/schedule/db/database.mysql.ddl` — adicionado `USE schedule;` no início para DDL rodar no banco schedule.
- `test/e2e-generator/projects/schedule/db/database.mysql.sql` — adicionado `USE schedule;` no início para dados rodarem no banco schedule.
- `test/e2e-generator/pg-init/scripts/00-init-extra.sh` — criação do banco `schedule` e aplicação do schema `projects/schedule/db/schema.postgres.ddl`.
- `test/e2e-generator/init-postgres.js` — inclusão do projeto `schedule` em `EXTRA_DBS` (fallback Node para criar banco e aplicar schema).
- `test/e2e-generator/init-sqlserver.js` — inclusão do projeto `schedule` em `PROJECT_DBS` (banco schedule e DDL via `database.sqlserver.ddl`).
- `test/e2e-generator/README.md` — menção ao init isolado por banco e aos bancos por projeto (todo, selling, google_calendar, schedule).

## Objetivo

- Isolar o init por banco mantendo um único container por engine (MySQL, Postgres, SQL Server): cada projeto (todo, selling, google_calendar, schedule) passa a ter seu próprio banco criado e populado apenas com seu DDL/dados.

## Regras/requisitos atendidos

- Cada projeto usa exclusivamente seu próprio banco no E2E; nenhum banco compartilha tabelas com outro.
- Ordem de execução do init permanece única (01→02→03→04 no MySQL; script único no Postgres; loop em PROJECT_DBS no SQL Server).

## Resultado

- MySQL: bancos `todo`, `selling`, `google_calendar`, `schedule` isolados; schedule com `USE schedule;` nos scripts 03 e 04.
- Postgres: banco `schedule` criado e schema aplicado em `00-init-extra.sh` e em `init-postgres.js`.
- SQL Server: banco `schedule` criado e schema aplicado via `init-sqlserver.js`.

## Referências

- Plano: E2E init isolado por banco (Opção B).
