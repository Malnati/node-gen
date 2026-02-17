<!-- CHANGELOG/20260217235500-mock-project-codegen-execution.md -->

# 2026-02-17 23:55:00 UTC — Execução do plano: projeto mock para testes de geração

## Arquivos modificados
- `mock/schema.sql` — criado (DDL SQLite cobrindo matriz: tabela simples, relações e chave composta, nullable/decimal/datas/external_id, prefixo tb_ e snake_case).
- `mock/create-db.js` — criado (script Node que gera mock/mock.sqlite a partir de schema.sql).
- `mock/README.md` — criado (objetivo, cenários, comandos, referências ao plano e ao plan-cli-test-execution).
- `docs/issues/plan-cli-test-execution.md` — adicionada seção "Uso do projeto mock (matriz completa)" e referência a plan-mock-project-codegen.md.
- `.gitignore` — ignorar `mock/mock.sqlite` e `build-mock-test/` (banco e output de teste gerados).
- `CHANGELOG/20260217235500-mock-project-codegen-execution.md` — este arquivo.

## Regras e requisitos atendidos
- Execução do [plan-mock-project-codegen.md](docs/issues/plan-mock-project-codegen.md): diretório `mock/` na raiz; schema com quatro cenários da matriz; script para criar SQLite; documentação e vínculos.
- Critérios de sucesso: schema existe e cobre os quatro itens; é possível criar o banco e executar o CLI com todos os componentes; documentação reproduzível; rastreabilidade com plan-cli-test-execution e template-review-plan.

## Comandos executados e resultado
- `node mock/create-db.js` — sucesso (mock/mock.sqlite criado).
- `node dist/main.js -a mock-app -d ./mock/mock.sqlite -o ./build-mock-test -t sqlite -f "entities,...,diagram"` — sucesso (artefatos gerados para tb_simple_item, tb_category, tb_product, tb_sale, tb_sale_item).

## Resultado resumido
- Projeto mock implementado em `mock/`; geração com todos os componentes validada; plan-cli-test-execution atualizado com uso do mock para matriz completa.
