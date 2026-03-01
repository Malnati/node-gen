<!-- CHANGELOG/20260301040748-e2e-addresses-makefile-audit.md -->
# Auditoria — E2E `addresses` via Makefile

## Data/Hora UTC
2026-03-01T04:07:48Z

## Plano relacionado
- `CHANGELOG/20260301040748-e2e-addresses-makefile-plan.md`

## Comandos executados
1. `make e2e-clean`
2. `make e2e addresses` (tentativa inicial)
3. `make e2e addresses` (reteste 1)
4. `make e2e addresses` (reteste 2)
5. `make e2e addresses` (reteste final)

## Execução e resultados
- Tentativa inicial: **falhou**
  - Motivo: fallback CRUD tentava `GET` com UUID aleatório em recurso com `id` numérico (`/country/:id`), retornando `400`.
- Correção 1 aplicada em `test/e2e-generator/e2e.js`
  - Adicionado fallback de resolução de ID por coleção e por banco (`findRecordIdInDb`), evitando uso de UUID inválido.
- Reteste 1: **falhou**
  - Motivo: payload de `PUT` gerava valor longo para `country.code` (`varchar(2)`), retornando erro de tamanho.
- Correção 2 aplicada em `test/e2e-generator/e2e.js`
  - Adicionado `buildUpdatedFieldValue` para respeitar tamanho/tipo do campo atualizado.
- Reteste 2: **falhou**
  - Motivo: `DELETE` retornava `204` e o teste aceitava apenas `200`.
- Correção 3 aplicada em `test/e2e-generator/e2e.js`
  - CRUD passou a aceitar `DELETE` com `200` ou `204`.
- Reteste final: **passou**
  - `make e2e addresses` concluído com código `0`.
  - Cobertura CRUD passou em MySQL, PostgreSQL e SQL Server; SQLite permaneceu no fluxo de aferição sem subida de API (comportamento esperado do teste atual).

## Arquivos alterados no ciclo
- `CHANGELOG/20260301040748-e2e-addresses-makefile-plan.md`
- `CHANGELOG/20260301040748-e2e-addresses-makefile-audit.md`
- `test/e2e-generator/e2e.js`

## Planos pendentes referenciados
- `CHANGELOG/20260217233500-plan-cli-test-execution-run.md`
- `CHANGELOG/20260217234500-plan-mock-project-codegen.md`
- `CHANGELOG/20260218000000-plan-test-project-generator-vs-mock.md`
- `CHANGELOG/20260227120000-api-generator-scope-plan.md`
- `CHANGELOG/20260227200000-api-nestjs-structure-plan.md`
- `CHANGELOG/plan-mfes.md`

## Definição de pronto
- [x] Plano registrado em `CHANGELOG/`
- [x] Auditoria irmã criada com mesmo timestamp
- [x] E2E `addresses` executado com Makefile
- [x] Falhas corrigidas
- [x] E2E reexecutado com sucesso
