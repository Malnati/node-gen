<!-- CHANGELOG/20260218020000-reestruturacao-gen-test.md -->

# 2026-02-18 02:00:00 UTC — Reestruturação: gen/ e test/

## Objetivo

Organizar o repositório com o aplicativo gerador em **`gen/`** e os testes em **`test/`**.

## Alterações

### Estrutura

- **`gen/`** — aplicativo gerador (node-gen): `package.json`, `package-lock.json`, `src/`, `static/`, `templates/`, `tsconfig.json`, `dist/` (após build), `node_modules/`. Build: `cd gen && npm run build` ou, na raiz, `npm run build`.
- **`test/`** — testes e mocks:
  - **`test/mock/`** — schema SQLite, `connection.json`, `create-db.js`, banco `mock.sqlite` (gerado).
  - **`test/e2e-generator-mock/`** — testes e2e do gerador contra o mock (`run.js`, `out/`).
  - **`test/build-cli-test/`** — output de exemplo do CLI (quando usado).

### Arquivos movidos

- Da raiz para **gen/**: `package.json`, `package-lock.json`, `src/`, `static/`, `templates/`, `tsconfig.json`, `dist/`, `node_modules/`.
- Da raiz para **test/**: `mock/`, `e2e-generator-mock/`, `build-cli-test/`.

### Arquivos criados/alterados

- **Raiz:** novo `package.json` com scripts `build` (delega a `gen`) e `test:e2e` (executa `test/e2e-generator-mock/run.js`).
- **test/e2e-generator-mock/run.js:** paths atualizados: `REPO_ROOT` (dois níveis acima), `GEN_DIR`, `MOCK_DIR` em `test/mock/`, `DIST_MAIN` em `gen/dist/main.js`; `runGenerator` com `cwd: GEN_DIR`.
- **test/mock/README.md**, **test/e2e-generator-mock/README.md:** referências a `test/mock/`, `gen/`, comandos atualizados.
- **.gitignore:** `test/mock/mock.sqlite` (em vez de `mock/mock.sqlite`).
- **README.md:** seção "Estrutura do repositório" (gen/ e test/), exemplos com `gen/` e `test/mock/`.
- **docs/issues:** plan-test-project-generator-vs-mock, plan-mock-project-codegen, plan-cli-test-execution atualizados para paths `gen/` e `test/`.

## Comandos após a mudança

- Build do gerador: `npm run build` (raiz) ou `cd gen && npm run build`.
- Testes e2e: `npm run test:e2e` (raiz) ou `node test/e2e-generator-mock/run.js`.
- Criar banco mock: `node test/mock/create-db.js`.

## Resultado

- E2E executado com sucesso após reestruturação (9/9 checks obrigatórios).
