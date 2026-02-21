-- test/e2e-generator-mock/projects/todo/db/database.mysql.ddl
CREATE TABLE tb_category (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  code VARCHAR(50) COMMENT 'Código da categoria.',
  name VARCHAR(255) NOT NULL COMMENT 'Nome.',
  full_description TEXT COMMENT 'Descrição completa.',
  status VARCHAR(50) COMMENT 'Status.',
  price DECIMAL(10,2) COMMENT 'Preço (opcional).',
  sort_order INT DEFAULT 0 COMMENT 'Ordem de exibição.',
  is_active TINYINT(1) DEFAULT 1 COMMENT 'Ativo (1) ou não (0).',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME
) COMMENT = 'Categorias para classificação local de itens (tarefas/classificação).';

CREATE TABLE tb_simple_item (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  name VARCHAR(255) NOT NULL COMMENT 'Nome do item.',
  category_id INT COMMENT 'FK local para tb_category.',
  product_id CHAR(36) COMMENT 'Referência lógica ao produto (serviço products), quando aplicável.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
) COMMENT = 'Itens genéricos; product_id é referência lógica ao serviço products.';

CREATE TABLE tb_tag (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Chave interna.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  name VARCHAR(255) NOT NULL COMMENT 'Nome da tag.',
  slug VARCHAR(255) COMMENT 'Slug para URL.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME
) COMMENT = 'Etiquetas para classificação de itens.';

CREATE TABLE tb_simple_item_tag (
  simple_item_id INT NOT NULL COMMENT 'FK local para tb_simple_item.',
  tag_id INT NOT NULL COMMENT 'FK local para tb_tag.',
  tenant CHAR(36) NOT NULL COMMENT 'Referência lógica ao locatário (serviço companies).',
  external_id CHAR(36) NOT NULL UNIQUE COMMENT 'Identificador público para APIs.',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação.',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora da última alteração.',
  deleted_at DATETIME COMMENT 'Exclusão lógica (soft delete).',
  PRIMARY KEY (simple_item_id, tag_id),
  FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
) COMMENT = 'Junção N-N entre tb_simple_item e tb_tag (ambas locais).';
