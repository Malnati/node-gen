#!/bin/bash
# .docker/e2e-postgres-init/00-init-extra.sh: create todo_mock, selling_mock and schedule_mock for E2E (schemas in projects/<name>/db)
set -e
E2E_MOCK="${E2E_MOCK:-/e2e-mock}"
# todo_mock already exists (POSTGRES_DB); only apply schema
psql -v ON_ERROR_STOP=1 -d todo_mock -f "$E2E_MOCK/projects/todo/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE selling_mock;"
psql -v ON_ERROR_STOP=1 -d selling_mock -f "$E2E_MOCK/projects/selling/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE schedule_mock;"
psql -v ON_ERROR_STOP=1 -d schedule_mock -f "$E2E_MOCK/projects/schedule/db/schema.postgres.ddl"
