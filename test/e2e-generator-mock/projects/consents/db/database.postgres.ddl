-- test/e2e-generator-mock/projects/consents/db/database.postgres.ddl
CREATE TABLE consent_record (
  id SERIAL PRIMARY KEY,
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
  UNIQUE(external_id)
);

CREATE TABLE notification_preference (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID,
  channel TEXT NOT NULL,
  opt_in BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  CONSTRAINT chk_notification_preference_channel CHECK (channel IN ('email','sms','push'))
);
