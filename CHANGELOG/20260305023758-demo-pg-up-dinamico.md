<!-- CHANGELOG/20260305023758-demo-pg-up-dinamico.md -->
# 2026-03-05 02:37:58 UTC - Fluxo demo PostgreSQL dinâmico por Makefile

## Arquivos modificados
- Makefile
- .docker/Dockerfile.demo
- .docker/Dockerfile.service-discovery
- demo/sspa/src/root-config.ts
- demo/sspa/src/vite-env.d.ts
- gen/templates/mfe-package-json.ejs
- gen/static-mfe/package.json

## Regras e requisitos atendidos
- Fluxo executado exclusivamente por alvos do `Makefile`.
- Geração de API + MFE application por projeto PostgreSQL incluída no fluxo `demo-pg-up`.
- Publicação dinâmica no demo SSPA implementada via `DISCOVERY_APPS_JSON` gerado automaticamente.
- Stack demo (`sspa` + `service-discovery`) mantida no compose dedicado `.docker/docker-compose.demo.yml`.
- Correção funcional no alvo `gen-mfe` para remover chamada inválida de shell (`or`).
- Fallback de porta no `demo-mfe-up` para leitura por `listen` quando `EXPOSE` não estiver presente.
- Dockerfiles do demo ajustados para fallback `npm install` quando não houver lockfile.
- Tipagem do `demo/sspa` ajustada para build TypeScript (`import.meta.env` e tipo de ciclo do single-spa).
- Dependência `vite-plugin-single-spa` ajustada para `latest` nos artefatos de geração MFE.

## Comandos executados
- `make -n demo-pg-up DEMO_PROJECTS="addresses contacts orders"`
- `make -n demo-pg-down`
- `make demo-pg-prepare DEMO_PROJECTS="addresses contacts orders"`
- `make gen-contacts-pg-mfe-app`
- `make demo-pg-up DEMO_PROJECTS="addresses contacts orders"` (múltiplas tentativas)
- `make gen-addresses-pg-mfe-app`

## Resultado resumido
- `make -n demo-pg-up DEMO_PROJECTS="addresses contacts orders"`: passou.
- `make -n demo-pg-down`: passou.
- `make demo-pg-prepare DEMO_PROJECTS="addresses contacts orders"`: passou.
- `make gen-contacts-pg-mfe-app`: passou.
- `make demo-pg-up DEMO_PROJECTS="addresses contacts orders"`: falhou no estágio de build dos MFEs gerados (`npm run build`) por erros TypeScript nos artefatos gerados (ex.: `output/addresses/postgres/frontend/address-mfe/src/pages/address-details-page.tsx` e `src/single-spa.ts`).

## Pendências relevantes
- O fluxo dinâmico via Makefile está implementado, mas a publicação completa depende de corrigir os erros de TypeScript nos MFEs gerados para os projetos usados no demo.
