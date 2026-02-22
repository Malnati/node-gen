<!-- CHANGELOG/20260218180000-remove-test-mock-dir.md -->

# 2026-02-18 18:00:00 UTC — Remoção do diretório test/mock

## Objetivo

Concentrar todo o mock (schema e scripts) em `test/e2e-generator/`; o diretório `test/mock/` deixou de ser necessário.

## Alterações

- **Movido:** `test/mock/schema.sql` → `test/e2e-generator/schema.sql` (comentário de caminho atualizado).
- **Removido:** diretório `test/mock/` (README.md e schema.sql; o schema foi movido antes da remoção).
- **create-db.js:** passa a ler `schema.sql` do próprio diretório (`path.join(__dirname, 'schema.sql')`).
- **Documentação:** README.md (raiz e test/), test/e2e-generator/README.md, docs/issues (plan-cli-test-execution, plan-test-project-generator-vs-mock, plan-mock-project-codegen) atualizados para não referenciar `test/mock/`; schema e mock descritos como estando em `test/e2e-generator/`.

## Estrutura de teste atual

- **test/e2e-generator/** — schema.sql, connection.json, create-db.js, create-sqlite-fixture.js, run.js, mock.sqlite (gerado); saída do gerador em `output/` na raiz.
- **test/db/** — DDL e dados de exemplo por dialeto (PostgreSQL, MySQL, etc.); movido para `test/e2e-generator/projects/user/db/` em 20260218190000.
