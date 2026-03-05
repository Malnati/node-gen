<!-- CHANGELOG/20260304212231-e2e-pg-parcel-paging-fixes.md -->
# 2026-03-04 21:22:31 UTC — Correções do fluxo E2E PG Parcel Paging

## Arquivos modificados
- .docker/docker-compose.projects.postgres.yml
- Makefile
- gen/templates/api-controller.template.ejs

## Regras e requisitos atendidos
- Correção direta do conflito estrutural de porta entre `apis` e `service-discovery` na stack de projetos.
- Ajuste dos alvos dinâmicos E2E para gerar API PostgreSQL no diretório consumido pela stack (`output/<projeto>/postgres`).
- Preservação da geração de parcel paging em diretório separado para evitar sobrescrita de artefatos da API usados no runtime.
- Correção de resposta da API gerada para payload vazio/relacionamento inválido em `POST`, evitando `500` e retornando erro controlado.
- Referência cruzada com ciclo anterior: `CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md`.

## Comandos executados
- `git status --short`
- `rg -n "3015|service-discovery|e2e-.*parcel-paging|e2e-.*pg-api|projects/" Makefile .docker -S`
- `make projects-up`
- `make e2e-addresses-pg-parcel-paging`
- `make gen-addresses-pg-api`
- `PLAYWRIGHT_PROJECT=addresses make playwright-test`

## Resultado resumido
- `make projects-up`: passou
- `PLAYWRIGHT_PROJECT=addresses make playwright-test`: passou (6/6)
- `make e2e-addresses-pg-parcel-paging`: passou ao final (inclui Playwright 6/6)

## Pendências
- Nenhuma pendência funcional remanescente identificada neste ciclo.
