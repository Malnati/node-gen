-- test/e2e-generator-mock/projects/schedule/db/schema.postgres.ddl
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
COMMENT ON TABLE tb_resource IS 'Recursos agendáveis do sistema com suporte a hierarquia.';
COMMENT ON COLUMN tb_resource.tenant IS 'Referência lógica (UUID) para o locatário/empresa.';
COMMENT ON COLUMN tb_resource.external_id IS 'Identificador público seguro para exposição via API.';

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
COMMENT ON TABLE tb_recurrence_rule IS 'Regras de repetição no formato CRON para agendamentos contínuos.';

CREATE TABLE tb_booking (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  slot_id INTEGER NOT NULL,
  recurrence_rule_id INTEGER,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);
COMMENT ON TABLE tb_booking IS 'Registro principal de um agendamento efetuado.';

CREATE TABLE tb_participant (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_participant IS 'Participantes envolvidos nos agendamentos.';

CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL,
  participant_id INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  role TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (booking_id, participant_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id),
  FOREIGN KEY (participant_id) REFERENCES tb_participant(id)
);
COMMENT ON TABLE tb_booking_participant IS 'Associação entre agendamentos e participantes com definição de papéis.';

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
COMMENT ON TABLE tb_booking_history IS 'Trilha de auditoria em formato JSONB imutável para eventos de agendamento.';
