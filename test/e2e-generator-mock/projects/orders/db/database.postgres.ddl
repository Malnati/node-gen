-- test/e2e-generator-mock/projects/orders/db/database.postgres.ddl
CREATE TABLE "order" (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  account_id UUID NOT NULL,
  shipping_address_id UUID,
  billing_address_id UUID,
  payment_id UUID,
  status TEXT,
  total DECIMAL(12,2) DEFAULT 0,
  currency_code VARCHAR(3) DEFAULT 'BRL',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);

CREATE TABLE order_item (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  order_id UUID NOT NULL,
  product_id UUID NOT NULL,
  quantity DECIMAL(12,2) DEFAULT 1,
  unit_price DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);
