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
	@node gen/dist/main.js -a $$(basename $(or $(GEN_PROJECT),$(PROJECT))) -d $(or $(GEN_PROJECT),$(PROJECT))/db -o $(or $(GEN_OUTPUT),$(OUTPUT)) -t sqlite

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
	@node gen/dist/main.js -a $$(basename $(or $(GEN_PROJECT),$(PROJECT))) -f mfes -d $(or $(GEN_PROJECT),$(PROJECT))/db -o $(or $(GEN_OUTPUT),$(OUTPUT))

# Gera MFE Parcel Paging para um projeto específico
# Uso: make gen-mfe-paging GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output> GEN_DB_TYPE=<postgres|mysql|sqlite>
# Exemplo: make gen-mfe-paging GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts-paging GEN_DB_TYPE=postgres
gen-mfe-paging: gen-mfe-paging-internal
	@:

gen-mfe-paging-internal:
	@echo "📑  Gerando MFE Parcel Paging para $(GEN_PROJECT) em $(GEN_OUTPUT)..."
	@if [ -z "$(GEN_PROJECT)" ] || [ -z "$(GEN_OUTPUT)" ]; then \
		echo "Uso: make gen-mfe-paging GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output> GEN_DB_TYPE=<type>"; \
		echo "Exemplo: make gen-mfe-paging GEN_PROJECT=test/e2e-generator/projects/accounts GEN_OUTPUT=output/accounts-paging GEN_DB_TYPE=postgres"; \
		exit 1; \
	fi
	@DB_TYPE="$${GEN_DB_TYPE:-postgres}"; \
	CONN_FILE="$(GEN_PROJECT)/db/connection.$$DB_TYPE.json"; \
	if [ ! -f "$$CONN_FILE" ]; then echo "Arquivo de conexão não encontrado: $$CONN_FILE"; exit 1; fi; \
	DB_NAME=$$(grep -o '"database":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_HOST=$$(grep -o '"host":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_USER=$$(grep -o '"user":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_PW=$$(grep -o '"password":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_PORT=$$(grep -o '"port":[0-9]*' $$CONN_FILE | cut -d':' -f2); \
	APP_NAME=$$(basename "$(GEN_PROJECT)"); \
	node gen/dist/main.js -a "$$APP_NAME" -f mfe-parcel-paging -d "$$DB_NAME" -o $(GEN_OUTPUT) -t $$DB_TYPE -h "$$DB_HOST" -u "$$DB_USER" -pw "$$DB_PW" -p "$$DB_PORT"

# Gera API + MFE Parcel Paging para um projeto específico (em sequência)
# Uso: make gen-api+paging GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output> GEN_DB_TYPE=<postgres|mysql|sqlite>
# Exemplo: make gen-api+paging GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/addresses GEN_DB_TYPE=postgres
gen-api+paging: gen-api+paging-internal
	@:

gen-api+paging-internal:
	@echo "📦  Gerando API + MFE Parcel Paging..."
	@PROJECT="$(GEN_PROJECT)" && OUTPUT="$(GEN_OUTPUT)" && DB_TYPE="$(GEN_DB_TYPE)" && \
	CONN_FILE="$$PROJECT/db/connection.$${DB_TYPE:-postgres}.json" && \
	if [ ! -f "$$CONN_FILE" ]; then echo "Arquivo de conexão não encontrado: $$CONN_FILE"; exit 1; fi && \
	DB_NAME=$$(grep -o '"database":"[^"]*"' "$$CONN_FILE" | cut -d'"' -f4) && \
	DB_HOST=$$(grep -o '"host":"[^"]*"' "$$CONN_FILE" | cut -d'"' -f4) && \
	DB_USER=$$(grep -o '"user":"[^"]*"' "$$CONN_FILE" | cut -d'"' -f4) && \
	DB_PW=$$(grep -o '"password":"[^"]*"' "$$CONN_FILE" | cut -d'"' -f4) && \
	DB_PORT=$$(grep -o '"port":[0-9]*' "$$CONN_FILE" | cut -d':' -f2) && \
	APP_NAME=$$(basename "$$PROJECT") && \
	echo ">>> Gerando API ($$DB_NAME on $$DB_HOST:$$DB_PORT)..." && \
	node gen/dist/main.js -a "$$APP_NAME" -d "$$DB_NAME" -o "$$OUTPUT" -t "$$DB_TYPE" -f "api-entities,api-services,api-interfaces,api-controllers,api-dtos,api-modules,api-app-module,api-main,api-datasource,api-readme" -h "$$DB_HOST" -u "$$DB_USER" -pw "$$DB_PW" -p "$$DB_PORT" && \
	echo ">>> Gerando MFE Parcel Paging..." && \
	node gen/dist/main.js -a "$$APP_NAME" -f mfe-parcel-paging -d "$$DB_NAME" -o "$$OUTPUT" -t "$$DB_TYPE" -h "$$DB_HOST" -u "$$DB_USER" -pw "$$DB_PW" -p "$$DB_PORT"

# Gera API (NestJS) forçando PostgreSQL para um projeto específico
# Uso: make gen-pg-api GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>
# Exemplo: make gen-pg-api GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/api/postgres/addresses
gen-pg-api: gen-pg-api-internal
	@:

gen-pg-api-internal:
	@echo "📦  Gerando API PostgreSQL para $(GEN_PROJECT) em $(GEN_OUTPUT)..."
	@if [ -z "$(GEN_PROJECT)" ] || [ -z "$(GEN_OUTPUT)" ]; then \
		echo "Uso: make gen-pg-api GEN_PROJECT=<path/project> GEN_OUTPUT=<path/output>"; \
		echo "Exemplo: make gen-pg-api GEN_PROJECT=test/e2e-generator/projects/addresses GEN_OUTPUT=output/api/postgres/addresses"; \
		exit 1; \
	fi
	@CONN_FILE="$(GEN_PROJECT)/db/connection.postgres.json"; \
	if [ ! -f "$$CONN_FILE" ]; then echo "Arquivo de conexão não encontrado: $$CONN_FILE"; exit 1; fi; \
	DB_NAME=$$(grep -o '"database":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_HOST=$$(grep -o '"host":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_USER=$$(grep -o '"user":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_PW=$$(grep -o '"password":"[^"]*"' $$CONN_FILE | cut -d'"' -f4); \
	DB_PORT=$$(grep -o '"port":[0-9]*' $$CONN_FILE | cut -d':' -f2); \
	APP_NAME=$$(basename "$(GEN_PROJECT)"); \
	node gen/dist/main.js -a "$$APP_NAME" -d "$$DB_NAME" -o $(GEN_OUTPUT) -t postgres -f "api-entities,api-services,api-interfaces,api-controllers,api-dtos,api-modules,api-app-module,api-main,api-datasource,api-readme" -h "$$DB_HOST" -u "$$DB_USER" -pw "$$DB_PW" -p "$$DB_PORT"

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

# E2E MFE Parcel Paging
e2e-paging: e2e-dbs e2e-build
	@echo "📑  Executando E2E MFE Parcel Paging para todos os projetos..."
	$(call compose_e2e,run --rm -e E2E_MODE=paging -e E2E_PROJECTS="$(E2E_PROJECTS)" e2e)

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

define e2e-paging-project-target
e2e-paging-$(1):
	@echo "📑  Executando E2E MFE Parcel Paging para projeto $(1)..."
	E2E_MODE=paging E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=paging -e E2E_PROJECTS=$(1) e2e)
endef

define gen-pg-api-project-target
gen-$(1)-pg-api:
	@echo "📦  Gerando API PostgreSQL para projeto $(1)..."
	$(MAKE) gen-pg-api GEN_PROJECT=projects/$(1) GEN_OUTPUT=output/$(1)/postgres
endef

define gen-pg-mfe-app-project-target
gen-$(1)-pg-mfe-app:
	@echo "🎨  Gerando MFE application PostgreSQL para projeto $(1)..."
	$(MAKE) gen-mfe GEN_PROJECT=projects/$(1) GEN_OUTPUT=output/$(1)/postgres
endef

define gen-pg-parcel-paging-project-target
gen-$(1)-pg-parcel-paging:
	@echo "📑  Gerando MFE Parcel Paging PostgreSQL para projeto $(1)..."
	$(MAKE) gen-mfe-paging GEN_PROJECT=projects/$(1) GEN_OUTPUT=output/parcel/postgres/$(1)/mfe-parcel-paging GEN_DB_TYPE=postgres
endef

define e2e-pg-api-project-target
e2e-$(1)-pg-api:
	@echo "🧪  Executando E2E API PostgreSQL para projeto $(1)..."
	$(MAKE) gen-$(1)-pg-api
	E2E_DB_TYPES=postgres $(MAKE) e2e-dbs
	E2E_DB_TYPES=postgres E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=api -e E2E_PROJECTS=$(1) -e E2E_DB_TYPES=postgres e2e)
endef

define e2e-pg-parcel-paging-project-target
e2e-$(1)-pg-parcel-paging:
	@echo "🧪  Executando E2E Parcel Paging PostgreSQL + Playwright para projeto $(1)..."
	$(MAKE) gen-$(1)-pg-api
	$(MAKE) gen-$(1)-pg-parcel-paging
	E2E_DB_TYPES=postgres E2E_PAGING_DB_TYPE=postgres $(MAKE) e2e-dbs
	E2E_DB_TYPES=postgres E2E_PAGING_DB_TYPE=postgres E2E_PROJECTS=$(1) $(MAKE) e2e-build
	$(call compose_e2e,run --rm -e E2E_MODE=paging -e E2E_PROJECTS=$(1) -e E2E_DB_TYPES=postgres -e E2E_PAGING_DB_TYPE=postgres e2e)
	$(MAKE) projects-down
	PLAYWRIGHT_PROJECT=$(1) $(MAKE) playwright-test
endef

define db-pg-project-target
db-pg-$(1):
	@echo "🗄️  Inicializando PostgreSQL para projeto $(1)..."
	E2E_DB_TYPES=postgres $(MAKE) e2e-dbs
	NODE_PATH=gen/node_modules E2E_DB_TYPES=postgres DB_POSTGRES_HOST=127.0.0.1 DB_POSTGRES_PORT=15432 DB_POSTGRES_USER=postgres DB_POSTGRES_PASSWORD=postgres node test/e2e-generator/run.js db $(1)
endef

define db-mysql-project-target
db-mysql-$(1):
	@echo "🗄️  Inicializando MySQL para projeto $(1)..."
	E2E_DB_TYPES=mysql $(MAKE) e2e-dbs
	NODE_PATH=gen/node_modules E2E_DB_TYPES=mysql DB_MYSQL_HOST=127.0.0.1 DB_MYSQL_PORT=13306 DB_MYSQL_USER=e2e DB_MYSQL_PASSWORD=e2e DB_MYSQL_INIT_USER=root DB_MYSQL_INIT_PASSWORD=root node test/e2e-generator/run.js db $(1)
endef

define db-sqlserver-project-target
db-sqlserver-$(1):
	@echo "🗄️  Inicializando SQL Server para projeto $(1)..."
	E2E_DB_TYPES=sqlserver $(MAKE) e2e-dbs
	NODE_PATH=gen/node_modules E2E_DB_TYPES=sqlserver DB_SQLSERVER_HOST=127.0.0.1 DB_SQLSERVER_PORT=11433 DB_SQLSERVER_USER=sa DB_SQLSERVER_PASSWORD=YourStrong@Passw0rd node test/e2e-generator/run.js db $(1)
endef

define db-sqlite-project-target
db-sqlite-$(1):
	@echo "🗄️  Inicializando SQLite para projeto $(1)..."
	NODE_PATH=gen/node_modules E2E_DB_TYPES=sqlite node test/e2e-generator/run.js db $(1)
endef

define demo-pg-project-target
demo-pg-$(1):
	@echo "🚀  Publicando projeto $(1) no fluxo demo PostgreSQL..."
	$(MAKE) demo-pg-up DEMO_PROJECTS="$(1)"
endef

$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-api-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-mfe-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-all-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-paging-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call gen-pg-api-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call gen-pg-mfe-app-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call gen-pg-parcel-paging-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-pg-api-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call e2e-pg-parcel-paging-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call db-pg-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call db-mysql-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call db-sqlserver-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call db-sqlite-project-target,$(p))))
$(foreach p,$(E2E_PROJECTS_LIST),$(eval $(call demo-pg-project-target,$(p))))

# ==============================================================================
# TARGETS DE PROJETOS POSTGRES (legado)
# ==============================================================================

# Detecção de IP público e Domínio
PUBLIC_IP      ?= $(shell curl -fsS https://api.ipify.org 2>/dev/null || echo "127.0.0.1")
PUBLIC_DOMAIN  ?= $(PUBLIC_IP).nip.io
PUBLIC_BASE_URL ?= https://sspa.$(PUBLIC_DOMAIN)

define compose_projects
	PUBLIC_DOMAIN=$(PUBLIC_DOMAIN) VITE_PUBLIC_URL=https://sspa.$(PUBLIC_DOMAIN) VITE_SERVICE_DISCOVERY_URL=https://discovery.$(PUBLIC_DOMAIN) VITE_MFE_BASE_URL=https://sspa.$(PUBLIC_DOMAIN) DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . $(1)
endef

define compose_demo
	PUBLIC_DOMAIN=$(PUBLIC_DOMAIN) DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.demo.yml --project-directory . $(1)
endef

DEMO_PROJECTS ?= addresses contacts orders
DEMO_MFE_BASE_PORT ?= 7100
DEMO_MFE_IMPORT_HOST ?= host.docker.internal
DEMO_MANIFESTS_DIR ?= output/manifests
DEMO_MFE_CONTAINERS_FILE ?= /tmp/nodegen-demo-mfe-containers.txt

demo-up:
	@echo "🚀  Subindo stack demo (sspa + service-discovery)..."
	$(call compose_demo,up -d --build sspa service-discovery)

demo-down:
	@echo "🛑  Parando stack demo..."
	$(call compose_demo,down)

demo-logs:
	@echo "📜  Exibindo logs da stack demo..."
	$(call compose_demo,logs -f sspa service-discovery)

demo-pg-prepare:
	@echo "🧱  Gerando APIs e MFEs PostgreSQL para: $(DEMO_PROJECTS)"
	@for project in $(DEMO_PROJECTS); do \
		$(MAKE) gen-$$project-pg-api; \
		$(MAKE) gen-$$project-pg-mfe-app; \
	done

demo-mfe-down:
	@echo "🧹  Limpando containers MFE do demo..."
	@containers="$$(DOCKER_CONFIG=$(DOCKER_CONFIG) docker ps -aq --filter label=nodegen.demo.mfe=true)"; \
	if [ -n "$$containers" ]; then \
		DOCKER_CONFIG=$(DOCKER_CONFIG) docker rm -f $$containers; \
	fi
	@rm -f $(DEMO_MFE_CONTAINERS_FILE)
	@rm -rf $(DEMO_MANIFESTS_DIR)

demo-mfe-up: demo-mfe-down
	@echo "🌐  Subindo MFEs do demo para: $(DEMO_PROJECTS)"
	@set -e; \
	base_port="$(DEMO_MFE_BASE_PORT)"; \
	current_port="$$base_port"; \
	mkdir -p "$(DEMO_MANIFESTS_DIR)"; \
	for project in $(DEMO_PROJECTS); do \
		frontend_dir="output/$$project/postgres/frontend"; \
		mfe_dir="$$(find "$$frontend_dir" -mindepth 1 -maxdepth 1 -type d -name '*-mfe' ! -name 'app-shell' ! -name '*paging*' | sort | head -n 1)"; \
		if [ -z "$$mfe_dir" ]; then \
			echo "❌  Nenhum MFE encontrado para $$project em $$frontend_dir"; \
			exit 1; \
		fi; \
		dockerfile="$$mfe_dir/Dockerfile"; \
		if [ ! -f "$$dockerfile" ]; then \
			echo "❌  Dockerfile não encontrado em $$mfe_dir"; \
			exit 1; \
		fi; \
		container_port="$$(sed -n 's/^EXPOSE \([0-9][0-9]*\)$$/\1/p' "$$dockerfile" | head -n 1)"; \
		if [ -z "$$container_port" ]; then \
			container_port="$$(sed -n 's/.*listen \([0-9][0-9]*\).*/\1/p' "$$dockerfile" | head -n 1)"; \
		fi; \
		if [ -z "$$container_port" ]; then \
			echo "❌  Porta EXPOSE não encontrada em $$dockerfile"; \
			exit 1; \
		fi; \
		image_name="node-gen-demo-$${project}-mfe:latest"; \
		container_name="nodegen-demo-mfe-$${project}"; \
		manifest_file="$(DEMO_MANIFESTS_DIR)/$${project}.json"; \
		if [ ! -f "$$mfe_dir/package-lock.json" ]; then \
			DOCKER_CONFIG=$(DOCKER_CONFIG) docker run --rm -v "$(PWD)/$$mfe_dir:/app" -w /app node:18-alpine npm install --package-lock-only --ignore-scripts --no-audit --no-fund; \
		fi; \
		DOCKER_CONFIG=$(DOCKER_CONFIG) docker build -t "$$image_name" "$$mfe_dir"; \
		DOCKER_CONFIG=$(DOCKER_CONFIG) docker run -d --name "$$container_name" --label nodegen.demo.mfe=true -p "$${current_port}:$${container_port}" "$$image_name" > /dev/null; \
		echo "$$container_name" >> "$(DEMO_MFE_CONTAINERS_FILE)"; \
		node -e 'const fs = require("fs"); const manifestPath = process.argv[1]; const targetPath = process.argv[2]; const project = process.argv[3]; const host = process.argv[4]; const port = process.argv[5]; let payload = {}; if (fs.existsSync(manifestPath)) { payload = JSON.parse(fs.readFileSync(manifestPath, "utf8")); } const app = { name: payload.name || ("@mfe/" + project), module: payload.module || ("@mfe/" + project), route: "/" + project, title: payload.title || project, description: payload.description || ("MFE " + project), importUrl: "http://" + host + ":" + port + "/spa.js" }; fs.writeFileSync(targetPath, JSON.stringify(app, null, 2) + "\n");' "$$mfe_dir/manifest.json" "$$manifest_file" "$$project" "$(DEMO_MFE_IMPORT_HOST)" "$$current_port"; \
		current_port=$$((current_port + 1)); \
	done

demo-pg-up: demo-pg-prepare demo-mfe-up
	@echo "🚀  Subindo demo com discovery dinâmico para: $(DEMO_PROJECTS)"
	@set -e; \
	resolved_public_url="$(VITE_PUBLIC_URL)"; \
	if [ -z "$$resolved_public_url" ]; then \
		detected_ip="$$(curl -fsS https://api.ipify.org 2>/dev/null || wget -qO- https://api.ipify.org 2>/dev/null || true)"; \
		if [ -n "$$detected_ip" ]; then \
			resolved_public_url="http://$$detected_ip:9000"; \
		else \
			resolved_public_url="http://localhost:9000"; \
		fi; \
	fi; \
	resolved_discovery_url="$(VITE_SERVICE_DISCOVERY_URL)"; \
	if [ -z "$$resolved_discovery_url" ]; then \
		resolved_discovery_url="$$(node -e 'const source = process.argv[1]; const parsed = new URL(source); console.log(parsed.protocol + "//" + parsed.hostname + ":3015");' "$$resolved_public_url")"; \
	fi; \
	resolved_mfe_base_url="$(VITE_MFE_BASE_URL)"; \
	if [ -z "$$resolved_mfe_base_url" ]; then \
		resolved_mfe_base_url="$$resolved_public_url"; \
	fi; \
	VITE_PUBLIC_URL="$$resolved_public_url" VITE_SERVICE_DISCOVERY_URL="$$resolved_discovery_url" VITE_MFE_BASE_URL="$$resolved_mfe_base_url" DISCOVERY_APPS_DIR="/mfe-output/manifests" $(MAKE) demo-up

demo-pg-down:
	@echo "🛑  Parando demo PostgreSQL completo..."
	@$(MAKE) demo-down
	@echo "🛑  Parando stack de APIs/Postgres usada no demo..."
	$(call compose_projects,down)
	@$(MAKE) demo-mfe-down

demo-pg-apis-up:
	@echo "🚀  Subindo Postgres + APIs para consumo dos MFEs do demo..."
	$(call compose_projects,up -d --build postgres-shared apis)
	@echo "⏳  Aguardando healthcheck das APIs dos projetos de DEMO_PROJECTS..."
	@pairs="$$(node -e 'const fs=require("fs"); const path=require("path"); const root="output"; const wanted=(process.argv[1]||"").split(/\s+/).filter(Boolean); const dirs=(fs.existsSync(root)?fs.readdirSync(root):[]).sort(); let port=3001; const mapped=[]; for (const p of dirs){ const pgDir=path.join(root,p,"postgres"); if(!fs.existsSync(pgDir)){ continue; } const hasAppPkg=fs.existsSync(path.join(pgDir,"package.json"))||fs.existsSync(path.join(pgDir,"api","package.json")); if(!hasAppPkg){ continue; } if (wanted.includes(p)){ mapped.push(p+":"+port); } port += 1; } process.stdout.write(mapped.join(" "));' "$(DEMO_PROJECTS)")"; \
	if [ -z "$$pairs" ]; then \
		echo "❌  Não foi possível mapear portas das APIs para DEMO_PROJECTS=$(DEMO_PROJECTS)"; \
		exit 1; \
	fi; \
	for pair in $$pairs; do \
		project="$${pair%%:*}"; \
		port="$${pair##*:}"; \
		echo "⏳  Aguardando API $$project na porta $$port..."; \
		for i in $$(seq 1 180); do \
			code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$port/health" || echo "000"); \
			if [ "$$code" = "200" ]; then \
				echo "✅  API $$project pronta na porta $$port"; \
				break; \
			fi; \
			if [ $$i -eq 180 ]; then \
				echo "❌  Timeout aguardando API $$project na porta $$port"; \
				exit 1; \
			fi; \
			sleep 1; \
		done; \
	done

demo-pg-verify-discovery:
	@echo "🔎  Validando service-discovery e manifests dinâmicos..."
	@curl -fsS http://localhost:3015/health > /dev/null
	@payload="$$(curl -fsS http://localhost:3015/api/discovery/applications)"; \
	printf '%s' "$$payload" | node -e 'const fs=require("fs"); const raw=fs.readFileSync(0,"utf8"); const expected=(process.argv[1]||"").split(/\s+/).filter(Boolean); const data=JSON.parse(raw); if(!Array.isArray(data)||data.length===0){console.error("Nenhuma aplicacao descoberta"); process.exit(1);} const names=new Set(data.map((a)=>String(a.route||"").replace(/^\//,""))); for(const p of expected){ if(!names.has(p)){ console.error("Aplicacao ausente no discovery:", p); process.exit(1);} } console.log("Discovery OK:", data.length, "aplicacao(oes)");' "$(DEMO_PROJECTS)"

demo-pg-e2e:
	@echo "🧪  Executando ciclo completo demo-pg (generate + publish + playwright)..."
	@$(MAKE) demo-pg-down
	@$(MAKE) demo-pg-up DEMO_PROJECTS="$(DEMO_PROJECTS)"
	@$(MAKE) demo-pg-apis-up
	@$(MAKE) demo-pg-verify-discovery DEMO_PROJECTS="$(DEMO_PROJECTS)"
	@PLAYWRIGHT_DB_ASSERT="$${PLAYWRIGHT_DB_ASSERT:-true}" PLAYWRIGHT_DB_LIMIT="$${PLAYWRIGHT_DB_LIMIT:-20}" $(MAKE) playwright-demo-test

projects-build:
	@echo "🛠️  Buildando imagem para projetos PostgreSQL..."
	$(call compose_projects,build)

projects-up:
	@echo "🚀  Subindo todas as APIs PostgreSQL + Proxy Centralizado ($(PUBLIC_DOMAIN))..."
	$(call compose_projects,up -d --build)
	@echo "⏳  Aguardando Proxy ficar acessível..."
	@for i in $(shell seq 1 60); do \
		if curl -sk https://sspa.$(PUBLIC_DOMAIN) > /dev/null 2>&1 || curl -sk http://$(PUBLIC_DOMAIN) > /dev/null 2>&1; then \
			echo "✅  Proxy pronto em https://sspa.$(PUBLIC_DOMAIN)"; \
			break; \
		fi; \
		if [ $$i -eq 60 ]; then \
			echo "❌  Timeout aguardando Proxy ficar pronto"; \
			exit 1; \
		fi; \
		sleep 2; \
	done

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
	@echo "🚀  Subindo stack de projetos para testes Playwright..."
	$(MAKE) projects-up
	@echo "⏳  Aguardando SSPA estar disponível..."
	@for i in $$(seq 1 30); do \
		if curl -s http://localhost:9000 > /dev/null 2>&1; then \
			echo "✅  SSPA disponível na porta 9000"; \
			break; \
		fi; \
		echo "⏳  Aguardando... ($$i/30)"; \
		sleep 2; \
	done
	@echo "⏳  Aguardando API base (porta 3001) estar disponível..."
	@for i in $$(seq 1 300); do \
		if curl -s http://localhost:3001 > /dev/null 2>&1; then \
			echo "✅  API base disponível na porta 3001"; \
			break; \
		fi; \
		if [ $$i -eq 300 ]; then \
			echo "❌  Timeout aguardando API na porta 3001"; \
			exit 1; \
		fi; \
		sleep 2; \
	done
	@echo "ℹ️  Snapshot de disponibilidade das portas 3001-3026 (não bloqueante)..."
	@for p in $$(seq 3001 3026); do \
		if curl -s --connect-timeout 1 --max-time 1 "http://localhost:$$p" > /dev/null 2>&1; then \
			echo "✅  API disponível na porta $$p"; \
		else \
			echo "⚠️  API indisponível na porta $$p no momento da checagem"; \
		fi; \
	done
	@if [ -n "$(PLAYWRIGHT_PROJECT)" ]; then \
		project_port=$$(curl -sS http://localhost:9000/data/projects.json 2>/dev/null | node -e 'const fs=require("fs"); const p=process.argv[1]; try { const d=JSON.parse(fs.readFileSync(0,"utf8")); process.stdout.write(String(d?.[p]?.apiPort ?? "")); } catch { process.stdout.write(""); }' "$(PLAYWRIGHT_PROJECT)"); \
		if [ -n "$$project_port" ]; then \
			echo "⏳  Aguardando API do projeto $(PLAYWRIGHT_PROJECT) na porta $$project_port..."; \
			for i in $$(seq 1 180); do \
				code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$project_port/health" || echo "000"); \
				if [ "$$code" = "200" ]; then \
					echo "✅  API do projeto $(PLAYWRIGHT_PROJECT) disponível na porta $$project_port"; \
					break; \
				fi; \
				if [ $$i -eq 180 ]; then \
					echo "❌  Timeout aguardando API do projeto $(PLAYWRIGHT_PROJECT) na porta $$project_port"; \
					exit 1; \
				fi; \
				sleep 1; \
			done; \
		else \
			echo "⚠️  apiPort não encontrado para PLAYWRIGHT_PROJECT=$(PLAYWRIGHT_PROJECT); usando fallback por qualquer API saudável."; \
			for i in $$(seq 1 180); do \
				healthy_port=""; \
				for p in $$(seq 3001 3026); do \
					code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$p/health" || echo "000"); \
					if [ "$$code" = "200" ]; then healthy_port="$$p"; break; fi; \
				done; \
				if [ -n "$$healthy_port" ]; then \
					echo "✅  API disponível para escopo filtrado na porta $$healthy_port"; \
					break; \
				fi; \
				if [ $$i -eq 180 ]; then \
					echo "❌  Timeout aguardando API com /health=200 para PLAYWRIGHT_PROJECT=$(PLAYWRIGHT_PROJECT)"; \
					exit 1; \
				fi; \
				sleep 1; \
			done; \
		fi; \
	else \
		echo "⏳  Aguardando healthcheck completo das APIs (3001-3026)..."; \
		for i in $$(seq 1 180); do \
			pending=0; \
			for p in $$(seq 3001 3026); do \
				code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$p/health" || echo "000"); \
				if [ "$$code" != "200" ]; then pending=$$((pending + 1)); fi; \
			done; \
			if [ $$pending -eq 0 ]; then \
				echo "✅  Todas as APIs responderam /health com 200"; \
				break; \
			fi; \
			if [ $$i -eq 180 ]; then \
				echo "❌  Timeout aguardando /health=200 em todas as APIs (faltando $$pending)"; \
				exit 1; \
			fi; \
			sleep 1; \
		done; \
	fi

playwright-down:
	@echo "🛑  Parando container SSPA..."
	$(call compose_projects,stop sspa)

playwright-demo-up:
	@echo "🚀  Validando disponibilidade da stack demo para Playwright..."
	@for i in $$(seq 1 60); do \
		if curl -s http://localhost:9000 > /dev/null 2>&1; then \
			echo "✅  SSPA demo disponível na porta 9000"; \
			break; \
		fi; \
		if [ $$i -eq 60 ]; then \
			echo "❌  Timeout aguardando SSPA demo na porta 9000"; \
			exit 1; \
		fi; \
		sleep 1; \
	done
	@curl -fsS http://localhost:3015/health > /dev/null

playwright-demo-test: playwright-install playwright-demo-up
	@echo "🧪  Executando Playwright contra a stack demo..."
	@mkdir -p playwright-report playwright-results test-results
	bash -lc 'set -o pipefail; npx playwright test 2>&1 | tee playwright-results/playwright-run.log; status=$$?; curl -sS http://localhost:9000/data/projects.json > playwright-results/sspa-projects.json 2>/dev/null || true; curl -sS http://localhost:3015/api/discovery/applications > playwright-results/discovery-applications.json 2>/dev/null || true; : > playwright-results/apis-health.log; for p in $$(seq 3001 3026); do code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$p/health" || echo "000"); echo "port=$$p health=$$code" >> playwright-results/apis-health.log; done; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.demo.yml --project-directory . logs --timestamps --tail=400 sspa > playwright-results/containers-demo-sspa.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.demo.yml --project-directory . logs --timestamps --tail=400 service-discovery > playwright-results/containers-demo-discovery.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --timestamps --tail=400 apis > playwright-results/containers-apis.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --timestamps --tail=400 postgres-shared > playwright-results/containers-postgres.log 2>&1 || true; exit $$status'
	@echo "📊  Relatórios demo disponíveis em:"
	@echo "   - HTML: playwright-report/index.html"
	@echo "   - JSON: playwright-results/results.json"
	@echo "   - LOG: playwright-results/playwright-run.log"
	@echo "   - Discovery Apps: playwright-results/discovery-applications.json"
	@echo "   - UI x DB Validation: playwright-results/ui-db-validation.json"
	@echo "   - UI x DB Anomalies: playwright-results/ui-db-validation-anomalies.json"

playwright-test: playwright-install playwright-up
	@echo "🧪  Executando testes Playwright contra $(PUBLIC_BASE_URL)..."
	@mkdir -p playwright-report playwright-results test-results
	bash -lc 'set -o pipefail; PUBLIC_BASE_URL=$(PUBLIC_BASE_URL) npx playwright test 2>&1 | tee playwright-results/playwright-run.log; status=$$?; curl -sS http://localhost:9000/data/projects.json > playwright-results/sspa-projects.json 2>/dev/null || true; : > playwright-results/apis-health.log; for p in $$(seq 3001 3026); do code=$$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 1 --max-time 2 "http://localhost:$$p/health" || echo "000"); echo "port=$$p health=$$code" >> playwright-results/apis-health.log; done; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --timestamps --tail=400 sspa > playwright-results/containers-sspa.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --timestamps --tail=400 apis > playwright-results/containers-apis.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --timestamps --tail=400 postgres-shared > playwright-results/containers-postgres.log 2>&1 || true; DOCKER_CONFIG=$(DOCKER_CONFIG) $(COMPOSE_CMD) -f .docker/docker-compose.projects.postgres.yml --project-directory . ps > playwright-results/containers-ps.log 2>&1 || true; exit $$status'
	@echo "📊  Relatórios disponíveis em:"
	@echo "   - HTML: playwright-report/index.html"
	@echo "   - JSON: playwright-results/results.json"
	@echo "   - LOG: playwright-results/playwright-run.log"
	@echo "   - HTTP Matrix: playwright-results/http-matrix.json"
	@echo "   - HTTP Matrix Anomalies: playwright-results/http-matrix-anomalies.json"
	@echo "   - Card Validation: playwright-results/card-validation.json"
	@echo "   - UI x DB Validation: playwright-results/ui-db-validation.json"
	@echo "   - UI x DB Anomalies: playwright-results/ui-db-validation-anomalies.json"
	@echo "   - SSPA Projects Snapshot: playwright-results/sspa-projects.json"
	@echo "   - APIs Health Snapshot: playwright-results/apis-health.log"
	@echo "   - Containers: playwright-results/containers-*.log"
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
