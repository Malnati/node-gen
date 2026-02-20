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
  carrier TEXT,
  status VARCHAR(50),
  tracking_code TEXT,
  estimated_delivery_at TIMESTAMP WITH TIME ZONE,
  delivered_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id),
  CONSTRAINT chk_shipment_status CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception'))
);

CREATE TABLE shipment_event (
  id SERIAL PRIMARY KEY,
  external_id UUID NOT NULL DEFAULT gen_random_uuid(),
  tenant UUID NOT NULL,
  shipment_id UUID NOT NULL,
  event_type TEXT,
  event_at TIMESTAMP WITH TIME ZONE,
  location_text TEXT,
  raw_payload TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(external_id)
);
