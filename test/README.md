<!-- test/README.md -->

# Testes do node-gen

Este diretório concentra os recursos de teste do gerador de código (`gen/`): mock de banco, projeto Nest gerado para validação, testes E2E do gerador e schemas de banco para múltiplos dialetos.

## Estrutura

| Diretório | Descrição |
|-----------|-----------|
| `e2e-generator/` | Testes E2E: executa o gerador contra o mock e valida artefatos. Conexões em `projects/<name>/db/connection.<dbType>.json` (sqlite, mysql, postgres, sqlserver). Contém `run.js`, `db.js`, `e2e.js` e JSONs de config; `db.js` cria mocks SQLite e inicializa Postgres/MySQL/SQL Server. Saída em `output/<project>/<dbType>/` na raiz. DDL/dados por dialeto em `e2e-generator/projects/<name>/db/` (database.{mysql,postgres,sqlite,sqlserver}.ddl e .sql). |

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
node test/e2e-generator/run.js e2e
```

**No diretório do E2E:**

```bash
cd test/e2e-generator && node run.js e2e
```

Se o mock SQLite não existir, o script executa `node test/e2e-generator/db.js --resume` (via e2e.js) para criá-lo antes de rodar o gerador.

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

O ambiente usa `.docker/docker-compose.e2e.yml` e `.docker/Dockerfile.e2e` (Node 20, gen compilado, mock SQLite criado no build via `db.js`). Por padrão são executados **todos os tipos de banco** para os quais existir `connection.<dbType>.json` em cada projeto (`projects/<name>/db/`): SQLite, Postgres, MySQL e/ou SQL Server conforme os arquivos presentes. A variável **`E2E_DB_TYPES`** não restringe a matriz de teste; ela é usada na verificação de acessibilidade dos containers e para decidir quais engines o `db.js` inicializa. Postgres, MySQL e SQL Server são inicializados pelo serviço e2e via `db.js` (descoberta dinâmica por `connection.<engine>.json` e DDL em `projects/<name>/db/`). O diretório `output/` na raiz é montado no container; após `make e2e-run` as aplicações geradas ficam em `output/<project>/<db>/`. O E2E valida: (1) **compilação** — `npm run build` em cada aplicação gerada é obrigatório; (2) **containers** — verificação de que os containers de DB estão acessíveis; (3) **subida da API** — cada app é iniciada em processo (NODE_ENV=production), verifica-se a porta e requisições HTTP; (4) **logs** — mensagem de startup (Nest/Application/listening); (5) **endpoints** — cURL em `/health`, `/version` e em todos os endpoints de módulos (GET); (6) **banco** — confirmação no banco após POST. Loops de espera usam sleep de no máximo 1,5 s por tentativa.

**Foco dos testes:** para cada projeto, são exercitados **todos os `connection.<dbType>.json`** encontrados no diretório `projects/<name>/db/` (tipos permitidos: sqlite, postgres, mysql, sqlserver). A matriz de teste não é restrita por `E2E_DB_TYPES`; essa variável afeta apenas quais containers de DB são aguardados na inicialização (ex.: `E2E_DB_TYPES=postgres,mysql` faz o entrypoint aguardar só Postgres e MySQL). Em ambientes arm64 o container SQL Server pode rodar em emulação; em amd64 o fluxo dos quatro bancos pode ser validado.

### 2. Criar o banco mock (quando necessário)

Para (re)criar os mocks e bancos, na raiz:

```bash
node test/e2e-generator/run.js db
```

Ou apenas SQLite (todos os projetos com connection.sqlite.json):

```bash
E2E_DB_TYPES=sqlite node test/e2e-generator/db.js
```

Gera `test/e2e-generator/mock.sqlite` (projeto todo) e `mock-<project>.sqlite` para os demais, a partir dos DDLs em `projects/<name>/db/`.

### 3. Testes unitários do projeto gerado (opcional)

Após `make e2e-run` (via Docker a app fica em `output/<project>/<db>/`, ex.: `output/e2e-mock-app/sqlite/`) ou após gerar manualmente para `output/<project>/<db>/`, o projeto Nest gerado fica em cada subdiretório. Para rodar os testes Jest dele:

```bash
cd output/e2e-mock-app/sqlite
npm install
npm test
```

Cobertura: `npm run test:cov`. Para outro projeto ou banco, use `output/<project>/<db>/`.

## Ordem sugerida

1. `npm run build` (raiz) — compila o gerador.
2. `node test/e2e-generator/run.js db` (raiz) — cria mocks e bancos, se necessário (ou use `run.js e2e`, que garante mock via db.js --resume).
3. `npm run test:e2e` (raiz) — executa o E2E do gerador (saída em `output/<project>/<db>/`).
4. Opcional: `cd output/e2e-mock-app/sqlite && npm install && npm test` — testes do projeto gerado.

## Referências

- **E2E e mock:** [test/e2e-generator/README.md](e2e-generator/README.md)
