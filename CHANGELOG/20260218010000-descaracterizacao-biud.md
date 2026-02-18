<!-- CHANGELOG/20260218010000-descaracterizacao-biud.md -->

# 2026-02-18 01:00:00 UTC — Descaracterização de referências à empresa BIUD

## Objetivo

Remover ou neutralizar nomes e estruturas que identifiquem a empresa BIUD, para uso genérico do repositório.

## Arquivos alterados

- `src/env-generator.ts` — URLs de sessão/health substituídas por padrões genéricos (`https://localhost/...`) e uso de variáveis de ambiente (`ENDPOINT_SESSION_VERIFY`, `ENDPOINT_SESSION_HEALTH`).
- `static/bitbucket-pipelines.yml` — repositório `biud/cicd-source` substituído por placeholder `your-workspace/cicd-scripts`; comentário orientando substituição pelo workspace/repo reais.
- `build-cli-test/bitbucket-pipelines.yml` — mesma substituição (repositório genérico).
- `README.md` — exemplos de uso: `--app "Log"`, host `34.134.67.65`, `--database "biud_log"`, `--user "biud_log"` substituídos por `--app "myapp"`, `--host "localhost"`, `--database "myapp_db"`, `--user "myapp_user"`.

## Regras atendidas

- Nenhuma referência explícita à BIUD ou a estruturas identificáveis da empresa nos arquivos versionados (exceto artefatos gerados cujo conteúdo dependa de templates já ajustados).
- Placeholders genéricos documentados onde necessário (Bitbucket).

## Observação

- A string "Iud" presente em hash de integridade em `package-lock.json` faz parte do checksum (ex.: `VbIudJ...`) e não foi alterada.
