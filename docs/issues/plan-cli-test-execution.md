<!-- docs/issues/plan-cli-test-execution.md -->

# Plano de execução de testes do CLI

## Contexto e escopo

Este documento descreve como executar e aferir o CLI do gerador node-gen de ponta a ponta (invocação → geração → compilação do projeto gerado) e registrar evidências.

- **Referências:** [EPIC de revisão](plan-issues-epic.md) e [Plano de revisão](template-review-plan.md) (seção "Matriz mínima de cenários de teste da revisão").
- **Objetivo:** validar o CLI e o output gerado, com passos reproduzíveis e critérios de sucesso objetivos.

## Pré-requisitos

- **Build do gerador:** executar `npm run build` na raiz do node-gen; o artefato deve estar em `dist/`.
- **Necessidade de banco (schema):** o fluxo em `src/main.ts` sempre executa um DbReader e persiste o schema em `{outputDir}/db.reader.{dbType}.json`. **Preferência:** usar **SQLite** (em disco ou, quando viável, in-memory) para atender a esse pré-requisito, dispensando servidor de banco. Outros tipos (postgres, mysql, sqlserver) permanecem opções quando necessário. **Limitação:** não existe modo "apenas schema JSON"; em fase posterior pode ser considerado um modo `--schemaFile` que dispense o DbReader.
- **Ambiente:** Node.js compatível; acesso a `npm install` no diretório de output (bloqueios de registry devem ser documentados no registro de execução).

## Atendendo o pré-requisito de banco com SQLite (preferido)

Para atender ao pré-requisito de schema usando **SQLite em disco** (sem servidor de banco):

1. **Criar fixture SQLite em disco:** na raiz do node-gen, com diretório de saída vazio ou dedicado (ex.: `build-cli-test`):
   ```bash
   node scripts/create-sqlite-fixture.js ./build-cli-test
   ```
   Isso gera `{outputDir}/fixture.sqlite` com uma tabela mínima `tb_user` (id, external_id, name, created_at, updated_at).

2. **Executar o CLI com SQLite:** use `-t sqlite` e `-d` com o caminho do arquivo `.sqlite`. Host, porta, usuário e senha são ignorados pelo DbReader SQLite.
   ```bash
   node dist/main.js -a cli-test -h localhost -p 5432 -d ./build-cli-test/fixture.sqlite -u - -pw - -o ./build-cli-test -t sqlite -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
   ```

3. **SQLite in-memory:** o driver SQLite aceita `-d ":memory:"`, porém o banco em memória fica vazio quando o CLI abre a conexão; não há tabelas. Para usar in-memory seria necessário o CLI aceitar um modo que crie o schema em memória antes da leitura (evolução futura). Para testes reproduzíveis, use o fixture em disco acima.

## Invocação do CLI

Opções conforme `src/utils/ConfigUtil.ts`:

| Opção | Descrição |
|-------|-----------|
| `-a, --app` | Nome da aplicação |
| `-h, --host` | Host do banco de dados |
| `-p, --port` | Porta do banco (default: 5432) |
| `-d, --database` | Nome do banco |
| `-u, --user` | Usuário do banco |
| `-pw, --password` | Senha do banco |
| `-o, --outputDir` | Diretório de saída (default: ./build) |
| `-t, --dbType` | Tipo: postgres, mysql, sqlite, sqlserver |
| `-f, --components` | Lista de componentes separados por vírgula |

**Exemplo com Postgres (placeholder):**

```bash
node dist/main.js -a myapp -h localhost -p 5432 -d mydb -u user -pw secret -o ./build-cli-test -t postgres -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

**Exemplo com SQLite em disco (teste sem servidor de banco):**

```bash
node scripts/create-sqlite-fixture.js ./build-cli-test
node dist/main.js -a cli-test -d ./build-cli-test/fixture.sqlite -u - -pw - -o ./build-cli-test -t sqlite -f "entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram"
```

**Ordem de execução interna:** cópia de arquivos estáticos → `dbReader.getSchemaInfo()` (grava schema JSON em `{outputDir}/db.reader.{dbType}.json`) → loop por cada componente solicitado gerando os artefatos.

## Passos de execução (checklist)

1. Garantir que o gerador está compilado: `npm run build` na raiz do node-gen.
2. Definir diretório de saída vazio ou dedicado (ex.: `./build-cli-test`).
3. Executar o CLI com opções válidas para o ambiente (preferir SQLite em disco conforme seção acima; ou outro banco quando necessário; ou, no futuro, schema file se o modo for implementado).
4. Verificar existência do schema JSON em `{outputDir}/db.reader.{dbType}.json` e dos diretórios/arquivos esperados (ex.: `src/app/`, `src/app/entities/`, `.env`, `package.json`, etc.).
5. No diretório gerado: `npm install` (se permitido pelo ambiente) e `npm run build`.
6. (Opcional) `npm run start` ou `npm run start:dev` com timeout para smoke.
7. Registrar comando(s) executados e resultado (sucesso/falha) em CHANGELOG ou em [plan-issues-execution.md](plan-issues-execution.md).

## Matriz mínima de cenários (referência)

Conforme o plano de revisão; usar para orientar quais schemas testar quando houver banco disponível:

- Tabela simples sem relacionamentos.
- Tabela com múltiplas relações e chaves compostas.
- Campos nullable, enum, decimal, datas e UUID/external_id.
- Nomes limítrofes (prefixo `tb_`, snake_case, termos reservados).

Para cada cenário: documentar se foi executado (sim/não) e, em caso de falha, motivo objetivo (ex.: registry 403, TS2688, erro de compilação no output).

## Critérios de sucesso

- CLI termina sem exceção e gera os artefatos dos componentes solicitados.
- Projeto gerado compila (`npm run build` no output) para a combinação de componentes e schema utilizada.
- Evidências registradas (comandos e resultado) em arquivo de execução ou CHANGELOG.

## Rastreabilidade

- **Documentos relacionados:** [plan-issues-epic.md](plan-issues-epic.md), [plan-issues-execution.md](plan-issues-execution.md), [../template-review-plan.md](../template-review-plan.md).
- Ao executar este plano, atualizar o status de "Matriz mínima de cenários" e "Validação automática fim a fim" em [plan-issues-execution.md](plan-issues-execution.md).
