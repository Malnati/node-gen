<!-- test/README.md -->

# Testes do node-gen

Este diretório concentra os recursos de teste do gerador de código (`gen/`): mock de banco, projeto Nest gerado para validação, testes E2E do gerador e schemas de banco para múltiplos dialetos.

## Estrutura

| Diretório | Descrição |
|-----------|-----------|
| `mock/` | Schema SQLite do mock (`schema.sql`). Scripts de criação do banco e `mock.sqlite` ficam em `e2e-generator-mock/`. |
| `e2e-generator-mock/` | Testes E2E: executa o gerador contra o mock e valida artefatos. Contém `connection.json`, `create-db.js`, `create-sqlite-fixture.js`, `mock.sqlite` (gerado). Saída do gerador em `output/` na raiz do repositório. |
| `build-cli-test/` | Projeto Nest gerado (fixture) para testes manuais e unitários do código gerado. |
| `db/` | DDL e dados de exemplo para PostgreSQL, MySQL, SQLite e SQL Server (referência e testes por dialeto). |

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

O ambiente usa `docker-compose.e2e.yml` e `.docker/Dockerfile.e2e` (Node 20, gen compilado, mock criado no build). O diretório `output/` na raiz do repositório é montado no container; após `make e2e-run` a aplicação gerada fica em `output/` e o E2E valida que `npm run build` no projeto gerado conclui com sucesso.

### 2. Criar o banco mock (quando necessário)

Para (re)criar apenas o banco mock, na raiz:

```bash
node test/e2e-generator-mock/create-db.js
```

Gera `test/e2e-generator-mock/mock.sqlite` a partir de `test/mock/schema.sql`.

### 3. Testes unitários do projeto gerado (build-cli-test)

O projeto em `test/build-cli-test/` é um Nest gerado; você pode rodar os testes Jest dele:

```bash
cd test/build-cli-test
npm install
npm test
```

Cobertura:

```bash
npm run test:cov
```

## Ordem sugerida

1. `npm run build` (raiz) — compila o gerador.
2. `node test/e2e-generator-mock/create-db.js` (raiz) — cria o mock, se ainda não existir.
3. `npm run test:e2e` (raiz) — executa o E2E do gerador contra o mock.
4. Opcional: `cd test/build-cli-test && npm install && npm test` — testes do projeto gerado.

## Referências

- **E2E:** [test/e2e-generator-mock/README.md](e2e-generator-mock/README.md)
- **Mock:** [test/mock/README.md](mock/README.md)
- **Projeto gerado (fixture):** [test/build-cli-test/README.md](build-cli-test/README.md)
