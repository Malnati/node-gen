-- test/e2e-generator-mock/projects/llm/db/database.sqlite.ddl
-- Log de chamadas LLM por tenant e conta.
CREATE TABLE llm_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT, -- Conta (UUID externo).
  model_name TEXT NOT NULL, -- Nome do modelo.
  prompt TEXT, -- Prompt enviado.
  response TEXT, -- Resposta.
  tokens_used INTEGER DEFAULT 0, -- Tokens utilizados.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Configuração de provedor LLM por tenant.
CREATE TABLE llm_provider_config (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT, -- Conta (UUID externo).
  provider_code TEXT NOT NULL, -- Código do provedor.
  model_id TEXT, -- ID do modelo.
  api_key_ref TEXT, -- Referência à API key.
  fallback_local_endpoint TEXT, -- Endpoint local de fallback.
  routing_priority INTEGER, -- Prioridade de roteamento.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Templates de prompt por tenant.
CREATE TABLE prompt_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  code TEXT NOT NULL, -- Código do template.
  name TEXT, -- Nome.
  content TEXT, -- Conteúdo do prompt.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Log de execução por provedor e modelo.
CREATE TABLE llm_execution_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  provider_config_id TEXT, -- Config do provedor (UUID externo).
  model_id TEXT, -- ID do modelo.
  success INTEGER, -- Sucesso da execução.
  latency_ms INTEGER, -- Latência em ms.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Resumo de uso LLM por período e tenant.
CREATE TABLE llm_usage_summary (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  account_id TEXT, -- Conta (UUID externo).
  provider_config_id TEXT, -- Config do provedor (UUID externo).
  period_start TEXT NOT NULL, -- Início do período.
  period_end TEXT NOT NULL, -- Fim do período.
  total_requests INTEGER DEFAULT 0, -- Total de requisições.
  total_tokens_input INTEGER DEFAULT 0, -- Tokens de entrada.
  total_tokens_output INTEGER DEFAULT 0, -- Tokens de saída.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);
