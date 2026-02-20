#!/bin/bash
# test/e2e-generator-mock/pg-init/scripts/00-init-extra.sh: create todo_mock, selling_mock and google_calendar_mock for E2E (schemas in projects/<name>/db)
set -e
E2E_MOCK="${E2E_MOCK:-/e2e-mock}"
# todo_mock already exists (POSTGRES_DB); only apply schema
psql -v ON_ERROR_STOP=1 -d todo_mock -f "$E2E_MOCK/projects/todo/db/database.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE selling_mock;"
psql -v ON_ERROR_STOP=1 -d selling_mock -f "$E2E_MOCK/projects/selling/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE google_calendar_mock;"
psql -v ON_ERROR_STOP=1 -d google_calendar_mock -f "$E2E_MOCK/projects/google-calendar/db/database.postgres.ddl"
