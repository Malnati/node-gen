-- test/e2e-generator/projects/gmail/db/database.postgres.ddl
CREATE TABLE gmail_integration (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  connected_email TEXT NOT NULL,
  oauth_ref TEXT,
  last_sync_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_gmail_integration PRIMARY KEY (id),
  CONSTRAINT uk_gmail_integration_external_id UNIQUE(external_id)
);
COMMENT ON TABLE gmail_integration IS 'Integração Gmail por conta e tenant.';
COMMENT ON COLUMN gmail_integration.id IS 'Identificador interno.';
COMMENT ON COLUMN gmail_integration.external_id IS 'UUID público.';
COMMENT ON COLUMN gmail_integration.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN gmail_integration.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN gmail_integration.connected_email IS 'E-mail conectado.';
COMMENT ON COLUMN gmail_integration.oauth_ref IS 'Referência OAuth.';
COMMENT ON COLUMN gmail_integration.last_sync_at IS 'Última sincronização.';
COMMENT ON COLUMN gmail_integration.created_at IS 'Data de criação.';
COMMENT ON COLUMN gmail_integration.updated_at IS 'Última atualização.';
COMMENT ON COLUMN gmail_integration.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_gmail_integration ON gmail_integration IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_gmail_integration_external_id ON gmail_integration IS 'UUID único.';

CREATE TABLE gmail_message_template (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID,
  code TEXT NOT NULL,
  name TEXT,
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_gmail_message_template PRIMARY KEY (id),
  CONSTRAINT uk_gmail_message_template_external_id UNIQUE(external_id)
);
COMMENT ON TABLE gmail_message_template IS 'Templates de mensagem Gmail por tenant.';
COMMENT ON COLUMN gmail_message_template.id IS 'Identificador interno.';
COMMENT ON COLUMN gmail_message_template.external_id IS 'UUID público.';
COMMENT ON COLUMN gmail_message_template.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN gmail_message_template.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN gmail_message_template.code IS 'Código do template.';
COMMENT ON COLUMN gmail_message_template.name IS 'Nome.';
COMMENT ON COLUMN gmail_message_template.subject_tpl IS 'Template do assunto.';
COMMENT ON COLUMN gmail_message_template.body_tpl IS 'Template do corpo.';
COMMENT ON COLUMN gmail_message_template.created_at IS 'Data de criação.';
COMMENT ON COLUMN gmail_message_template.updated_at IS 'Última atualização.';
COMMENT ON COLUMN gmail_message_template.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_gmail_message_template ON gmail_message_template IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_gmail_message_template_external_id ON gmail_message_template IS 'UUID único.';

CREATE TABLE gmail_message (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  integration_id UUID NOT NULL,
  gmail_message_id TEXT,
  gmail_thread_id TEXT,
  direction VARCHAR(20) NOT NULL,
  subject TEXT,
  from_addr TEXT,
  to_addr TEXT,
  body_preview TEXT,
  sent_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_gmail_message PRIMARY KEY (id),
  CONSTRAINT uk_gmail_message_external_id UNIQUE(external_id),
  CONSTRAINT chk_gmail_message_direction CHECK (direction IN ('sent','received'))
);
COMMENT ON TABLE gmail_message IS 'Mensagens Gmail por integração e tenant.';
COMMENT ON COLUMN gmail_message.id IS 'Identificador interno.';
COMMENT ON COLUMN gmail_message.external_id IS 'UUID público.';
COMMENT ON COLUMN gmail_message.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN gmail_message.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN gmail_message.integration_id IS 'Integração (UUID externo).';
COMMENT ON COLUMN gmail_message.gmail_message_id IS 'ID da mensagem no Gmail.';
COMMENT ON COLUMN gmail_message.gmail_thread_id IS 'ID do thread no Gmail.';
COMMENT ON COLUMN gmail_message.direction IS 'Direção (sent, received).';
COMMENT ON COLUMN gmail_message.subject IS 'Assunto.';
COMMENT ON COLUMN gmail_message.from_addr IS 'Remetente.';
COMMENT ON COLUMN gmail_message.to_addr IS 'Destinatário.';
COMMENT ON COLUMN gmail_message.body_preview IS 'Prévia do corpo.';
COMMENT ON COLUMN gmail_message.sent_at IS 'Data de envio.';
COMMENT ON COLUMN gmail_message.created_at IS 'Data de criação.';
COMMENT ON COLUMN gmail_message.updated_at IS 'Última atualização.';
COMMENT ON COLUMN gmail_message.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_gmail_message ON gmail_message IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_gmail_message_external_id ON gmail_message IS 'UUID único.';
COMMENT ON CONSTRAINT chk_gmail_message_direction ON gmail_message IS 'Direção permitida.';
