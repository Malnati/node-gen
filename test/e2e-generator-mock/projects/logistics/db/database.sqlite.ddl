-- test/e2e-generator-mock/projects/logistics/db/database.sqlite.ddl
-- Entregas por pedido e tenant.
CREATE TABLE shipment (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  order_id TEXT NOT NULL, -- Pedido (UUID externo).
  origin_address_id TEXT, -- Endereço de origem (UUID externo).
  destination_address_id TEXT, -- Endereço de destino (UUID externo).
  driver_contact_id TEXT, -- Contato do motorista (UUID externo).
  receiver_contact_id TEXT, -- Contato do receptor (UUID externo).
  carrier TEXT, -- Transportadora.
  status TEXT CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception')), -- Status da entrega.
  tracking_code TEXT, -- Código de rastreio.
  estimated_delivery_at TEXT, -- Previsão de entrega.
  delivered_at TEXT, -- Data de entrega.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);

-- Eventos de rastreio da entrega.
CREATE TABLE shipment_event (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador interno.
  external_id TEXT NOT NULL, -- UUID público.
  tenant TEXT NOT NULL, -- Tenant dono do registro.
  shipment_id TEXT NOT NULL, -- Entrega (UUID externo).
  event_type TEXT, -- Tipo do evento.
  event_at TEXT, -- Data do evento.
  location_text TEXT, -- Localização.
  raw_payload TEXT, -- Payload bruto.
  created_at TEXT DEFAULT (datetime('now')), -- Data de criação.
  updated_at TEXT, -- Última atualização.
  deleted_at TEXT, -- Exclusão lógica.
  UNIQUE(external_id)
);
