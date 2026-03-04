-- test/e2e-generator/projects/logistics/db/database.postgres.ddl
CREATE TABLE shipment (
  id SERIAL,
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
  CONSTRAINT pk_shipment PRIMARY KEY (id),
  CONSTRAINT uk_shipment_external_id UNIQUE(external_id),
  CONSTRAINT chk_shipment_status CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception'))
);

COMMENT ON TABLE shipment IS 'Entregas por pedido e tenant.';
COMMENT ON COLUMN shipment.id IS 'Identificador interno.';
COMMENT ON COLUMN shipment.external_id IS 'UUID público.';
COMMENT ON COLUMN shipment.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN shipment.order_id IS 'Pedido (UUID externo).';
COMMENT ON COLUMN shipment.origin_address_id IS 'Endereço de origem (UUID externo).';
COMMENT ON COLUMN shipment.destination_address_id IS 'Endereço de destino (UUID externo).';
COMMENT ON COLUMN shipment.driver_contact_id IS 'Contato do motorista (UUID externo).';
COMMENT ON COLUMN shipment.receiver_contact_id IS 'Contato do receptor (UUID externo).';
COMMENT ON COLUMN shipment.carrier IS 'Transportadora.';
COMMENT ON COLUMN shipment.status IS 'Status da entrega.';
COMMENT ON COLUMN shipment.tracking_code IS 'Código de rastreio.';
COMMENT ON COLUMN shipment.estimated_delivery_at IS 'Previsão de entrega.';
COMMENT ON COLUMN shipment.delivered_at IS 'Data de entrega.';
COMMENT ON COLUMN shipment.created_at IS 'Data de criação.';
COMMENT ON COLUMN shipment.updated_at IS 'Última atualização.';
COMMENT ON COLUMN shipment.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_shipment ON shipment IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_shipment_external_id ON shipment IS 'UUID único.';
COMMENT ON CONSTRAINT chk_shipment_status ON shipment IS 'Status permitidos.';

CREATE TABLE shipment_event (
  id SERIAL,
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
  CONSTRAINT pk_shipment_event PRIMARY KEY (id),
  CONSTRAINT uk_shipment_event_external_id UNIQUE(external_id)
);

COMMENT ON TABLE shipment_event IS 'Eventos de rastreio da entrega.';
COMMENT ON COLUMN shipment_event.id IS 'Identificador interno.';
COMMENT ON COLUMN shipment_event.external_id IS 'UUID público.';
COMMENT ON COLUMN shipment_event.tenant IS 'Tenant dono do registro.';
COMMENT ON COLUMN shipment_event.shipment_id IS 'Entrega (UUID externo).';
COMMENT ON COLUMN shipment_event.event_type IS 'Tipo do evento.';
COMMENT ON COLUMN shipment_event.event_at IS 'Data do evento.';
COMMENT ON COLUMN shipment_event.location_text IS 'Localização.';
COMMENT ON COLUMN shipment_event.raw_payload IS 'Payload bruto.';
COMMENT ON COLUMN shipment_event.created_at IS 'Data de criação.';
COMMENT ON COLUMN shipment_event.updated_at IS 'Última atualização.';
COMMENT ON COLUMN shipment_event.deleted_at IS 'Exclusão lógica.';
COMMENT ON CONSTRAINT pk_shipment_event ON shipment_event IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_shipment_event_external_id ON shipment_event IS 'UUID único.';
