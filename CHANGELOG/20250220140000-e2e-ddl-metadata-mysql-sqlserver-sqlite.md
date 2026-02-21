<!-- CHANGELOG/20250220140000-e2e-ddl-metadata-mysql-sqlserver-sqlite.md -->
# Metadados DDL (comentários/descrições) em MySQL, SQL Server e SQLite — projetos e2e-generator-mock (2025-02-20)

## Arquivos alterados
- `test/e2e-generator-mock/projects/contacts/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/users/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/tenant/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/transactions/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/auth/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/communications/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/maps/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/config/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/roles/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/notifications/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/orders/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/warehouse/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/reports/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/google-calendar/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/google-drive/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/llm/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/gmail/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/logistics/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/consents/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/todo/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/projects/selling/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`, `schema.mysql.ddl`, `schema.sqlserver.ddl`
- `test/e2e-generator-mock/projects/schedule/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator-mock/apply-ddl-comments.js` (script one-off utilizado para aplicar os metadados)

## Regras atendidas
- Fonte de verdade: `database.postgres.ddl` e `schema.postgres.ddl` (COMMENT ON TABLE/COLUMN/CONSTRAINT).
- MySQL: COMMENT = '...' na tabela; COMMENT '...' em cada coluna.
- SQL Server: PK nomeada (CONSTRAINT pk_&lt;tabela&gt; PRIMARY KEY (id)); EXEC sp_addextendedproperty para tabela, colunas e constraints (MS_Description, schema dbo).
- SQLite: comentários inline -- antes da tabela e ao final de cada linha de coluna.
- Primeira linha de caminho e sintaxe específica de cada motor preservadas.

## Resultado
- Metadados aplicados nos 21 projetos listados (contacts, users, tenant, transactions, auth, communications, maps, config, roles, notifications, orders, warehouse, reports, google-calendar, google-drive, llm, gmail, logistics, consents, todo, selling, schedule), incluindo schema.mysql e schema.sqlserver do selling.
