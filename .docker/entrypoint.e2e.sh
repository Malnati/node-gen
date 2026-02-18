#!/bin/bash
# .docker/entrypoint.e2e.sh
set -e
if [ $# -eq 0 ]; then
  export NODE_PATH=/app/gen/node_modules
  node test/e2e-generator-mock/create-db.js 2>/dev/null || true
  export E2E_DB_TYPES="${E2E_DB_TYPES:-sqlite}"
  if echo ",${E2E_DB_TYPES}," | grep -q ',postgres,'; then
    echo "[e2e] Aguardando Postgres em postgres:5432..."
    for i in $(seq 1 60); do
      if (echo >/dev/tcp/postgres/5432) 2>/dev/null; then break; fi
      if [ "$i" -eq 60 ]; then echo "[e2e] Postgres nao respondeu."; exit 1; fi
      sleep 2
    done
    echo "[e2e] Postgres pronto. Criando selling_mock e schedule_mock se necessario..."
    node test/e2e-generator-mock/init-postgres.js 2>/dev/null || true
  fi
  if echo ",${E2E_DB_TYPES}," | grep -q ',mysql,'; then
    echo "[e2e] Aguardando MySQL em mysql:3306..."
    for i in $(seq 1 60); do
      if (echo >/dev/tcp/mysql/3306) 2>/dev/null; then break; fi
      if [ "$i" -eq 60 ]; then echo "[e2e] MySQL nao respondeu."; exit 1; fi
      sleep 2
    done
    echo "[e2e] MySQL pronto."
  fi
  if echo ",${E2E_DB_TYPES}," | grep -q ',sqlserver,'; then
    echo "[e2e] Aguardando SQL Server em sqlserver:1433..."
    for i in $(seq 1 60); do
      if (echo >/dev/tcp/sqlserver/1433) 2>/dev/null; then break; fi
      if [ "$i" -eq 60 ]; then echo "[e2e] SQL Server nao respondeu."; exit 1; fi
      sleep 2
    done
    echo "[e2e] Inicializando SQL Server (schema)..."
    node test/e2e-generator-mock/init-sqlserver.js
  fi
  exec node test/e2e-generator-mock/run.js
fi
exec "$@"
