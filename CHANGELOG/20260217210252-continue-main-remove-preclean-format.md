<!-- CHANGELOG/20260217210252-continue-main-remove-preclean-format.md -->

# 2026-02-17 21:02:52 UTC — Continuidade: remover pré-limpeza e formatação forçadas no main

## Arquivos modificados
- `src/main.ts`
- `CHANGELOG/20260217210252-continue-main-remove-preclean-format.md`

## Regras e requisitos atendidos
- Continuidade solicitada com escopo restrito a ajustes funcionais no fluxo principal.
- Redução de efeitos colaterais no ambiente de saída, removendo operações automáticas de limpeza/formatação.
- Rastreabilidade registrada em novo arquivo `CHANGELOG/` com timestamp único.

## Correção implementada
- Removidas as funções `getAllFiles`, `removeNodeModules` e `formatFiles` de `src/main.ts`.
- Removidas as chamadas iniciais que executavam limpeza de `node_modules` e formatação automática do output.
- Removido import de `prettier`, agora não utilizado.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- O fluxo principal passa a focar apenas em cópia estática, leitura de schema e geração de componentes.
- Menor risco de comportamento destrutivo e de acoplamento ao ambiente local durante a geração.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
