<!-- CHANGELOG/20260305123000-service-discovery-mfe-dir-impl.md -->
# 2026-03-05 12:30:00 UTC - Implementacao do plano service-discovery por diretorio de manifestos

## Plano e auditoria relacionados
- `CHANGELOG/20260305105059-service-discovery-mfe-dir-plan.md`
- `CHANGELOG/20260305105059-service-discovery-mfe-dir-audit.md`

## Arquivos alterados
- `demo/service-discovery/src/main.ts`
- `gen/src/microfrontend-generator.ts`
- `gen/templates/mfe-vite-config.ejs`
- `gen/templates/app-shell-import-map.ejs`
- `gen/templates/app-shell-index-html-dynamic.ejs`
- `gen/templates/app-shell-vite-config.ejs`
- `gen/templates/app-shell-root-config-dynamic.ejs`
- `gen/templates/app-shell-app-dynamic.ejs`
- `.docker/docker-compose.projects.postgres.yml`
- `.docker/docker-compose.demo.yml`
- `Makefile`
- `CHANGELOG/20260305123000-service-discovery-mfe-dir-impl.md`

## Requisitos e regras atendidos
- `REQ-SD-001`: service-discovery agora prioriza `DISCOVERY_APPS_DIR` e faz parse de `*.json` do diretorio.
- `REQ-SD-002`: gerador de MFEs agora cria `manifest.json` por app com `name`, `module`, `route`, `title`, `description`, `importUrl`.
- `REQ-SD-003`: templates passaram a consumir `VITE_PUBLIC_URL`, `VITE_SERVICE_DISCOVERY_URL`, `VITE_MFE_BASE_URL` em vez de URLs fixas.
- `REQ-SD-004`: fallback para `VITE_PUBLIC_URL` no app-shell via deteccao por `ipify` em tempo de build.
- `REQ-SD-005`: `demo-pg-up` calcula URLs dinamicas e propaga sem exigir recompilacao manual dos artefatos.
- `REG-SD-001`: `DISCOVERY_APPS_DIR` prevalece sobre `DISCOVERY_APPS_JSON` no discovery.
- `REG-SD-002`: cada arquivo JSON valido do diretorio e agregado no contrato `DiscoveryApplication`.
- `REG-SD-005`: `importUrl` de manifesto do gerador usa placeholder `${VITE_MFE_BASE_URL:-http://localhost:9000}`.

## Comandos executados
1. `ls -la`
2. `sed -n '1,220p' CHANGELOG/20260305105059-service-discovery-mfe-dir-plan.md`
3. `sed -n '1,320p' gen/src/microfrontend-generator.ts`
4. `sed -n '1,260p' demo/service-discovery/src/main.ts`
5. `sed -n '320,500p' Makefile`
6. `npm run build`
7. `make gen-mfe GEN_PROJECT=projects/addresses GEN_OUTPUT=output/addresses/postgres`
8. `npm --prefix demo/service-discovery run build`
9. `make -n demo-pg-up DEMO_PROJECTS=addresses`
10. `make demo-mfe-up DEMO_PROJECTS=addresses`
11. `PORT=3915 DISCOVERY_APPS_DIR=/root/w/node-gen/output/addresses/postgres/frontend/address-mfe node demo/service-discovery/dist/main.js ...`
12. `PORT=3916 DISCOVERY_APPS_DIR=/tmp/nodegen-empty-discovery-dir DISCOVERY_APPS_JSON='[...]' node demo/service-discovery/dist/main.js ...`
13. `git status --short`

## Resultado resumido
- `npm run build`: **PASSOU**.
- `make gen-mfe ...`: **PASSOU** (geracao concluida; conexao local em `5432` recusada, mas fluxo de geracao `mfes` foi concluido).
- `npm --prefix demo/service-discovery run build`: **PASSOU**.
- `make -n demo-pg-up ...`: **PASSOU** (alvo renderizado sem erro de sintaxe).
- `make demo-mfe-up ...`: **FALHOU** por erro de TypeScript preexistente nos MFEs gerados (`TS6133` em `Bootstrap.tsx` e `ErrorBoundary.tsx`), fora do escopo direto deste plano.
- teste runtime de discovery com `DISCOVERY_APPS_DIR`: **PASSOU** (retornou array com app do manifesto).
- teste de prioridade (`DISCOVERY_APPS_DIR` + `DISCOVERY_APPS_JSON`): **PASSOU** (retornou `[]` com diretorio vazio, sem fallback para JSON).

## Definicao de pronto (item a item)
- [x] Demo e E2E: alvo `demo-pg-up` revisado para discovery por diretorio e variaveis dinamicas.
- [x] Geracao: `make gen-mfe` executado e `manifest.json` presente em `output/addresses/postgres/frontend/*-mfe/manifest.json`.
- [x] URL dinamica: templates e compose atualizados para `VITE_PUBLIC_URL`, `VITE_SERVICE_DISCOVERY_URL`, `VITE_MFE_BASE_URL`.
- [x] Service discovery: discovery por diretorio implementado e validado com execucao real do servico.

## Pendencias objetivas
- Corrigir erros TS6133 nos arquivos estaticos de MFE (`Bootstrap.tsx`, `ErrorBoundary.tsx`) para permitir `make demo-mfe-up` concluir com build de imagem, em ciclo dedicado.

