<!-- CHANGELOG/20250220140000-e2e-ddl-metadata-mysql-sqlserver-sqlite.md -->
# Metadados DDL (comentários/descrições) em MySQL, SQL Server e SQLite — projetos e2e-generator (2025-02-20)

## Arquivos alterados
- `test/e2e-generator/projects/contacts/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/users/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/tenant/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/transactions/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/auth/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/communications/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/maps/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/config/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/roles/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/notifications/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/orders/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/warehouse/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/reports/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/google-calendar/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/google-drive/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/llm/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/gmail/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/logistics/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/consents/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/todo/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/projects/selling/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`, `schema.mysql.ddl`, `schema.sqlserver.ddl`
- `test/e2e-generator/projects/schedule/db/database.mysql.ddl`, `database.sqlserver.ddl`, `database.sqlite.ddl`
- `test/e2e-generator/apply-ddl-comments.js` (script one-off utilizado para aplicar os metadados)

## Regras atendidas
- Fonte de verdade: `database.postgres.ddl` e `schema.postgres.ddl` (COMMENT ON TABLE/COLUMN/CONSTRAINT).
- MySQL: COMMENT = '...' na tabela; COMMENT '...' em cada coluna.
- SQL Server: PK nomeada (CONSTRAINT pk_&lt;tabela&gt; PRIMARY KEY (id)); EXEC sp_addextendedproperty para tabela, colunas e constraints (MS_Description, schema dbo).
- SQLite: comentários inline -- antes da tabela e ao final de cada linha de coluna.
- Primeira linha de caminho e sintaxe específica de cada motor preservadas.

## Resultado
- Metadados aplicados nos 21 projetos listados (contacts, users, tenant, transactions, auth, communications, maps, config, roles, notifications, orders, warehouse, reports, google-calendar, google-drive, llm, gmail, logistics, consents, todo, selling, schedule), incluindo schema.mysql e schema.sqlserver do selling.
