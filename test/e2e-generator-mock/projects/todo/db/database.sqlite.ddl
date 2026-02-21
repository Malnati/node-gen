-- test/e2e-generator-mock/projects/todo/db/database.sqlite.ddl
-- Categorias para classificação local de itens (tarefas/classificação).
CREATE TABLE tb_category (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  code TEXT, -- Código da categoria.
  name TEXT NOT NULL, -- Nome.
  full_description TEXT, -- Descrição completa.
  status TEXT, -- Status.
  price REAL, -- Preço (opcional).
  sort_order INTEGER DEFAULT 0, -- Ordem de exibição.
  is_active INTEGER DEFAULT 1, -- Ativo (1) ou não (0).
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT -- Exclusão lógica (soft delete).
);

-- Itens genéricos; product_id é referência lógica ao serviço products.
CREATE TABLE tb_simple_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  name TEXT NOT NULL, -- Nome do item.
  category_id INTEGER, -- FK local para tb_category.
  product_id TEXT, -- Referência lógica ao produto (serviço products), quando aplicável.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

-- Etiquetas para classificação de itens.
CREATE TABLE tb_tag (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- Chave interna.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  name TEXT NOT NULL, -- Nome da tag.
  slug TEXT, -- Slug para URL.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT -- Exclusão lógica (soft delete).
);

-- Junção N-N entre tb_simple_item e tb_tag (ambas locais).
CREATE TABLE tb_simple_item_tag (
  simple_item_id INTEGER NOT NULL, -- FK local para tb_simple_item.
  tag_id INTEGER NOT NULL, -- FK local para tb_tag.
  tenant TEXT NOT NULL, -- Referência lógica ao locatário (serviço companies).
  external_id TEXT NOT NULL UNIQUE, -- Identificador público para APIs.
  created_at TEXT DEFAULT (datetime('now')), -- Data/hora de criação.
  updated_at TEXT DEFAULT (datetime('now')), -- Data/hora da última alteração.
  deleted_at TEXT, -- Exclusão lógica (soft delete).
  PRIMARY KEY (simple_item_id, tag_id),
  FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);
