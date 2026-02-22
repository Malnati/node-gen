<!-- CHANGELOG/20260218170000-remove-build-cli-test.md -->

# 2026-02-18 17:00:00 UTC — Remoção de test/build-cli-test

## Objetivo

Consolidar a saída do gerador em `output/` na raiz; o diretório `test/build-cli-test` deixou de ser necessário.

## Alterações

- **Removido:** diretório `test/build-cli-test/` (projeto Nest fixture com tabela `tb_user`, até então usado no fluxo de teste manual do CLI).
- **create-sqlite-fixture.js:** diretório padrão de saída alterado de `build-cli-test` para `output` (quando não se passa argumento).
- **Documentação:** plan-cli-test-execution, plan-issues-execution, plan-test-project-generator-vs-mock, test/README.md, README.md atualizados para usar `output/` no fluxo do teste CLI (fixture mínima e testes do projeto gerado).
- **.gitignore:** removida a entrada `test/build-cli-test/fixture.sqlite`.
- **.dockerignore:** removida a entrada `test/build-cli-test/node_modules`.

## Uso atual

- **Teste CLI (fixture mínima tb_user):** `node test/e2e-generator/create-sqlite-fixture.js ./output` e depois executar o gerador com `-d ./output/fixture.sqlite -o ./output`.
- **Testes do projeto gerado:** após E2E ou geração manual, `cd output && npm install && npm test`.
