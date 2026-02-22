-- test/e2e-generator/projects/llm/db/database.postgres.ddl
CREATE TABLE llm_log (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID,
  model_name TEXT NOT NULL,
  prompt TEXT,
  response TEXT,
  tokens_used INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_llm_log PRIMARY KEY (id),
  CONSTRAINT uk_llm_log_external_id UNIQUE(external_id)
);
COMMENT ON TABLE llm_log IS 'Log de chamadas LLM por tenant e conta.';
COMMENT ON COLUMN llm_log.id IS 'Identificador interno.';
COMMENT ON COLUMN llm_log.external_id IS 'UUID público.';
COMMENT ON COLUMN llm_log.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN llm_log.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN llm_log.model_name IS 'Nome do modelo.';
COMMENT ON COLUMN llm_log.prompt IS 'Prompt enviado.';
COMMENT ON COLUMN llm_log.response IS 'Resposta.';
COMMENT ON COLUMN llm_log.tokens_used IS 'Tokens utilizados.';
COMMENT ON COLUMN llm_log.created_at IS 'Data de criação.';
COMMENT ON COLUMN llm_log.updated_at IS 'Última atualização.';
COMMENT ON COLUMN llm_log.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_llm_log ON llm_log IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_llm_log_external_id ON llm_log IS 'UUID único.';

CREATE TABLE llm_provider_config (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID,
  provider_code TEXT NOT NULL,
  model_id TEXT,
  api_key_ref TEXT,
  fallback_local_endpoint TEXT,
  routing_priority INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_llm_provider_config PRIMARY KEY (id),
  CONSTRAINT uk_llm_provider_config_external_id UNIQUE(external_id)
);
COMMENT ON TABLE llm_provider_config IS 'Configuração de provedor LLM por tenant.';
COMMENT ON COLUMN llm_provider_config.id IS 'Identificador interno.';
COMMENT ON COLUMN llm_provider_config.external_id IS 'UUID público.';
COMMENT ON COLUMN llm_provider_config.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN llm_provider_config.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN llm_provider_config.provider_code IS 'Código do provedor.';
COMMENT ON COLUMN llm_provider_config.model_id IS 'ID do modelo.';
COMMENT ON COLUMN llm_provider_config.api_key_ref IS 'Referência à API key.';
COMMENT ON COLUMN llm_provider_config.fallback_local_endpoint IS 'Endpoint local de fallback.';
COMMENT ON COLUMN llm_provider_config.routing_priority IS 'Prioridade de roteamento.';
COMMENT ON COLUMN llm_provider_config.created_at IS 'Data de criação.';
COMMENT ON COLUMN llm_provider_config.updated_at IS 'Última atualização.';
COMMENT ON COLUMN llm_provider_config.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_llm_provider_config ON llm_provider_config IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_llm_provider_config_external_id ON llm_provider_config IS 'UUID único.';

CREATE TABLE prompt_template (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  content TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_prompt_template PRIMARY KEY (id),
  CONSTRAINT uk_prompt_template_external_id UNIQUE(external_id)
);
COMMENT ON TABLE prompt_template IS 'Templates de prompt por tenant.';
COMMENT ON COLUMN prompt_template.id IS 'Identificador interno.';
COMMENT ON COLUMN prompt_template.external_id IS 'UUID público.';
COMMENT ON COLUMN prompt_template.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN prompt_template.code IS 'Código do template.';
COMMENT ON COLUMN prompt_template.name IS 'Nome.';
COMMENT ON COLUMN prompt_template.content IS 'Conteúdo do prompt.';
COMMENT ON COLUMN prompt_template.created_at IS 'Data de criação.';
COMMENT ON COLUMN prompt_template.updated_at IS 'Última atualização.';
COMMENT ON COLUMN prompt_template.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_prompt_template ON prompt_template IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_prompt_template_external_id ON prompt_template IS 'UUID único.';

CREATE TABLE llm_execution_log (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  provider_config_id UUID,
  model_id TEXT,
  success BOOLEAN,
  latency_ms INT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_llm_execution_log PRIMARY KEY (id),
  CONSTRAINT uk_llm_execution_log_external_id UNIQUE(external_id)
);
COMMENT ON TABLE llm_execution_log IS 'Log de execução por provedor e modelo.';
COMMENT ON COLUMN llm_execution_log.id IS 'Identificador interno.';
COMMENT ON COLUMN llm_execution_log.external_id IS 'UUID público.';
COMMENT ON COLUMN llm_execution_log.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN llm_execution_log.provider_config_id IS 'Config do provedor (UUID externo).';
COMMENT ON COLUMN llm_execution_log.model_id IS 'ID do modelo.';
COMMENT ON COLUMN llm_execution_log.success IS 'Sucesso da execução.';
COMMENT ON COLUMN llm_execution_log.latency_ms IS 'Latência em ms.';
COMMENT ON COLUMN llm_execution_log.created_at IS 'Data de criação.';
COMMENT ON COLUMN llm_execution_log.updated_at IS 'Última atualização.';
COMMENT ON COLUMN llm_execution_log.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_llm_execution_log ON llm_execution_log IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_llm_execution_log_external_id ON llm_execution_log IS 'UUID único.';

CREATE TABLE llm_usage_summary (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID,
  provider_config_id UUID,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  total_requests INT DEFAULT 0,
  total_tokens_input INT DEFAULT 0,
  total_tokens_output INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_llm_usage_summary PRIMARY KEY (id),
  CONSTRAINT uk_llm_usage_summary_external_id UNIQUE(external_id)
);
COMMENT ON TABLE llm_usage_summary IS 'Resumo de uso LLM por período e tenant.';
COMMENT ON COLUMN llm_usage_summary.id IS 'Identificador interno.';
COMMENT ON COLUMN llm_usage_summary.external_id IS 'UUID público.';
COMMENT ON COLUMN llm_usage_summary.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN llm_usage_summary.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN llm_usage_summary.provider_config_id IS 'Config do provedor (UUID externo).';
COMMENT ON COLUMN llm_usage_summary.period_start IS 'Início do período.';
COMMENT ON COLUMN llm_usage_summary.period_end IS 'Fim do período.';
COMMENT ON COLUMN llm_usage_summary.total_requests IS 'Total de requisições.';
COMMENT ON COLUMN llm_usage_summary.total_tokens_input IS 'Tokens de entrada.';
COMMENT ON COLUMN llm_usage_summary.total_tokens_output IS 'Tokens de saída.';
COMMENT ON COLUMN llm_usage_summary.created_at IS 'Data de criação.';
COMMENT ON COLUMN llm_usage_summary.updated_at IS 'Última atualização.';
COMMENT ON COLUMN llm_usage_summary.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_llm_usage_summary ON llm_usage_summary IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_llm_usage_summary_external_id ON llm_usage_summary IS 'UUID único.';
