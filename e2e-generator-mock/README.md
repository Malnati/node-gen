<!-- e2e-generator-mock/README.md -->

# E2E: testes do gerador contra o mock

## Objetivo

Este projeto orquestra o fluxo **garantir mock → executar node-gen → validar artefatos** para testar o aplicativo gerador de código-fonte contra o aplicativo mock (`mock/` na raiz do repositório). Não altera o node-gen nem o mock; apenas invoca e valida.

## Pré-requisitos

- **Node.js** instalado.
- **Gerador compilado:** na raiz do repositório, executar `npm run build` para gerar `dist/main.js`.
- **Mock disponível:** o script cria `mock/mock.sqlite` automaticamente se não existir (via `node mock/create-db.js`).

## Comandos

Execução a partir da **raiz do repositório** (recomendado):

```bash
node e2e-generator-mock/run.js
```

Ou a partir do próprio diretório:

```bash
cd e2e-generator-mock && node run.js
```

Ou via npm (na raiz, após `cd e2e-generator-mock`):

```bash
cd e2e-generator-mock && npm run test
```

## O que o script faz

1. **Garantir mock:** verifica se `mock/mock.sqlite` existe; caso contrário, executa `node mock/create-db.js` na raiz.
2. **Executar gerador:** invoca `node dist/main.js` com `-d mock/mock.sqlite -o e2e-generator-mock/out -t sqlite` e todos os componentes (entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram).
3. **Aferir resultados:** valida os artefatos gerados e imprime um relatório (Aferição):
   - **Obrigatórios:** existência de `db.reader.sqlite.json`, `src/app/app.module.ts`, `.env`, `package.json`, `README.md`; quantidade e nomes das entidades (5: simple_item, category, product, sale, sale_item); módulos por tabela (5 diretórios com service, controller, module); schema JSON com 5 tabelas.
   - **Opcionais:** `public/diagram.png`; `npm run build` no output (o build do projeto gerado pode falhar por erros de tipo conhecidos; o teste não falha por isso).
   - O script termina com **Resultado: OK** ou **FALHA** e código de saída 1 se algum check obrigatório falhar.

## Estrutura

- `package.json` — nome e scripts (`test`, `run`).
- `run.js` — script único que executa o fluxo completo.
- `out/` — diretório de saída do gerador (gerado pelo script; ignorado pelo git).
- `README.md` — este arquivo.

## Referências

- **Plano deste projeto:** [docs/issues/plan-test-project-generator-vs-mock.md](../docs/issues/plan-test-project-generator-vs-mock.md).
- **Mock:** [mock/README.md](../mock/README.md), [docs/issues/plan-mock-project-codegen.md](../docs/issues/plan-mock-project-codegen.md).
- **Teste manual do CLI:** [docs/issues/plan-cli-test-execution.md](../docs/issues/plan-cli-test-execution.md).
