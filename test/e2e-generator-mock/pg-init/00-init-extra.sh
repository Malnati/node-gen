#!/bin/bash
# pg-init/00-init-extra.sh: create todo_mock, selling_mock and schedule_mock for E2E
set -e
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE todo_mock;"
psql -v ON_ERROR_STOP=1 -d todo_mock -f /docker-entrypoint-initdb.d/01-schema.sql
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE selling_mock;"
psql -v ON_ERROR_STOP=1 -d selling_mock -f /docker-entrypoint-initdb.d/scripts/selling.ddl
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE schedule_mock;"
psql -v ON_ERROR_STOP=1 -d schedule_mock -f /docker-entrypoint-initdb.d/scripts/schedule.ddl
