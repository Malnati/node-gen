<!-- CHANGELOG/20260217211547-continue-constructor-signatures-cleanup.md -->

# 2026-02-17 21:15:47 UTC — Continuidade: ajuste de assinaturas de construtor sem schemaPath

## Arquivos modificados
- `src/env-generator.ts`
- `src/package-json-generator.ts`
- `src/main-generator.ts`
- `src/main.ts`
- `CHANGELOG/20260217211547-continue-constructor-signatures-cleanup.md`

## Regras e requisitos atendidos
- Continuidade consecutiva em correções pontuais dos geradores, sem expansão de escopo.
- Remoção de parâmetros redundantes em construtores onde `schemaPath` não era utilizado.
- Atualização dos pontos de chamada no orquestrador para manter consistência de contrato.
- Registro de rastreabilidade em novo arquivo `CHANGELOG/` com timestamp único.

## Correção implementada
- `EnvGenerator`, `PackageJsonGenerator` e `MainFileGenerator` passaram a receber apenas `config` no construtor.
- `src/main.ts` atualizado para instanciar esses geradores sem `schemaPath`.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Contratos dos construtores alinhados ao uso real, removendo argumento redundante.
- Fluxo principal mantido funcionalmente equivalente para geração.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
