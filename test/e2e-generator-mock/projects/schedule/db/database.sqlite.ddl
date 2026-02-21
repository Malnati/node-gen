-- test/e2e-generator-mock/projects/schedule/db/database.sqlite.ddl
-- Recursos agendáveis com hierarquia (parent_id FK local).
CREATE TABLE tb_resource (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  name TEXT NOT NULL, -- Nome do recurso.
  resource_type TEXT NOT NULL, -- Tipo do recurso.
  capacity INTEGER DEFAULT 1, -- Capacidade (ex.: lotação).
  parent_id INTEGER, -- FK local para hierarquia (recurso pai).
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
);

-- Janelas de tempo disponíveis para agendamento em um recurso.
CREATE TABLE tb_slot (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  resource_id INTEGER NOT NULL, -- FK local para tb_resource.
  start_at TEXT NOT NULL, -- Início da janela.
  end_at TEXT NOT NULL, -- Fim da janela.
  status TEXT NOT NULL, -- Status do slot.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
);

-- Regras de repetição (CRON) para agendamentos.
CREATE TABLE tb_recurrence_rule (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  code TEXT NOT NULL UNIQUE, -- Código único da regra.
  name TEXT NOT NULL, -- Nome da regra.
  cron_expression TEXT, -- Expressão CRON.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT -- Exclusão lógica (soft delete).
);

-- Agendamento; organizador e participantes referenciados por UUID (accounts/users).
CREATE TABLE tb_booking (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  slot_id INTEGER NOT NULL, -- FK local para tb_slot.
  recurrence_rule_id INTEGER, -- FK local para tb_recurrence_rule.
  organizer_account_id TEXT, -- Referência lógica ao responsável pelo agendamento (serviço accounts).
  title TEXT NOT NULL, -- Título do agendamento.
  description TEXT, -- Descrição.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
);

-- Participantes do agendamento; account_id é referência lógica (serviço accounts/users).
CREATE TABLE tb_booking_participant (
  booking_id INTEGER NOT NULL, -- FK local para tb_booking.
  account_id TEXT NOT NULL, -- Referência lógica ao participante (serviço accounts ou users).
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  role TEXT NOT NULL, -- Papel do participante no agendamento.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  PRIMARY KEY (booking_id, account_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);

-- Trilha de auditoria (JSONB) para eventos do agendamento.
CREATE TABLE tb_booking_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  booking_id INTEGER NOT NULL, -- FK local para tb_booking.
  action TEXT NOT NULL, -- Ação registrada.
  changed_at TEXT NOT NULL, -- Data/hora da alteração.
  snapshot TEXT, -- Estado ou payload da alteração (JSONB).
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
);
