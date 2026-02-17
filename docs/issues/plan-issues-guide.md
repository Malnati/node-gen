<!-- docs/issues/plan-issues-guide.md -->

# Guia de criação das issues do plano de revisão

## Estratégia recomendada de abertura
1. Criar primeiro o EPIC (`docs/issues/plan-issues-epic.md`).
2. Criar as SUBs na ordem de dependência técnica:
   1. `[SUB] 1` base
   2. `[SUB] 2` intermediários
   3. `[SUB] 3` domínio/persistência
   4. `[SUB] 4` transversal e fechamento
3. Vincular todas as SUBs ao EPIC no corpo da issue e nos comentários iniciais.

## Labels sugeridas
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

## Comandos prontos (`gh issue create`)
> Ajuste `<repo>` apenas se estiver executando fora do repositório corrente.

```bash
gh issue create --repo <repo> --title "$(sed -n '3p' docs/issues/plan-issues-epic.md | sed 's/^# //')" --body-file docs/issues/plan-issues-epic.md --label "type:epic,area:codegen,priority:high,status:ready"
```

```bash
gh issue create --repo <repo> --title "$(sed -n '3p' docs/issues/plan-issues-sub-1.md | sed 's/^# //')" --body-file docs/issues/plan-issues-sub-1.md --label "type:task,track:base,priority:high"
```

```bash
gh issue create --repo <repo> --title "$(sed -n '3p' docs/issues/plan-issues-sub-2.md | sed 's/^# //')" --body-file docs/issues/plan-issues-sub-2.md --label "type:task,track:api,priority:high"
```

```bash
gh issue create --repo <repo> --title "$(sed -n '3p' docs/issues/plan-issues-sub-3.md | sed 's/^# //')" --body-file docs/issues/plan-issues-sub-3.md --label "type:task,track:persistence,priority:high"
```

```bash
gh issue create --repo <repo> --title "$(sed -n '3p' docs/issues/plan-issues-sub-4.md | sed 's/^# //')" --body-file docs/issues/plan-issues-sub-4.md --label "type:task,track:integration,priority:high"
```

## Mapeamento de dependências entre SUBs
- `[SUB] 1` → base para `[SUB] 2`.
- `[SUB] 2` → base para `[SUB] 3`.
- `[SUB] 3` → base para `[SUB] 4`.
- `[SUB] 4` consolida resultado do EPIC.

## Checklist final de publicação e rastreabilidade
- [ ] EPIC criada antes das SUBs.
- [ ] SUBs publicadas sem pular numeração.
- [ ] Dependências registradas entre as issues.
- [ ] Referências cruzadas EPIC ↔ SUBs adicionadas.
- [ ] Escopo das issues aderente ao `docs/template-review-plan.md`.
- [ ] Evidências esperadas preservadas em todas as issues.

## Prompt recomendado para executar as tarefas do EPIC + SUBs
Use o texto abaixo (ajustando apenas o que estiver entre `<...>`):

```text
Implemente o plano definido em `docs/issues/plan-issues-epic.md`, `docs/issues/plan-issues-guide.md`, `docs/issues/plan-issues-sub-1.md`, `docs/issues/plan-issues-sub-2.md`, `docs/issues/plan-issues-sub-3.md` e `docs/issues/plan-issues-sub-4.md`.

Regras de execução:
1) Não expandir escopo; executar somente o que está definido nesses arquivos.
2) Respeitar a ordem de dependência técnica: SUB 1 → SUB 2 → SUB 3 → SUB 4.
3) Publicar EPIC e SUBs com os títulos/corpos exatamente dos arquivos `docs/issues/plan-issues-*.md`.
4) Aplicar labels sugeridas no guia.
5) Vincular todas as SUBs ao EPIC com referências cruzadas.
6) Registrar evidências objetivas de execução e rastreabilidade.

Entregáveis obrigatórios:
- Lista de issues criadas (EPIC + SUBs) com links e IDs.
- Matriz de dependências confirmando ordem de execução.
- Lista de comandos executados e resultado (passou/falhou, com motivo objetivo em falhas).
- Definição de pronto atendida item a item para EPIC e cada SUB.

Se houver bloqueio de ambiente (ex.: ausência de `gh` ou integração GitHub indisponível),
registre explicitamente o bloqueio, o impacto e os próximos passos para conclusão.
```

### Versão curta (para uso rápido)
```text
Execute integralmente o plano em `docs/issues/plan-issues-epic.md` + `docs/issues/plan-issues-sub-1.md` a `sub-4.md`, sem expandir escopo, respeitando a ordem SUB1→SUB2→SUB3→SUB4, criando e vinculando as issues com labels do guia e entregando evidências: links/IDs, comandos, resultados e definição de pronto item a item.
```

