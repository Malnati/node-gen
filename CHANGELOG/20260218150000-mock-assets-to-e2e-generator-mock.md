<!-- CHANGELOG/20260218150000-mock-assets-to-e2e-generator-mock.md -->

# 2026-02-18 15:00:00 UTC — Assets do mock movidos para test/e2e-generator-mock

## Alterações

- **Removidos de `test/mock/`:** `connection.json`, `create-db.js`, `create-sqlite-fixture.js` (o arquivo `mock.sqlite` é gerado e ignorado pelo git; passa a ser criado em `test/e2e-generator-mock/`).
- **Criados em `test/e2e-generator-mock/`:** `connection.json`, `create-db.js`, `create-sqlite-fixture.js`.
- **`create-db.js`:** lê o schema de `test/mock/schema.sql` e grava `mock.sqlite` no próprio diretório `test/e2e-generator-mock/`.
- **`test/mock/`** permanece apenas com `schema.sql` e `README.md`.

## Motivo

Concentrar scripts de criação do banco, dados de conexão e o banco mock no projeto que os utiliza (`test/e2e-generator-mock/`), mantendo em `test/mock/` somente o DDL do schema.

## Referências atualizadas

- `test/e2e-generator-mock/run.js`: `MOCK_DIR` aponta para `test/e2e-generator-mock`.
- `.gitignore`: `test/e2e-generator-mock/mock.sqlite`.
- `.docker/Dockerfile.e2e`: `node test/e2e-generator-mock/create-db.js`.
- `.dockerignore`: `test/e2e-generator-mock/mock.sqlite`.
- `test/mock/README.md`, `test/e2e-generator-mock/README.md`, `test/README.md`, `README.md`: comandos e descrições.
- `docs/issues/`: plan-cli-test-execution, plan-issues-execution, plan-mock-project-codegen, plan-test-project-generator-vs-mock.

## Uso (inalterado)

- Criar mock: `node test/e2e-generator-mock/create-db.js` (raiz).
- Fixture CLI: `node test/e2e-generator-mock/create-sqlite-fixture.js ./test/build-cli-test`.
- E2E: `npm run test:e2e` ou `node test/e2e-generator-mock/run.js`.
