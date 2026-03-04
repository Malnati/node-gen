<!-- CHANGELOG/20260304162716-politica-correcao-por-escopo-de-teste.md -->
# Implementação 2026-03-04 16:27:16 UTC - regras de escopo de correção por tipo de teste

## Referências cruzadas (planos/políticas consultados)
- `CHANGELOG/20260304161932-addresses-playwright-db-targets.md`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`

## Arquivos alterados
- `AGENTS.md`
- `opencode.json`
- `CHANGELOG/20260304162716-politica-correcao-por-escopo-de-teste.md`

## Regras e requisitos atendidos
- Adicionada regra no `AGENTS.md` para defeitos em testes contra APIs: correção apenas em geração/templates/estáticos de API, sem alteração de banco.
- Adicionada regra no `AGENTS.md` para defeitos em testes contra frontends: correção apenas em geração/templates/estáticos do frontend afetado, sem alteração de banco e API.
- Adicionada regra no `AGENTS.md` para defeitos em testes E2E/UI relacionados ao consumo das APIs: correção apenas em geração/templates/estáticos de frontend, sem alteração de API e banco.
- Espelhadas as mesmas três regras no prompt do agente `governance` em `opencode.json` (itens 13, 14 e 15).

## Comandos executados
- `rg -n "defeito|defeitos|teste|front|api|banco|e2e|ui|AGENTS" AGENTS.md opencode.json`
- `sed -n '1,320p' AGENTS.md`
- `sed -n '1,260p' opencode.json`
- `sed -n '15p' opencode.json`
- `date -u +%Y%m%d%H%M%S`

## Resultado resumido
- Atualização de política em `AGENTS.md`: **PASSOU**.
- Atualização de política em `opencode.json`: **PASSOU**.

## Definição de pronto
- [x] Regras novas adicionadas ao `AGENTS.md`.
- [x] Regras novas adicionadas ao `opencode.json`.
- [x] Changelog do ciclo criado com rastreabilidade.
