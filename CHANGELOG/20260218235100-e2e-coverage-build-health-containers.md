<!-- CHANGELOG/20260218235100-e2e-coverage-build-health-containers.md -->

# Changelog — Cobertura E2E: build obrigatório, API e health

**Data/Hora (UTC):** 2026-02-18 23:51:00

## Arquivos modificados

- `test/e2e-generator-mock/run.js` — Build obrigatório; verificação de subida da API (porta, /health, logs); main async; leitura de PORT do .env sem capturar DATABASE_PORT.
- `gen/static/Dockerfile` — Novo: imagem Node 20 para build e execução da aplicação gerada.
- `gen/static/docker-compose.yaml` — Uso de `Dockerfile` na raiz; remoção de `version`; envs para microservice.
- `gen/src/typeorm-entity-generator.ts` — Inclusão de colunas que são primary key na geração da entidade mesmo quando são colunas de relação (composite PK, ex.: booking_participant).
- `gen/static/src/app/health/health.service.ts` — Em produção, checkMe() usa apenas indicador de banco (sem ping ao Swagger), para /health retornar 200 quando a API está no ar.
- `test/README.md` — Documentação da nova cobertura (build, API, health).
- `test/e2e-generator-mock/README.md` — Menção à verificação de API e /health.

## Regras/requisitos atendidos

- Todos os aplicativos gerados devem compilar sem erros (build obrigatório no E2E).
- Containers/aplicações geradas sobem com suas APIs: E2E sobe o processo da app (NODE_ENV=production), verifica porta e curl em /health.
- Testes verificam logs (stdout/stderr em falha) e uso de requisição HTTP para endpoint de saúde.
- Foco em MySQL, SQLServer, Postgres e SQLite (já cobertos por `E2E_DB_TYPES` e run.js).
- Ajustes apenas em templates e gen/static (Dockerfile, docker-compose); estrutura estática mantida.
- Timeouts definidos (API_START_TIMEOUT_MS, PORT_POLL_MS, HEALTH_REQUEST_TIMEOUT_MS) para não esperar em excesso.

## Pendências

- Nenhuma.
