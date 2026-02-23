DOCKER_CONFIG  ?= /tmp/docker-config-noauth
IMAGE          ?= node-gen
DOCKERFILE     ?= .docker/Dockerfile.node-gen

COMPOSE_CMD := $(shell (docker compose version >/dev/null 2>&1 && echo "docker compose") || echo "docker-compose")

define compose_main
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.yml --project-directory . $(1)
endef

define compose_e2e
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.e2e.yml --project-directory . $(1)
endef

build:
	@echo "🛠️  Buildando imagem $(IMAGE):latest via $(DOCKERFILE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker build -t $(IMAGE):latest -f $(DOCKERFILE) .

up:
	@echo "🔼  Iniciando todos os serviços..."
	$(call compose_main,up -d)

down:
	@echo "🛑  Parando e removendo containers..."
	$(call compose_main,down)

logs:
	@echo "📜  Exibindo logs do serviço $(service)..."
	$(call compose_main,logs -f $(service))

shell:
	@echo "🔗  Entrando no container $(IMAGE)..."
	DOCKER_CONFIG=$(DOCKER_CONFIG) docker run -it --rm -v $(PWD):/app $(IMAGE):latest bash

clean:
	@echo "🗑️  Removendo imagens, volumes e containers órfãos..."
	$(call compose_main,down --rmi all --volumes --remove-orphans)

e2e-clean:
	@echo "🧹  Removendo containers e volumes E2E (MySQL/Postgres/SQL Server) para forçar reexecução dos inits..."
	$(call compose_e2e,down -v) 2>/dev/null || true

e2e-build:
	@echo "🛠️  Buildando imagem E2E (node-gen-e2e:latest)..."
	$(call compose_e2e,build)

e2e-run:
	@echo "🧪  Executando testes E2E no container..."
	$(call compose_e2e,run --rm e2e)

e2e: e2e-build e2e-run
