<!-- CHANGELOG/20260302174555-sspa-card-by-card-validation-impl.md -->
# Implementação 2026-03-02 17:45:55 UTC - Validação Card-a-Card do SSPA e Correção de Disponibilidade

## Arquivos alterados
- `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/gen/templates/api-main.template.ejs`
- `/root/w/node-gen/gen/templates/api-controller.template.ejs`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-impl.md`

## Mudanças implementadas
- Ciclo de governança criado (plano + auditoria + implementação) para executar validação card-a-card do SSPA com correção de problemas encontrados.
- Correção de indisponibilidade multiporta aplicada:
  - `gen/templates/api-main.template.ejs` atualizado para usar `MICROSERVICE_TCP_PORT` no transporte TCP do Nest, evitando colisão em `:3000`.
  - `.docker/entrypoint.projects.postgres.sh` atualizado para injetar `MICROSERVICE_TCP_PORT` exclusivo por projeto (`13001+`).
- Correção de classificação HTTP para escrita sem payload mínimo:
  - `gen/templates/api-controller.template.ejs` e controladores gerados locais atualizados para mapear duplicidade em `409` e constraints/payload inválido (`23502`, `22P02`, `23514`, `23503`) em `400`, evitando `500` indevido.
- Correção do projeto `reports` (porta `3018`) aplicada:
  - entidades de visão com coluna `id` ajustadas para chave primária, removendo falha `MissingPrimaryColumnError`.
- Validação card-a-card ampliada:
  - `test/sspa.spec.ts` ganhou teste dedicado `validação card-a-card: ui, health e endpoint principal por projeto`.
  - geração de artefato dedicado `playwright-results/card-validation.json`.
- Robustez de orquestração de testes:
  - `Makefile` (`playwright-up`) agora aguarda `/health=200` em todas as APIs `3001-3026` antes de iniciar Playwright.
  - `Makefile` (`playwright-test`) lista explicitamente os novos artefatos.

## Comandos executados
- `date -u +%Y%m%d%H%M%S`
- `sed -n '1,220p' playwright-results/sspa-projects.json`
- `docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'`
- `docker exec nodegen-apis sh -lc "netstat -ltn 2>/dev/null | sed -n '1,200p'"`
- `make playwright-test` (múltiplas execuções de diagnóstico e validação final)
- `npm run build` (batch em `output/*/postgres` e rebuild direcionado em `output/reports/postgres`)
- inspeções com `rg`/`sed`/`tail` em logs de containers e fontes de bootstrap/controllers
- `git status --short`

## Resultado resumido
- Correções aplicadas: **PASSOU**.
- `make playwright-test` final: **PASSOU** (`5 passed`).
- Evidências geradas:
  - `playwright-results/card-validation.json`
  - `playwright-results/http-matrix.json`
  - `playwright-results/http-matrix-anomalies.json`
  - `playwright-results/apis-health.log`
  - `playwright-results/sspa-projects.json`
  - `playwright-results/containers-sspa.log`
  - `playwright-results/containers-apis.log`
  - `playwright-results/containers-postgres.log`
  - `playwright-results/containers-ps.log`

## Definição de pronto (parcial desta etapa)
- [x] Novo plano registrado em disco.
- [x] Nova auditoria registrada em disco.
- [x] Diagnóstico inicial objetivo realizado.
- [x] Correção de indisponibilidade multiporta aplicada.
- [x] Validação card-a-card concluída com evidências finais.

## Referências cruzadas
- Plano: `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302174555-sspa-card-by-card-validation-audit.md`
