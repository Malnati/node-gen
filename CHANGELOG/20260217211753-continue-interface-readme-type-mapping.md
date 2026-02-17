<!-- CHANGELOG/20260217211753-continue-interface-readme-type-mapping.md -->

# 2026-02-17 21:17:53 UTC — Continuidade: ampliar mapeamento de tipos em interface/readme generators

## Arquivos modificados
- `src/interface-generator.ts`
- `src/readme-generator.ts`
- `CHANGELOG/20260217211753-continue-interface-readme-type-mapping.md`

## Regras e requisitos atendidos
- Continuidade consecutiva das tarefas nos demais geradores de código.
- Correção de inconformidades de mapeamento para reduzir fallback indevido e documentação inconsistente.
- Registro de rastreabilidade em novo `CHANGELOG/` com timestamp único.

## Correção implementada
- `src/interface-generator.ts`:
  - ampliado `mapType` para cobrir `timestamp with time zone`, `date`, `text`, `boolean`, `numeric`, `decimal`.
- `src/readme-generator.ts`:
  - descrição da tabela passa a substituir todos os `_` (não apenas o primeiro) após remoção de prefixo `tb_`.
  - ampliado `mapType` para `timestamptz`, `date`, `text`, `bool`, `numeric`, `decimal`.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Redução de lacunas de tipo na geração de interfaces e na documentação README gerada.
- Validação automática completa permanece bloqueada por limitação de ambiente.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
