<!-- CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md -->
# Plano — `addresses` Postgres com geração + E2E Paging + Playwright

## Data/Hora UTC
2026-03-03T20:52:20Z

## 1. Arquivos existentes relevantes para o escopo
- `Makefile`
- `.docker/docker-compose.e2e.yml`
- `.docker/entrypoint.e2e.sh`
- `.docker/docker-compose.projects.postgres.yml`
- `test/e2e-generator/e2e-paging.js`
- `test/sspa.spec.ts`
- `CHANGELOG/20260303204500-plan-api-mfe-paging-addresses.md`

## 2. Arquivos que serão alterados
- `test/e2e-generator/e2e-paging.js`
- `test/sspa.spec.ts`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-impl.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-audit.md`

## 3. Lista combinada de requisitos (específicos + globais)
- Executar fluxo completo para um projeto (`addresses`) usando Postgres.
- Gerar API e MFE parcel paging para `addresses`.
- Testar MFE parcel paging de `addresses` com base Postgres.
- Testar via Playwright focado em `addresses`.
- Iniciar comandos sempre via `Makefile`.
- Registrar rastreabilidade no `CHANGELOG/` com evidências objetivas.

## 4. Requisitos não atendidos no início do ciclo
- `e2e-paging` executava apenas caminho sqlite.
- Playwright não tinha filtro explícito para um único projeto no spec.
- Faltava execução consolidada em um ciclo único (`geração + e2e + playwright`) para `addresses`.

## 5. Lista combinada de regras (específicas + globais)
- Mudança mínima, sem refactor amplo.
- Não executar fluxos diretos de `npm`, `node` ou `sh` fora de alvos `make`.
- Evidências obrigatórias: comandos, arquivos, resultado e definição de pronto.
- Preservar comportamento retrocompatível quando variáveis novas não forem informadas.

## 6. Regras não atendidas que motivam os ajustes
- Cobertura parcial do cenário Postgres para paging.
- Ausência de escopo Playwright dedicado a um projeto por variável de ambiente.

## 7. Plano de auditoria (manual + automático)
1. Executar `make e2e-clean`.
2. Executar geração com `make gen-api+paging ... GEN_DB_TYPE=postgres`.
3. Executar `E2E_DB_TYPES=postgres E2E_PAGING_DB_TYPE=postgres make e2e-paging-addresses`.
4. Executar `make projects-up`.
5. Executar `PLAYWRIGHT_PROJECT=addresses make playwright-test`.
6. Executar `make projects-down`.
7. Registrar resultados, saídas objetivas e arquivos alterados em `*-impl.md` e `*-audit.md`.

## 8. Seleção de checklists aplicáveis
- Governança e rastreabilidade por `CHANGELOG/*`.
- Execução por `Makefile` como único ponto de entrada.
- Validação de geração + testes E2E + testes Playwright.
- Checklist obrigatório transversal: evidências de comandos e definição de pronto.

## Referências cruzadas
- `CHANGELOG/20260303204500-plan-api-mfe-paging-addresses.md`
- `CHANGELOG/20260301040748-e2e-addresses-makefile-plan.md`
- `CHANGELOG/20260301040748-e2e-addresses-makefile-audit.md`
