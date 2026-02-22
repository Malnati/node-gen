<!-- CHANGELOG/20260222140000-compose-e2e-init-neutro-opcao-b.md -->
# Compose E2E com init neutro (Opção B)

**Data/Hora UTC:** 2026-02-22 (estimado).

## Arquivos alterados

- `.docker/docker-compose.e2e.yml` — removida variável `POSTGRES_DB: todo` do serviço postgres; healthcheck alterado de `pg_isready -d todo` para `pg_isready -d postgres`; removidos os volumes do serviço postgres (`pg-init/scripts` e `e2e-mock`). Removida variável `MYSQL_DATABASE: todo` do serviço mysql.

## Objetivo

Deixar o compose sem definir banco de aplicação por projeto: usar apenas o default da engine (Postgres) ou nenhum banco inicial (MySQL). Nenhum script de init em shell no Postgres; todos os projetos são inicializados apenas pelos scripts Node (init-postgres.js, init-mysql.js). Nenhum projeto fica fixado no compose.

## Resultado

- Postgres: sobe com banco default `postgres`; init-postgres.js cria todos os bancos dos projetos e aplica schemas.
- MySQL: sobe sem banco de aplicação; init-mysql.js cria todos os bancos e aplica DDL/dados.
- SQL Server: sem alteração; já neutro.
- O diretório `test/e2e-generator/pg-init/scripts` e o arquivo `00-init-extra.sh` permanecem no repositório (documentação/histórico), mas deixam de ser montados e executados.

## Referências

- Plano: Compose E2E com init neutro (Opção B).
- CHANGELOG 20260222130000-e2e-init-todos-os-projetos.md.
