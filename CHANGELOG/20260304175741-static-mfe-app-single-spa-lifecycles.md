<!-- CHANGELOG/20260304175741-static-mfe-app-single-spa-lifecycles.md -->
# 2026-03-04 17:57:41 UTC - Ajuste single-spa no template `gen/static-mfe-app`

## Arquivos modificados
- `gen/static-mfe-app/vite.config.ts`
- `gen/static-mfe-app/src/main.tsx`
- `gen/static-mfe-app/src/single-spa.ts`
- `gen/static-mfe-app/src/spa.tsx`

## Regras e requisitos atendidos
- Aplicado o empacotamento MFE com `vite-plugin-single-spa` no template alvo.
- Criado entrypoint dedicado de ciclo de vida single-spa (`bootstrap`, `mount`, `unmount`) em `src/spa.tsx`.
- Mantida compatibilidade com entrada existente via `src/single-spa.ts` como reexport.
- Mantido o escopo restrito ao diretório solicitado (`gen/static-mfe-app`), sem alterações em infraestrutura, banco ou serviços.
- Registro de rastreabilidade criado em `CHANGELOG/` com timestamp UTC único.

## Pendencias e observacoes
- O registro no orquestrador root-config ja existe no fluxo de geracao via `gen/templates/app-shell-root-config.ejs`; nao foi alterado por estar fora do escopo solicitado.
- O `basename` das rotas internas continua sendo definido no template de `App.tsx` gerado (`gen/templates/mfe-app.ejs`), tambem sem necessidade de ajuste neste escopo.
