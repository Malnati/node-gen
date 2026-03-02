#!/bin/bash
# .docker/entrypoint.projects.postgres.sh

set -e

DATABASE_HOST="${DATABASE_HOST:-postgres-shared}"
DATABASE_PORT="${DATABASE_PORT:-5432}"
DATABASE_USER="${DATABASE_USER:-postgres}"
DATABASE_PASSWORD="${DATABASE_PASSWORD:-postgres}"
DATABASE_DB="${DATABASE_DB:-postgres}"
PROJECTS_SOURCE_DIR="${PROJECTS_SOURCE_DIR:-/projects-source}"
OUTPUT_DIR="${OUTPUT_DIR:-/output}"

export PGPASSWORD="$DATABASE_PASSWORD"

echo "[entrypoint] Aguardando PostgreSQL em $DATABASE_HOST:$DATABASE_PORT..."

until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER"; do
    echo "[entrypoint] PostgreSQL não está pronto, aguardando..."
    sleep 1
done

echo "[entrypoint] PostgreSQL pronto!"

# Configurar autenticação trust para localhost
echo "[entrypoint] Configurando autenticação..."
psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '$DATABASE_PASSWORD';" 2>/dev/null || true

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

    # Sanitizar nome do banco (hifens não são permitidos sem aspas)
    safe_db_name="$project_name"
    quoted_db_name="$project_name"

    echo "[entrypoint] Processando banco: $project_name"

    # Criar banco de dados se não existir (usar nome entre aspas para hifens)
    psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_DB" -tc "SELECT 1 FROM pg_database WHERE datname = '$project_name'" | grep -q 1 || \
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_DB" -c "CREATE DATABASE \"$project_name\";"

    # Executar DDL (ignorar erros para continuar com outros projetos)
    if [ -f "$ddl_file" ]; then
        echo "[entrypoint] Executando DDL para $project_name..."
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$project_name" -f "$ddl_file" 2>/dev/null || \
            echo "[entrypoint] DDL para $project_name falhou (ignorando)"
    fi

    # Executar SQL de carga (ignorar erros para continuar com outros projetos)
    if [ -f "$sql_file" ]; then
        echo "[entrypoint] Executando seed SQL para $project_name..."
        psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$project_name" -f "$sql_file" 2>/dev/null || \
            echo "[entrypoint] Seed SQL para $project_name falhou (ignorando)"
    fi
done

# ============================================
# 2. Build de todas as APIs NestJS primeiro
# ============================================
echo "[entrypoint] Fazendo build de todas as APIs em $OUTPUT_DIR..."

for project_dir in "$OUTPUT_DIR"/*/postgres; do
    if [ ! -d "$project_dir" ]; then
        continue
    fi

    if [ ! -f "$project_dir/package.json" ]; then
        continue
    fi

    project_name=$(basename "$(dirname "$project_dir")")
    cd "$project_dir"

    # Instalar dependências (apenas se necessário)
    if [ ! -d "node_modules" ]; then
        echo "[entrypoint] Instalando dependências da API: $project_name"
        npm install --legacy-peer-deps --no-audit --ignore-scripts 2>/dev/null
    fi

    if [ -f "dist/main.js" ]; then
        echo "[entrypoint] Build já existente para API: $project_name"
    else
        echo "[entrypoint] Buildando API: $project_name"
        npm run build 2>/dev/null
    fi

    cd /app
done

echo "[entrypoint] Todos os builds concluídos!"

# ============================================
# 3. Iniciar todas as APIs NestJS
# ============================================
echo "[entrypoint] Iniciando todas as APIs..."

port=3001

for project_dir in "$OUTPUT_DIR"/*/postgres; do
    if [ ! -d "$project_dir" ]; then
        continue
    fi

    if [ ! -f "$project_dir/package.json" ]; then
        continue
    fi

    project_name=$(basename "$(dirname "$project_dir")")
    
    cd "$project_dir"

    # Atualizar arquivo .env com variáveis corretas (usar .env.local para ter prioridade)
    echo "DATABASE_HOST=$DATABASE_HOST" > .env.local
    echo "DATABASE_PORT=$DATABASE_PORT" >> .env.local
    echo "DATABASE_NAME=$project_name" >> .env.local
    echo "DATABASE_USER=$DATABASE_USER" >> .env.local
    echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" >> .env.local
    echo "DATABASE_TYPE=postgres" >> .env.local
    echo "DATABASE_PATH=" >> .env.local
    echo "ENDPOINT_SESSION_TOKEN=https://localhost/session/verify" >> .env.local
    echo "ENDPOINT_SESSION_HEALTHCHECK=https://localhost/health" >> .env.local
    echo "MICROSERVICE_NAME=$project_name" >> .env.local
    echo "HOST=0.0.0.0" >> .env.local
    echo "PORT=$port" >> .env.local

    # Copiar para .env também
    cp .env.local .env

    # Subir microserviço em background
    echo "[entrypoint] Iniciando $project_name na porta $port..."

    env \
    PORT="$port" \
    HOST="0.0.0.0" \
    NODE_ENV=production \
    DATABASE_HOST="$DATABASE_HOST" \
    DATABASE_PORT="$DATABASE_PORT" \
    DATABASE_NAME="$project_name" \
    DATABASE_USER="$DATABASE_USER" \
    DATABASE_PASSWORD="$DATABASE_PASSWORD" \
    DATABASE_TYPE=postgres \
    nohup node dist/main.js > /tmp/$project_name.log 2>&1 &

    # Aguardar a API iniciar
    sleep 2

    cd /app
    port=$((port + 1))
done

echo "[entrypoint] Todas as APIs iniciadas!"

# ============================================
# 4. Manter container vivo
# ============================================
tail -f /dev/null
