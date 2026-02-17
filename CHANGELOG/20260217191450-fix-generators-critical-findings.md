<!-- CHANGELOG/20260217191450-fix-generators-critical-findings.md -->

# 2026-02-17 19:14:50 UTC — Correções de código-fonte após aprovação para continuidade

## Arquivos modificados
- `src/dto-generator.ts`
- `src/typeorm-entity-generator.ts`
- `src/controller-generator.ts`
- `CHANGELOG/20260217191450-fix-generators-critical-findings.md`

## Regras e requisitos atendidos
- Continuidade solicitada pelo aprovador para avançar além da documentação e aplicar correções pontuais no código-fonte.
- Correção direta de inconformidades já identificadas no ciclo EPIC/SUB, sem refatorações abrangentes nem expansão de escopo.
- Rastreabilidade registrada em `CHANGELOG/` com timestamp único.

## Correções implementadas
- `src/typeorm-entity-generator.ts`: detecção de chave primária alterada para `col.isPrimaryKey` (removida heurística por substring `id`).
- `src/dto-generator.ts`: validação UUID baseada em `column.dataType === 'uuid'`, garantindo emissão de `@IsUUID()`.
- `src/controller-generator.ts`: normalização de `toCamelCase` para inicial minúscula em nomes derivados de PascalCase.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Correções críticas aplicadas nos geradores identificados como fonte de risco funcional.
- Validação automática completa permanece bloqueada por dependências/tipos do ambiente atual.

## Pendências
- Reexecutar build e cenário fim a fim em ambiente com dependências instaláveis para confirmar fechamento operacional.
