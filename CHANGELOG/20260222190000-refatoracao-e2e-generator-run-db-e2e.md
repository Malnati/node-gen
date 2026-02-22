<!-- CHANGELOG/20260222190000-refatoracao-e2e-generator-run-db-e2e.md -->
# Changelog — Refatoração e2e-generator em run/db/e2e (2026-02-22 19:00:00 UTC)

## Arquivos alterados

- **Criados:** `test/e2e-generator/run.json`, `test/e2e-generator/db.json`, `test/e2e-generator/db.js`, `test/e2e-generator/e2e.json`, `test/e2e-generator/e2e.js`
- **Modificados:** `test/e2e-generator/run.js` (reduzido a orquestrador), `test/e2e-generator/README.md`, `.docker/entrypoint.e2e.sh`, `.docker/Dockerfile.e2e`, `README.md`, `test/README.md`, `test/e2e-generator/pg-init/README.md`
- **Removidos:** `test/e2e-generator/init-mysql.js`, `test/e2e-generator/init-postgres.js`, `test/e2e-generator/init-sqlserver.js`, `test/e2e-generator/create-db.js`, `test/e2e-generator/apply-ddl-comments.js`

## Regras/requisitos atendidos

- Consolidação dos seis arquivos originais em seis novos: run.js, run.json, db.js, db.json, e2e.js, e2e.json.
- run.js: executa db.js ou e2e.js para todos os projetos ou para os informados em parâmetro.
- db.js: criação, carga ou testes de bancos (SQLite, Postgres, MySQL, SQL Server); modos full (padrão) e incremental (--resume); opção --load e --apply-comments.
- e2e.js: geração, aferição de artefatos e testes de endpoints; constantes e PROJECT_EXPECTED em e2e.json.
- Constantes e hardcodes migrados para run.json, db.json e e2e.json conforme plano.
- Criação de bancos verifica o que já existe e segue de onde parou no modo incremental; padrão permanece limpar tudo e executar completamente.

## Comandos executados

- Nenhum comando de build ou teste foi executado nesta entrega (apenas alterações de código e documentação).

## Pendências relevantes

- Nenhuma.
