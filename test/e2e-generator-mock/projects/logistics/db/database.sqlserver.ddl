-- test/e2e-generator-mock/projects/logistics/db/database.sqlserver.ddl
CREATE TABLE shipment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  order_id UNIQUEIDENTIFIER NOT NULL,
  origin_address_id UNIQUEIDENTIFIER,
  destination_address_id UNIQUEIDENTIFIER,
  driver_contact_id UNIQUEIDENTIFIER,
  receiver_contact_id UNIQUEIDENTIFIER,
  carrier NVARCHAR(255),
  status NVARCHAR(50),
  tracking_code NVARCHAR(100),
  estimated_delivery_at DATETIME2,
  delivered_at DATETIME2,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_shipment_external_id UNIQUE (external_id),
  CONSTRAINT chk_shipment_status CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception'))
);

CREATE TABLE shipment_event (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  shipment_id UNIQUEIDENTIFIER NOT NULL,
  event_type NVARCHAR(100),
  event_at DATETIME2,
  location_text NVARCHAR(500),
  raw_payload NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_shipment_event_external_id UNIQUE (external_id)
);
