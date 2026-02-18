<!-- docs/issues/plan-test-project-generator-vs-mock.md -->

# Plano: projeto de testes do gerador contra o mock

## Objetivo

Criar um **novo projeto na raiz do repositório** dedicado a **testar o aplicativo gerador de código-fonte (node-gen) contra o aplicativo mock** (`mock/`). O projeto deve orquestrar a execução do gerador usando o mock como entrada e validar o resultado (artefatos gerados e, quando aplicável, build do output).

## Contexto e referências

- **Gerador:** node-gen (CLI em `dist/main.js`, build com `npm run build` na raiz).
- **Mock:** projeto em `mock/` na raiz: schema em `mock/schema.sql`, banco em `mock/mock.sqlite` (criado por `node mock/create-db.js`). Ver [mock/README.md](../../mock/README.md) e [plan-mock-project-codegen.md](plan-mock-project-codegen.md).
- **Teste manual do CLI:** [plan-cli-test-execution.md](plan-cli-test-execution.md) descreve passos manuais; o novo projeto automatiza e reproduz o fluxo “mock → gerador → validação”.

## Escopo

### Entra

- Definir e implementar um **projeto na raiz do repositório** (diretório próprio, ex.: `e2e-generator-mock/` ou `test-generator-mock/`) que:
  1. **Prepare o mock:** garantir que o banco mock existe (executar `node mock/create-db.js` se necessário ou verificar existência de `mock/mock.sqlite`).
  2. **Execute o gerador:** invocar o CLI do node-gen com o mock como fonte (ex.: `-d ./mock/mock.sqlite -t sqlite -o <diretório de output dedicado>`) e com a lista completa de componentes.
  3. **Valide o resultado:** verificar existência dos artefatos esperados (ex.: `db.reader.sqlite.json`, `src/app/entities/*.ts`, módulos por tabela, `.env`, `package.json`, `README.md`, `public/diagram.png`) e, opcionalmente, executar `npm run build` no projeto gerado e registrar sucesso/falha.
  4. **Seja reproduzível:** scripts ou comandos documentados (npm scripts, Node, ou Makefile conforme convenções do repo) para rodar o fluxo completo.
- Documentar no próprio projeto: objetivo, pré-requisitos (build do node-gen, Node instalado), comandos para rodar os testes e vínculo com o mock e com o plan-cli-test-execution.
- Integrar com a governança: referência em CHANGELOG quando do uso ou criação; referências cruzadas com plan-mock-project-codegen e plan-cli-test-execution.

### Não entra

- Alterar a lógica do node-gen ou do mock para implementar este projeto (apenas invocar e validar).
- Garantir que o projeto **gerado** compile ou rode sem correções nos geradores (a validação pode falhar e ser registrada como evidência).
- Adicionar testes unitários dentro do node-gen; o foco é um projeto separado que testa o gerador de forma ponta a ponta contra o mock.

## Proposta de estrutura do projeto

- **Localização:** diretório na **raiz do repositório** (nome a definir: ex. `e2e-generator-mock/` ou `test-generator-mock/`).
- **Conteúdo mínimo sugerido:**
  - **package.json:** nome do projeto, scripts (ex.: `test` ou `run` que executem o fluxo: criar mock DB → rodar node-gen → validar artefatos).
  - **Scripts de teste:** um ou mais scripts (Node ou comandos documentados) que: (1) garantam `mock/mock.sqlite` (chamada a `mock/create-db.js` ou checagem), (2) chamem `node ../dist/main.js ... -d ../mock/mock.sqlite -o <out>` a partir da raiz do repo ou com caminhos absolutos/relativos corretos, (3) verifiquem presença de arquivos/diretórios esperados no output.
  - **Diretório de output:** usar um subdiretório dentro do projeto (ex.: `e2e-generator-mock/out/`) ou um path fora (ex.: `../build-e2e-mock`) para evitar misturar artefatos gerados com o código do projeto de teste; documentar onde fica o output.
  - **README.md:** objetivo do projeto, pré-requisitos (build do node-gen na raiz), comandos para executar os testes, descrição das validações e referências (mock, plan-cli-test-execution, plan-mock-project-codegen).

## Fluxo de teste (resumo)

1. Na raiz do repo: `npm run build` (node-gen) se ainda não compilado.
2. Garantir mock: `node mock/create-db.js` (ou verificar `mock/mock.sqlite`).
3. Executar gerador: `node dist/main.js -a <app> -d ./mock/mock.sqlite -o <outputDir> -t sqlite -f "entities,...,diagram"` (e opcionalmente `-T ./static`).
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

- **Dependência:** node-gen compilado (`dist/`) e mock disponível (`mock/schema.sql`, `mock/create-db.js`). O projeto de teste assume que está na raiz do mesmo repositório (caminhos relativos para `mock/` e `dist/main.js`).
- **Risco:** paths relativos podem quebrar se o script for executado de outro diretório; documentar que a execução deve ser feita a partir da raiz ou do próprio projeto com caminhos explícitos.
- **Risco:** build do projeto gerado pode falhar (já conhecido); o projeto de teste deve registrar falha sem bloquear a existência da evidência de geração.

## Rastreabilidade

- **Documentos relacionados:** [plan-cli-test-execution.md](plan-cli-test-execution.md), [plan-mock-project-codegen.md](plan-mock-project-codegen.md), [../../mock/README.md](../../mock/README.md).
- Ao implementar o projeto de testes, registrar em CHANGELOG e atualizar, se aplicável, plan-cli-test-execution ou plan-mock-project-codegen com referência ao novo projeto.
