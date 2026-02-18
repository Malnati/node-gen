<!-- CHANGELOG/20260218210000-e2e-via-docker-sqlite-only.md -->

# E2E Via Docker: apenas SQLite no container e aplicação compila

## Data/Hora UTC
2026-02-18 21:00:00

## Arquivos modificados
- `test/e2e-generator-mock/run.js` — filtro por `E2E_DB_TYPES` (lista separada por vírgula); quando definido, só são executados os db types listados.
- `.docker/entrypoint.e2e.sh` — define `E2E_DB_TYPES=sqlite` por padrão para que no container rode apenas o E2E SQLite (mysql/postgres/sqlserver não estão disponíveis no container).
- `test/README.md` — Via Docker: documentado que só SQLite roda, app em `output/sqlite/`; estrutura e schema em `projects/todo/db/schema.sql`.

## Regras/requisitos atendidos
- Teste da aplicação conforme seção "Via Docker" com `make e2e`, `make e2e-build`, `make e2e-run`.
- Aplicação gerada compila com sucesso; nenhum ajuste em templates foi necessário (estrutura estática mantida).

## Pendências
- Nenhuma.
