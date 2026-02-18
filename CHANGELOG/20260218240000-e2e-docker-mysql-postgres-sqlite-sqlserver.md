<!-- CHANGELOG/20260218240000-e2e-docker-mysql-postgres-sqlite-sqlserver.md -->
# E2E Via Docker: MySQL, SQL Server, Postgres e SQLite; aplicação gerada compila

**Data/Hora UTC:** 2026-02-18 (estimado).

## Arquivos alterados

- `test/e2e-generator-mock/projects/todo/db/schema.mysql.ddl` — criado: DDL MySQL do mock (tb_simple_item, tb_category, … tb_document) para E2E.
- `test/e2e-generator-mock/projects/todo/db/schema.mysql.sql` — criado: mesmo conteúdo em .sql para init do container MySQL (imagem executa apenas .sql/.sh/.sql.gz).
- `docker-compose.e2e.yml` — serviço `mysql` (imagem mysql:8.0, healthcheck, init com `schema.mysql.sql`); `E2E_DB_TYPES` padrão `sqlite,postgres,mysql,sqlserver`; variáveis `DB_MYSQL_HOST`, `DB_MYSQL_PORT`, `DB_MYSQL_USER`, `DB_MYSQL_PASSWORD`; `depends_on` do serviço `e2e` inclui `mysql (condition: service_healthy)`.
- `test/e2e-generator-mock/run.js` — override de host/port/user/password para MySQL via `DB_MYSQL_*` ao carregar conexão.
- `.docker/entrypoint.e2e.sh` — quando `E2E_DB_TYPES` contém `mysql`: espera porta 3306 antes de executar o gerador.
- `test/README.md` — documentação da seção Via Docker: padrão com os quatro bancos (SQLite, Postgres, MySQL, SQL Server); schema.mysql.sql e init descritos.

## Objetivo

- Testes E2E conforme seção "Via Docker" com `make e2e`, `make e2e-build`, `make e2e-run`, focando em MySQL, SQL Server, Postgres e SQLite.
- Aplicação gerada deve compilar com sucesso em cada banco; correções apenas em templates ou arquivos permitidos em gen/static e raiz de gen/ se necessário.

## Resultado

- `make e2e-build` — passou (imagem node-gen-e2e:latest construída).
- `make e2e-run` — passou para SQLite, Postgres, MySQL e SQL Server; artefatos em `output/e2e-mock-app/sqlite/`, `output/e2e-mock-app/postgres/`, `output/e2e-mock-app/mysql/`, `output/e2e-mock-app/sqlserver/`; `npm run build` OK em todos.
- Nenhuma alteração em templates ou gen/static foi necessária; a aplicação gerada compilou para os quatro dialetos.

## Referências

- CHANGELOG 20260218140000-e2e-docker-sqlite-postgres-sqlserver.md
- test/README.md (Via Docker)
