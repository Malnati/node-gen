<!-- CHANGELOG/20260218183000-e2e-via-docker-validacao.md -->
# Validação E2E Via Docker — MySQL, SQL Server, Postgres, SQLite

**Data/Hora UTC:** 2026-02-18 18:30:00 (auditoria executada em 18/02/2026).

## Escopo auditado

- Execução dos testes E2E conforme seção "Via Docker" do `test/README.md`.
- Comandos: `make e2e-build`, `make e2e-run`, com foco em MySQL, SQL Server, Postgres e SQLite.

## Comandos executados

1. `make e2e-build` — build da imagem `node-gen-e2e:latest` via `docker-compose.e2e.yml`.
2. `make e2e-run` — execução do container E2E com `E2E_DB_TYPES=sqlite,postgres,mysql,sqlserver`.

## Resultado

- **make e2e-build:** passou (imagem construída).
- **make e2e-run:** passou para os quatro bancos:
  - **mysql:** OK (obrigatórios 9/9); `npm run build` no output OK.
  - **postgres:** OK (obrigatórios 9/9); `npm run build` no output OK.
  - **sqlite:** OK (obrigatórios 9/9); `npm run build` no output OK.
  - **sqlserver:** OK (obrigatórios 9/9); `npm run build` no output OK.

Aplicações geradas em `output/e2e-mock-app/<dbType>/` compilaram com sucesso em todos os casos. Nenhuma alteração em templates ou arquivos estáticos foi necessária.

## Referências

- test/README.md (seção Via Docker)
- CHANGELOG/20260218240000-e2e-docker-mysql-postgres-sqlite-sqlserver.md
