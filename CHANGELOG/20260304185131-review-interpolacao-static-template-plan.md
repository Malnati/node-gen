<!-- CHANGELOG/20260304185131-review-interpolacao-static-template-plan.md -->
# Plano - Review de interpolacao obrigatoria em artefatos estaticos

## Data/Hora UTC
2026-03-04T18:51:31Z

## 1. Lista de arquivos existentes relevantes para o escopo
- `gen/src/microfrontend-generator.ts`
- `gen/src/mfe-parcel-paging-generator.ts`
- `gen/src/appshell-generator.ts`
- `gen/src/main.ts`
- `gen/templates/mfe-vite-config.ejs`
- `gen/templates/mfe-index-html.ejs`
- `gen/templates/mfe-app.ejs`
- `gen/templates/mfe-dockerfile.ejs`
- `gen/templates/mfe-parcel-paging-vite-config.ejs`
- `gen/templates/mfe-parcel-paging-dockerfile.ejs`
- `gen/static-mfe-app/app-shell/package.json`
- `gen/static-mfe-app/app-shell/vite.config.ts`
- `gen/static-mfe-app/package.json`
- `gen/static-mfe-app/vite.config.ts`
- `gen/static/mfe-parcel-paging/Dockerfile`
- `gen/static/mfe-parcel-paging/package.json`
- `gen/static/mfe-parcel-paging/README.md`
- `sspa-static/mfe-app-crud/index.html`
- `sspa-static/mfe-app-crud/package.json`
- `sspa-static/mfe-app-crud/README.md`
- `sspa-static/mfe-app/index.html`
- `sspa-static/mfe-app/package.json`
- `sspa-static/mfe-app/README.md`
- `sspa-static/mfe-parcel-create/mfe-app/index.html`
- `sspa-static/mfe-parcel-create/mfe-app/package.json`
- `sspa-static/mfe-parcel-create/mfe-app/README.md`
- `sspa-static/mfe-parcel-create/index.html`
- `sspa-static/mfe-parcel-create/package.json`
- `sspa-static/mfe-parcel-create/README.md`
- `sspa-static/mfe-parcel-delete/index.html`
- `sspa-static/mfe-parcel-delete/package.json`
- `sspa-static/mfe-parcel-delete/README.md`
- `sspa-static/mfe-parcel-paging/index.html`
- `sspa-static/mfe-parcel-paging/package.json`
- `sspa-static/mfe-parcel-paging/README.md`
- `sspa-static/mfe-parcel-retrieve/index.html`
- `sspa-static/mfe-parcel-retrieve/package.json`
- `sspa-static/mfe-parcel-retrieve/README.md`
- `sspa-static/mfe-parcel-update/index.html`
- `sspa-static/mfe-parcel-update/package.json`
- `sspa-static/mfe-parcel-update/README.md`
- `sspa-static/mfe-parcel-view/index.html`
- `sspa-static/mfe-parcel-view/package.json`
- `sspa-static/mfe-parcel-view/README.md`
- `sspa-static/mfe-parcel/index.html`
- `sspa-static/mfe-parcel/package.json`
- `sspa-static/mfe-parcel/README.md`
- `CHANGELOG/20260304153828-gen-main-static-template-governance.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`

## 2. Lista de arquivos que serao alterados
- `CHANGELOG/20260304185131-review-interpolacao-static-template-plan.md`
- `CHANGELOG/20260304185131-review-interpolacao-static-template-audit.md`

## 3. Lista combinada de requisitos da mudanca especifica e requisitos globais
- Produzir plano de Review para tratar arquivos estaticos que contem valores que deveriam ser interpolados por template + gerador.
- Cobrir explicitamente todos os arquivos listados no pedido (gen/static-mfe-app, gen/static/mfe-parcel-paging e sspa-static/*).
- Definir estrategia de migracao para `gen/templates/*.ejs` e ajustes cirurgicos nos geradores em `gen/src/*`.
- Garantir que `gen/src/main.ts` permaneca apenas como orquestrador e sem strings multiline/hardcode > 150 caracteres.
- Manter escopo de implementacao focado em geradores/templates/static, sem alteracoes de banco, API ou pipeline.
- Registrar rastreabilidade completa em `CHANGELOG/` com plano e auditoria irmaos.

## 4. Lista de requisitos atualmente nao atendidos que o plano busca resolver
- Existem artefatos em `gen/static-mfe-app` e `gen/static/mfe-parcel-paging` com campos variaveis (`name`, `version`, `port`, `title`, `APP_PORT`) sem interpolacao por template.
- Existem artefatos em `sspa-static/*` contendo campos variaveis que nao estao sendo gerados por template e gerador dedicados.
- Nao ha consolidacao formal, em um unico ciclo, do mapeamento arquivo-a-arquivo dos pontos que devem migrar de estatico para template.

## 5. Lista combinada de regras da mudanca especifica e regras globais do projeto
- Implementar exatamente o escopo solicitado (Review e planejamento), sem refatoracao ampla.
- Para conteudo com interpolacao obrigatoria, usar `gen/templates/*.ejs` + gerador TypeScript.
- Para conteudo 100% estatico, manter em `gen/static-*` e copiar por funcao dedicada.
- Proibido gerar conteudo interpolado por string multiline hardcoded em geradores.
- Nao adicionar dependencias, novos pipelines, novos servicos ou scripts shell.
- Atualizar `CHANGELOG/` com timestamp unico e referencias cruzadas de plano/auditoria.

## 6. Lista de regras atualmente nao atendidas que motivam os ajustes
- Regra de fronteira estatico vs template nao esta aplicada de forma uniforme nos arquivos listados.
- Regra de interpolacao obrigatoria para artefatos variaveis nao esta totalmente cumprida no conjunto citado.
- Regra de rastreabilidade por ciclo ainda nao possui, para este escopo especifico, um plano/auditoria dedicados.

## 7. Plano de auditoria descrevendo verificacoes manuais e automaticas previstas
1. Confirmar baseline dos arquivos alvo: `rg --files gen/static-mfe-app gen/static/mfe-parcel-paging sspa-static`.
2. Levantar campos variaveis atuais (`name`, `version`, `title`, `port`, `APP_PORT`) com `rg -n` nos arquivos listados.
3. Mapear cobertura atual de templates e geradores: `rg --files gen/templates gen/src` + inspecoes por `rg -n`.
4. Validar em Review que cada arquivo com variavel tenha destino definido: template EJS novo/existente e gerador responsavel.
5. Verificar que artefatos estaticos restantes nao contenham placeholders/interpolacao indevida.
6. Registrar resultado item a item (PASSOU/FALHOU) no arquivo irmao `-audit`.
7. Na fase de implementacao posterior, validar com build/geracao via alvos existentes do `Makefile` e registrar evidencias.

## 8. Selecao dos checklists em `docs/checklists/` aplicaveis ao contexto
- Nao foram encontrados arquivos em `docs/checklists/` no estado atual.
- Checklist obrigatorio transversal aplicado neste plano:
- plano e auditoria com mesmo prefixo timestamp em `CHANGELOG/`;
- rastreabilidade de requisitos/regras em secoes 1..8;
- delimitacao explicita de escopo e tipos de arquivo permitidos na proxima execucao (geradores, templates e estaticos listados).

## Referencias cruzadas
- Auditoria irma: `CHANGELOG/20260304185131-review-interpolacao-static-template-audit.md`
- Contexto de governanca: `CHANGELOG/20260304153828-gen-main-static-template-governance.md`
- Contexto recente de fronteira estatico/template: `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
