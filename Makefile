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
