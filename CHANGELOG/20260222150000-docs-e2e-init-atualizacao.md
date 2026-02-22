<!-- CHANGELOG/20260222150000-docs-e2e-init-atualizacao.md -->
# Docs e mensagens do init E2E — atualização e remoção de obsoletos

**Data/Hora UTC:** 2026-02-22.

## Arquivos alterados

- `.docker/entrypoint.e2e.sh` — mensagem de log (linha 17) de "Criando selling e schedule se necessario..." para "Inicializando bancos...".
- `test/e2e-generator/pg-init/README.md` — texto substituído: init feito por init-postgres.js; diretório sem scripts de init.
- `test/README.md` — trecho Via Docker atualizado: Postgres e MySQL inicializados por init-postgres.js e init-mysql.js (descoberta dinâmica); removidas referências a 00-init-extra.sh e init.mysql.sql.

## Arquivos removidos

- `test/e2e-generator/pg-init/scripts/00-init-extra.sh`.
- `test/e2e-generator/pg-init/scripts/` (diretório removido após exclusão do único arquivo).
- `test/e2e-generator/projects/selling/db/init.mysql.sql`.
- `test/e2e-generator/projects/google-calendar/db/init.mysql.sql`.

## Objetivo

Atualizar documentação e mensagens do init E2E para refletir init neutro e descoberta dinâmica; remover scripts obsoletos (sem referência/histórico).

## Referências

- CHANGELOG 20260222130000-e2e-init-todos-os-projetos.md.
- CHANGELOG 20260222140000-compose-e2e-init-neutro-opcao-b.md.
