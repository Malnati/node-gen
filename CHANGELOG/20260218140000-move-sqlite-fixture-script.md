<!-- CHANGELOG/20260218140000-move-sqlite-fixture-script.md -->

# 2026-02-18 14:00:00 UTC — Script de fixture SQLite movido para test/mock

## Alterações

- **Removido:** `scripts/create-sqlite-fixture.js`
- **Criado:** `test/mock/create-sqlite-fixture.js` (mesmo conteúdo; comentário de caminho atualizado)

## Motivo

Colocar o script de criação do fixture SQLite junto aos demais mocks em `test/mock/` (schema.sql, create-db.js, connection.json).

## Referências atualizadas

- `docs/issues/plan-cli-test-execution.md`: comandos passam a usar `node test/mock/create-sqlite-fixture.js`
- `docs/issues/plan-issues-execution.md`: tabela e texto com `node test/mock/create-sqlite-fixture.js`

## Uso (inalterado)

Na raiz do repositório:

```bash
node test/mock/create-sqlite-fixture.js ./test/build-cli-test
# ou
node test/mock/create-sqlite-fixture.js ./build-cli-test
```
