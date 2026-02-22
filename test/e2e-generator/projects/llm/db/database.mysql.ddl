-- test/e2e-generator/projects/llm/db/database.mysql.ddl
CREATE TABLE llm_log (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) COMMENT 'Conta (UUID externo).',
  model_name VARCHAR(255) NOT NULL COMMENT 'Nome do modelo.',
  prompt TEXT COMMENT 'Prompt enviado.',
  response TEXT COMMENT 'Resposta.',
  tokens_used INT DEFAULT 0 COMMENT 'Tokens utilizados.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_llm_log_external_id (external_id)
) COMMENT = 'Log de chamadas LLM por tenant e conta.';

CREATE TABLE llm_provider_config (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) COMMENT 'Conta (UUID externo).',
  provider_code VARCHAR(50) NOT NULL COMMENT 'Código do provedor.',
  model_id VARCHAR(100) COMMENT 'ID do modelo.',
  api_key_ref VARCHAR(255) COMMENT 'Referência à API key.',
  fallback_local_endpoint VARCHAR(500) COMMENT 'Endpoint local de fallback.',
  routing_priority INT COMMENT 'Prioridade de roteamento.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_llm_provider_config_external_id (external_id)
) COMMENT = 'Configuração de provedor LLM por tenant.';

CREATE TABLE prompt_template (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  code VARCHAR(100) NOT NULL COMMENT 'Código do template.',
  name VARCHAR(255) COMMENT 'Nome.',
  content TEXT COMMENT 'Conteúdo do prompt.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_prompt_template_external_id (external_id)
) COMMENT = 'Templates de prompt por tenant.';

CREATE TABLE llm_execution_log (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  provider_config_id CHAR(36) COMMENT 'Config do provedor (UUID externo).',
  model_id VARCHAR(100) COMMENT 'ID do modelo.',
  success TINYINT(1) COMMENT 'Sucesso da execução.',
  latency_ms INT COMMENT 'Latência em ms.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_llm_execution_log_external_id (external_id)
) COMMENT = 'Log de execução por provedor e modelo.';

CREATE TABLE llm_usage_summary (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  account_id CHAR(36) COMMENT 'Conta (UUID externo).',
  provider_config_id CHAR(36) COMMENT 'Config do provedor (UUID externo).',
  period_start DATE NOT NULL COMMENT 'Início do período.',
  period_end DATE NOT NULL COMMENT 'Fim do período.',
  total_requests INT DEFAULT 0 COMMENT 'Total de requisições.',
  total_tokens_input INT DEFAULT 0 COMMENT 'Tokens de entrada.',
  total_tokens_output INT DEFAULT 0 COMMENT 'Tokens de saída.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_llm_usage_summary_external_id (external_id)
) COMMENT = 'Resumo de uso LLM por período e tenant.';
