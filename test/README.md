<!-- test/README.md -->

# Testes do node-gen

Este diretório concentra os recursos de teste do gerador de código (`gen/`): mock de banco, projeto Nest gerado para validação, testes E2E do gerador e schemas de banco para múltiplos dialetos.

## Estrutura

| Diretório | Descrição |
|-----------|-----------|
| `e2e-generator-mock/` | Testes E2E: executa o gerador contra o mock e valida artefatos. Conexões em `projects/todo/db/connection.<dbType>.json` (sqlite, mysql, postgres, sqlserver). Contém `create-db.js`, `projects/todo/db/schema.sql`, `create-sqlite-fixture.js`, `mock.sqlite` (gerado). Saída em `output/<dbType>/` na raiz. DDL/dados por dialeto em `e2e-generator-mock/projects/todo/db/` (database.{mysql,postgres,sqlite,sqlserver}.ddl e .sql). |

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** na raiz do repositório execute `npm run build` (gera `gen/dist/`).

## Como executar os testes

### 1. Testes E2E do gerador (recomendado)

Valida o fluxo: mock → node-gen → artefatos. O script garante o mock e invoca o gerador; a saída fica em `output/` na raiz do repositório.

**Na raiz do repositório:**

```bash
npm run test:e2e
```

Ou diretamente:

```bash
node test/e2e-generator-mock/run.js
```

**No diretório do E2E:**

```bash
cd test/e2e-generator-mock && node run.js
```

Se `test/e2e-generator-mock/mock.sqlite` não existir, o script executa `node test/e2e-generator-mock/create-db.js` antes de rodar o gerador.

**Via Docker (evita problemas de arquitetura com sqlite3/sharp):**

Na raiz do repositório:

```bash
make e2e
```

Ou apenas build da imagem e depois execução:

```bash
make e2e-build
make e2e-run
```

O ambiente usa `docker-compose.e2e.yml` e `.docker/Dockerfile.e2e` (Node 20, gen compilado, mock criado no build). No container só o SQLite é executado (`E2E_DB_TYPES=sqlite`). O diretório `output/` na raiz é montado no container; após `make e2e-run` a aplicação gerada fica em `output/sqlite/` e o E2E valida que `npm run build` no projeto gerado conclui com sucesso.

### 2. Criar o banco mock (quando necessário)

Para (re)criar apenas o banco mock, na raiz:

```bash
node test/e2e-generator-mock/create-db.js
```

Gera `test/e2e-generator-mock/mock.sqlite` a partir de `test/e2e-generator-mock/projects/todo/db/schema.sql`.

### 3. Testes unitários do projeto gerado (opcional)

Após `make e2e-run` (via Docker a app fica em `output/sqlite/`) ou após gerar manualmente para `output/` ou `output/<dbType>/`, o projeto Nest gerado fica na raiz em `output/` ou em `output/<dbType>/`. Para rodar os testes Jest dele:

```bash
cd output
npm install
npm test
```

Cobertura: `npm run test:cov`.

## Ordem sugerida

1. `npm run build` (raiz) — compila o gerador.
2. `node test/e2e-generator-mock/create-db.js` (raiz) — cria o mock, se ainda não existir.
3. `npm run test:e2e` (raiz) — executa o E2E do gerador contra o mock (saída em `output/`).
4. Opcional: `cd output && npm install && npm test` — testes do projeto gerado.

## Referências

- **E2E e mock:** [test/e2e-generator-mock/README.md](e2e-generator-mock/README.md)
