#!/bin/bash
# .docker/entrypoint.e2e.sh
# E2E_DB_TYPES: usada para decidir quais containers aguardar e quais engines o db.js inicializa.
# A matriz de teste em e2e.js é definida pelos connection.<dbType>.json encontrados em cada projeto.
set -e
if [ $# -eq 0 ]; then
  export NODE_PATH=/app/gen/node_modules
  export E2E_DB_TYPES="${E2E_DB_TYPES:-sqlite,postgres,mysql,sqlserver}"
  if echo ",${E2E_DB_TYPES}," | grep -q ',postgres,'; then
    echo "[e2e] Aguardando Postgres em postgres:5432..."
    for i in $(seq 1 60); do
      if (echo >/dev/tcp/postgres/5432) 2>/dev/null; then break; fi
      if [ "$i" -eq 60 ]; then echo "[e2e] Postgres nao respondeu."; exit 1; fi
      sleep 1.5
    done
  fi
  if echo ",${E2E_DB_TYPES}," | grep -q ',mysql,'; then
    echo "[e2e] Aguardando MySQL em mysql:3306..."
    for i in $(seq 1 120); do
      if (echo >/dev/tcp/mysql/3306) 2>/dev/null; then break; fi
      if [ "$i" -eq 120 ]; then echo "[e2e] MySQL nao respondeu."; exit 1; fi
      sleep 1.5
    done
  fi
  if echo ",${E2E_DB_TYPES}," | grep -q ',sqlserver,'; then
    echo "[e2e] Aguardando SQL Server em sqlserver:1433..."
    for i in $(seq 1 120); do
      if (echo >/dev/tcp/sqlserver/1433) 2>/dev/null; then
        sleep 5
        if node -e "
          const mssql = require('mssql');
          mssql.connect({server: 'sqlserver', user: 'sa', password: 'YourStrong@Passw0rd', database: 'master', options: {trustServerCertificate: true}}).then(() => {console.log('OK'); process.exit(0);}).catch(() => {process.exit(1);});
        " 2>/dev/null; then
          break
        fi
      fi
      if [ "$i" -eq 120 ]; then echo "[e2e] SQL Server nao respondeu."; exit 1; fi
      sleep 1.5
    done
  fi
  echo "[e2e] Inicializando bancos (db.js)..."
  node test/e2e-generator/db.js 2>/dev/null || true
  exec node test/e2e-generator/run.js e2e $E2E_PROJECTS
fi
exec "$@"
