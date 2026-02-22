#!/bin/bash
# test/e2e-generator/pg-init/scripts/00-init-extra.sh: create todo, selling and google_calendar for E2E (schemas in projects/<name>/db)
set -e
E2E_MOCK="${E2E_MOCK:-/e2e-mock}"
# todo already exists (POSTGRES_DB); only apply schema
psql -v ON_ERROR_STOP=1 -d todo -f "$E2E_MOCK/projects/todo/db/database.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE selling;"
psql -v ON_ERROR_STOP=1 -d selling -f "$E2E_MOCK/projects/selling/db/schema.postgres.ddl"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE google_calendar;"
psql -v ON_ERROR_STOP=1 -d google_calendar -f "$E2E_MOCK/projects/google-calendar/db/database.postgres.ddl"
