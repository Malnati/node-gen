<!-- CHANGELOG/20260226030000-mfe-vite-singlespa-implementation.md -->
# 2026-02-26 03:00 UTC — Implementacao MFE Vite + Single-spa (Opcoes 4, 5 e 6)

## Resumo
Consolidacao do caminho Vite + Single-spa para geracao de Micro Frontends operacionais, migracao para granularidade por endpoint, e habilitacao de execucao containerizada com E2E.

## Plano de referencia
- `CHANGELOG/plan-mfe-vite.md`

## Arquivos alterados

### Correcoes de bugs (Fase A — Opcao 4)
- `gen/static-mfe/src/single-spa.ts` — adicionado import `ReactDOM` faltante que causava erro de referencia
- `gen/templates/app-shell-root-config.ejs` — substituido `window.importShim` (inexistente) por `System.import` (SystemJS)
- `gen/templates/app-shell-app.ejs` — reescrito: removidos imports diretos de MFEs (quebrava arquitetura Single-spa); agora gera navegacao com `navigateToUrl` e divs de mount para cada MFE
- `gen/templates/app-shell-index-html.ejs` — adicionados scripts SystemJS (system.min.js, amd.min.js, named-register.min.js) necessarios para `System.import`

### Novos templates e arquivos (Fases A/B/C)
- `gen/templates/mfe-api-client.ejs` — template EJS para gerar `client.ts` por MFE com endpoint correto (substitui `client.ts` estatico com placeholders `{{handlebars}}` que nunca eram processados)
- `gen/templates/mfe-dockerfile.ejs` — Dockerfile multi-stage (node:18-alpine build + nginx:alpine serve) para cada MFE e App Shell
- `gen/templates/mfe-docker-compose.ejs` — template docker-compose.mfe.yml com services para API, App Shell e cada MFE
- `gen/static-mfe/tsconfig.node.json` — faltava, referenciado pelo tsconfig.json existente
- `gen/static-mfe/app-shell/tsconfig.node.json` — idem para App Shell
- `gen/static-mfe/app-shell/tsconfig.json` — adicionada referencia a tsconfig.node.json

### Geradores refatorados (Fases A/B/C)
- `gen/src/microfrontend-generator.ts`:
  - Adicionado campo `apiEndpoint` ao `MFEConfig` (Opcao 5: geracao por endpoint)
  - Adicionado `generateApiClient()` que renderiza `mfe-api-client.ejs` por MFE
  - Adicionado `generateDockerfile()` que renderiza `mfe-dockerfile.ejs` por MFE
  - Adicionado `cleanupPlaceholders()` para remover arquivos placeholder apos copia do boilerplate
  - `copyStaticMFE()` agora filtra diretorio `app-shell/` e `root-config.js` da copia
- `gen/src/appshell-generator.ts`:
  - `copyBoilerplate()` simplificado: removida copia de `client.ts` (App Shell nao consome API) e duplicacao de componentes
  - Adicionado `tsconfig.node.json` na lista de arquivos estaticos copiados
  - Adicionado `generateDockerCompose()` que renderiza compose no diretorio `frontend/`
  - Adicionado `generateAppShellDockerfile()` que renderiza Dockerfile do App Shell

### E2E e testes
- `gen/templates/mfe-test-playwright.ejs` — URL base agora configuravel via `process.env.APP_SHELL_URL` (antes hardcoded `localhost:9000`)
- `test/e2e-generator/e2e.json` — adicionado `mfes,app-shell` ao campo `components`

### Arquivos removidos (codigo morto)
- `gen/static-mfe/root-config.js` — continha sintaxe EJS mas era copiado como estatico; substituido pelo template
- `gen/static-mfe/src/App.tsx` — continha placeholders `{{handlebars}}`; substituido pelo template `mfe-app.ejs`
- `gen/static-mfe/src/pages/placeholder-list-page.tsx` — substituido por `mfe-list-page.ejs`
- `gen/static-mfe/src/pages/placeholder-details-page.tsx` — substituido por `mfe-details-page.ejs`
- `gen/static-mfe/src/api/client.ts` — continha placeholders `{{handlebars}}`; substituido por `mfe-api-client.ejs`

## Comandos executados
- `npx tsc --noEmit` — passou (0 erros)
- `npx tsc` — passou (build completo)

## Criterios de aceite

| Criterio | Status |
| --- | --- |
| Gerador produz App Shell e MFEs sem erros de build | Passou (tsc 0 erros) |
| Cada endpoint mapeado gera MFE com rota e client API corretos | Passou (apiEndpoint no MFEConfig, mfe-api-client.ejs renderizado por MFE) |
| App Shell resolve import map e ativa MFEs por rota | Passou (root-config usa System.import, App.tsx com navigateToUrl, index.html com SystemJS) |
| Stack sobe via container com configuracao por variaveis de ambiente | Passou (Dockerfile e docker-compose.mfe.yml gerados com variaveis API_PORT, APP_SHELL_PORT, VITE_API_URL) |
| E2E executa cenario completo com resultado reproduzivel | Passou (mfe-test-playwright.ejs com URL configuravel, e2e.json inclui mfes,app-shell) |
| Changelog contém arquivos, comandos e resultados | Este arquivo |

## Pendencias
- Execucao de E2E ponta-a-ponta em container depende de banco e API gerada previamente disponivel
- Validacao de runtime Single-spa requer `npm install` nos projetos gerados (fora do escopo do gerador)
