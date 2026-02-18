<!-- CHANGELOG/20250218150000-e2e-projetos-selling-schedule.md -->
# Changelog — Projetos E2E selling e schedule (múltiplos modelos)

**Data/Hora UTC:** 2025-02-18 15:00:00

## Arquivos criados

- `test/e2e-generator-mock/projects/selling/db/` — projeto **selling** (vendas): connection.*.json, schema.sql, schema.postgres.ddl, schema.mysql.ddl, schema.mysql.sql, schema.sqlserver.ddl, database.sqlite.ddl, database.sqlite.sql, database.postgres.ddl, database.postgres.sql, database.mysql.ddl, database.mysql.sql, database.sqlserver.ddl, database.sqlserver.sql, create-sqlite-fixture.js
- `test/e2e-generator-mock/projects/schedule/db/` — projeto **schedule** (agendamento): mesma estrutura para os quatro bancos (SQLite, PostgreSQL, MySQL, SQL Server)

## Regras/requisitos atendidos

- Mesmos bancos que `todo`: SQLite, PostgreSQL, MySQL, SQL Server, com connection files e DDL/DML por dialeto
- Modelos com tipos de dados diferentes e relações complexas entre tabelas
- **selling:** DECIMAL, DATE, JSON/JSONB, BOOLEAN/BIT/TINYINT; N-1 (order→customer, order→payment_method), 1-N (order→order_line, order→payment, customer→customer_address); chave composta em tb_order_line (order_id, line_number)
- **schedule:** auto-referência (tb_resource.parent_id → tb_resource.id), N-N com atributo (tb_booking_participant.role), histórico com snapshot JSON/JSONB; relações slot→resource, booking→slot, booking→recurrence_rule, booking↔participant, booking→booking_history

## Pendências

- Nenhuma
