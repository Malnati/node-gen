<!-- test/e2e-generator-mock/pg-init/README.md -->
# Postgres E2E init

O script de init do Postgres para E2E foi movido para `.docker/e2e-postgres-init/00-init-extra.sh`. Os schemas por projeto ficam em `projects/<name>/db/schema.postgres.ddl`. O `docker-compose.e2e.yml` monta `.docker/e2e-postgres-init` em `/docker-entrypoint-initdb.d` e `test/e2e-generator-mock` em `/e2e-mock`.
