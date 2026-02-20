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
  status NVARCHAR(50),
  tracking_code NVARCHAR(100),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_shipment_external_id UNIQUE (external_id)
);
