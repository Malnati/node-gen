# /root/w/node-gen/Makefile
DOCKER_CONFIG  ?= /tmp/docker-config-noauth
IMAGE          ?= node-gen
DOCKERFILE     ?= .docker/Dockerfile.node-gen

COMPOSE_CMD := $(shell (docker compose version >/dev/null 2>&1 && echo "docker compose") || echo "docker-compose")

# Processamento de argumentos para alvos E2E
ifeq (e2e,$(firstword $(MAKECMDGOALS)))
  E2E_PROJECTS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(E2E_PROJECTS):;@:)
endif

ifeq (e2e-api,$(firstword $(MAKECMDGOALS)))
  E2E_PROJECTS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(E2E_PROJECTS):;@:)
endif

ifeq (e2e-mfe,$(firstword $(MAKECMDGOALS)))
  E2E_PROJECTS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(E2E_PROJECTS):;@:)
endif

ifeq (e2e-all,$(firstword $(MAKECMDGOALS)))
  E2E_PROJECTS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(E2E_PROJECTS):;@:)
endif

define compose_main
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.yml --project-directory . $(1)
endef

define compose_e2e
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.e2e.yml --project-directory . $(1)
endef

# ==============================================================================
# TARGETS PRINCIPAIS
# ==============================================================================

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

# ==============================================================================
# TARGETS DE GERAÇÃO ISOLADA
# ==============================================================================

# Gera API (NestJS) para um projeto específico
# Uso: make gen GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>
# Exemplo: make gen GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts
# Alternativamente: make gen PROJECT=accounts OUTPUT=output/accounts
gen: gen-internal
	@:

gen-internal:
	@echo "📦  Gerando API para $(or $(GEN_PROJECT),$(PROJECT)) em $(or $(GEN_OUTPUT),$(OUTPUT))..."
	@if [ -z "$(or $(GEN_PROJECT),$(PROJECT))" ] || [ -z "$(or $(GEN_OUTPUT),$(OUTPUT))" ]; then \
		echo "Uso: make gen GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>"; \
		echo "Exemplo: make gen GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts"; \
		echo "Alternativamente: make gen PROJECT=accounts OUTPUT=output/accounts"; \
		exit 1; \
	fi
	@node gen/dist/main.js -a $$(basename $(or $(GEN_PROJECT),$(PROJECT))) -d $$(or $(GEN_PROJECT),$(PROJECT))/db -o $(or $(GEN_OUTPUT),$(OUTPUT)) -t sqlite

# Gera MFE (Micro-frontend) para um projeto específico
# Uso: make gen-mfe GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>
# Exemplo: make gen-mfe GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts-mfe
gen-mfe: gen-mfe-internal
	@:

gen-mfe-internal:
	@echo "🎨  Gerando MFE para $(or $(GEN_PROJECT),$(PROJECT)) em $(or $(GEN_OUTPUT),$(OUTPUT))..."
	@if [ -z "$(or $(GEN_PROJECT),$(PROJECT))" ] || [ -z "$(or $(GEN_OUTPUT),$(OUTPUT))" ]; then \
		echo "Uso: make gen-mfe GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>"; \
		echo "Exemplo: make gen-mfe GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts-mfe"; \
		exit 1; \
	fi
	@node gen/dist/main.js -a $$(basename $(or $(GEN_PROJECT),$(PROJECT))) -f mfes -d $$(or $(GEN_PROJECT),$(PROJECT))/db -o $(or $(GEN_OUTPUT),$(OUTPUT))

# ==============================================================================
# TARGETS E2E — BANCOS DE DADOS
# ==============================================================================

e2e-clean:
	@echo "🧹  Removendo containers e volumes E2E (MySQL/Postgres/SQL Server)..."
	$(call compose_e2e,down -v) 2>/dev/null || true

e2e-dbs:
	@echo "🗄️  Iniciando bancos de dados E2E..."
	$(call compose_e2e,up -d mysql postgres sqlserver)
	@echo "⏳  Aguardando bancos ficarem saudáveis..."
	$(call compose_e2e,ps --format "table {{.Name}}\t{{.Status}}")

e2e-build:
	@echo "🛠️  Buildando imagem E2E (node-gen-e2e:latest)..."
	$(call compose_e2e,build)

# ==============================================================================
# TARGETS E2E — EXECUÇÃO PARALELA
# ==============================================================================

# E2E completo: bancos + API + MFE em paralelo
e2e: e2e-dbs
	@echo "🚀  Executando E2E completo (API + MFE) em paralelo..."
	$(call compose_e2e,run --rm -e E2E_MODE=all -e E2E_PROJECTS="$(E2E_PROJECTS)" e2e)

# E2E apenas API (NestJS)
e2e-api: e2e-dbs e2e-build
	@echo "🔧  Executando E2E API para todos os projetos..."
	$(call compose_e2e,run --rm -e E2E_MODE=api -e E2E_PROJECTS="$(E2E_PROJECTS)" e2e)

# E2E apenas MFE (Micro-frontends)
e2e-mfe: e2e-dbs e2e-build
	@echo "🎨  Executando E2E MFE para todos os projetos..."
	$(call compose_e2e,run --rm -e E2E_MODE=mfe -e E2E_PROJECTS="$(E2E_PROJECTS)" e2e)

# E2E API + MFE em paralelo (mesmo que e2e)
e2e-all: e2e-dbs e2e-build
	@echo "⚡  Executando E2E completo (API + MFE)..."
	$(call compose_e2e,run --rm -e E2E_MODE=all -e E2E_PROJECTS="$(E2E_PROJECTS)" e2e)

# ==============================================================================
# TARGETS E2E POR PROJETO INDIVIDUAL
# ==============================================================================

E2E_PROJECTS_LIST := accounts addresses auth communications config consents contacts gmail google-calendar google-drive llm logistics maps notifications orders payments products reports roles schedule selling tenant todo transactions users warehouse

# Geração dinâmica de alvos por projeto
define e2e-api-project-target
e2e-api-$(1):
	@echo "🔧  Executando E2E API para projeto $(1)..."
	E2E_MODE=api E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=api -e E2E_PROJECTS=$(1) e2e)
endef

define e2e-mfe-project-target
e2e-mfe-$(1):
	@echo "🎨  Executando E2E MFE para projeto $(1)..."
	E2E_MODE=mfe E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=mfe -e E2E_PROJECTS=$(1) e2e)
endef

define e2e-all-project-target
e2e-all-$(1):
	@echo "⚡  Executando E2E completo (API + MFE) para projeto $(1)..."
	E2E_MODE=all E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=all -e E2E_PROJECTS=$(1) e2e)
endef

$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-api-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-mfe-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-all-project-target,$(p))))

# ==============================================================================
# TARGETS DE PROJETOS POSTGRES (legado)
# ==============================================================================

define compose_projects
	DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . $(1)
endef

projects-build:
	@echo "🛠️  Buildando imagem para projetos PostgreSQL..."
	$(call compose_projects,build)

projects-up:
	@echo "🚀  Subindo todas as APIs PostgreSQL..."
	$(call compose_projects,up -d)

projects-down:
	@echo "🛑  Parando todas as APIs PostgreSQL..."
	$(call compose_projects,down)

projects-logs:
	@echo "📜  Exibindo logs de todas as APIs PostgreSQL..."
	$(call compose_projects,logs -f)

projects-restart: projects-down projects-up

# ==============================================================================
# TESTES PLAYWRIGHT SSPA
# ==============================================================================

playwright-install:
	@echo "📦  Instalando dependências Playwright..."
	npm install
	npx playwright install --with-deps chromium

playwright-up:
	@echo "🚀  Subindo container SSPA..."
	$(call compose_projects,up -d sspa)
	@echo "⏳  Aguardando SSPA estar disponível..."
	@for i in $$(seq 1 30); do \
		if curl -s http://localhost:9000 > /dev/null 2>&1; then \
			echo "✅  SSPA disponível na porta 9000"; \
			break; \
		fi; \
		echo "⏳  Aguardando... ($$i/30)"; \
		sleep 2; \
	done

playwright-down:
	@echo "🛑  Parando container SSPA..."
	$(call compose_projects,stop sspa)

playwright-test: playwright-up
	@echo "🧪  Executando testes Playwright..."
	@mkdir -p playwright-report playwright-results test-results
	npx playwright test --reporter=list,html,json
	@echo "📊  Relatórios disponíveis em:"
	@echo "   - HTML: playwright-report/index.html"
	@echo "   - JSON: playwright-results/results.json"
	@echo "   - Screenshots: test-results/"

playwright-test-headed: playwright-up
	@echo "🧪  Executando testes Playwright (headed mode)..."
	npx playwright test --headed

playwright-test-ui: playwright-up
	@echo "🧪  Executando testes Playwright (UI mode)..."
	npx playwright test --ui

playwright-report:
	@echo "📊  Abrindo relatório Playwright..."
	npx playwright show-report

playwright-clean:
	@echo "🧹  Removendo relatórios e resultados..."
	rm -rf playwright-report playwright-results test-results

