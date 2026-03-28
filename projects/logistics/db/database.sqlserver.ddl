-- test/e2e-generator/projects/logistics/db/database.sqlserver.ddl
CREATE TABLE shipment (
  id INT IDENTITY(1,1),
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
,
  CONSTRAINT pk_shipment PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Entregas por pedido e tenant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Pedido (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'order_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Endereço de origem (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'origin_address_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Endereço de destino (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'destination_address_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Contato do motorista (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'driver_contact_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Contato do receptor (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'receiver_contact_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Transportadora.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'carrier';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Status da entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Código de rastreio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'tracking_code';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Previsão de entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'estimated_delivery_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'delivered_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'CONSTRAINT', @level2name = N'uk_shipment_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Status permitidos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'CONSTRAINT', @level2name = N'chk_shipment_status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment', @level2type = N'CONSTRAINT', @level2name = N'pk_shipment';

CREATE TABLE shipment_event (
  id INT IDENTITY(1,1),
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
,
  CONSTRAINT pk_shipment_event PRIMARY KEY (id)
);
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Eventos de rastreio da entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador interno.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID público.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tenant dono do registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'tenant';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Entrega (UUID externo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'shipment_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo do evento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'event_type';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data do evento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'event_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Localização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'location_text';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Payload bruto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'raw_payload';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Data de criação.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'created_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Última atualização.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'updated_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Exclusão lógica.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'COLUMN', @level2name = N'deleted_at';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'UUID único.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'CONSTRAINT', @level2name = N'uk_shipment_event_external_id';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Chave primária.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'shipment_event', @level2type = N'CONSTRAINT', @level2name = N'pk_shipment_event';
