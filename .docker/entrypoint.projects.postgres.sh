#!/bin/bash
# .docker/entrypoint.projects.postgres.sh

set -e

DATABASE_HOST="${DATABASE_HOST:-postgres-shared}"
DATABASE_PORT="${DATABASE_PORT:-5432}"
DATABASE_USER="${DATABASE_USER:-postgres}"
DATABASE_PASSWORD="${DATABASE_PASSWORD:-postgres}"
PROJECTS_SOURCE_DIR="${PROJECTS_SOURCE_DIR:-/projects-source}"
OUTPUT_DIR="${OUTPUT_DIR:-/output}"

echo "[entrypoint] Aguardando PostgreSQL em $DATABASE_HOST:$DATABASE_PORT..."

until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"; do
    echo "[entrypoint] PostgreSQL não está pronto, aguardando..."
    sleep 1
done

echo "[entrypoint] PostgreSQL pronto!"

# ============================================
# 1. Criar bancos de dados (DDL + Seed)
# ============================================
echo "[entrypoint] Descobrindo projetos em $PROJECTS_SOURCE_DIR..."

for project_dir in "$PROJECTS_SOURCE_DIR"/*/db; do
    if [ ! -d "$project_dir" ]; then
        continue
    fi

    project_name=$(basename "$(dirname "$project_dir")")
    ddl_file="$project_dir/database.postgres.ddl"
    sql_file="$project_dir/database.postgres.sql"

    echo "[entrypoint] Processando banco: $project_name"

    # Criar banco de dados se não existir
    psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -tc "SELECT 1 FROM pg_database WHERE datname = '$project_name'" | grep -q 1 || \
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -c "CREATE DATABASE $project_name;"

    # Executar DDL
    if [ -f "$ddl_file" ]; then
        echo "[entrypoint] Executando DDL para $project_name..."
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$project_name" -f "$ddl_file"
    fi

    # Executar SQL de carga
    if [ -f "$sql_file" ]; then
        echo "[entrypoint] Executando seed SQL para $project_name..."
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$project_name" -f "$sql_file"
    fi
done

# ============================================
# 2. Subir APIs NestJS
# ============================================
echo "[entrypoint] Descobrindo projetos NestJS em $OUTPUT_DIR..."

port=3001

for project_dir in "$OUTPUT_DIR"/*/postgres; do
    if [ ! -d "$project_dir" ]; then
        continue
    fi

    if [ ! -f "$project_dir/package.json" ]; then
        echo "[entrypoint] Pulando $project_dir (sem package.json)"
        continue
    fi

    project_name=$(basename "$(dirname "$project_dir")")
    echo "[entrypoint] Processando API: $project_name na porta $port"

    cd "$project_dir"

    # Instalar dependências
    echo "[entrypoint] npm install para $project_name..."
    npm install --legacy-peer-deps --no-audit --ignore-scripts 2>/dev/null

    # Build
    echo "[entrypoint] npm run build para $project_name..."
    npm run build 2>/dev/null

    # Subir microserviço em background
    echo "[entrypoint] Iniciando $project_name na porta $port..."

    PORT=$port \
    DATABASE_HOST="$DATABASE_HOST" \
    DATABASE_PORT="$DATABASE_PORT" \
    DATABASE_NAME="$project_name" \
    DATABASE_USER="$DATABASE_USER" \
    DATABASE_PASSWORD="$DATABASE_PASSWORD" \
    DATABASE_TYPE=postgres \
    node dist/main.js &

    cd /app
    port=$((port + 1))
done

echo "[entrypoint] Todas as APIs iniciadas!"

# ============================================
# 3. Manter container vivo
# ============================================
tail -f /dev/null
