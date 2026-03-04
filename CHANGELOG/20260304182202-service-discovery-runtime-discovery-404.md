<!-- CHANGELOG/20260304182202-service-discovery-runtime-discovery-404.md -->
# 2026-03-04 18:22:02 UTC - Ajuste de descoberta dinamica no demo/service-discovery

## Arquivos modificados
- `demo/service-discovery/src/main.ts`
- `demo/service-discovery/src/contracts.ts`
- `demo/service-discovery/src/mock-data.ts` (removido)
- `CHANGELOG/20260304182202-service-discovery-runtime-discovery-404.md`

## Requisitos e regras atendidos
- Removido uso de dados mock estaticos no `service-discovery`.
- Descoberta passou a ser em tempo de requisicao a partir de `DISCOVERY_APPS_JSON`.
- Apenas apps alcancaveis sao retornadas no discovery (lista pode ser vazia quando nada encontrado).
- Novo endpoint `GET /api/discovery/applications/:name` retorna `404` quando a aplicacao nao existe/nao foi descoberta.
- `GET /api/discovery/import-map` agora usa somente apps efetivamente descobertas.
- Rastreabilidade registrada em `CHANGELOG/` com timestamp unico.

## Comandos executados
- `rg --files demo/service-discovery/src`
- `rg -n "mock-data|contracts|discover|404|service" demo/service-discovery/src`
- `sed -n '1,220p' demo/service-discovery/src/main.ts`
- `sed -n '1,220p' demo/service-discovery/src/contracts.ts`
- `sed -n '1,260p' demo/service-discovery/src/mock-data.ts`
- `rg -n "api/discovery|import-map|applications|service-discovery" demo -g '!**/dist/**'`
- `sed -n '1,220p' demo/sspa/src/root-config.ts`
- `sed -n '1,220p' demo/sspa/src/dashboard.tsx`
- `cat demo/service-discovery/package.json`
- `cat demo/service-discovery/tsconfig.json`
- `rg -n "mock-data|DISCOVERY_APPS_JSON|application_not_found|importUrl" demo/service-discovery/src`

## Resultado resumido
- Implementacao: PASSOU.
- Validacao automatica de build/teste: NAO EXECUTADA (sem alvo de Makefile especifico para este demo neste ciclo).

## Pendencias
- Definir/propagar `DISCOVERY_APPS_JSON` no ambiente de execucao para habilitar descoberta em runtime.

## Referencias cruzadas
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`
