<!-- CHANGELOG/20260217234500-plan-mock-project-codegen.md -->

# 2026-02-17 23:45:00 UTC — Plano: projeto mock para testes de geração de código-fonte

## Arquivos modificados
- `docs/issues/plan-mock-project-codegen.md` — criado (plano completo).
- `CHANGELOG/20260217234500-plan-mock-project-codegen.md` — este arquivo.

## Regras e requisitos atendidos
- Elaboração de plano conforme solicitação do usuário: projeto mock para testar o aplicativo em todas as possibilidades de geração.
- Rastreabilidade: plano referenciado em CHANGELOG; referências cruzadas com plan-cli-test-execution e template-review-plan.

## Conteúdo do plano
- Objetivo: projeto mock que cubra a matriz mínima de cenários (tabela simples; relações e chaves compostas; nullable/enum/decimal/datas/UUID; nomes limítrofes) e permita testar todos os componentes e tipos de banco (SQLite preferido).
- Escopo: schema mock, meio de obter schema (SQLite em disco), documentação de uso, integração com plan-cli-test-execution; sem alterar geradores.
- Proposta de estrutura: diretório `mock/` na raiz do repositório, com DDL, script de criação do SQLite e README.
- Tarefas técnicas em 5 itens; critérios de sucesso e riscos descritos no plano.

## Resultado resumido
- Plano documentado em docs/issues/plan-mock-project-codegen.md; pronto para aprovação e implementação em ciclo posterior.
