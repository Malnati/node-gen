#!/bin/bash
# .docker/entrypoint.e2e.sh
# E2E_DB_TYPES: usada para decidir quais containers aguardar e quais engines o db.js inicializa.
# A matriz de teste em e2e.js é definida pelos connection.<dbType>.json encontrados em cada projeto.
# E2E_MODE: define o modo de execução (api, mfe, all)
set -e
if [ $# -eq 0 ]; then
  export NODE_PATH=/app/gen/node_modules
  export E2E_DB_TYPES="${E2E_DB_TYPES:-sqlite,postgres,mysql,sqlserver}"
  export E2E_MODE="${E2E_MODE:-api}"
  
  echo "[e2e] Modo de execução: $E2E_MODE"
  
  # Aguardar bancos conforme configuração
  if echo ",${E2E_DB_TYPES}," | grep -q ',postgres,'; then
    echo "[e2e] Aguardando Postgres em postgres:5432..."
    for i in $(seq 1 60); do
      if (echo >/dev/tcp/postgres/5432) 2>/dev/null; then break; fi
      if [ "$i" -eq 60 ]; then echo "[e2e] Postgres não respondeu."; exit 1; fi
      sleep 1.5
    done
  fi
  
  if echo ",${E2E_DB_TYPES}," | grep -q ',mysql,'; then
    echo "[e2e] Aguardando MySQL em mysql:3306..."
    for i in $(seq 1 120); do
      if (echo >/dev/tcp/mysql/3306) 2>/dev/null; then break; fi
      if [ "$i" -eq 120 ]; then echo "[e2e] MySQL não respondeu."; exit 1; fi
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
      if [ "$i" -eq 120 ]; then echo "[e2e] SQL Server não respondeu."; exit 1; fi
      sleep 1.5
    done
  fi
  
  echo "[e2e] Inicializando bancos (db.js)..."
  node test/e2e-generator/run.js db $E2E_PROJECTS 2>/dev/null || true
  
  # Executar testes conforme modo
  echo "[e2e] Executando testes em modo: $E2E_MODE"
  exec node test/e2e-generator/run.js e2e $E2E_PROJECTS
fi
exec "$@"
