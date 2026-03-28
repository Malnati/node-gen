<!-- CHANGELOG/20260305041000-sspa-mfe-react18-render-type-fix.md -->
# 2026-03-05 04:10:00 UTC — Correção de mount MFE React 18 no SSPA dinâmico

## Arquivos modificados
- `gen/static-mfe-app/src/spa.tsx`
- `gen/static-mfe/src/spa.ts`

## Regras e requisitos atendidos
- Corrigido o fluxo de montagem dos MFEs para React 18 com `single-spa-react`, definindo `renderType: 'createRoot'` nos artefatos base de geração.
- Escopo mantido estritamente no frontend MFE (sem alterações em API, banco ou infraestrutura).
- Mantida rastreabilidade em `CHANGELOG/` com referência cruzada ao contexto anterior: `CHANGELOG/20260305031427-demo-sspa-acesso-remoto-fix.md`.

## Comandos executados
- `rg -n "ReactDOM\\.render|react-dom/client|single-spa-react|mount\\(" -S /root/w/node-gen`
- `rg --files /root/w/node-gen | rg -n "(mfe|sspa|single-spa|spa\\.js|main\\.(ts|tsx|js|jsx)|generator|template|CHANGELOG)"`
- `sed -n '1,220p' /root/w/node-gen/gen/static-mfe/src/spa.ts`
- `sed -n '1,220p' /root/w/node-gen/gen/src/microfrontend-generator.ts`
- `sed -n '1,220p' /root/w/node-gen/gen/templates/mfe-app.ejs`
- `sed -n '1,220p' /root/w/node-gen/gen/static-mfe-app/src/spa.tsx`
- `sed -n '1,220p' /root/w/node-gen/gen/static-mfe/package.json`
- `rg -n "MicrofrontendGenerator|static-mfe|static-mfe-app|generate.*mfe|mfe" /root/w/node-gen/gen/src/main.ts /root/w/node-gen/Makefile /root/w/node-gen/gen/src/*.ts`

## Resultado resumido
- Status: **passou**
- Motivo objetivo: os templates/base de MFE agora instruem o `single-spa-react` a usar `createRoot`, eliminando a dependência de `ReactDOM.render`.

## Definição de pronto (item a item)
- [x] Identificar causa do erro `ReactDOM.render is not a function` no mount dos MFEs.
- [x] Aplicar correção direta na origem de geração dos MFEs.
- [x] Não expandir escopo para outros domínios.
- [x] Registrar evidências e rastreabilidade no CHANGELOG desta entrega.

## Pendências relevantes
- Regerar os MFEs já publicados e republicar os containers para que os artefatos em execução passem a incluir esta correção.
