<!-- test/e2e-generator-mock/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte (`gen/`) contra o mock. Não altera o gerador; apenas invoca e valida.

**Parâmetros de entrada dos testes:** os dados de conexão do banco mock vêm de `test/e2e-generator-mock/connection.json` (dbType, database, user, password). O teste usa exclusivamente esses dados para conectar ao mock e invocar o gerador; não há valores de conexão hardcoded no script.

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** em `gen/` executar `npm run build` (ou na raiz do repositório `npm run build`) para gerar `gen/dist/main.js`.
- **Mock disponível:** o script usa os dados de `connection.json` (neste diretório) e cria o banco (`mock.sqlite` neste diretório) automaticamente se não existir (via `node test/e2e-generator-mock/create-db.js`).

## Comandos

Execução a partir da **raiz do repositório** (recomendado):

```bash
node test/e2e-generator-mock/run.js
```

Ou via npm na raiz:

```bash
npm run test:e2e
```

Ou a partir do próprio diretório:

```bash
cd test/e2e-generator-mock && node run.js
```

## O que o script faz

1. **Garantir mock:** verifica se `test/e2e-generator-mock/mock.sqlite` existe; caso contrário, executa `node test/e2e-generator-mock/create-db.js` (que usa `projects/todo/db/schema.sql`).
2. **Executar gerador:** invoca `gen/dist/main.js` com os parâmetros de conexão do mock e todos os componentes; saída em `output/` na raiz do repositório.
3. **Aferir resultados:** valida artefatos (schema JSON, entidades, módulos, etc.) e opcionalmente `npm run build` no output.

## Estrutura

- `package.json` — scripts (`test`, `run`).
- `run.js` — script que executa o fluxo completo.
- `connection.json` — dados de conexão do mock (dbType, database, user, password).
- `projects/todo/db/schema.sql` — DDL SQLite do mock (8 tabelas: N-1, N-N, tipos diversos). Ver [plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- `create-db.js` — cria `mock.sqlite` a partir de `projects/todo/db/schema.sql`.
- `projects/todo/db/create-sqlite-fixture.js` — cria SQLite a partir de `database.sqlite.ddl` em diretório informado; usado pelo teste CLI em disco. Ver [plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
- `mock.sqlite` — banco gerado (criado por `create-db.js`; ignorado pelo git).
- Saída do gerador: `output/` na raiz do repositório (ignorado pelo git).
- `README.md` — este arquivo.

## Referências

- **Plano:** [docs/issues/plan-test-project-generator-vs-mock.md](../../docs/issues/plan-test-project-generator-vs-mock.md).
- **Plano do mock:** [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
