<!-- CHANGELOG/20260301035158-projects-postgres-compose-apis.md -->
# 2026-03-01 03:51:58 UTC - Postgres projects compose com APIs embarcadas

## Arquivos modificados
- .docker/Dockerfile.projects.postgres
- .docker/docker-compose.projects.postgres.yml
- CHANGELOG/20260301035158-projects-postgres-compose-apis.md

## Regras e requisitos atendidos
- Implementacao restrita ao escopo aprovado para arquivos `.docker/*.postgres.*` e registro de rastreabilidade em `CHANGELOG/`.
- `apis` no compose passou a expor faixa dedicada de portas para APIs distintas: `3001-3099:3001-3099`.
- Bind mount de `/output` foi removido do compose para evitar mascaramento do conteudo embarcado na imagem.
- APIs geradas foram incorporadas na imagem via `COPY root/w/node-gen/output /output` em `.docker/Dockerfile.projects.postgres`.
- Referencia cruzada ao plano: `CHANGELOG/20260227201838-projects-postgres-compose-plan.md`.

## Pendencias relevantes
- Nenhuma pendencia funcional identificada no escopo desta entrega.

## Validacoes executadas
- `docker compose -f .docker/docker-compose.projects.postgres.yml config`
