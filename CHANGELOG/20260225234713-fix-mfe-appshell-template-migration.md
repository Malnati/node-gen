<!-- CHANGELOG/20260225234713-fix-mfe-appshell-template-migration.md -->
# 2026-02-25 23:47 UTC — Migracao MFE/AppShell para templates EJS

## Resumo
Unificacao da geracao de micro frontends e app-shell com o padrao de templates EJS do projeto, removendo blocos de codigo inline (hardcoded) dos geradores e migrando todo conteudo gerado para `gen/templates/`.

## Arquivos alterados

### Templates convertidos (Handlebars -> EJS)
- `gen/templates/mfe-list-page.ejs`
- `gen/templates/mfe-details-page.ejs`
- `gen/templates/mfe-vite-config.ejs`
- `gen/templates/mfe-test-playwright.ejs`

### Templates novos
- `gen/templates/mfe-app.ejs`
- `gen/templates/app-shell-root-config.ejs`
- `gen/templates/app-shell-import-map.ejs`
- `gen/templates/app-shell-app.ejs`
- `gen/templates/app-shell-package-json.ejs`
- `gen/templates/app-shell-index-html.ejs`
- `gen/templates/app-shell-vite-config.ejs`
- `gen/templates/app-shell-tsconfig.ejs`

### Geradores refatorados
- `gen/src/microfrontend-generator.ts` — removidos metodos `getListPageTemplate()`, `getDetailsPageTemplate()`, `getTestTemplate()` e blocos inline de `generateViteConfig()`, `updateAppTsx()`; todos substituidos por `renderTemplate()`
- `gen/src/appshell-generator.ts` — removidos todos blocos inline de `generateRootConfig()`, `generateImportMap()`, `generateAppShellTsx()`, `generatePackageJson()`, `updateIndexHtml()`; metodo `generateImportMapString()` eliminado; todos substituidos por `renderTemplate()`

### Orquestracao
- `gen/src/main.ts` — corrigida condicao sempre-true no case `mfes` (bug: `!A || A`); separados cases `mfes` e `app-shell` com variavel `mfeConfigs` compartilhada; eliminada duplicacao de geracao MFE

### Templates estaticos movidos para gen/static-mfe/app-shell/
- `gen/templates/app-shell-package-json.ejs` -> `gen/static-mfe/app-shell/package.json` (removido do templates)
- `gen/templates/app-shell-vite-config.ejs` -> `gen/static-mfe/app-shell/vite.config.ts` (removido do templates)
- `gen/templates/app-shell-tsconfig.ejs` -> `gen/static-mfe/app-shell/tsconfig.json` (removido do templates)

## Regras/requisitos atendidos
- Padrao de template engine consistente com geradores de API (`service-generator.ts`)
- Uso de `renderTemplate()` de `TemplateEngine.ts` (EJS) em todos os geradores MFE/AppShell
- Nenhum bloco longo de codigo-fonte final permanece hardcoded nos geradores
- Estaticos API em `gen/static`, estaticos MFE em `gen/static-mfe`
- Codigo morto removido (metodos inline substituidos)

## Plano de referencia
- `CHANGELOG/plan-fix-fme-opencode.md`
