---
name: Issues a partir de plano
about: Geração de issues a partir de plano de revisão
title: Geração de issues a partir de plano de revisão
labels: copilot
assignees: ''

---

Você é um analista técnico responsável por transformar um plano de revisão em issues executáveis no GitHub.

## Contexto
- PLAN_REPORT_PATH: XXXXXXXXXX
- O plano de referência está em: `{{PLAN_REPORT_PATH}}`.
- Objetivo: analisar o plano, extrair frentes de execução e produzir um pacote de issues organizado em um EPIC e subtarefas sequenciais.

## Tarefas obrigatórias
1. Ler integralmente `{{PLAN_REPORT_PATH}}`.
2. Identificar escopo, critérios de pronto, auditorias e sequência de execução descritos no plano.
3. Agrupar o trabalho em trilhas coerentes e dependentes, mantendo rastreabilidade com o plano.
4. Gerar os documentos de issues em `docs/issues/` com os prefixos obrigatórios no título:
   - `[EPIC]` para issue-mãe
   - `[SUB] 1`, `[SUB] 2`, `[SUB] 3`, ... para subtarefas
5. Gerar guia de criação das issues e changelog da entrega.

## Arquivos de saída obrigatórios
- `docs/issues/plan-issues-epic.md`
- `docs/issues/plan-issues-sub-1.md`
- `docs/issues/plan-issues-sub-2.md`
- `docs/issues/plan-issues-sub-3.md`
- `docs/issues/plan-issues-guide.md`
- `CHANGELOG/<timestamp>-plan-issues.md`

> Se o plano exigir mais de três subtarefas, continue a numeração (`plan-issues-sub-4.md`, `plan-issues-sub-5.md`, etc.) sem pular índices.

## Estrutura obrigatória de cada documento de issue
Use como referência de estilo os templates existentes em `.github/ISSUE_TEMPLATE/analise-hardcode.md` e `.github/ISSUE_TEMPLATE/analise-sonarq.md`.

Cada issue deve conter, no mínimo:
1. **Título** com prefixo obrigatório (`[EPIC]` ou `[SUB] N`).
2. **Contexto** (origem no plano e motivação).
3. **Objetivo** (resultado verificável).
4. **Escopo** (o que entra / o que não entra).
5. **Tarefas técnicas** (checklist acionável).
6. **Critérios de aceite** (mensuráveis).
7. **Riscos e dependências**.
8. **Evidências esperadas** (arquivos, comandos e validações).
9. **Definição de pronto** com checklist final.

## Regras de decomposição EPIC/SUB
- A issue `[EPIC]` deve consolidar visão macro, ordem de execução e vínculo com todas as `[SUB]`.
- Cada `[SUB] N` deve ter escopo exclusivo, sem duplicidade de tarefas.
- `[SUB]` devem seguir ordem de dependência técnica (da base para integração final).
- Cada `[SUB]` deve referenciar explicitamente os itens do plano de origem que está cobrindo.
- O conjunto `[SUB]` precisa cobrir 100% dos requisitos acionáveis do plano, sem expandir escopo.

## Requisitos de conteúdo para `docs/issues/plan-issues-guide.md`
- Estratégia recomendada de abertura (primeiro EPIC, depois SUBs na ordem).
- Labels sugeridas por tipo/prioridade.
- Comandos `gh issue create` prontos para cada arquivo gerado.
- Mapeamento de dependências entre as SUBs.
- Checklist final de publicação e rastreabilidade.

## Requisitos de conteúdo para `CHANGELOG/<timestamp>-plan-issues.md`
- Caminho do plano analisado (`{{PLAN_REPORT_PATH}}`).
- Lista dos arquivos de issues gerados.
- Metodologia de decomposição EPIC/SUB.
- Evidências objetivas de aderência ao plano (sem invenção de dados).
- Referências cruzadas entre EPIC e SUBs.

## Regras de execução
- Não inventar informações fora de `{{PLAN_REPORT_PATH}}`.
- Não propor soluções alternativas; entregar decomposição direta e executável.
- Manter linguagem objetiva, auditável e orientada à execução.
- Não expandir escopo além do que está definido no plano.
- Preservar consistência entre EPIC, SUBs, guia e changelog.

## Formato de resposta esperado
- Listar arquivos criados/atualizados.
- Listar comandos executados.
- Informar resumo de validação (passou/falhou) com motivo objetivo.
- Confirmar definição de pronto:
  - [ ] plano analisado integralmente
  - [ ] EPIC gerada
  - [ ] SUBs geradas e numeradas
  - [ ] guia de criação de issues gerado
  - [ ] changelog criado
