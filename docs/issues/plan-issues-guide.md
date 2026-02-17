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
