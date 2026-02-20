-- test/e2e-generator-mock/projects/notifications/db/database.postgres.ddl
CREATE TABLE notification (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  user_id UUID,
  contact_id UUID,
  channel TEXT,
  subject TEXT,
  body TEXT,
  read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);
