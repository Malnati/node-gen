<!-- docs/issues/plan-test-project-generator-vs-mock.md -->

# Plano: projeto de testes do gerador contra o mock

## Objetivo

Criar um **projeto de testes** dedicado a **testar o aplicativo gerador de código-fonte (node-gen) contra o aplicativo mock**. O projeto deve orquestrar a execução do gerador usando o mock como entrada e validar o resultado (artefatos gerados e, quando aplicável, build do output). **Estrutura atual:** gerador em `gen/`, testes e mock em `test/` (ex.: `test/mock/`, `test/e2e-generator/`); saída do gerador em `output/` na raiz.

## Contexto e referências

- **Gerador:** node-gen em `gen/` (CLI em `gen/dist/main.js`, build com `npm run build` em `gen/` ou na raiz).
- **Mock:** schema e scripts em `test/e2e-generator/` (`schema.sql`, `create-db.js` cria `mock.sqlite`). Ver [test/e2e-generator/README.md](../../test/e2e-generator/README.md) e [plan-mock-project-codegen.md](plan-mock-project-codegen.md).
- **Teste manual do CLI:** [plan-cli-test-execution.md](plan-cli-test-execution.md) descreve passos manuais; o novo projeto automatiza e reproduz o fluxo “mock → gerador → validação”.

## Escopo

### Entra

- Definir e implementar um **projeto de testes** em `test/` (ex.: `test/e2e-generator/`) que:
  1. **Prepare o mock:** garantir que o banco mock existe (executar `node test/e2e-generator/create-db.js` se necessário ou verificar existência de `test/e2e-generator/mock.sqlite`).
  2. **Execute o gerador:** invocar o CLI do node-gen (`gen/dist/main.js`) com o mock como fonte (ex.: `-d test/e2e-generator/mock.sqlite -t sqlite -o <output dedicado>`) e com a lista completa de componentes.
  3. **Valide o resultado:** verificar existência dos artefatos esperados (ex.: `db.reader.sqlite.json`, `src/app/entities/*.ts`, módulos por tabela, `.env`, `package.json`, `README.md`, `public/diagram.png`) e, opcionalmente, executar `npm run build` no projeto gerado e registrar sucesso/falha.
  4. **Seja reproduzível:** scripts ou comandos documentados (npm scripts, Node, ou Makefile conforme convenções do repo) para rodar o fluxo completo.
- Documentar no próprio projeto: objetivo, pré-requisitos (build do node-gen, Node instalado), comandos para rodar os testes e vínculo com o mock e com o plan-cli-test-execution.
- Integrar com a governança: referência em CHANGELOG quando do uso ou criação; referências cruzadas com plan-mock-project-codegen e plan-cli-test-execution.

### Não entra

- Alterar a lógica do node-gen ou do mock para implementar este projeto (apenas invocar e validar).
- Garantir que o projeto **gerado** compile ou rode sem correções nos geradores (a validação pode falhar e ser registrada como evidência).
- Adicionar testes unitários dentro do node-gen; o foco é um projeto separado que testa o gerador de forma ponta a ponta contra o mock.

## Proposta de estrutura do projeto

- **Localização:** diretório em **`test/`** (ex.: `test/e2e-generator/`).
- **Conteúdo mínimo sugerido:**
  - **package.json:** nome do projeto, scripts (ex.: `test` ou `run` que executem o fluxo: criar mock DB → rodar node-gen → validar artefatos).
  - **Scripts de teste:** um ou mais scripts que: (1) garantam `test/e2e-generator/mock.sqlite` (chamada a `node test/e2e-generator/create-db.js` ou checagem), (2) chamem `gen/dist/main.js` com `-d test/e2e-generator/mock.sqlite -o <out>` (caminhos a partir da raiz do repo), (3) verifiquem presença dos artefatos esperados no output.
  - **Diretório de output:** `output/` na raiz do repositório.
  - **README.md:** objetivo, pré-requisitos (build do node-gen em `gen/`), comandos e referências (test/e2e-generator, plan-cli-test-execution, plan-mock-project-codegen).

## Fluxo de teste (resumo)

1. Em `gen/` ou na raiz: `npm run build` (node-gen) se ainda não compilado.
2. Garantir mock: `node test/e2e-generator/create-db.js` (ou verificar `test/e2e-generator/mock.sqlite`).
3. Executar gerador: `node gen/dist/main.js -a <app> -d test/e2e-generator/mock.sqlite -o <outputDir> -t sqlite -f "entities,...,diagram"` (a partir da raiz; ou `cd gen && node dist/main.js ...` com caminhos relativos a `gen/`).
4. Validar: existência de schema JSON, entidades, módulos por tabela, env, package.json, readme, datasource, diagram; opcionalmente `npm run build` em `<outputDir>`.
5. Registrar resultado (sucesso/falha) em saída do script ou em relatório (ex.: console, arquivo de resultado).

## Tarefas técnicas (checklist do plano)

1. Definir nome do diretório do projeto na raiz e criar a estrutura (package.json, README, diretório para scripts ou config).
2. Implementar passo “garantir mock”: script ou comando que cria `mock/mock.sqlite` se não existir (invocando `node mock/create-db.js` a partir da raiz).
3. Implementar passo “executar gerador”: invocação do CLI do node-gen com parâmetros fixos (mock como `-d`, output dedicado, todos os componentes).
4. Implementar passo “validar”: checagem de existência dos artefatos esperados (lista mínima documentada); opcionalmente execução de `npm run build` no output e registro do resultado.
5. Documentar no projeto: README com objetivo, pré-requisitos, comandos e referências ao mock e aos planos (plan-cli-test-execution, plan-mock-project-codegen).
6. Registrar em CHANGELOG a criação do projeto e, se aplicável, adicionar referência em plan-cli-test-execution ou plan-mock-project-codegen ao novo projeto de testes.

## Critérios de sucesso

- Projeto existe na raiz do repositório com estrutura definida (package.json, scripts, README).
- É possível executar o fluxo “garantir mock → executar gerador → validar” com um comando ou sequência documentada.
- A validação verifica de forma objetiva a presença dos artefatos gerados (e opcionalmente o build do output).
- Documentação permite que um executor reproduza os testes sem alterar node-gen ou mock.
- Rastreabilidade: plano e projeto referenciados em CHANGELOG; referências cruzadas com mock e com planos de CLI e mock.

## Riscos e dependências

- **Dependência:** node-gen compilado (`gen/dist/`) e mock disponível (`test/e2e-generator/schema.sql`, `test/e2e-generator/create-db.js`). O projeto de teste assume execução a partir da raiz do repositório (caminhos para `gen/` e `test/e2e-generator/`).
- **Risco:** paths relativos podem quebrar se o script for executado de outro diretório; documentar que a execução deve ser feita a partir da raiz ou do próprio projeto com caminhos explícitos.
- **Risco:** build do projeto gerado pode falhar (já conhecido); o projeto de teste deve registrar falha sem bloquear a existência da evidência de geração.

## Rastreabilidade

- **Documentos relacionados:** [plan-cli-test-execution.md](plan-cli-test-execution.md), [plan-mock-project-codegen.md](plan-mock-project-codegen.md), [../../test/e2e-generator/README.md](../../test/e2e-generator/README.md).
- Ao implementar o projeto de testes, registrar em CHANGELOG e atualizar, se aplicável, plan-cli-test-execution ou plan-mock-project-codegen com referência ao novo projeto.
