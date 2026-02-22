<!-- CHANGELOG/20260218000000-plan-test-project-generator-vs-mock.md -->

# 2026-02-18 00:00:00 UTC — Plano: projeto de testes do gerador contra o mock

## Arquivos modificados
- `docs/issues/plan-test-project-generator-vs-mock.md` — criado (plano completo).
- `CHANGELOG/20260218000000-plan-test-project-generator-vs-mock.md` — este arquivo.

## Regras e requisitos atendidos
- Elaboração de plano conforme solicitação: novo projeto na raiz para testar o aplicativo gerador de código-fonte contra o aplicativo mock.
- Rastreabilidade: plano referenciado em CHANGELOG; referências cruzadas com plan-cli-test-execution e plan-mock-project-codegen.

## Conteúdo do plano
- Objetivo: projeto na raiz (ex.: `e2e-generator/` ou `test-generator-mock/`) que orquestre: garantir mock → executar node-gen com mock como entrada → validar artefatos (e opcionalmente build do output).
- Escopo: não alterar node-gen nem mock; apenas invocar e validar; fluxo reproduzível via scripts/comandos documentados.
- Estrutura proposta: package.json, scripts de teste (Node ou comandos), diretório de output dedicado, README com pré-requisitos e referências.
- Tarefas técnicas em 6 itens; critérios de sucesso, riscos e rastreabilidade descritos no plano.

## Resultado resumido
- Plano documentado em docs/issues/plan-test-project-generator-vs-mock.md; pronto para aprovação e implementação em ciclo posterior.
