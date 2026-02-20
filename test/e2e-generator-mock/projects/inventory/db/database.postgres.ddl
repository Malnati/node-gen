-- test/e2e-generator-mock/projects/inventory/db/database.postgres.ddl
CREATE TABLE inventory_level (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  product_id UUID NOT NULL,
  address_id UUID NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 0,
  reserved DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);
