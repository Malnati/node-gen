#!/bin/bash
set -e

echo "[sqlserver] Starting SQL Server..."

/opt/mssql/bin/sqlservr &

MAX_ATTEMPTS=180
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    ATTEMPT=$((ATTEMPT + 1))
    
    if [ -f /var/opt/mssql/log/errorlog ]; then
        if grep -qi "cannot start" /var/opt/mssql/log/errorlog 2>/dev/null; then
            echo "[sqlserver] ERROR: Found critical error in logs:"
            tail -10 /var/opt/mssql/log/errorlog
            exit 1
        fi
        
        if grep -qi "SQL Server is now ready for client connections" /var/opt/mssql/log/errorlog 2>/dev/null; then
            echo "[sqlserver] SQL Server is ready (attempt $ATTEMPT)"
            wait
        fi
    fi
    
    echo "[sqlserver] Waiting for SQL Server to be ready... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
    sleep 5
done

echo "[sqlserver] ERROR: Timeout waiting for SQL Server to be ready"
tail -20 /var/opt/mssql/log/errorlog
exit 1
