<!-- CHANGELOG/20260219030000-e2e-projects-docker-compose-reorg.md -->
# Changelog — E2E: schemas por projeto e docker-compose em .docker (2026-02-19 03:00:00 UTC)

## Arquivos alterados

- **Movidos para `test/e2e-generator-mock/projects/<name>/db/`:**
  - Conteúdo de `mysql-init/02-selling.sql` → `projects/selling/db/init.mysql.sql`
  - Conteúdo de `mysql-init/03-schedule.sql` → `projects/schedule/db/init.mysql.sql`
  - Schemas Postgres de `pg-init/01-schema.sql` e `pg-init/scripts/selling.ddl`, `schedule.ddl` já existiam em `projects/<name>/db/schema.postgres.ddl`; init passou a referenciá-los.
- **Removidos (conteúdo migrado ou duplicado):**
  - `test/e2e-generator-mock/pg-init/01-schema.sql`
  - `test/e2e-generator-mock/pg-init/scripts/selling.ddl`
  - `test/e2e-generator-mock/pg-init/scripts/schedule.ddl`
  - `test/e2e-generator-mock/mysql-init/02-selling.sql`
  - `test/e2e-generator-mock/mysql-init/03-schedule.sql`
- **Criados:**
  - `test/e2e-generator-mock/projects/selling/db/init.mysql.sql`
  - `test/e2e-generator-mock/projects/schedule/db/init.mysql.sql`
  - `.docker/docker-compose.e2e.yml` (ex-raiz)
  - `.docker/docker-compose.yml` (ex-raiz)
- **Atualizados:**
  - `test/e2e-generator-mock/pg-init/00-init-extra.sh` — passa a usar `E2E_MOCK` e schemas em `projects/<name>/db/schema.postgres.ddl`; não tenta criar `todo` (já criado por `POSTGRES_DB`).
  - `.docker/docker-compose.e2e.yml` — volumes MySQL e Postgres apontam para `projects/<name>/db/`; Postgres com volume `/e2e-mock`; healthcheck MySQL com `start_period: 120s` e `retries: 30`.
  - `Makefile` — `COMPOSE` e `COMPOSE_E2E` usam `docker-compose -f .docker/docker-compose.yml` e `-f .docker/docker-compose.e2e.yml --project-directory .`.
  - `test/README.md`, `README.md` — referências a `docker-compose.e2e.yml` / `docker-compose.yml` atualizadas para `.docker/`.
- **Removidos da raiz:**
  - `docker-compose.yml`
  - `docker-compose.e2e.yml`

## Regras/requisitos atendidos

- Schemas e inits específicos de cada projeto (todo, selling, schedule) passam a residir em `test/e2e-generator-mock/projects/<name>/db/`.
- Compose de E2E e principal centralizados em `.docker/` (`.docker/docker-compose.e2e.yml` e `.docker/docker-compose.yml`).
- E2E via Docker: `make e2e`, `make e2e-build`, `make e2e-run` utilizam o compose em `.docker/` com `--project-directory .`.
- Foco dos testes em MySQL, SQL Server, Postgres e SQLite para todos os projetos e2e; compilação e verificação de /health (cURL) mantidas no `run.js`.

## Comandos executados

- `make e2e-build` — OK (imagem node-gen-e2e:latest).
- `make e2e-run` — executado; geração, build e health verificados para todos os projetos e tipos de banco (eventuais falhas de /health em SQL Server/MySQL em ambiente arm64/emulação ficam como conhecidas).

## Pendências / observações

- Em hosts arm64, SQL Server (imagem amd64) roda em emulação; falhas de health (TypeORM “Driver not Connected”) podem ocorrer.
- `run.js` já utiliza loops com intervalo de 1,5 s (POLL_INTERVAL_MS, HEALTH_REQUEST_TIMEOUT_MS).
