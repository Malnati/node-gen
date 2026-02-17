<!-- CHANGELOG/20260217191718-continue-package-json-script-safety.md -->

# 2026-02-17 19:17:18 UTC — Continuidade: ajuste de scripts gerados no package.json

## Arquivos modificados
- `src/package-json-generator.ts`
- `CHANGELOG/20260217191718-continue-package-json-script-safety.md`

## Regras e requisitos atendidos
- Continuidade solicitada com correção direta em código-fonte, sem expansão para refatoração ampla.
- Endereçamento de inconformidade já registrada (scripts destrutivos no `package.json` gerado).
- Registro de rastreabilidade em novo arquivo `CHANGELOG/` com timestamp único.

## Correção implementada
- `start:dev`: removida reinstalação forçada de dependências e remoção de `node_modules`; comando agora limpa apenas `dist` via `rimraf` e inicia watch.
- `test`: removida remoção de `node_modules` e `npm install` do fluxo de teste; comando agora limpa apenas `dist`, limpa cache do jest e executa testes.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Scripts gerados ficam menos destrutivos e mais previsíveis para desenvolvimento/CI.
- Validação automática total permanece bloqueada por dependências do ambiente.

## Pendências
- Reexecutar build em ambiente com tipagens Node disponíveis para confirmar validação completa.
