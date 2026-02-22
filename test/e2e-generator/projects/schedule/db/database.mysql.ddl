-- test/e2e-generator/projects/schedule/db/database.mysql.ddl
USE schedule;
CREATE TABLE tb_resource (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  name VARCHAR(255) NOT NULL COMMENT 'Nome do recurso.',
  resource_type VARCHAR(100) NOT NULL COMMENT 'Tipo do recurso.',
  capacity INT DEFAULT 1 COMMENT 'Capacidade (ex.: lotação).',
  parent_id INT COMMENT 'FK local para hierarquia (recurso pai).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  FOREIGN KEY (parent_id) REFERENCES tb_resource(id)
) COMMENT = 'Recursos agendáveis com hierarquia (parent_id FK local).';

CREATE TABLE tb_slot (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  resource_id INT NOT NULL COMMENT 'FK local para tb_resource.',
  start_at DATETIME NOT NULL COMMENT 'Início da janela.',
  end_at DATETIME NOT NULL COMMENT 'Fim da janela.',
  status VARCHAR(50) NOT NULL COMMENT 'Status do slot.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  FOREIGN KEY (resource_id) REFERENCES tb_resource(id)
) COMMENT = 'Janelas de tempo disponíveis para agendamento em um recurso.';

CREATE TABLE tb_recurrence_rule (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT 'Código único da regra.',
  name VARCHAR(255) NOT NULL COMMENT 'Nome da regra.',
  cron_expression TEXT COMMENT 'Expressão CRON.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME
) COMMENT = 'Regras de repetição (CRON) para agendamentos.';

CREATE TABLE tb_booking (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  slot_id INT NOT NULL COMMENT 'FK local para tb_slot.',
  recurrence_rule_id INT COMMENT 'FK local para tb_recurrence_rule.',
  organizer_account_id CHAR(36) COMMENT 'Referência lógica ao responsável pelo agendamento (serviço accounts).',
  title VARCHAR(255) NOT NULL COMMENT 'Título do agendamento.',
  description TEXT COMMENT 'Descrição.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  FOREIGN KEY (slot_id) REFERENCES tb_slot(id),
  FOREIGN KEY (recurrence_rule_id) REFERENCES tb_recurrence_rule(id)
) COMMENT = 'Agendamento; organizador e participantes referenciados por UUID (accounts/users).';

CREATE TABLE tb_booking_participant (
  booking_id INT NOT NULL COMMENT 'FK local para tb_booking.',
  account_id CHAR(36) NOT NULL COMMENT 'Referência lógica ao participante (serviço accounts ou users).',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  role VARCHAR(100) NOT NULL COMMENT 'Papel do participante no agendamento.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  PRIMARY KEY (booking_id, account_id),
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
) COMMENT = 'Participantes do agendamento; account_id é referência lógica (serviço accounts/users).';

CREATE TABLE tb_booking_history (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  booking_id INT NOT NULL COMMENT 'FK local para tb_booking.',
  action VARCHAR(100) NOT NULL COMMENT 'Ação registrada.',
  changed_at DATETIME NOT NULL COMMENT 'Data/hora da alteração.',
  snapshot JSON COMMENT 'Estado ou payload da alteração (JSONB).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  FOREIGN KEY (booking_id) REFERENCES tb_booking(id)
) COMMENT = 'Trilha de auditoria (JSONB) para eventos do agendamento.';
