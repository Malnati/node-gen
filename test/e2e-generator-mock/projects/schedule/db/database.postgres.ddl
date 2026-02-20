-- test/e2e-generator-mock/projects/schedule/db/database.postgres.ddl
CREATE TABLE tb_resource (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  parent_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);
COMMENT ON TABLE tb_resource IS 'Recursos agendáveis com hierarquia (parent_id FK local).';
COMMENT ON COLUMN tb_resource.id IS 'Chave interna.';
COMMENT ON COLUMN tb_resource.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_resource.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_resource.name IS 'Nome do recurso.';
COMMENT ON COLUMN tb_resource.resource_type IS 'Tipo do recurso.';
COMMENT ON COLUMN tb_resource.capacity IS 'Capacidade (ex.: lotação).';
COMMENT ON COLUMN tb_resource.parent_id IS 'FK local para hierarquia (recurso pai).';
COMMENT ON COLUMN tb_resource.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_resource.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_resource.deleted_at IS 'Exclusão lógica (soft delete).';

CREATE TABLE tb_slot (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  resource_id INTEGER NOT NULL,
  start_at TIMESTAMP NOT NULL,
  end_at TIMESTAMP NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);
COMMENT ON TABLE tb_slot IS 'Janelas de tempo disponíveis para agendamento em um recurso.';
COMMENT ON COLUMN tb_slot.id IS 'Chave interna.';
COMMENT ON COLUMN tb_slot.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_slot.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_slot.resource_id IS 'FK local para tb_resource.';
COMMENT ON COLUMN tb_slot.start_at IS 'Início da janela.';
COMMENT ON COLUMN tb_slot.end_at IS 'Fim da janela.';
COMMENT ON COLUMN tb_slot.status IS 'Status do slot.';
COMMENT ON COLUMN tb_slot.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_slot.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_slot.deleted_at IS 'Exclusão lógica (soft delete).';

CREATE TABLE tb_recurrence_rule (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  cron_expression TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_recurrence_rule IS 'Regras de repetição (CRON) para agendamentos.';
COMMENT ON COLUMN tb_recurrence_rule.id IS 'Chave interna.';
COMMENT ON COLUMN tb_recurrence_rule.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_recurrence_rule.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_recurrence_rule.code IS 'Código único da regra.';
COMMENT ON COLUMN tb_recurrence_rule.name IS 'Nome da regra.';
COMMENT ON COLUMN tb_recurrence_rule.cron_expression IS 'Expressão CRON.';
COMMENT ON COLUMN tb_recurrence_rule.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_recurrence_rule.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_recurrence_rule.deleted_at IS 'Exclusão lógica (soft delete).';

CREATE TABLE tb_booking (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  slot_id INTEGER NOT NULL,
  recurrence_rule_id INTEGER,
  organizer_account_id UUID,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);
COMMENT ON TABLE tb_booking IS 'Agendamento; organizador e participantes referenciados por UUID (accounts/users).';
COMMENT ON COLUMN tb_booking.id IS 'Chave interna.';
COMMENT ON COLUMN tb_booking.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_booking.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_booking.slot_id IS 'FK local para tb_slot.';
COMMENT ON COLUMN tb_booking.recurrence_rule_id IS 'FK local para tb_recurrence_rule.';
COMMENT ON COLUMN tb_booking.organizer_account_id IS 'Referência lógica ao responsável pelo agendamento (serviço accounts).';
COMMENT ON COLUMN tb_booking.title IS 'Título do agendamento.';
COMMENT ON COLUMN tb_booking.description IS 'Descrição.';
COMMENT ON COLUMN tb_booking.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_booking.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_booking.deleted_at IS 'Exclusão lógica (soft delete).';

CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL,
  account_id UUID NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  role TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (booking_id, account_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);
COMMENT ON TABLE tb_booking_participant IS 'Participantes do agendamento; account_id é referência lógica (serviço accounts/users).';
COMMENT ON COLUMN tb_booking_participant.booking_id IS 'FK local para tb_booking.';
COMMENT ON COLUMN tb_booking_participant.account_id IS 'Referência lógica ao participante (serviço accounts ou users).';
COMMENT ON COLUMN tb_booking_participant.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_booking_participant.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_booking_participant.role IS 'Papel do participante no agendamento.';
COMMENT ON COLUMN tb_booking_participant.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_booking_participant.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_booking_participant.deleted_at IS 'Exclusão lógica (soft delete).';

CREATE TABLE tb_booking_history (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  booking_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  changed_at TIMESTAMP NOT NULL,
  snapshot JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);
COMMENT ON TABLE tb_booking_history IS 'Trilha de auditoria (JSONB) para eventos do agendamento.';
COMMENT ON COLUMN tb_booking_history.id IS 'Chave interna.';
COMMENT ON COLUMN tb_booking_history.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_booking_history.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_booking_history.booking_id IS 'FK local para tb_booking.';
COMMENT ON COLUMN tb_booking_history.action IS 'Ação registrada.';
COMMENT ON COLUMN tb_booking_history.changed_at IS 'Data/hora da alteração.';
COMMENT ON COLUMN tb_booking_history.snapshot IS 'Estado ou payload da alteração (JSONB).';
COMMENT ON COLUMN tb_booking_history.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_booking_history.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_booking_history.deleted_at IS 'Exclusão lógica (soft delete).';
