<!-- docs/issues/plan-issues-guide.md -->

# Guia de execução do plano de revisão com agentes CLI (multi-LLM)

## Estratégia recomendada de execução
1. Executar primeiro o EPIC (`docs/issues/plan-issues-epic.md`).
2. Executar as SUBs na ordem de dependência técnica:
   1. `[SUB] 1` base
   2. `[SUB] 2` intermediários
   3. `[SUB] 3` domínio/persistência
   4. `[SUB] 4` transversal e fechamento
3. Manter vínculo explícito EPIC ↔ SUBs nos registros de execução (`CHANGELOG/*.md` e/ou `docs/issues/plan-issues-execution.md`).

## Labels sugeridas (quando houver tracker externo)
- EPIC:
  - `type:epic`
  - `area:codegen`
  - `priority:high`
  - `status:ready`
- SUBs:
  - `[SUB] 1`: `type:task`, `track:base`, `priority:high`
  - `[SUB] 2`: `type:task`, `track:api`, `priority:high`
  - `[SUB] 3`: `type:task`, `track:persistence`, `priority:high`
  - `[SUB] 4`: `type:task`, `track:integration`, `priority:high`

## Comandos prontos para agentes CLI (sem `gh`)
```bash
sed -n '1,220p' docs/issues/plan-issues-epic.md
sed -n '1,220p' docs/issues/plan-issues-sub-1.md
sed -n '1,220p' docs/issues/plan-issues-sub-2.md
sed -n '1,220p' docs/issues/plan-issues-sub-3.md
sed -n '1,220p' docs/issues/plan-issues-sub-4.md
```

```bash
cat docs/issues/plan-issues-epic.md docs/issues/plan-issues-sub-1.md docs/issues/plan-issues-sub-2.md docs/issues/plan-issues-sub-3.md docs/issues/plan-issues-sub-4.md > /tmp/plan-issues-bundle.md
```

```bash
# Registrar execução local no repositório
sed -n '1,220p' docs/issues/plan-issues-execution.md
```

## Mapeamento de dependências entre SUBs
- `[SUB] 1` → base para `[SUB] 2`.
- `[SUB] 2` → base para `[SUB] 3`.
- `[SUB] 3` → base para `[SUB] 4`.
- `[SUB] 4` consolida resultado do EPIC.

## Checklist final de execução e rastreabilidade
- [ ] EPIC executado antes das SUBs.
- [ ] SUBs executadas sem pular numeração.
- [ ] Dependências registradas entre EPIC e SUBs.
- [ ] Referências cruzadas EPIC ↔ SUBs adicionadas no registro de execução.
- [ ] Escopo aderente ao `docs/template-review-plan.md`.
- [ ] Evidências esperadas preservadas no repositório.

## Prompt recomendado para executar as tarefas do EPIC + SUBs (agentes CLI)
Use o texto abaixo (ajustando apenas o que estiver entre `<...>`):

```text
Implemente o plano definido em `docs/issues/plan-issues-epic.md`, `docs/issues/plan-issues-guide.md`, `docs/issues/plan-issues-sub-1.md`, `docs/issues/plan-issues-sub-2.md`, `docs/issues/plan-issues-sub-3.md` e `docs/issues/plan-issues-sub-4.md`.

Contexto operacional:
- A execução será feita por agente CLI (Codex, Gemini CLI, Cursor CLI ou equivalente).
- Não depender de `gh issue create` nem de integração obrigatória com GitHub.
- Tratar os arquivos `docs/issues/plan-issues-*.md` como fonte de verdade do EPIC e das SUBs.

Regras de execução:
1) Não expandir escopo; executar somente o que está definido nesses arquivos.
2) Respeitar a ordem de dependência técnica: SUB 1 → SUB 2 → SUB 3 → SUB 4.
3) Registrar vínculo EPIC ↔ SUBs e progresso no repositório (ex.: `docs/issues/plan-issues-execution.md` e `CHANGELOG/*.md`).
4) Quando houver tracker externo, aplicar labels sugeridas neste guia.
5) Registrar evidências objetivas de execução e rastreabilidade.

Entregáveis obrigatórios:
- Matriz de dependências confirmando ordem de execução.
- Lista de comandos executados e resultado (passou/falhou, com motivo objetivo em falhas).
- Definição de pronto atendida item a item para EPIC e cada SUB.
- Registro de status consolidado em arquivo Markdown no repositório.

Se houver bloqueio de ambiente, registre explicitamente o bloqueio, o impacto e os próximos passos para conclusão.
```

### Versão curta (para uso rápido)
```text
Execute integralmente o plano em `docs/issues/plan-issues-epic.md` + `docs/issues/plan-issues-sub-1.md` a `sub-4.md`, sem expandir escopo, respeitando a ordem SUB1→SUB2→SUB3→SUB4 e registrando toda a execução em Markdown no repositório (comandos, resultados, evidências e definição de pronto item a item).
```
