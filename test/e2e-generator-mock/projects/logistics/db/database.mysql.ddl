-- test/e2e-generator-mock/projects/logistics/db/database.mysql.ddl
CREATE TABLE shipment (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  order_id CHAR(36) NOT NULL COMMENT 'Pedido (UUID externo).',
  origin_address_id CHAR(36) COMMENT 'Endereço de origem (UUID externo).',
  destination_address_id CHAR(36) COMMENT 'Endereço de destino (UUID externo).',
  driver_contact_id CHAR(36) COMMENT 'Contato do motorista (UUID externo).',
  receiver_contact_id CHAR(36) COMMENT 'Contato do receptor (UUID externo).',
  carrier VARCHAR(255) COMMENT 'Transportadora.',
  status VARCHAR(50) COMMENT 'Status da entrega.',
  tracking_code VARCHAR(100) COMMENT 'Código de rastreio.',
  estimated_delivery_at DATETIME COMMENT 'Previsão de entrega.',
  delivered_at DATETIME COMMENT 'Data de entrega.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_shipment_external_id (external_id),
  CONSTRAINT chk_shipment_status CHECK (status IS NULL OR status IN ('pending','picked_up','in_transit','out_for_delivery','delivered','exception'))
) COMMENT = 'Entregas por pedido e tenant.';

CREATE TABLE shipment_event (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador interno.',
  external_id CHAR(36) NOT NULL COMMENT 'UUID público.',
  tenant CHAR(36) NOT NULL COMMENT 'Tenant dono do registro.',
  shipment_id CHAR(36) NOT NULL COMMENT 'Entrega (UUID externo).',
  event_type VARCHAR(100) COMMENT 'Tipo do evento.',
  event_at DATETIME COMMENT 'Data do evento.',
  location_text VARCHAR(500) COMMENT 'Localização.',
  raw_payload TEXT COMMENT 'Payload bruto.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação.',
  updated_at DATETIME COMMENT 'Última atualização.',
  deleted_at DATETIME COMMENT 'Exclusão lógica.',
  UNIQUE KEY uk_shipment_event_external_id (external_id)
) COMMENT = 'Eventos de rastreio da entrega.';
