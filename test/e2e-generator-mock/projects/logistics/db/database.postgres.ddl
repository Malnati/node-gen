-- test/e2e-generator-mock/projects/logistics/db/database.postgres.ddl
CREATE TABLE shipment (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  order_id UUID NOT NULL,
  origin_address_id UUID,
  destination_address_id UUID,
  driver_contact_id UUID,
  receiver_contact_id UUID,
  status TEXT,
  tracking_code TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);
