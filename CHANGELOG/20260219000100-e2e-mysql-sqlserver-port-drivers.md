<!-- CHANGELOG/20260219000100-e2e-mysql-sqlserver-port-drivers.md -->

# Changelog — E2E MySQL/SQL Server: porta numérica, drivers e log de falha de build

**Data/Hora (UTC):** 2026-02-19 00:01:00

## Arquivos modificados

- `gen/templates/datasource.template.ts` — `DATABASE_PORT` lido como string e convertido com `parseInt(..., 10)` para MySQL e demais tipos (postgres/mssql).
- `gen/static/src/app/config/datasource.service.ts` — Mesma conversão de porta para número.
- `gen/src/package-json-generator.ts` — Inclusão condicional de drivers por `dbType`: `mysql2` (MySQL), `mssql` (SQL Server), `sqlite3` (SQLite); `pg` mantido para Postgres.
- `test/e2e-generator-mock/run.js` — Log de stdout/stderr quando `npm install` ou `npm run build` falham; timeout de `npm install` aumentado para 300000 ms (5 min).

## Regras/requisitos atendidos

- Aplicações geradas para MySQL e SQL Server passam a ter driver correto no `package.json` e porta do datasource em número (TypeORM exige `port` numérico).
- E2E com foco em MySQL, SQLServer, Postgres e SQLite: compilação e health verificados; em falha de build/install o log é exibido.

## Pendências

- Nenhuma.
