<!-- CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md -->
# 2026-03-04 20:41:11 UTC - Correcao de alvos E2E PG por projeto no Makefile

## Arquivos modificados
- `Makefile`
- `CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md`

## Regras/requisitos atendidos
- Correcao direta da falha de execucao de `e2e-<project>-pg-parcel-paging` sem expandir escopo.
- Alteracao restrita ao arquivo necessario para o comportamento esperado dos alvos dinamicos.
- Registro de evidencias e rastreabilidade em novo arquivo de changelog do ciclo.

## Mudancas aplicadas
- Ajustado `gen-<project>-pg-api` para usar `GEN_PROJECT=projects/<project>`.
- Ajustado `gen-<project>-pg-parcel-paging` para usar `GEN_PROJECT=projects/<project>`.
- Ajustado `e2e-<project>-pg-api` para executar `gen-<project>-pg-api` antes do fluxo E2E.
- Ajustado `e2e-<project>-pg-parcel-paging` para executar `projects-down` antes do `playwright-test`, reduzindo risco de conflito com containers residuais.

## Comandos executados
1. `git status --short`
2. `rg -n "PENDENTE|pendente|pendência|pendencias|pendências" CHANGELOG --glob "*.md"`
3. `sed -n '1,220p' CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`
4. `sed -n '1,240p' CHANGELOG/20260304122745-makefile-exclusive-execution-policy.md`
5. `rg -n "e2e-<project>|pg-api|pg-parcel-paging|e2e-.*pg" Makefile gen -S`
6. `make e2e-addresses-pg-api`
7. `make e2e-addresses-pg-api` (com permissao escalada para Docker)
8. `make e2e-addresses-pg-parcel-paging`
9. `rg --files | rg "connection\.postgres\.json$"`
10. `sed -n '120,220p' Makefile`
11. `date -u +%Y%m%d%H%M%S`
12. `make e2e-addresses-pg-parcel-paging` (reexecucao apos ajuste)
13. `docker ps --format 'table {{.Names}}\t{{.Ports}}'`
14. `ss -ltnp | rg ':3015|:9000|:3001' -n`
15. `rg -n "service-discovery|3015|apis:|ports:" .docker/docker-compose.projects.postgres.yml -S`

## Resultado resumido
- `make e2e-addresses-pg-api`: **passou** (com Docker).
- `make e2e-addresses-pg-parcel-paging` antes da correcao: **falhou** por caminho invalido de projeto.
- `make e2e-addresses-pg-parcel-paging` apos correcao de caminho: **avancou** ate etapa Playwright.
- `make e2e-addresses-pg-parcel-paging` apos `projects-down` previo: **falhou** por conflito de porta `3015` no compose de projetos (`nodegen-service-discovery` ocupa `3015`, enquanto `nodegen-apis` tenta expor faixa `3001-3099`, incluindo `3015`).

## Pendencias relevantes
- Resolver conflito estrutural de portas na stack `.docker/docker-compose.projects.postgres.yml` para permitir subida conjunta de `service-discovery` e `apis`.
