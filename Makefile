DOCKER_CONFIG  ?= /tmp/docker-config-noauth
IMAGE          ?= node-gen
DOCKERFILE     ?= .docker/Dockerfile.node-gen

build:
	@echo "🛠️  Buildando imagem $(IMAGE):latest via $(DOCKERFILE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker build -t $(IMAGE):latest -f $(DOCKERFILE) .

COMPOSE      ?= docker-compose -f .docker/docker-compose.yml --project-directory .
up:
	@echo "🔼  Iniciando todos os serviços..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE) up -d

down:
	@echo "🛑  Parando e removendo containers..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE) down

logs:
	@echo "📜  Exibindo logs do serviço $(service)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE) logs -f $(service)

shell:
	@echo "🔗  Entrando no container $(IMAGE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker run -it --rm -v $(PWD):/app $(IMAGE):latest bash

clean:
	@echo "🗑️  Removendo imagens, volumes e containers órfãos..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE) down --rmi all --volumes --remove-orphans

COMPOSE_E2E ?= docker-compose -f .docker/docker-compose.e2e.yml --project-directory .
e2e-clean:
	@echo "🧹  Removendo containers e volumes E2E (MySQL/Postgres/SQL Server) para forçar reexecução dos inits..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_E2E) down -v 2>/dev/null || true

e2e-build:
	@echo "🛠️  Buildando imagem E2E (node-gen-e2e:latest)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_E2E) build

e2e-run:
	@echo "🧪  Executando testes E2E no container..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_E2E) run --rm e2e

e2e: e2e-build e2e-run
