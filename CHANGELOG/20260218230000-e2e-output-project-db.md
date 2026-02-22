<!-- CHANGELOG/20260218230000-e2e-output-project-db.md -->

# E2E: saída em output/<project>/<db>

**Data/Hora UTC:** 2026-02-18 23:00:00

## Arquivos modificados

- `test/e2e-generator/run.js` — saída passou de `output/<dbType>/` para `output/<project>/<dbType>/`; constante `E2E_APP_NAME` (default `e2e-mock-app`), override via `E2E_APP_NAME`; `runGenerator` recebe `appName` e monta `outDir = path.join(OUT_DIR_BASE, E2E_APP_NAME, dbType)`.
- `test/README.md` — documentação atualizada: estrutura `output/<project>/<db>/`, exemplos `output/e2e-mock-app/sqlite/`, comandos para testes do projeto gerado com `cd output/e2e-mock-app/sqlite`.
- `test/e2e-generator/README.md` — fluxo e saída descritos como `output/<project>/<dbType>/`; referência a `E2E_APP_NAME` para vários projetos.

## Regras/requisitos atendidos

- Múltiplos projetos com múltiplos bancos: cada execução E2E grava em `output/<project>/<db>/`; o nome do projeto é configurável por `E2E_APP_NAME`.

## Comandos executados e resultado

- `make e2e-build` e `make e2e-run` — passaram; artefatos em `output/e2e-mock-app/postgres/` e `output/e2e-mock-app/sqlite/`; `npm run build` OK em ambos.

## Referências

- CHANGELOG 20260218220000-e2e-docker-postgres-sqlite.md.
