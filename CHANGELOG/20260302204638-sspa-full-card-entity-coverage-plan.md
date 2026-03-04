<!-- CHANGELOG/20260302204638-sspa-full-card-entity-coverage-plan.md -->
# 2026-03-02 20:46:38 UTC - Plano de cobertura total SSPA (cards e entidades)

## 1. Arquivos existentes relevantes para o escopo
- `test/sspa.spec.ts`
- `Makefile`
- `playwright.config.ts`
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md`

## 2. Arquivos que serão alterados
- `test/sspa.spec.ts`
- `CHANGELOG/20260302204638-sspa-full-card-entity-coverage-plan.md`
- `CHANGELOG/20260302204638-sspa-full-card-entity-coverage-impl.md`
- `CHANGELOG/20260302204638-sspa-full-card-entity-coverage-audit.md`

## 3. Requisitos da mudança + requisitos globais do projeto
- Cobrir testes de todos os cards e funcionalidades (entidades) do SSPA.
- Executar validação somente via `Makefile`, de forma reprodutível.
- Identificar falhas por evidências objetivas (status HTTP, logs e artefatos Playwright).
- Registrar governança e rastreabilidade em `CHANGELOG/`.

## 4. Requisitos atualmente não atendidos
- Cobertura de UI não validava explicitamente clique e carregamento visual de cada entidade em cada card.

## 5. Regras da mudança + regras globais do projeto
- Não criar novos arquivos fora de `CHANGELOG/`.
- Não remover arquivos existentes.
- Não expandir escopo além de cobertura e validação funcional dos cards/entidades.
- Executar testes via `make playwright-test`.

## 6. Regras atualmente não atendidas que motivam ajustes
- Ausência de verificação UI explícita card-a-card/entidade-a-entidade com assert de erro visual.

## 7. Plano de auditoria (manual e automático)
- Rodar `make playwright-test` e validar:
  - `playwright-results/card-validation.json`
  - `playwright-results/http-matrix.json`
  - `playwright-results/http-matrix-anomalies.json`
  - `playwright-results/ui-entity-navigation.json`
- Confirmar ausência de respostas 5xx e de mensagens de erro visual por entidade.

## 8. Checklists aplicáveis
- Obrigatório: checklist de rastreabilidade por changelog do ciclo (plan/impl/audit).
- Obrigatório: checklist de execução reprodutível via `Makefile`.
- Aplicável: checklist de validação funcional ponta-a-ponta do SSPA com artefatos Playwright.

## Referências cruzadas
- Baseado em: `CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- Complementa: `CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md`
- Auditoria irmã: `CHANGELOG/20260302204638-sspa-full-card-entity-coverage-audit.md`
