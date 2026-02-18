<!-- CHANGELOG/20260218190000-db-scripts-to-projects-user-db.md -->

# 2026-02-18 19:00:00 UTC — Scripts DDL/SQL movidos para test/e2e-generator-mock/projects/user/db

## Objetivo

Padronizar a localização dos scripts de banco por dialeto e unificar o padrão de nomes (incluindo SQL Server).

## Alterações

- **Novo diretório:** `test/e2e-generator-mock/projects/user/db/` com 8 arquivos:
  - `database.mysql.ddl`, `database.mysql.sql`
  - `database.postgres.ddl`, `database.postgres.sql`
  - `database.sqlite.ddl`, `database.sqlite.sql`
  - `database.sqlserver.ddl`, `database.sqlserver.sql` (antes `test/db/sqlserver/database.ddl` e `sqlserver/data.sql`).
- **Removido:** `test/db/` (incluindo subdiretório `sqlserver/`).

## Referências atualizadas

- **README.md:** exemplos com MySQL, Postgres, SQL Server e caminho dos scripts; pg_dump; referência a scripts em `test/e2e-generator-mock/projects/user/db/`.
- **gen.sh:** paths para sqlite, mysql e sqlcmd (sqlserver) apontando para o novo diretório.
- **gen/templates/datasource.template.ts** e **gen/static/src/app/config/datasource.service.ts:** default `DATABASE_PATH` para `test/e2e-generator-mock/projects/user/db/database.db`.
- **.gitignore** e **.dockerignore:** `test/e2e-generator-mock/projects/user/db/database.db` e `*.db`.
- **test/README.md:** tabela de estrutura; DDL/dados descritos em `e2e-generator-mock/projects/user/db/`.
- **docs/issues/plan-mock-project-codegen.md:** schema existente em `test/e2e-generator-mock/projects/user/db/`.
- **.github/agents/agent-docker-stack.md:** exemplo de estrutura de pastas.

## Padrão de nomes

Todos os dialetos seguem o mesmo padrão: `database.<dialeto>.ddl` (estrutura) e `database.<dialeto>.sql` (dados). SQL Server passou de `sqlserver/database.ddl` e `sqlserver/data.sql` para `database.sqlserver.ddl` e `database.sqlserver.sql`.
