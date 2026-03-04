<!-- CHANGELOG/20260304190638-implementacao-interpolacao-static-template.md -->
# 2026-03-04 19:06:38 UTC - Implementacao de interpolacao via template + gerador

## Arquivos modificados
- `gen/src/microfrontend-generator.ts`
- `gen/src/appshell-generator.ts`
- `gen/src/mfe-parcel-paging-generator.ts`
- `gen/src/main.ts`
- `gen/src/interfaces.ts`
- `gen/src/sspa-static-assets-generator.ts` (novo)
- `gen/templates/mfe-package-json.ejs` (novo)
- `gen/templates/app-shell-package-json.ejs` (novo)
- `gen/templates/app-shell-vite-config.ejs` (novo)
- `gen/templates/mfe-parcel-paging-package-json.ejs` (novo)
- `gen/templates/mfe-parcel-paging-readme.ejs` (novo)
- `gen/templates/sspa-static-package-json.ejs` (novo)
- `gen/templates/sspa-static-index-html.ejs` (novo)
- `gen/templates/sspa-static-readme.ejs` (novo)
- `gen/static-mfe-app/package.json` (removido)
- `gen/static-mfe-app/vite.config.ts` (removido)
- `gen/static-mfe-app/app-shell/package.json` (removido)
- `gen/static-mfe-app/app-shell/vite.config.ts` (removido)
- `gen/static/mfe-parcel-paging/Dockerfile` (removido)
- `gen/static/mfe-parcel-paging/package.json` (removido)
- `gen/static/mfe-parcel-paging/README.md` (removido)
- `sspa-static/mfe-app-crud/index.html`
- `sspa-static/mfe-app-crud/package.json`
- `sspa-static/mfe-app-crud/README.md`
- `sspa-static/mfe-app/README.md`
- `sspa-static/mfe-parcel-create/index.html`
- `sspa-static/mfe-parcel-create/package.json`
- `sspa-static/mfe-parcel-create/README.md`
- `sspa-static/mfe-parcel-create/mfe-app/README.md`
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
- `CHANGELOG/20260304190638-implementacao-interpolacao-static-template.md`

## Requisitos e regras atendidos
- Arquivos variaveis de `gen/static-mfe-app` (package/vite de app-shell e raiz) deixaram de ser estaticos e passaram a ser gerados por templates EJS.
- Arquivos variaveis de `gen/static/mfe-parcel-paging` (Dockerfile/package/README) deixaram de ser estaticos e passaram a ser gerados por templates EJS.
- Geradores foram ajustados para renderizacao direta de templates, eliminando mutacoes por parse de arquivos estaticos quando aplicavel.
- Criado gerador dedicado `SspaStaticAssetsGenerator` para aplicar templates em `sspa-static/*` para `index.html`, `package.json` e `README.md`.
- `sspa-static/*` alvo foi atualizado para refletir interpolacao de `title`, `name` e `version`.
- Escopo mantido em geradores/templates/artefatos estaticos; sem alteracoes de banco/API.

## Comandos executados
- `sed -n '1,320p' gen/src/microfrontend-generator.ts`
- `sed -n '1,320p' gen/src/mfe-parcel-paging-generator.ts`
- `sed -n '1,320p' gen/src/appshell-generator.ts`
- `sed -n '1,220p' gen/static-mfe-app/package.json`
- `sed -n '1,220p' gen/static-mfe-app/vite.config.ts`
- `sed -n '1,220p' gen/static-mfe-app/app-shell/package.json`
- `sed -n '1,220p' gen/static-mfe-app/app-shell/vite.config.ts`
- `sed -n '1,240p' gen/static/mfe-parcel-paging/Dockerfile`
- `sed -n '1,220p' gen/static/mfe-parcel-paging/package.json`
- `sed -n '1,240p' gen/static/mfe-parcel-paging/README.md`
- `sed -n '1,260p' gen/templates/mfe-parcel-paging-dockerfile.ejs`
- `sed -n '1,260p' gen/templates/mfe-parcel-paging-vite-config.ejs`
- `rg -n "sspa-static" gen/src gen/templates Makefile -S`
- `sed -n '1,220p' gen/src/interfaces.ts`
- `sed -n '1,280p' gen/src/main.ts`
- `rm -f gen/static-mfe-app/vite.config.ts`
- `rm -f gen/static-mfe-app/app-shell/package.json`
- `rm -f gen/static-mfe-app/app-shell/vite.config.ts`
- `rm -f gen/static/mfe-parcel-paging/Dockerfile`
- `rm -f gen/static/mfe-parcel-paging/package.json`
- `rm -f gen/static/mfe-parcel-paging/README.md`
- `rg -n "mfe-package-json.ejs|app-shell-package-json.ejs|app-shell-vite-config.ejs|mfe-parcel-paging-package-json.ejs|mfe-parcel-paging-readme.ejs|sspa-static-assets-generator|sspa-static-package-json.ejs|sspa-static-index-html.ejs|sspa-static-readme.ejs" gen/src gen/templates`
- `ls -la gen/static-mfe-app gen/static-mfe-app/app-shell gen/static/mfe-parcel-paging`
- `git status --short`

## Resultado resumido
- Implementacao de templates + geradores: PASSOU.
- Verificacao estrutural por `rg`/`ls`: PASSOU.
- Build/testes automatizados: NAO EXECUTADOS neste ciclo.

## Pendencias
- Executar validacao completa de geracao (fluxo via `Makefile`) em ciclo dedicado.

## Referencias cruzadas
- `CHANGELOG/20260304185131-review-interpolacao-static-template-plan.md`
- `CHANGELOG/20260304185131-review-interpolacao-static-template-audit.md`
- `CHANGELOG/20260304153828-gen-main-static-template-governance.md`
