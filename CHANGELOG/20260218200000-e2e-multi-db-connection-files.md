<!-- CHANGELOG/20260218200000-e2e-multi-db-connection-files.md -->

# E2E: conexões por banco e chamada de teste por database

## Data/Hora UTC
2026-02-18 20:00:00

## Arquivos modificados
- `test/e2e-generator-mock/run.js` — descoberta de `connection.<dbType>.json` em `projects/todo/db`, execução de uma chamada e2e por banco, saída em `output/<dbType>/`, artefato de schema dinâmico `db.reader.<dbType>.json`.
- `test/e2e-generator-mock/README.md` — documentação das conexões por banco e do fluxo por dbType.
- `test/e2e-generator-mock/projects/todo/db/connection.sqlite.json` — criado (SQLite).
- `test/e2e-generator-mock/projects/todo/db/connection.mysql.json` — criado (MySQL).
- `test/e2e-generator-mock/projects/todo/db/connection.postgres.json` — criado (PostgreSQL).
- `test/e2e-generator-mock/projects/todo/db/connection.sqlserver.json` — criado (SQL Server).

## Arquivos removidos
- `test/e2e-generator-mock/connection.json` — substituído pelos arquivos em `projects/todo/db/`.

## Regras/requisitos atendidos
- Cobertura de testes expandida com mocks/conexões para todos os bancos previstos em `test/e2e-generator-mock/projects/todo/db` (mysql, postgres, sqlite, sqlserver).
- Uma chamada e2e por database; conexões diferenciadas em arquivos separados: `connection.mysql.json`, `connection.postgres.json`, `connection.sqlite.json`, `connection.sqlserver.json` em `projects/todo/db/`.

## Pendências
- Nenhuma.
