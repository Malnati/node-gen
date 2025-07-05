---
name: Adicionar Dockerfiles, entrypoints, docker-compose e Makefile para múltiplos bancos
about: Criação de infraestrutura Docker para SQLite, Postgres, MySQL, SQLServer e ambiente do gerador, com Makefile e exemplos detalhados.
labels: enhancement, docker, infra, test
---

# Objetivo

Criar a infraestrutura Docker para testes automatizados e execução do gerador, incluindo:
- Dockerfiles e entrypoints para SQLite, Postgres, MySQL e SQLServer em `.docker/`
- Dockerfile base e Dockerfile para o gerador
- docker-compose.yml para orquestração
- Makefile para build, up, down, logs, shell, etc.

## Instruções

### 1. Criar Dockerfiles e entrypoints

- Criar os seguintes arquivos:
  - `.docker/Dockerfile.sqlite`
  - `.docker/Dockerfile.postgres`
  - `.docker/Dockerfile.mysql`
  - `.docker/Dockerfile.sqlserver`
  - `.docker/entrypoint.sqlite.sh`
  - `.docker/entrypoint.postgres.sh`
  - `.docker/entrypoint.mysql.sh`
  - `.docker/entrypoint.sqlserver.sh`
  - `.docker/Dockerfile.base` (imagem base com ferramentas mínimas)
  - `.docker/Dockerfile.node-gen` (herda de Dockerfile.base, instala dependências do gerador)
  - `.docker/entrypoint.node-gen.sh` (entrypoint para o gerador)

#### Exemplo de conteúdo para `.docker/Dockerfile.base`:

```dockerfile
FROM ubuntu:22.04

ENV TZ=America/Sao_Paulo
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
        apt-get install -y \
        iproute2 \
        net-tools \
        nmap \
        arp-scan \
        curl \
        ffmpeg \
        gnupg \
        lsb-release \
        sudo \
        tzdata \
        bash \
        coreutils \
        moreutils \
        parallel \
        dnsutils \
        gdal-bin \
        libgl1 \
        libgl1-mesa-glx \
        libspatialindex-dev \
        libgdal-dev \
        libffi-dev \
        liblzma-dev \
        python3-pip \
        git \
        build-essential \
        libbz2-dev \
        libreadline-dev \
        libssl-dev \
        zlib1g-dev \
        libsqlite3-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
    && rm -rf /var/lib/apt/lists/*
```

#### Exemplo de conteúdo para `.docker/Dockerfile.node-gen`:

```dockerfile
FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm install --legacy-peer-deps

FROM download-car-base:latest
WORKDIR /app
COPY --from=build /app /app
RUN npm run build
ENTRYPOINT ["/app/.docker/entrypoint.node-gen.sh"]
```

#### Exemplo de entrypoint:

```bash
#!/bin/bash
set -e
# comandos de inicialização do banco ou do gerador
exec "$@"
```

### 2. Criar docker-compose.yml

- Criar `docker-compose.yml` na raiz do projeto, orquestrando todos os bancos e o gerador.
- Cada serviço deve usar seu respectivo Dockerfile e entrypoint.
- Exemplo de serviços: `sqlite`, `postgres`, `mysql`, `sqlserver`, `node-gen`.

#### Exemplo de trecho para `docker-compose.yml`:

```yaml
version: '3.8'
services:
  sqlite:
    build:
      context: .
      dockerfile: .docker/Dockerfile.sqlite
    entrypoint: ["/app/.docker/entrypoint.sqlite.sh"]
    volumes:
      - ./db:/db
    environment:
      - TZ=America/Sao_Paulo
  postgres:
    build:
      context: .
      dockerfile: .docker/Dockerfile.postgres
    entrypoint: ["/app/.docker/entrypoint.postgres.sh"]
    environment:
      - POSTGRES_PASSWORD=postgres
      - TZ=America/Sao_Paulo
    volumes:
      - ./db:/db
  # ... outros serviços ...
  node-gen:
    build:
      context: .
      dockerfile: .docker/Dockerfile.node-gen
    entrypoint: ["/app/.docker/entrypoint.node-gen.sh"]
    volumes:
      - ./:/app
    depends_on:
      - sqlite
      - postgres
      - mysql
      - sqlserver
```

### 3. Criar Makefile

- Criar `Makefile` na raiz do projeto, inspirado no exemplo abaixo.
- Adaptar comandos para os serviços e imagens do projeto.

#### Exemplo de comandos:

```makefile
DOCKER_CONFIG  ?= /tmp/docker-config-noauth
IMAGE          ?= node-gen
DOCKERFILE     ?= .docker/Dockerfile.node-gen

build:
	@echo "🛠️  Buildando imagem $(IMAGE):latest via $(DOCKERFILE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker build -t $(IMAGE):latest -f $(DOCKERFILE) .

up:
	@echo "🔼  Iniciando todos os serviços..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker compose up -d

down:
	@echo "🛑  Parando e removendo containers..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker compose down

logs:
	@echo "📜  Exibindo logs do serviço $(service)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker compose logs -f $(service)

shell:
	@echo "🔗  Entrando no container $(IMAGE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker run -it --rm -v $(PWD):/app $(IMAGE):latest bash

clean:
	@echo "🗑️  Removendo imagens, volumes e containers órfãos..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker compose down --rmi all --volumes --remove-orphans
```

### 4. Observações

- Todos os arquivos devem ser criados em `.docker/` conforme especificado.
- O `docker-compose.yml` e o `Makefile` devem ficar na raiz do projeto.
- Os entrypoints devem ser scripts shell executáveis.
- Adapte os exemplos conforme a necessidade do projeto.
- Documentar no `README.md` como utilizar a infraestrutura Docker e o Makefile.

---

Se precisar de exemplos mais detalhados para cada arquivo, consulte os arquivos existentes em `.docker/`, `docker-compose.yml` e `Makefile` após a implementação. 