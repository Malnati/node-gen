<!-- CHANGELOG/20260305031427-demo-sspa-acesso-remoto-fix.md -->
# 2026-03-05 03:14:27 UTC - Correção de acesso remoto ao demo SSPA

## Arquivos modificados
- `.docker/Dockerfile.demo`
- `.docker/sspa/demo-dynamic.conf`
- `demo/service-discovery/src/main.ts`
- `demo/sspa/index.html`
- `demo/sspa/src/dashboard.tsx`
- `demo/sspa/src/root-config.ts`

## Requisitos e regras atendidos
- Corrigido consumo de discovery no SSPA para não depender de `localhost` no navegador cliente.
- Adicionado proxy interno no nginx do SSPA para `/api/discovery/*` com fallback SPA (`try_files ... /index.html`).
- Mantida a publicação dinâmica dos 3 MFEs, com reescrita de `importUrl` no `service-discovery` para host/protocolo do cliente quando URL de origem for local (`host.docker.internal`, `localhost`, `127.0.0.1`).
- Escopo restrito a correção funcional solicitada, sem refactor amplo.

## Auditoria executada
- `make demo-pg-up DEMO_PROJECTS="addresses contacts orders"`
- `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9000/`
- `curl -sS http://localhost:9000/api/discovery/applications`
- `curl -sS http://localhost:9000/api/discovery/import-map`
- `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9000/addresses`

## Pendências
- Validar em navegador externo com o IP público do host para confirmar carregamento completo dos MFEs com CORS/rede do ambiente final.

## Atualização do ciclo (segundo ajuste no mesmo escopo)
- Causa confirmada após nova evidência de browser: bundle ainda compilado com `http://localhost:3015` por valor injetado em build (`VITE_DISCOVERY_BASE_URL`), apesar do fallback anterior.
- Correção aplicada no frontend do demo para consumo direto por path relativo (`/api/discovery/applications`) sem depender de variável injetada em build.
- Rebuild executado mantendo o `DISCOVERY_APPS_JSON` dinâmico já publicado:
  - `DISCOVERY_APPS_JSON="$(cat /tmp/nodegen-demo-discovery-apps.json)" make demo-up`
- Evidência após rebuild:
  - `http://157.173.125.230:9000/` retorna bundle `index-CTUPE6Yn.js`.
  - Bundle não contém `localhost:3015`.
  - Endpoints por IP público:
    - `/api/discovery/applications` -> `200`
    - `/api/discovery/import-map` -> `200`
    - `/addresses` -> `200`
