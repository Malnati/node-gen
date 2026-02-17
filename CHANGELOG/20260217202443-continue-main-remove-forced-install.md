<!-- CHANGELOG/20260217202443-continue-main-remove-forced-install.md -->

# 2026-02-17 20:24:43 UTC — Continuidade: remover instalação/prettier forçados do fluxo principal

## Arquivos modificados
- `src/main.ts`
- `CHANGELOG/20260217202443-continue-main-remove-forced-install.md`

## Regras e requisitos atendidos
- Continuidade da correção sem expansão de escopo para novas funcionalidades.
- Remoção de comportamento operacional forçado que causava falhas e efeitos colaterais no ambiente gerado.
- Registro de evidência em arquivo novo de `CHANGELOG/` com timestamp único.

## Correção implementada
- Removidas as funções `runNpmInstall` e `runPrettier` do `src/main.ts`.
- Removida a chamada obrigatória de `npm install` e `npx prettier` ao final da execução do gerador.
- Removido import não utilizado de `child_process` após a eliminação desse fluxo.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- O gerador deixa de impor instalação/formatação automática no projeto de saída.
- Fluxo principal permanece focado na geração de artefatos, com menor acoplamento ao ambiente local.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
