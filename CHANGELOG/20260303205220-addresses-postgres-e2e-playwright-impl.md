<!-- CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-impl.md -->
# Implementação — `addresses` Postgres com geração + E2E Paging + Playwright

## Data/Hora UTC
2026-03-03T20:52:20Z

## Plano relacionado
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`

## Arquivos alterados
- `.docker/docker-compose.e2e.yml`
- `Makefile`
- `gen/src/mfe-parcel-paging-generator.ts`
- `gen/templates/mfe-parcel-page.ejs`
- `gen/static/mfe-parcel-paging/package.json`
- `gen/static/mfe-parcel-paging/vite.config.ts`
- `gen/static/mfe-parcel-paging/src/main.tsx`
- `gen/static/mfe-parcel-paging/src/index.css`
- `test/e2e-generator/e2e-paging.js`
- `test/sspa.spec.ts`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-impl.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-audit.md`

## Ajustes implementados
1. `test/e2e-generator/e2e-paging.js`
- Adicionada variável `E2E_PAGING_DB_TYPE` (default `sqlite`) para selecionar conexão alvo por banco.
- Substituída seleção fixa de sqlite por seleção dinâmica de `connection.<dbType>.json`.
- Mantida compatibilidade: banco sqlite continua usando fixture local; bancos externos preservam `database` da conexão.

2. `test/sspa.spec.ts`
- Adicionado filtro opcional por variável `PLAYWRIGHT_PROJECT`.
- `loadProjects` agora filtra `projects.json` quando variável é fornecida e falha explicitamente se o projeto não existir.
- Sem variável, comportamento anterior (todos os projetos) permanece.

3. Ajustes de suporte ao fluxo `mfe-parcel-paging` em Postgres
- `.docker/docker-compose.e2e.yml`: propagação de `E2E_PAGING_DB_TYPE` para o container E2E.
- `gen/src/mfe-parcel-paging-generator.ts`: correções no conteúdo gerado (`client.ts`, `vite.config.ts`) e cópia de arquivos estáticos necessários (`src/main.tsx`).
- `gen/templates/mfe-parcel-page.ejs`: import corrigido para API em camelCase.
- `gen/static/mfe-parcel-paging/*`: correções de compatibilidade de build (dependências, `vite.config.ts`, `main.tsx`, `index.css`).
- `Makefile`: `playwright-up` agora suporta execução filtrada por `PLAYWRIGHT_PROJECT` sem exigir `health=200` em todas as portas `3001-3026`.

## Comandos executados
1. `make e2e-clean`
2. `make gen-api+paging GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/addresses GEN_DB_TYPE=postgres`
3. `E2E_DB_TYPES=postgres E2E_PAGING_DB_TYPE=postgres make e2e-paging-addresses` (múltiplas tentativas até correções)
4. `make projects-up`
5. `PLAYWRIGHT_PROJECT=addresses make playwright-test` (tentativas)
6. `make e2e-api-addresses` (iniciado para alinhamento do stack SSPA; execução interrompida por tempo)
7. `make playwright-clean`

## Resultado resumido
- `e2e-paging-addresses` com Postgres: **PASSOU** na execução final após correções.
- `projects-up`: **PASSOU**.
- `playwright-test` com `PLAYWRIGHT_PROJECT=addresses`: **FALHOU** porque `addresses` não consta em `projects.json` da stack SSPA do ciclo.
