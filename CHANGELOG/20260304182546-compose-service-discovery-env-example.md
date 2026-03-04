<!-- CHANGELOG/20260304182546-compose-service-discovery-env-example.md -->
# 2026-03-04 18:25:46 UTC - Exemplo de DISCOVERY_APPS_JSON no compose de projetos

## Arquivos modificados
- `.docker/docker-compose.projects.postgres.yml`
- `CHANGELOG/20260304182546-compose-service-discovery-env-example.md`

## Requisitos e regras atendidos
- Adicionado exemplo funcional de `DISCOVERY_APPS_JSON` no compose para subir `demo/service-discovery` pronto.
- Variaveis novas no compose seguem formato `${VAR:-default}`.
- Escopo mantido cirurgico, sem alteracoes de arquitetura/pipeline.
- Rastreabilidade registrada em `CHANGELOG/` com timestamp unico.

## Comandos executados
- `rg -n "service-discovery|DISCOVERY_APPS_JSON|VITE_DISCOVERY_BASE_URL|sspa" .docker demo -g "*.yml" -g "*.yaml" -g "*.env"`
- `sed -n '1,260p' .docker/docker-compose.projects.postgres.yml`
- `date -u +%Y%m%d%H%M%S`

## Resultado resumido
- Implementacao: PASSOU.
- Validacao de execucao do compose: NAO EXECUTADA neste ciclo.

## Referencias cruzadas
- `CHANGELOG/20260304182202-service-discovery-runtime-discovery-404.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
