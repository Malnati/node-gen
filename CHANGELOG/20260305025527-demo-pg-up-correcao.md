<!-- CHANGELOG/20260305025527-demo-pg-up-correcao.md -->
# 2026-03-05 02:55:27 UTC - Correcoes no fluxo demo-pg-up

## Arquivos modificados
- Makefile
- gen/templates/mfe-details-page.ejs
- gen/templates/mfe-list-page.ejs
- gen/templates/mfe-api-client.ejs
- gen/static-mfe/src/Bootstrap.tsx
- gen/static-mfe/src/components/ErrorBoundary.tsx
- gen/static-mfe/src/single-spa.ts
- gen/static-mfe/src/spa.ts
- gen/static-mfe/src/types/single-spa-react.d.ts
- gen/static-mfe/src/vite-env.d.ts
- demo/service-discovery/src/main.ts

## Requisitos e regras atendidos
- Execucao do fluxo solicitado via Makefile (`make demo-pg-up`) para 3 projetos Postgres (addresses, contacts, orders).
- Correcao de falhas encontradas durante execucao, sem expandir escopo.
- Publicacao dinamica no demo (`sspa` + `service-discovery`) mantida no alvo existente.
- Registro de rastreabilidade em CHANGELOG para o ciclo atual.

## Evidencias objetivas do ciclo
- Falha detectada: build TypeScript dos MFEs quebrava por escape HTML (`&#39;`) no template de detalhes.
- Falha detectada: `single-spa.ts` continha JSX em arquivo `.ts`.
- Falha detectada: alvo `demo-mfe-up` nao propagava erro de build (nao fail-fast).
- Falha detectada: `vite-plugin-single-spa` procurava `src/spa.ts` e o estatico nao fornecia esse entrypoint.
- Falha detectada: `service-discovery` retornava lista vazia por filtrar todos os apps como indisponiveis no ambiente de container.
- Correcao aplicada em templates/estaticos MFE, alvo `demo-mfe-up` (fail-fast), URL dinamica `spa.js` e fallback do `service-discovery`.

## Comandos executados
- `make demo-pg-up` (multiplas execucoes durante diagnostico e validacao)
- `make demo-mfe-up`
- `DISCOVERY_APPS_JSON=\"$(cat /tmp/nodegen-demo-discovery-apps.json)\" make demo-up`
- `curl -sS http://localhost:9000`
- `curl -sS http://localhost:3015/health`
- `curl -sS http://localhost:3015/api/discovery/applications`
- `curl -sS http://localhost:3015/api/discovery/import-map`

## Resultado resumido
- `make demo-pg-up`: passou na execucao final de geracao/publicacao (com geracao de APIs/MFEs e subida de `sspa` + `service-discovery`).
- `service-discovery`:
  status final `passou` com `200` em `/api/discovery/applications` contendo `@mfe/addresses`, `@mfe/contacts` e `@mfe/orders`.
- `sspa`: status final `passou` com `200` em `http://localhost:9000`.

## Pendencias relevantes
- Existem alteracoes preexistentes no workspace nao relacionadas a este ciclo (mantidas sem reversao).
- Referencia cruzada de contexto anterior: `CHANGELOG/20260305023758-demo-pg-up-dinamico.md`.
