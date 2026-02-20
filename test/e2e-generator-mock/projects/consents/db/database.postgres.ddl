-- test/e2e-generator-mock/projects/consents/db/database.postgres.ddl
CREATE TABLE consent_record (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID,
  consent_type TEXT NOT NULL,
  granted_at TIMESTAMP WITH TIME ZONE,
  ip_address TEXT,
  version TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_consent_record PRIMARY KEY (id),
  CONSTRAINT uk_consent_record_external_id UNIQUE(external_id)
);

COMMENT ON TABLE consent_record IS 'Registros de consentimento por conta e tenant.';
COMMENT ON COLUMN consent_record.id IS 'Identificador interno.';
COMMENT ON COLUMN consent_record.external_id IS 'UUID público.';
COMMENT ON COLUMN consent_record.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN consent_record.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN consent_record.user_id IS 'Usuário (UUID externo).';
COMMENT ON COLUMN consent_record.consent_type IS 'Tipo de consentimento.';
COMMENT ON COLUMN consent_record.granted_at IS 'Data de concessão.';
COMMENT ON COLUMN consent_record.ip_address IS 'IP da solicitação.';
COMMENT ON COLUMN consent_record.version IS 'Versão do termo.';
COMMENT ON COLUMN consent_record.created_at IS 'Data de criação.';
COMMENT ON COLUMN consent_record.updated_at IS 'Última atualização.';
COMMENT ON COLUMN consent_record.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_consent_record ON consent_record IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_consent_record_external_id ON consent_record IS 'UUID único.';

CREATE TABLE notification_preference (
  id SERIAL,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID,
  channel TEXT NOT NULL,
  opt_in BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT pk_notification_preference PRIMARY KEY (id),
  CONSTRAINT uk_notification_preference_external_id UNIQUE(external_id),
  CONSTRAINT chk_notification_preference_channel CHECK (channel IN ('email','sms','push'))
);

COMMENT ON TABLE notification_preference IS 'Preferências de notificação por canal e usuário.';
COMMENT ON COLUMN notification_preference.id IS 'Identificador interno.';
COMMENT ON COLUMN notification_preference.external_id IS 'UUID público.';
COMMENT ON COLUMN notification_preference.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN notification_preference.account_id IS 'Conta (UUID externo).';
COMMENT ON COLUMN notification_preference.user_id IS 'Usuário (UUID externo).';
COMMENT ON COLUMN notification_preference.channel IS 'Canal (email, sms, push).';
COMMENT ON COLUMN notification_preference.opt_in IS 'Opt-in ativo.';
COMMENT ON COLUMN notification_preference.created_at IS 'Data de criação.';
COMMENT ON COLUMN notification_preference.updated_at IS 'Última atualização.';
COMMENT ON COLUMN notification_preference.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_notification_preference ON notification_preference IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_notification_preference_external_id ON notification_preference IS 'UUID único.';
COMMENT ON CONSTRAINT chk_notification_preference_channel ON notification_preference IS 'Canal permitido.';
