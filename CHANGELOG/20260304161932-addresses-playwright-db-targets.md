<!-- CHANGELOG/20260304161932-addresses-playwright-db-targets.md -->
# Implementação 2026-03-04 16:19:32 UTC - addresses Playwright + alvos db-* por projeto

## Referências cruzadas (planos/políticas consultados)
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`
- `CHANGELOG/20260304153828-gen-main-static-template-governance.md`

## Arquivos alterados
- `.docker/entrypoint.projects.postgres.sh`
- `.docker/docker-compose.e2e.yml`
- `Makefile`
- `gen/src/api-entity-generator.ts`
- `gen/src/api-service-generator.ts`
- `test/sspa.spec.ts`
- `CHANGELOG/20260304161932-addresses-playwright-db-targets.md`

## Regras e requisitos atendidos
- Corrigido bootstrap do container `apis` para aceitar ambos os layouts de projeto:
  - `output/<project>/postgres/package.json`
  - `output/<project>/postgres/api/package.json`
- Mantida a estratégia existente de subida das APIs, apenas com resolução do diretório da aplicação (`resolve_app_dir`) para evitar pular projetos válidos (como `addresses`).
- Ajustado o bootstrap de APIs para rebuild automático quando `src/` estiver mais novo que `dist/main.js`, evitando execução com artefatos stale após nova geração.
- Adicionados alvos por projeto para inicialização de banco via `Makefile`:
  - `db-pg-<projeto>`
  - `db-sqlite-<projeto>`
  - `db-mysql-<projeto>`
  - `db-sqlserver-<projeto>`
- Exposição de portas dedicadas para bancos da stack E2E em `.docker/docker-compose.e2e.yml`:
  - Postgres `15432:5432`
  - MySQL `13306:3306`
  - SQL Server `11433:1433`
- Alvos de banco executam `run.js db` via Makefile com `NODE_PATH=gen/node_modules` e portas dedicadas da stack E2E.
- Corrigidos imports inválidos gerados para entidades/serviços de API com relacionamentos:
  - removido alias `@app/entities/*` para imports relativos corretos por módulo.
  - removidos imports inexistentes como `./country`, `./state`, `./city` nas entidades.
- Ajustado `playwright-up` para aguardar especificamente o `apiPort` do `PLAYWRIGHT_PROJECT` (via `projects.json`), evitando corrida com porta `3001` quando o projeto filtrado é `addresses` (`3002`).
- Ajustada asserção no teste card-a-card para cenário com `PLAYWRIGHT_PROJECT` filtrado, sem exigir contagem total de cards da dashboard.

## Comandos executados
- `ls -la`
- `rg --files -g 'Makefile'`
- `git status --short`
- `rg -n "addresses|playwright|e2e|db-pg|db-sqlite|db-mysql|db-sqlserver|gen|project" Makefile`
- `sed -n '1,520p' Makefile`
- `rg --files test`
- `rg -n "addresses|PLAYWRIGHT_PROJECT|projects.json|health|card" test playwright.config.ts Makefile`
- `ls -la playwright-results`
- `rg -n "failed|FAIL|addresses|Error|Timeout|expect\(" playwright-results/playwright-run.log test-results -S`
- `sed -n '1,340p' test/sspa.spec.ts`
- `sed -n '40,240p' playwright-results/sspa-projects.json`
- `sed -n '1,280p' .docker/docker-compose.projects.postgres.yml`
- `rg -n "addresses|3002|Application|Error|Nest|listening|health" playwright-results/containers-apis.log`
- `sed -n '1,260p' .docker/entrypoint.projects.postgres.sh`
- `sed -n '1,260p' .docker/entrypoint.e2e.sh`
- `date -u +%Y%m%d%H%M%S`
- `make db-pg-addresses`
- `make gen-addresses-pg-api`
- `make gen-addresses-pg-parcel-paging`
- `make e2e-addresses-pg-parcel-paging`
- `PLAYWRIGHT_PROJECT=addresses make playwright-test`
- `DOCKER_BUILDKIT=0 make e2e-build`
- `npm --prefix gen run build`
- `make projects-up`
- `make gen-pg-api GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/addresses/postgres`
- `PLAYWRIGHT_PROJECT=addresses make playwright-test`
- `make db-pg-addresses`
- `make db-sqlite-addresses`
- `make db-mysql-addresses`
- `make db-sqlserver-addresses`

## Resultado resumido
- Diagnóstico das 3 falhas Playwright do `addresses`: **PASSOU**.
  - Causa raiz 1: API do `addresses` não era aguardada especificamente antes do Playwright.
  - Causa raiz 2: asserção de card-count incompatível com filtro de projeto.
  - Causa raiz 3: código gerado de API com imports inválidos em `addresses`, impedindo subida estável.
- Execução final do Playwright focado (`PLAYWRIGHT_PROJECT=addresses make playwright-test`): **PASSOU** (`6 passed`).
- Implementação dos alvos `db-pg-*`, `db-sqlite-*`, `db-mysql-*`, `db-sqlserver-*`: **PASSOU**.
- Validação de inicialização para `addresses` nos 4 alvos de banco:
  - `db-pg-addresses`: **PASSOU**
  - `db-sqlite-addresses`: **PASSOU**
  - `db-mysql-addresses`: **PASSOU**
  - `db-sqlserver-addresses`: **PASSOU** (com retries transitórios de conexão/login durante bootstrap).
- Validação de geração + testes para 1 projeto (`addresses`): **PASSOU**.

## Definição de pronto
- [x] Existe correção para evitar `404` de `addresses` causados por mapeamento incorreto de porta/projeto na stack Playwright.
- [x] Há alvos `db-pg-<projeto>`, `db-sqlite-<projeto>`, `db-mysql-<projeto>`, `db-sqlserver-<projeto>` no `Makefile`.
- [x] Geração e testes executados para um único projeto e com evidência final de sucesso.
- [x] Execução Playwright focada em `addresses` sem as 3 falhas originais.
