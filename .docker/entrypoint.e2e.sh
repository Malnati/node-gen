#!/bin/bash
# .docker/entrypoint.e2e.sh
set -e
if [ $# -eq 0 ]; then
  export NODE_PATH=/app/gen/node_modules
  node test/e2e-generator-mock/create-db.js 2>/dev/null || true
  export E2E_DB_TYPES="${E2E_DB_TYPES:-sqlite}"
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
