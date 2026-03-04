<!-- CHANGELOG/20260302193539-sspa-all-cards-functional-audit.md -->
# 2026-03-02 19:35:39 UTC - Auditoria SSPA all cards functional

## Referências cruzadas
- Plano: `CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md`
- Implementação: `CHANGELOG/20260302193539-sspa-all-cards-functional-impl.md`

## Escopo auditado
- Compatibilidade entre endpoint listado em `projects.json` e rota real gerada pelas APIs.
- Cobertura de testes Playwright para todos os cards e todas as funcionalidades.
- Rastreabilidade de execução obrigatória via `Makefile`.

## Evidências objetivas
- Baseline mostrou `404` em funcionalidades com `_` no nome da entidade (ex.: `auth_session`, `gmail_message_template`, `notification_template`).
- `card-validation.json` pré-correção continha múltiplos `sample_entity_status: 404`.
- `http-matrix.json` pré-correção continha múltiplos `get_*: 404` e `post_*: 404` para entidades com `_`.
- Pós-correção:
  - `playwright-results/sspa-projects.json` passou a registrar `endpoints.list` em `kebab-case`.
  - `playwright-results/card-validation.json`: contagem de `entity_status==404` igual a `0`.
  - `playwright-results/http-matrix.json`: contagem de `GET` com `404` igual a `0`.
  - `make playwright-test` final: `5 passed`.

## Causa raiz e validação da correção
- Causa raiz primária: o SSPA gerava endpoints a partir de `entityKey` em `snake_case`, enquanto controladores das APIs expõem rotas em `kebab-case`.
- Causa raiz secundária: suíte de testes aceitava `404` como status válido para operações principais de leitura/listagem.
- Validação: correção aplicada no gerador de `projects.json` e endurecimento/expansão da suíte Playwright confirmados por execução completa via `make playwright-test`.

## Pendências e riscos residuais
- Não há pendência bloqueante para o objetivo desta entrega.
- Risco residual conhecido: algumas entidades sem `external_id` não possuem semântica de mutação por recurso UUID; a matriz agora diferencia esse caso para evitar falso positivo estrutural.

## Conclusão da auditoria
- Ciclo concluído com rastreabilidade completa.
- Objetivo principal atendido: cards e funcionalidades do dashboard estão acessíveis funcionalmente, com validação automatizada reprodutível via `Makefile`.
