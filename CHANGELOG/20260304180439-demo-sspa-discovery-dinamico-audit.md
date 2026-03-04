<!-- CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md -->
# Auditoria - demo SSPA com descoberta dinamica e import map remoto

## Data/Hora UTC
2026-03-04T18:04:39Z

## Plano relacionado
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`

## Escopo auditado
- Criacao da aplicacao demo em `demo/sspa`.
- Criacao do servico de descoberta em `demo/service-discovery`.
- Registro dinamico de MFEs com `fetch` + `registerApplication`.
- Consumo de import map remoto via script `systemjs-importmap` com `src`.
- Dashboard com cards dinamicos e navegacao por `navigateToUrl`.
- Adequacao da fronteira `gen/static-mfe-app` (estatico) vs `gen/templates` (interpolado).

## Comandos planejados para verificacao
1. `find demo -maxdepth 4 -type f | sort`
2. `rg -n "systemjs-importmap|import-map|registerApplication|start\\(|navigateToUrl|fetch\\(" demo/sspa demo/service-discovery -S`
3. `rg -n "<%=?|{{|}}" gen/static-mfe-app -S`
4. `rg -n "<%=?|{{|}}" gen/templates -S`
5. `git status --short`

## Matriz de criterios de aceite
- [x] `demo/service-discovery` exposto com endpoints `/api/discovery/import-map` e `/api/discovery/applications`. **PASSOU**
- [x] `demo/sspa/index.html` aponta import map remoto por atributo `src`. **PASSOU**
- [x] `demo/sspa/src/root-config.ts` registra apps dinamicamente antes de `start()`. **PASSOU**
- [x] `demo/sspa` renderiza cards com dados de descoberta e navega por `navigateToUrl`. **PASSOU**
- [x] Nao existe registro estatico fixo de apps no demo SSPA. **PASSOU**
- [x] Arquivos com interpolacao foram movidos para `gen/templates` quando aplicavel. **PASSOU**
- [x] `gen/static-mfe-app` fica restrito a conteudo estatico. **PASSOU**
- [x] Rastreabilidade final documentada com arquivos alterados, comandos e status. **PASSOU**

## Evidencias a registrar na conclusao do ciclo
- Lista final de arquivos criados/alterados.
- Resultado objetivo por criterio (PASSOU/FALHOU).
- Pendencias remanescentes com causa objetiva.
- Referencia cruzada para o proximo ciclo, se houver.

## Arquivos criados/alterados no ciclo
- `demo/service-discovery/package.json`
- `demo/service-discovery/tsconfig.json`
- `demo/service-discovery/src/contracts.ts`
- `demo/service-discovery/src/mock-data.ts`
- `demo/service-discovery/src/main.ts`
- `demo/sspa/package.json`
- `demo/sspa/tsconfig.json`
- `demo/sspa/vite.config.ts`
- `demo/sspa/index.html`
- `demo/sspa/src/root-config.ts`
- `demo/sspa/src/dashboard.tsx`
- `demo/sspa/src/main.tsx`
- `gen/src/microfrontend-generator.ts`
- `gen/src/appshell-generator.ts`
- `gen/static-mfe-app/package.json`
- `gen/static-mfe-app/index.html`
- `gen/static-mfe-app/vite.config.ts`
- `gen/templates/mfe-index-html.ejs`
- `gen/templates/app-shell-root-config-dynamic.ejs`
- `gen/templates/app-shell-app-dynamic.ejs`
- `gen/templates/app-shell-index-html-dynamic.ejs`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`

## Comandos executados
1. `find demo -maxdepth 4 -type f | sort`
2. `rg -n "systemjs-importmap|import-map|registerApplication|start\\(|navigateToUrl|fetch\\(" demo/sspa demo/service-discovery -S`
3. `rg -n "<%|\\{\\{name\\}\\}|\\{\\{port\\}\\}" gen/static-mfe-app -S`
4. `rg -n "<%|\\{\\{name\\}\\}|\\{\\{port\\}\\}" gen/templates -S`
5. `git status --short`

## Resultado resumido dos comandos
- `find demo ...`: **PASSOU** (estrutura `demo/service-discovery` e `demo/sspa` criada com os arquivos planejados).
- `rg ... demo/sspa demo/service-discovery`: **PASSOU** (evidencias de import-map remoto, fetch, `registerApplication`, `start()` e `navigateToUrl`).
- `rg ... gen/static-mfe-app`: **PASSOU** (sem placeholders de interpolacao `{{name}}`, `{{port}}`, `<%`).
- `rg ... gen/templates`: **PASSOU** (placeholders/interpolacoes presentes nas camadas de template, incluindo novos arquivos dinâmicos).
- `git status --short`: **PASSOU** (rastreabilidade dos arquivos alterados no escopo do ciclo).

## Pendencias objetivas
- Nao foram executados `build`/`dev` dos novos demos neste ciclo; auditoria focada em verificacao estrutural e de contratos estaticos conforme o plano.

## Referencias cruzadas
- Plano: `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- Contexto previo: `CHANGELOG/20260304175741-static-mfe-app-single-spa-lifecycles.md`

## Status desta auditoria
- Concluida.
