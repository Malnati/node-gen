-- test/e2e-generator-mock/projects/notifications/db/database.postgres.ddl
CREATE TABLE notification_template (
  id SERIAL PRIMARY KEY,
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
  UNIQUE(external_id),
  CONSTRAINT chk_notification_template_channel CHECK (channel IS NULL OR channel IN ('email','sms','push'))
);

CREATE TABLE notification (
  id SERIAL PRIMARY KEY,
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
  UNIQUE(external_id),
  CONSTRAINT chk_notification_channel CHECK (channel IS NULL OR channel IN ('email','sms','push')),
  CONSTRAINT chk_notification_priority CHECK (priority IS NULL OR priority IN ('low','normal','high','urgent'))
);
