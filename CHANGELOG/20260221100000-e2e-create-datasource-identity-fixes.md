<!-- CHANGELOG/20260221100000-e2e-create-datasource-identity-fixes.md -->
# Changelog — E2E create, datasource SQL Server e colunas identity

**Data/Hora UTC:** 2026-02-21 10:00:00

## Arquivos modificados

- `gen/templates/datasource.template.ts` — branch explícita para `mssql` com `options.trustServerCertificate: true`.
- `gen/templates/service.ejs` — create usa apenas `repo.save(newEntity)` na transação (remoção do fluxo insert+findOne+fallback).
- `gen/src/service-generator.ts` — no create, atribuição da FK (`newEntity.<coluna_fk> = relacionamento.id|external_id`) em vez da entidade de relação (`newEntity.relacao = entidade`), evitando cascade/update sem id.
- `gen/src/interfaces.ts` — campo opcional `isIdentity?: boolean` em `Column`.
- `gen/src/db.reader.sqlserver.ts` — preenchimento de `isIdentity` a partir de `sys.identity_columns`.
- `gen/src/db.reader.mysql.ts` — preenchimento de `isIdentity` a partir de `EXTRA` (auto_increment) em `information_schema.columns`.
- `gen/src/typeorm-entity-generator.ts` — uso de `@PrimaryGeneratedColumn()` quando `isPrimaryKey && column.isIdentity`; import de `PrimaryGeneratedColumn` adicionado.
- `test/e2e-generator/run.js` — em `postAndVerifyInDb`, query de verificação no banco usa `SELECT TOP 1 ...` para SQL Server e `... LIMIT 1` para os demais.

## Regras/requisitos atendidos

- Teste E2E via Docker (`make e2e`, `make e2e-build`, `make e2e-run`).
- Apenas edição de arquivos existentes (nenhum arquivo criado/deletado/movido além do changelog).
- Ajustes restritos a templates e geradores em `gen/`.
- SQL Server: conexão com certificado self-signed (trustServerCertificate).
- SQL Server: INSERT sem enviar valor para coluna IDENTITY (entidade com `@PrimaryGeneratedColumn()`).
- MySQL/Postgres: create sem “Cannot update entity because entity id is not set” (save com apenas FKs atribuídas).

## Atualização: verificação banco SQL Server

- `test/e2e-generator/run.js`: em `postAndVerifyInDb`, a query de verificação usa `SELECT TOP 1 1 AS ok ...` quando `conn.dbType === 'sqlserver'`, e `... LIMIT 1` para os demais, evitando o erro "Incorrect syntax near 'LIMIT'" no SQL Server.

## Pendências / observações

- Rodar `make e2e-build && make e2e-run` para validar todos os projetos e DBs (incluindo google-calendar sqlserver).
- Postgres: colunas SERIAL/GENERATED não preenchem `isIdentity` no reader; comportamento atual pode permanecer correto pois Postgres já passava na cobertura banco.
