<!-- CHANGELOG/20260222130000-e2e-init-todos-os-projetos.md -->
# E2E init com todos os projetos (descoberta dinâmica)

**Data/Hora UTC:** 2026-02-22 (estimado).

## Arquivos alterados

- `test/e2e-generator/init-mysql.js` — criado: init MySQL por descoberta (connection.mysql.json + DDL/dados), cria cada banco, grant e2e, aplica DDL e database.mysql.sql quando existir.
- `.docker/entrypoint.e2e.sh` — após MySQL pronto, executa `node test/e2e-generator/init-mysql.js`.
- `.docker/docker-compose.e2e.yml` — removidos os quatro volumes do serviço `mysql` (docker-entrypoint-initdb.d); adicionados `DB_MYSQL_INIT_USER` e `DB_MYSQL_INIT_PASSWORD` no serviço e2e para init-mysql.js.
- `test/e2e-generator/init-postgres.js` — lista fixa `EXTRA_DBS` substituída por descoberta (connection.postgres.json + schema/database.postgres.ddl); primeira tabela do DDL usada como checkTable; ordenação por nome do projeto.
- `test/e2e-generator/pg-init/scripts/00-init-extra.sh` — reduzido a apenas aplicar schema do todo no banco todo; demais bancos criados e populados pelo init-postgres.js.
- `test/e2e-generator/init-sqlserver.js` — lista fixa `PROJECT_DBS` substituída por descoberta (connection.sqlserver.json + schema/database.sqlserver.ddl); primeira tabela do DDL usada como checkTable; ordenação por nome do projeto; escape de nomes em queries.

## Objetivo

Incluir todos os projetos que possuem `connection.<engine>.json` e DDL correspondente no init de MySQL, Postgres e SQL Server, usando descoberta dinâmica a partir de `projects/`, para que cada projeto tenha seu próprio banco criado e populado igualmente.

## Regras/requisitos atendidos

- Nome do banco obtido de `connection.<engine>.json` (campo `database`).
- Arquivo de schema: `schema.<engine>.ddl` se existir, senão `database.<engine>.ddl`.
- Projetos sem DDL são ignorados (skip com log).
- Ordem determinística (projetos ordenados por nome).

## Resultado

- MySQL: um banco por projeto descoberto; init via init-mysql.js no startup do e2e; sem volumes de init no container MySQL.
- Postgres: um banco por projeto descoberto; init-postgres.js descobre e aplica; 00-init-extra.sh só aplica schema do todo.
- SQL Server: um banco por projeto descoberto; init-sqlserver.js descobre e aplica.

## Referências

- Plano: E2E init com todos os projetos.
- CHANGELOG 20260222120000-e2e-init-isolado-por-banco-opcao-b.md.
