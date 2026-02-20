-- test/e2e-generator-mock/projects/communications/db/database.postgres.ddl
CREATE TABLE email_template (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_email_template PRIMARY KEY (id),
  CONSTRAINT uk_email_template_external_id UNIQUE(external_id)
);

COMMENT ON TABLE email_template IS 'Templates de e-mail por tenant.';
COMMENT ON COLUMN email_template.id IS 'Identificador interno.';
COMMENT ON COLUMN email_template.external_id IS 'UUID público.';
COMMENT ON COLUMN email_template.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN email_template.code IS 'Código do template.';
COMMENT ON COLUMN email_template.name IS 'Nome.';
COMMENT ON COLUMN email_template.subject_tpl IS 'Template do assunto.';
COMMENT ON COLUMN email_template.body_tpl IS 'Template do corpo.';
COMMENT ON COLUMN email_template.created_at IS 'Data de criação.';
COMMENT ON COLUMN email_template.updated_at IS 'Última atualização.';
COMMENT ON COLUMN email_template.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_email_template ON email_template IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_email_template_external_id ON email_template IS 'UUID único.';

CREATE TABLE smtp_config (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID,
  host TEXT NOT NULL,
  port INT DEFAULT 587,
  use_tls BOOLEAN DEFAULT true,
  credentials_ref TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_smtp_config PRIMARY KEY (id),
  CONSTRAINT uk_smtp_config_external_id UNIQUE(external_id)
);

COMMENT ON TABLE smtp_config IS 'Configuração SMTP por tenant/conta.';
COMMENT ON COLUMN smtp_config.id IS 'Identificador interno.';
COMMENT ON COLUMN smtp_config.external_id IS 'UUID público.';
COMMENT ON COLUMN smtp_config.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN smtp_config.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN smtp_config.host IS 'Host SMTP.';
COMMENT ON COLUMN smtp_config.port IS 'Porta.';
COMMENT ON COLUMN smtp_config.use_tls IS 'Usar TLS.';
COMMENT ON COLUMN smtp_config.credentials_ref IS 'Referência às credenciais.';
COMMENT ON COLUMN smtp_config.created_at IS 'Data de criação.';
COMMENT ON COLUMN smtp_config.updated_at IS 'Última atualização.';
COMMENT ON COLUMN smtp_config.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_smtp_config ON smtp_config IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_smtp_config_external_id ON smtp_config IS 'UUID único.';

CREATE TABLE send_history (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  template_id UUID,
  recipient TEXT NOT NULL,
  sent_at TIMESTAMP WITH TIME ZONE,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_send_history PRIMARY KEY (id),
  CONSTRAINT uk_send_history_external_id UNIQUE(external_id)
);

COMMENT ON TABLE send_history IS 'Histórico de envios por tenant.';
COMMENT ON COLUMN send_history.id IS 'Identificador interno.';
COMMENT ON COLUMN send_history.external_id IS 'UUID público.';
COMMENT ON COLUMN send_history.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN send_history.template_id IS 'Template (UUID externo).';
COMMENT ON COLUMN send_history.recipient IS 'Destinatário.';
COMMENT ON COLUMN send_history.sent_at IS 'Data de envio.';
COMMENT ON COLUMN send_history.status IS 'Status.';
COMMENT ON COLUMN send_history.created_at IS 'Data de criação.';
COMMENT ON COLUMN send_history.updated_at IS 'Última atualização.';
COMMENT ON COLUMN send_history.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_send_history ON send_history IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_send_history_external_id ON send_history IS 'UUID único.';

CREATE TABLE delivery_tracking (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  send_history_id UUID NOT NULL,
  event_type TEXT,
  event_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_delivery_tracking PRIMARY KEY (id),
  CONSTRAINT uk_delivery_tracking_external_id UNIQUE(external_id)
);

COMMENT ON TABLE delivery_tracking IS 'Rastreio de entrega por envio.';
COMMENT ON COLUMN delivery_tracking.id IS 'Identificador interno.';
COMMENT ON COLUMN delivery_tracking.external_id IS 'UUID público.';
COMMENT ON COLUMN delivery_tracking.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN delivery_tracking.send_history_id IS 'Envio (UUID externo).';
COMMENT ON COLUMN delivery_tracking.event_type IS 'Tipo do evento.';
COMMENT ON COLUMN delivery_tracking.event_at IS 'Data do evento.';
COMMENT ON COLUMN delivery_tracking.created_at IS 'Data de criação.';
COMMENT ON COLUMN delivery_tracking.updated_at IS 'Última atualização.';
COMMENT ON COLUMN delivery_tracking.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_delivery_tracking ON delivery_tracking IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_delivery_tracking_external_id ON delivery_tracking IS 'UUID único.';
