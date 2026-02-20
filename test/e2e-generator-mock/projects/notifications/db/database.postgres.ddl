-- test/e2e-generator-mock/projects/notifications/db/database.postgres.ddl
CREATE TABLE notification_template (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  channel VARCHAR(20),
  subject_tpl TEXT,
  body_tpl TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_notification_template PRIMARY KEY (id),
  CONSTRAINT uk_notification_template_external_id UNIQUE(external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
);

COMMENT ON TABLE notification_template IS 'Templates de notificação por tenant.';
COMMENT ON COLUMN notification_template.id IS 'Identificador interno.';
COMMENT ON COLUMN notification_template.external_id IS 'UUID público.';
COMMENT ON COLUMN notification_template.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN notification_template.code IS 'Código do template.';
COMMENT ON COLUMN notification_template.name IS 'Nome.';
COMMENT ON COLUMN notification_template.channel IS 'Canal (email, sms, push).';
COMMENT ON COLUMN notification_template.subject_tpl IS 'Template do assunto.';
COMMENT ON COLUMN notification_template.body_tpl IS 'Template do corpo.';
COMMENT ON COLUMN notification_template.created_at IS 'Data de criação.';
COMMENT ON COLUMN notification_template.updated_at IS 'Última atualização.';
COMMENT ON COLUMN notification_template.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_notification_template ON notification_template IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_notification_template_external_id ON notification_template IS 'UUID único.';
COMMENT ON CONSTRAINT chk_notification_template_channel ON notification_template IS 'Canal permitido.';

CREATE TABLE notification (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID,
  contact_id UUID,
  template_id UUID,
  channel VARCHAR(20),
  priority VARCHAR(20),
  subject TEXT,
  body TEXT,
  read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_notification PRIMARY KEY (id),
  CONSTRAINT uk_notification_external_id UNIQUE(external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
);

COMMENT ON TABLE notification IS 'Notificações enviadas por tenant/conta.';
COMMENT ON COLUMN notification.id IS 'Identificador interno.';
COMMENT ON COLUMN notification.external_id IS 'UUID público.';
COMMENT ON COLUMN notification.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN notification.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN notification.user_id IS 'Usuário (UUID externo).';
COMMENT ON COLUMN notification.contact_id IS 'Contato (UUID externo).';
COMMENT ON COLUMN notification.template_id IS 'Template (UUID externo).';
COMMENT ON COLUMN notification.channel IS 'Canal (email, sms, push).';
COMMENT ON COLUMN notification.priority IS 'Prioridade (low, normal, high, urgent).';
COMMENT ON COLUMN notification.subject IS 'Assunto.';
COMMENT ON COLUMN notification.body IS 'Corpo.';
COMMENT ON COLUMN notification.read_at IS 'Data de leitura.';
COMMENT ON COLUMN notification.created_at IS 'Data de criação.';
COMMENT ON COLUMN notification.updated_at IS 'Última atualização.';
COMMENT ON COLUMN notification.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_notification ON notification IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_notification_external_id ON notification IS 'UUID único.';
COMMENT ON CONSTRAINT chk_notification_channel ON notification IS 'Canal permitido.';
COMMENT ON CONSTRAINT chk_notification_priority ON notification IS 'Prioridade permitida.';
