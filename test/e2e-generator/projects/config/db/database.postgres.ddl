-- test/e2e-generator/projects/config/db/database.postgres.ddl
CREATE TABLE config (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  config_key TEXT NOT NULL,
  config_value TEXT,
  value_type TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_config PRIMARY KEY (id),
  CONSTRAINT uk_config_external_id UNIQUE(external_id)
);

COMMENT ON TABLE config IS 'Configurações chave-valor por tenant.';
COMMENT ON COLUMN config.id IS 'Identificador interno.';
COMMENT ON COLUMN config.external_id IS 'UUID público.';
COMMENT ON COLUMN config.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN config.config_key IS 'Chave da configuração.';
COMMENT ON COLUMN config.config_value IS 'Valor.';
COMMENT ON COLUMN config.value_type IS 'Tipo do valor.';
COMMENT ON COLUMN config.created_at IS 'Data de criação.';
COMMENT ON COLUMN config.updated_at IS 'Última atualização.';
COMMENT ON COLUMN config.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_config ON config IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_config_external_id ON config IS 'UUID único.';

CREATE TABLE integration_config (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  integration_code TEXT NOT NULL,
  endpoint_url TEXT,
  credentials_ref TEXT,
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_integration_config PRIMARY KEY (id),
  CONSTRAINT uk_integration_config_external_id UNIQUE(external_id)
);

COMMENT ON TABLE integration_config IS 'Configuração de integrações por tenant.';
COMMENT ON COLUMN integration_config.id IS 'Identificador interno.';
COMMENT ON COLUMN integration_config.external_id IS 'UUID público.';
COMMENT ON COLUMN integration_config.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN integration_config.integration_code IS 'Código da integração.';
COMMENT ON COLUMN integration_config.endpoint_url IS 'URL do endpoint.';
COMMENT ON COLUMN integration_config.credentials_ref IS 'Referência às credenciais.';
COMMENT ON COLUMN integration_config.enabled IS 'Integração ativa.';
COMMENT ON COLUMN integration_config.created_at IS 'Data de criação.';
COMMENT ON COLUMN integration_config.updated_at IS 'Última atualização.';
COMMENT ON COLUMN integration_config.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_integration_config ON integration_config IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_integration_config_external_id ON integration_config IS 'UUID único.';

CREATE TABLE webhook (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  url TEXT NOT NULL,
  event_type TEXT,
  secret_hash TEXT,
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_webhook PRIMARY KEY (id),
  CONSTRAINT uk_webhook_external_id UNIQUE(external_id)
);

COMMENT ON TABLE webhook IS 'Webhooks por tenant.';
COMMENT ON COLUMN webhook.id IS 'Identificador interno.';
COMMENT ON COLUMN webhook.external_id IS 'UUID público.';
COMMENT ON COLUMN webhook.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN webhook.url IS 'URL de callback.';
COMMENT ON COLUMN webhook.event_type IS 'Tipo de evento.';
COMMENT ON COLUMN webhook.secret_hash IS 'Hash do segredo.';
COMMENT ON COLUMN webhook.enabled IS 'Webhook ativo.';
COMMENT ON COLUMN webhook.created_at IS 'Data de criação.';
COMMENT ON COLUMN webhook.updated_at IS 'Última atualização.';
COMMENT ON COLUMN webhook.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_webhook ON webhook IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_webhook_external_id ON webhook IS 'UUID único.';

CREATE TABLE branding (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  name TEXT,
  logo_url TEXT,
  logo_ref TEXT,
  favicon_url TEXT,
  primary_color VARCHAR(20),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_branding PRIMARY KEY (id),
  CONSTRAINT uk_branding_external_id UNIQUE(external_id)
);

COMMENT ON TABLE branding IS 'Identidade visual por tenant.';
COMMENT ON COLUMN branding.id IS 'Identificador interno.';
COMMENT ON COLUMN branding.external_id IS 'UUID público.';
COMMENT ON COLUMN branding.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN branding.name IS 'Nome da marca.';
COMMENT ON COLUMN branding.logo_url IS 'URL do logo.';
COMMENT ON COLUMN branding.logo_ref IS 'Referência ao logo.';
COMMENT ON COLUMN branding.favicon_url IS 'URL do favicon.';
COMMENT ON COLUMN branding.primary_color IS 'Cor primária.';
COMMENT ON COLUMN branding.created_at IS 'Data de criação.';
COMMENT ON COLUMN branding.updated_at IS 'Última atualização.';
COMMENT ON COLUMN branding.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_branding ON branding IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_branding_external_id ON branding IS 'UUID único.';

CREATE TABLE label (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  code TEXT NOT NULL,
  value TEXT NOT NULL,
  locale VARCHAR(10),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_label PRIMARY KEY (id),
  CONSTRAINT uk_label_external_id UNIQUE(external_id)
);

COMMENT ON TABLE label IS 'Labels de internacionalização por tenant.';
COMMENT ON COLUMN label.id IS 'Identificador interno.';
COMMENT ON COLUMN label.external_id IS 'UUID público.';
COMMENT ON COLUMN label.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN label.code IS 'Código do label.';
COMMENT ON COLUMN label.value IS 'Valor do texto.';
COMMENT ON COLUMN label.locale IS 'Locale (ex.: pt-BR).';
COMMENT ON COLUMN label.created_at IS 'Data de criação.';
COMMENT ON COLUMN label.updated_at IS 'Última atualização.';
COMMENT ON COLUMN label.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_label ON label IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_label_external_id ON label IS 'UUID único.';
