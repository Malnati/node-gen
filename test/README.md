<!-- test/README.md -->

# Testes do node-gen

Este diretório concentra os recursos de teste do gerador de código (`gen/`): mock de banco, projeto Nest gerado para validação, testes E2E do gerador e schemas de banco para múltiplos dialetos.

## Estrutura

| Diretório | Descrição |
|-----------|-----------|
| `e2e-generator/` | Testes E2E: executa o gerador contra o mock e valida artefatos. Conexões em `projects/todo/db/connection.<dbType>.json` (sqlite, mysql, postgres, sqlserver). Contém `create-db.js`, `projects/todo/db/schema.sql`, `create-sqlite-fixture.js`, `mock.sqlite` (gerado). Saída em `output/<project>/<dbType>/` na raiz (ex.: `output/e2e-mock-app/sqlite/`). DDL/dados por dialeto em `e2e-generator/projects/todo/db/` (database.{mysql,postgres,sqlite,sqlserver}.ddl e .sql). |

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
node test/e2e-generator/run.js
```

**No diretório do E2E:**

```bash
cd test/e2e-generator && node run.js
```

Se `test/e2e-generator/mock.sqlite` não existir, o script executa `node test/e2e-generator/create-db.js` antes de rodar o gerador.

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

O ambiente usa `.docker/docker-compose.e2e.yml` e `.docker/Dockerfile.e2e` (Node 20, gen compilado, mock criado no build). Por padrão são executados **todos os tipos de banco** para os quais existir `connection.<dbType>.json` em cada projeto (`projects/<name>/db/`): SQLite, Postgres, MySQL e/ou SQL Server conforme os arquivos presentes. A variável **`E2E_DB_TYPES`** não restringe mais a matriz de teste; ela é usada apenas na verificação inicial de acessibilidade dos containers (quais DBs aguardar antes de rodar). As verificações de porta e de health usam loops com timeout de no máximo 1,5 s por tentativa. O serviço `postgres` sobe com schemas em `projects/<name>/db/schema.postgres.ddl` (init em `test/e2e-generator/pg-init/scripts/00-init-extra.sh`); o `mysql` com `projects/<name>/db/schema.mysql.sql` e `projects/<name>/db/init.mysql.sql` para selling/schedule; o `sqlserver` é inicializado via `init-sqlserver.js` com `schema.sqlserver.ddl` em cada `projects/<name>/db/`. O diretório `output/` na raiz é montado no container; após `make e2e-run` as aplicações geradas ficam em `output/<project>/<db>/` (ex.: `output/e2e-mock-app/sqlite/`, `output/e2e-mock-app/postgres/`, etc.). O E2E valida: (1) **compilação** — `npm run build` em cada aplicação gerada é obrigatório e deve concluir com sucesso; (2) **containers** — verificação de que os containers de DB (Postgres, MySQL, SQL Server) estão acessíveis antes de rodar; (3) **subida da API** — cada app é iniciada em processo (NODE_ENV=production), verifica-se a porta de escuta e requisições HTTP; (4) **logs** — os logs (stdout/stderr) da API devem conter mensagem de startup (Nest/Application/listening); (5) **endpoints** — cURL em `/health`, `/version` e em todos os endpoints de módulos (GET); (6) **banco** — após execução do endpoint de criação (POST), confirmação no banco de que o dado foi persistido. Loops de espera usam sleep de no máximo 1,5 s por tentativa.

**Foco dos testes:** para cada projeto, são exercitados **todos os `connection.<dbType>.json`** encontrados no diretório `projects/<name>/db/` (tipos permitidos: sqlite, postgres, mysql, sqlserver). A matriz de teste não é restrita por `E2E_DB_TYPES`; essa variável afeta apenas quais containers de DB são aguardados na inicialização (ex.: `E2E_DB_TYPES=postgres,mysql` faz o entrypoint aguardar só Postgres e MySQL). Em ambientes arm64 o container SQL Server pode rodar em emulação; em amd64 o fluxo dos quatro bancos pode ser validado.

### 2. Criar o banco mock (quando necessário)

Para (re)criar apenas o banco mock, na raiz:

```bash
node test/e2e-generator/create-db.js
```

Gera `test/e2e-generator/mock.sqlite` a partir de `test/e2e-generator/projects/todo/db/schema.sql`.

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
2. `node test/e2e-generator/create-db.js` (raiz) — cria o mock, se ainda não existir.
3. `npm run test:e2e` (raiz) — executa o E2E do gerador contra o mock (saída em `output/<project>/<db>/`).
4. Opcional: `cd output/e2e-mock-app/sqlite && npm install && npm test` — testes do projeto gerado.

## Referências

- **E2E e mock:** [test/e2e-generator/README.md](e2e-generator/README.md)
