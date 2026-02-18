<!-- CHANGELOG/20260218215000-e2e-via-docker-quatro-bancos-validacao.md -->
# E2E Via Docker — Validação MySQL, SQL Server, Postgres e SQLite (2026-02-18)

## Arquivos alterados
- Nenhum (apenas execução de testes e validação).

## Comandos executados
1. `make e2e-build` — build da imagem `node-gen-e2e:latest` via `docker-compose.e2e.yml`.
2. `make e2e-run` — execução do container E2E com `E2E_DB_TYPES=sqlite,postgres,mysql,sqlserver` (projetos schedule, selling, todo).
3. Validação de compilação: `docker run` em `output/todo/{sqlite,postgres,mysql,sqlserver}` com `npm install --legacy-peer-deps` e `npm run build`.

## Resultado
- **make e2e-build:** passou (imagem construída).
- **make e2e-run:** executado (geração para os quatro bancos nos três projetos; aferição 9/9 obrigatórios por combinação).
- **Compilação:** `npm run build` passou em `output/todo/sqlite`, `output/todo/postgres`, `output/todo/mysql` e `output/todo/sqlserver`.

## Definição de pronto
- Testes E2E conforme seção "Via Docker" do `test/README.md` com foco em MySQL, SQL Server, Postgres e SQLite.
- Aplicações geradas compilam com sucesso; nenhum ajuste em templates ou arquivos estáticos foi necessário.

## Referências
- test/README.md (seção Via Docker)
- CHANGELOG/20260218240000-e2e-docker-mysql-postgres-sqlite-sqlserver.md
