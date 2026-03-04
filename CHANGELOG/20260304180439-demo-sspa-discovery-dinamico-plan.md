<!-- CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md -->
# Plano - demo SSPA com descoberta dinamica e import map remoto

## Data/Hora UTC
2026-03-04T18:04:39Z

## 1. Arquivos existentes relevantes para o escopo
- `gen/static-mfe-app/vite.config.ts`
- `gen/static-mfe-app/src/main.tsx`
- `gen/static-mfe-app/src/single-spa.ts`
- `gen/static-mfe-app/src/spa.tsx`
- `gen/static-mfe/vite.config.ts`
- `gen/static-mfe/src/single-spa.ts`
- `gen/src/microfrontend-generator.ts`
- `gen/src/appshell-generator.ts`
- `gen/templates/mfe-vite-config.ejs`
- `gen/templates/app-shell-root-config.ejs`
- `gen/templates/app-shell-import-map.ejs`
- `gen/templates/app-shell-app.ejs`
- `.docker/Dockerfile.sspa`
- `.docker/docker-compose.projects.postgres.yml`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-plan.md`
- `CHANGELOG/20260302193539-sspa-all-cards-functional-audit.md`
- `CHANGELOG/20260304175741-static-mfe-app-single-spa-lifecycles.md`

## 2. Arquivos que serao alterados
- `demo/service-discovery/package.json` (novo)
- `demo/service-discovery/tsconfig.json` (novo)
- `demo/service-discovery/src/main.ts` (novo)
- `demo/service-discovery/src/contracts.ts` (novo)
- `demo/service-discovery/src/mock-data.ts` (novo)
- `demo/sspa/package.json` (novo)
- `demo/sspa/tsconfig.json` (novo)
- `demo/sspa/vite.config.ts` (novo)
- `demo/sspa/index.html` (novo)
- `demo/sspa/src/root-config.ts` (novo)
- `demo/sspa/src/dashboard.tsx` (novo)
- `demo/sspa/src/main.tsx` (novo)
- `gen/static-mfe-app/*` (somente arquivos 100% estaticos; reduzir interpolacoes indevidas)
- `gen/templates/*` (adicionar/mover arquivos com interpolacao obrigatoria)
- `gen/src/microfrontend-generator.ts` (ajuste de copia estatico vs template)
- `gen/src/appshell-generator.ts` (ajuste para fluxo dinamico e sem registro estatico no servidor SSPA demo)
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`

## 3. Lista combinada de requisitos (especificos + globais)
- Criar aplicacao de demonstracao em `demo/sspa` que exiba cards de MFEs disponiveis.
- Criar servico de descoberta em `demo/service-discovery` que exponha:
- endpoint de import map no formato SystemJS (`/api/discovery/import-map`);
- endpoint de aplicacoes para registro dinamico (`/api/discovery/applications`).
- O `index.html` do demo SSPA deve consumir import map remoto por `<script type="systemjs-importmap" src="...">`.
- O `root-config` do demo SSPA deve buscar a lista de aplicacoes e executar `registerApplication` dinamicamente antes de `start()`.
- O dashboard deve renderizar cards a partir da descoberta e usar `navigateToUrl` no clique.
- Nao registrar MFEs estaticamente no servidor SSPA demo.
- Corrigir a fronteira de geracao: arquivos com interpolacao devem estar em `gen/templates/`; `gen/static-mfe-app` deve conter somente artefatos estaticos.
- Manter mudancas cirurgicas, sem adicionar pipelines/jobs externos e sem refatoracao ampla nao solicitada.
- Manter rastreabilidade completa em `CHANGELOG/` com plano e auditoria irmaos.

## 4. Requisitos nao atendidos no inicio do ciclo
- Nao existe diretorio `demo/` com `demo/sspa` e `demo/service-discovery`.
- Nao existe endpoint remoto de import map para consumo direto do SystemJS no demo.
- O `root-config` atual de app shell usa registro estatico por template.
- O dashboard atual nao esta definido como consumo dinamico exclusivo do servico de descoberta.
- Existe ambiguidade entre `gen/static-mfe` e `gen/static-mfe-app`, com risco de arquivos interpolados permanecerem em pasta estatica.

## 5. Lista combinada de regras (especificas + globais)
- Implementar somente o escopo solicitado: demo SSPA + discovery dinamico + plano rastreavel.
- Preservar separacao: estatico em `gen/static-*`; interpolado em `gen/templates/*.ejs`.
- Evitar hardcode funcional de MFEs no root-config do demo.
- Nao incluir segredos/tokens/chaves e nao vazar dados de ambiente.
- Nao adicionar dependencias e estruturas fora do necessario ao objetivo da demonstracao.
- Seguir convencao de cabecalho de caminho em todos os novos arquivos.
- Registrar evidencias (arquivos, comandos, status) no arquivo de auditoria irmao.

## 6. Regras nao atendidas que motivam os ajustes
- Regra de geracao estatico vs template nao esta claramente aplicada em todos os artefatos ligados a MFE.
- Registro estatico de aplicacoes no root-config conflita com o objetivo de descoberta dinamica.
- Ausencia de demo dedicada impede validacao objetiva do fluxo de cards -> rota -> mount de MFE.

## 7. Plano de auditoria (manual + automatico)
1. Validar estrutura criada: `find demo -maxdepth 3 -type f`.
2. Validar contrato de descoberta: inspecionar rotas e schema JSON dos endpoints `/api/discovery/import-map` e `/api/discovery/applications`.
3. Validar que `demo/sspa/index.html` referencia import map remoto (sem arquivo local fixo).
4. Validar que `demo/sspa/src/root-config.ts` executa `fetch` + `registerApplication` dinamico + `start()` apos registro.
5. Validar que `demo/sspa/src/dashboard.tsx` renderiza cards dinamicos e usa `navigateToUrl`.
6. Validar ausencia de cadastro estatico no demo: `rg "registerApplication\\(|System\\.import\\(" demo/sspa`.
7. Validar fronteira de geracao: nenhum arquivo com placeholders/interpolacao indevida em `gen/static-mfe-app`; interpolacoes em `gen/templates`.
8. Registrar no arquivo `-audit`:
- lista de arquivos alterados;
- comandos executados;
- resultado por criterio (PASSOU/FALHOU);
- pendencias objetivas, se houver.

## 8. Selecao de checklists aplicaveis
- `docs/checklists/` nao possui arquivos no estado atual.
- Checklist obrigatorio transversal aplicado neste ciclo:
- plano + auditoria em `CHANGELOG/` com timestamp unico;
- rastreabilidade de requisitos e regras por secao 1..8;
- escopo restrito ao pedido (demo SSPA + discovery dinamico + correcao da fronteira estatico/template).

## Referencias cruzadas
- Auditoria irma: `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`
- Contexto previo: `CHANGELOG/20260304175741-static-mfe-app-single-spa-lifecycles.md`
