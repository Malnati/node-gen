<!-- CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-audit.md -->
# Auditoria — `addresses` Postgres com geração + E2E Paging + Playwright

## Data/Hora UTC
2026-03-03T20:52:20Z

## Plano relacionado
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`

## Comandos executados
1. `make e2e-clean`
2. `make gen-api+paging GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/addresses GEN_DB_TYPE=postgres`
3. `E2E_DB_TYPES=postgres E2E_PAGING_DB_TYPE=postgres make e2e-paging-addresses` (tentativas sucessivas)
4. `make projects-up`
5. `PLAYWRIGHT_PROJECT=addresses make playwright-test` (tentativas sucessivas)
6. `make e2e-api-addresses` (tentativa de alinhamento com stack `projects-up`)
7. `make playwright-clean`

## Resultado por etapa
1. `make e2e-clean` — **PASSOU**
2. `gen-api+paging` — **PASSOU** (com avisos de conexão local no host, sem bloquear geração)
3. `e2e-paging-addresses` — **FALHOU** nas tentativas iniciais e **PASSOU** na final
   - Falhas corrigidas no ciclo:
     - `E2E_PAGING_DB_TYPE` não propagado ao container E2E.
     - seleção fixa sqlite no `e2e-paging.js`.
     - ausência de credenciais nas chamadas do gerador para Postgres.
     - estrutura esperada de artefatos divergente (`frontend/*-paging-mfe`).
     - dependência inválida (`vite-plugin-single-spa@^5.0.0`).
     - imports/case incorretos e erro de template em `client.ts`.
     - `vite.config.ts` incompatível com plugin ajustado.
     - `src/main.tsx` ausente por filtro de cópia.
     - `main.tsx` usando API inexistente (`createSingleSpa`).
     - imports CSS estáticos não resolvíveis.
4. `projects-up` — **PASSOU**
5. `PLAYWRIGHT_PROJECT=addresses make playwright-test` — **FALHOU**
   - Causa objetiva final: `addresses` não está presente no `projects.json` servido pelo SSPA no fluxo `projects-up` deste ciclo.
6. `make e2e-api-addresses` — **INTERROMPIDO**
   - Causa objetiva: tempo de execução elevado por rebuild completo recorrente; sem conclusão antes do fechamento do ciclo.

## Evidências obrigatórias
- Arquivos alterados:
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
- Comandos executados: listados acima.
- Resultado resumido:
  - Geração + E2E Paging Postgres para `addresses`: **PASSOU**.
  - Playwright filtrado para `addresses`: **FALHOU** por ausência de `addresses` no `projects.json`.
- Definição de pronto:
  - [x] Plano registrado em `CHANGELOG/`.
  - [x] Implementação com alterações mínimas para geração + E2E via Makefile.
  - [x] Execução E2E Paging Postgres para `addresses`.
  - [ ] Execução Playwright filtrada em `addresses` com sucesso.
  - [x] Auditoria com comandos e resultados objetivos.
