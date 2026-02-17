<!-- CHANGELOG/20260217212134-continue-typeorm-service-generator-fixes.md -->

# 2026-02-17 21:21:34 UTC — Continuidade: correções em typeorm-entity e service generators

## Arquivos modificados
- `src/typeorm-entity-generator.ts`
- `src/service-generator.ts`
- `CHANGELOG/20260217212134-continue-typeorm-service-generator-fixes.md`

## Regras e requisitos atendidos
- Continuidade consecutiva de correções nos demais geradores de código.
- Ajuste de inconformidades funcionais na geração de decorators TypeORM/Swagger.
- Remoção de parâmetro não utilizado no service generator.
- Rastreabilidade registrada em novo `CHANGELOG/` com timestamp único.

## Correções implementadas
- `src/typeorm-entity-generator.ts`:
  - geração de `@Column`/`@PrimaryColumn` agora monta opções sem vírgula sobrando quando não há defaults/length.
  - geração de `@ApiProperty` agora monta opções sem vírgula sobrando quando não há `nullable`.
- `src/service-generator.ts`:
  - removido parâmetro não utilizado `entityName` de `generateRelationCheckAndAssignment` e `generateRelationUpdateAndAssignment`.
  - chamadas ajustadas para a nova assinatura.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Redução de risco de saída TypeScript inválida por objeto decorator malformado.
- Redução de código morto no service generator.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
