<!-- CHANGELOG/20260225120000-e2e-makefile-project-filter.md -->
# 2026-02-25 12:00:00 — Filtro de projetos no `make e2e`

## Arquivos modificados
- `Makefile`
- `.docker/entrypoint.e2e.sh`

## Descrição
Adicionado suporte a filtragem de projetos E2E por argumento posicional no Makefile.
Exemplos: `make e2e accounts`, `make e2e accounts users todo`.
Sem argumentos, todos os projetos continuam sendo executados (comportamento anterior preservado).

## Detalhes técnicos
- `Makefile`: bloco `MAKECMDGOALS` captura nomes de projetos após `e2e` e os propaga via variável de ambiente `E2E_PROJECTS` no `docker compose run`.
- `.docker/entrypoint.e2e.sh`: variável `$E2E_PROJECTS` anexada à chamada de `run.js e2e`, expandindo para vazio quando não definida.

## Regras/requisitos atendidos
- Convenções de Makefile do projeto (reutilização de alvos existentes, sem novo alvo).
- Entrypoint continua como único shell script permitido no fluxo Docker.
- Comportamento retrocompatível (`make e2e` sem argumentos executa todos os projetos).

## Pendências
- Nenhuma.
