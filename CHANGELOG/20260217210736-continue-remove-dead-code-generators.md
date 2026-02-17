<!-- CHANGELOG/20260217210736-continue-remove-dead-code-generators.md -->

# 2026-02-17 21:07:36 UTC — Continuidade: remoção de código morto em geradores

## Arquivos modificados
- `src/module-generator.ts`
- `src/dto-generator.ts`
- `CHANGELOG/20260217210736-continue-remove-dead-code-generators.md`

## Regras e requisitos atendidos
- Continuidade solicitada, mantendo escopo pontual em correções de código.
- Aplicação da regra de remoção de código morto (função e parâmetro não utilizados).
- Rastreabilidade registrada em novo arquivo `CHANGELOG/` com timestamp único.

## Correção implementada
- `src/module-generator.ts`: removida função privada `toCamelCase` não utilizada.
- `src/dto-generator.ts`: removido parâmetro `isQuery` do método `generateProperty` e ajustadas chamadas para evitar parâmetro não utilizado.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Redução de código morto, mantendo o comportamento funcional existente dos geradores.
- Validação automática completa permanece bloqueada por limitação de ambiente.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
