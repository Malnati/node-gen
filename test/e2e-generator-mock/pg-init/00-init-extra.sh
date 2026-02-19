#!/bin/bash
# test/e2e-generator-mock/pg-init/00-init-extra.sh: create todo_mock, selling_mock and schedule_mock for E2E (schemas em projects/<name>/db)
set -e
E2E_MOCK="${E2E_MOCK:-/e2e-mock}"
# todo_mock já existe (POSTGRES_DB); apenas aplica schema
psql -v ON_ERROR_STOP=1 -d todo_mock -f "$E2E_MOCK/projects/todo/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE selling_mock;"
psql -v ON_ERROR_STOP=1 -d selling_mock -f "$E2E_MOCK/projects/selling/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE schedule_mock;"
psql -v ON_ERROR_STOP=1 -d schedule_mock -f "$E2E_MOCK/projects/schedule/db/schema.postgres.ddl"
