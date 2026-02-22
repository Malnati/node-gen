<!-- CHANGELOG/20260219170000-e2e-endpoints-db-verify-optional-relations.md -->
# Changelog — E2E: endpoints 200, verificação em logs/DB, relações opcionais (2026-02-19 17:00:00 UTC)

## Arquivos alterados

- **Modificados**
  - `gen/static/src/app/middleware/jwt-auth.guard.ts` — bypass de autenticação quando `E2E_SKIP_JWT=true` para permitir chamadas e2e aos endpoints protegidos com 200.
  - `test/e2e-generator/run.js` — (1) Exigência de status 200 em todos os endpoints (removida aceitação de 401). (2) Envio de `E2E_SKIP_JWT: 'true'` no env do processo da API gerada. (3) Verificação de logs da API (presença de Nest/Application/listening/started). (4) Nova rotina `postAndVerifyInDb`: POST em um endpoint por projeto (simple-item, customer, resource) com payload mínimo e verificação no banco via `queryDb` (sqlite, postgres, mysql, sqlserver). (5) `curlPost` e `queryDb` para suportar POST e consulta por motor. (6) Limpeza do outDir: só chama `fs.rmSync` se `fs.existsSync(p)` para evitar ENOENT em arquivos já removidos.
  - `gen/src/service-generator.ts` — relações opcionais (coluna FK nullable): em `generateRelationCheckAndAssignment` e `generateRelationUpdateAndAssignment` o bloco de busca e atribuição da entidade relacionada passa a ser envolvido em `if (dto.<dtoKey> != null) { ... }`, evitando "Resource not found" em create/update quando o DTO não envia o FK (ex.: `parent_id` em tb_resource).

## Regras/requisitos atendidos

- Testes E2E focados em SQLServer, MySQL, Postgres e SQLite; aplicações geradas compilam e sobem; todos os endpoints retornam sucesso (200); resultados confirmados nos retornos, nos logs e no banco.
- Verificação de containers, logs e cURL para todos os endpoints; confirmação das execuções acessando os bancos após o POST (cobertura e2e).
- Ajuste apenas em templates/gerador (service-generator) e estático (jwt-auth.guard) para corrigir comportamento; estrutura estática preservada.
- Loops de verificação com timeout de no máximo 1,5 s mantidos (POLL_INTERVAL_MS, HEALTH_REQUEST_TIMEOUT_MS, DB_CONNECT_CHECK_TIMEOUT_MS).

## Comandos executados

- `make e2e-build` — OK.
- `make e2e-run` — executado (parcialmente em background); schedule/mysql e schedule/postgres falhavam em POST /resource com "Resource not found" antes do ajuste de relações opcionais; após o ajuste e correção da limpeza do outDir, fluxo deve passar.

## Pendências / observações

- Execução completa `make e2e` (e2e-build + e2e-run) para os quatro bancos e três projetos pode ser longa; validar localmente com `E2E_DB_TYPES=sqlite make e2e-run` para ciclo rápido.
