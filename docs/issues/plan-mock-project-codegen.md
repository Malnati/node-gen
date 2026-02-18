<!-- docs/issues/plan-mock-project-codegen.md -->

# Plano: projeto mock para testes de geração de código-fonte

## Objetivo

Criar um **projeto mock** dedicado a testar o aplicativo node-gen em **todas as possibilidades de geração**, cobrindo a matriz mínima de cenários do plano de revisão e permitindo validação reproduzível do CLI e dos 13 geradores.

## Contexto e referências

- **Plano de revisão:** [template-review-plan.md](../template-review-plan.md) — ordem dos geradores e matriz mínima de cenários.
- **Teste do CLI:** [plan-cli-test-execution.md](plan-cli-test-execution.md) — execução com SQLite preferido.
- **Execução EPIC/SUBs:** [plan-issues-execution.md](plan-issues-execution.md).
- **Schema existente:** `test/e2e-generator-mock/projects/user/db/` contém DDL/SQL para postgres, mysql, sqlite e sqlserver (tabelas user, project, todo, etc.) com relações e chaves compostas; **não** cobre de forma explícita: prefixo `tb_`, UUID/external_id, enum, decimal, datas, nullable variado, nomes limítrofes.

## Escopo

### Entra

- Definir e implementar um **schema mock** (e, quando aplicável, banco ou artefatos derivados) que cubra:
  1. **Tabela simples** sem relacionamentos.
  2. **Múltiplas relações e chaves compostas.**
  3. **Campos nullable, enum, decimal, datas e UUID/external_id.**
  4. **Nomes limítrofes:** prefixo `tb_`, snake_case, termos que exigem cuidado (ex.: nomes reservados ou que impactam naming nos geradores).
- Preferir **SQLite em disco** para o mock, de forma a não depender de servidor de banco; opcionalmente fornecer equivalente em outros tipos (postgres/mysql) se necessário para testes específicos.
- Fornecer **meio de obter o schema** no formato consumido pelo node-gen: seja criando um banco (ex.: SQLite) e rodando o CLI com o DbReader correspondente, seja (em evolução futura) gerando/fornecendo `db.reader.*.json` diretamente.
- Documentar **como usar o mock** para rodar a geração com cada combinação relevante (todos os componentes, por tipo de banco quando houver) e como aferir o resultado (artefatos gerados, build quando aplicável).
- Integrar com o [plan-cli-test-execution.md](plan-cli-test-execution.md): o mock deve ser utilizável como fonte de schema nesse plano.

### Não entra

- Alterar a lógica dos 13 geradores ou do `main.ts` para implementar o mock (apenas consumir o que o CLI já oferece).
- Garantir que o projeto **gerado** a partir do mock compile e rode sem nenhum ajuste manual (pode haver correções futuras nos geradores; o mock expõe os cenários).
- Suporte a SqlServer no mock, a menos que seja requisito explícito (dependência e ambiente podem ser restritivos).

## Matriz de cenários a cobrir no mock

| Cenário | Objetivo | Exemplo no schema mock |
|---------|----------|-------------------------|
| Tabela simples | Validar geração sem FK/relações | Uma tabela com colunas básicas, sem referências a outras tabelas. |
| Múltiplas relações e chaves compostas | Validar entity/dto/service/datasource com N:1, 1:N, N:N e PK composta | Tabelas com FKs e pelo menos uma tabela de junção com PK (col1, col2). |
| Nullable, enum, decimal, datas, UUID | Validar mapeamento de tipos e validações (interface, dto, entity) | Colunas NULL, tipo enum-like (ex.: TEXT com valores fixos ou equivalente), NUMERIC/DECIMAL, DATE/DATETIME, e coluna UUID ou external_id. |
| Nomes limítrofes | Validar prefixo `tb_`, snake_case e nomes sensíveis | Tabelas com prefixo `tb_`; colunas em snake_case; eventual nome que exija escape ou convenção (ex.: `order` como nome de tabela, se suportado). |

## Proposta de estrutura do projeto mock

- **Localização:** `test/e2e-generator-mock/` (schema, scripts e `mock.sqlite` no mesmo diretório).
- **Conteúdo mínimo:**
  - **Schema:** DDL em `test/e2e-generator-mock/schema.sql` com as tabelas que cobrem a matriz acima.
  - **SQLite:** script `test/e2e-generator-mock/create-db.js` que cria `mock.sqlite` a partir de `schema.sql`.
  - **README ou doc:** descrição das tabelas, dos cenários cobertos e dos comandos para (1) criar o banco mock e (2) rodar o node-gen contra ele (ex.: `-d test/e2e-generator-mock/mock.sqlite -o <out> -t sqlite -f "entities,...,diagram"`).
- **Uso:** quem executa o [plan-cli-test-execution.md](plan-cli-test-execution.md) pode, em vez do fixture mínimo atual (`tb_user`), usar o mock completo para testar todas as possibilidades de geração; ou usar ambos (fixture mínimo para smoke, mock completo para matriz).

## Possibilidades de geração a exercitar

- **Componentes:** entities, services, interfaces, controllers, dtos, modules, app-module, main, env, package.json, readme, datasource, diagram (todos).
- **Tipos de banco:** pelo menos SQLite; opcionalmente Postgres/MySQL se o mock tiver DDL equivalente e ambiente disponível.
- **Combinações:** gerar com todos os componentes de uma vez; eventualmente documentar execuções parciais (ex.: apenas entities + interfaces) para isolar falhas.

## Tarefas técnicas (checklist do plano)

1. Definir estrutura do diretório do mock e convenção de nomes (DDL, script de criação); atualmente em `test/e2e-generator-mock/`.
2. Escrever DDL do schema que atenda aos quatro cenários da matriz (tabela simples; relações e chaves compostas; nullable/enum/decimal/datas/UUID; nomes limítrofes).
3. Fornecer forma de criar o SQLite a partir do DDL (script Node ou comando documentado).
4. Documentar no repositório: (a) objetivo do mock, (b) cenários cobertos, (c) comandos para criar o banco e rodar o CLI, (d) vínculo com plan-cli-test-execution e com a matriz do template-review-plan.
5. (Opcional) Adicionar ao [plan-cli-test-execution.md](plan-cli-test-execution.md) uma seção ou referência ao uso do mock completo para testes da matriz; ou criar um artefato separado (ex.: `plan-cli-test-matrix.md`) que descreva a execução por cenário usando o mock.

## Critérios de sucesso

- Schema mock existe e cobre os quatro itens da matriz mínima de cenários.
- É possível criar um banco (SQLite) a partir do mock e executar o CLI do node-gen com todos os componentes, gerando artefatos para todas as tabelas do schema.
- Documentação permite que um executor reproduza: criação do banco mock → invocação do CLI → verificação dos artefatos (e, quando aplicável, build do projeto gerado).
- Rastreabilidade: plano referenciado em CHANGELOG quando do uso ou criação do mock; referência cruzada com plan-cli-test-execution e template-review-plan.

## Riscos e dependências

- **Dependência:** existência do script ou ferramenta para criar SQLite a partir de DDL (ex.: `sqlite3` CLI ou script Node que execute os DDLs).
- **Risco:** diferenças de tipos entre SQLite e Postgres/MySQL (ex.: enum, UUID nativo) podem exigir variantes de DDL ou documentação de limitações por banco.
- **Risco:** projeto gerado a partir do mock pode não compilar ou rodar sem ajustes (já previsto em “Não entra”); o objetivo é ter schema que **exercite** todas as possibilidades, não necessariamente produzir app final funcional.

## Rastreabilidade

- **Documentos relacionados:** [plan-cli-test-execution.md](plan-cli-test-execution.md), [plan-test-project-generator-vs-mock.md](plan-test-project-generator-vs-mock.md), [template-review-plan.md](../template-review-plan.md), [plan-issues-execution.md](plan-issues-execution.md).
- Ao implementar o mock ou executar testes com ele, registrar em CHANGELOG e, se aplicável, atualizar plan-issues-execution ou plan-cli-test-execution com o uso do mock. O plano [plan-test-project-generator-vs-mock.md](plan-test-project-generator-vs-mock.md) define o projeto em `test/e2e-generator-mock/` para automatizar testes do gerador contra este mock.
