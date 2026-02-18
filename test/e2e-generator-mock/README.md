<!-- test/e2e-generator-mock/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte (`gen/`) contra o mock (`test/mock/`). Não altera o gerador nem o mock; apenas invoca e valida.

**Parâmetros de entrada dos testes:** os dados de conexão do banco mock vêm de `test/mock/connection.json` (dbType, database, user, password). O teste usa exclusivamente esses dados para conectar ao mock e invocar o gerador; não há valores de conexão hardcoded no script.

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** em `gen/` executar `npm run build` (ou na raiz do repositório `npm run build`) para gerar `gen/dist/main.js`.
- **Mock disponível:** o script usa os dados de `test/mock/connection.json` e cria o banco (`test/mock/mock.sqlite`) automaticamente se não existir (via `node test/mock/create-db.js`).

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

1. **Garantir mock:** verifica se `test/mock/mock.sqlite` existe; caso contrário, executa `node test/mock/create-db.js`.
2. **Executar gerador:** invoca `gen/dist/main.js` com os parâmetros de conexão do mock e todos os componentes; saída em `test/e2e-generator-mock/out/`.
3. **Aferir resultados:** valida artefatos (schema JSON, entidades, módulos, etc.) e opcionalmente `npm run build` no output.

## Estrutura

- `package.json` — scripts (`test`, `run`).
- `run.js` — script que executa o fluxo completo.
- `out/` — saída do gerador (ignorado pelo git).
- `README.md` — este arquivo.

## Referências

- **Plano:** [docs/issues/plan-test-project-generator-vs-mock.md](../../docs/issues/plan-test-project-generator-vs-mock.md).
- **Mock:** [test/mock/README.md](../mock/README.md), [docs/issues/plan-mock-project-codegen.md](../../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../../docs/issues/plan-cli-test-execution.md).
