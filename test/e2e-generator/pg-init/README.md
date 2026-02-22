<!-- test/e2e-generator/pg-init/README.md -->
# Postgres E2E init

O script de init do Postgres para E2E está em `test/e2e-generator/pg-init/scripts/00-init-extra.sh`. Os schemas por projeto ficam em `projects/<name>/db/schema.postgres.ddl`. O `docker-compose.e2e.yml` monta `pg-init/scripts` em `/docker-entrypoint-initdb.d` e `test/e2e-generator` em `/e2e-mock`.
