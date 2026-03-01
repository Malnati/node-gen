<!-- CHANGELOG/20260301073905-e2e-notifications-cobertura-completa-crud.md -->
# 2026-03-01 07:39:05 UTC - E2E notifications com cobertura completa de CRUD por endpoint

## Arquivos modificados
- `test/e2e-generator/e2e.js`
- `test/e2e-generator/e2e.json`
- `CHANGELOG/20260301073905-e2e-notifications-cobertura-completa-crud.md`

## Regras e requisitos atendidos
- Validacao executada via `Makefile` em apenas um projeto (`notifications`).
- Correcao aplicada para cobertura CRUD em multiplos endpoints por projeto.
- Cobertura de endpoints finalizada para `notifications` nos dois modulos: `notification-template` e `notification`.

## Comandos executados
1. `make e2e-clean`
2. `make e2e notifications`
3. `node -e "const fs=require('fs'); JSON.parse(fs.readFileSync('test/e2e-generator/e2e.json','utf8')); console.log('ok')"`
4. `make e2e-clean`
5. `make e2e notifications`

## Resultado resumido
- Execucao inicial de `notifications`: passou, mas com lacuna de cobertura CRUD em apenas um endpoint por projeto.
- Correcao aplicada:
  - `test/e2e-generator/e2e.js`: suporte a `crudVerify[]` e execucao sequencial de CRUD por endpoint configurado.
  - `test/e2e-generator/e2e.json`: `notifications` recebeu `crudVerify` com `/notification-template` e `/notification`.
- Reteste final de `make e2e notifications`: passou (exit code 0) com CRUD completo nos dois endpoints para `mysql`, `postgres` e `sqlserver`; `sqlite` manteve o comportamento de afericao sem subida da API.

## Definicao de pronto
- [x] Geração de API + MFE via `make e2e <project>` validada para um projeto.
- [x] Projeto `notifications` testado conforme solicitado.
- [x] Cobertura de endpoints finalizada para os modulos do projeto (`GET` em todos os endpoints + CRUD completo em `notification-template` e `notification`).
- [x] Correcao implementada e retestada com sucesso.
