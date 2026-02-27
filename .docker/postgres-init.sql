#!/bin/bash
set -e

echo "Configurando PostgreSQL..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER USER postgres PASSWORD 'postgres';
EOSQL

echo "PostgreSQL configurado!"
