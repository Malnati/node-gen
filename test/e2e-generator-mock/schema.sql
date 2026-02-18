-- test/e2e-generator-mock/schema.sql
-- Modelo de dados mock: relações N-1, N-N e tipos de uso comum no mercado (texto, números, binário, datas, booleano).

-- 1) Tabela simples sem relacionamentos (tipos básicos)
CREATE TABLE tb_simple_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  name TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

-- 2) Tabela com tipos variados: texto curto/longo, numérico, decimal, datas, nullable, enum-like
CREATE TABLE tb_category (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  code TEXT,
  name TEXT NOT NULL,
  full_description TEXT,
  status TEXT,
  price REAL,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT
);

-- 3) Relação N-1: produto pertence a uma categoria
CREATE TABLE tb_product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  unit_price REAL NOT NULL,
  stock_quantity INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

-- 4) Venda (lado 1 da N-N com produto via tb_sale_item)
CREATE TABLE tb_sale (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  total REAL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT
);

-- 5) Tabela de junção N-N: venda <-> produto (muitos para muitos), chave composta
CREATE TABLE tb_sale_item (
  sale_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price REAL,
  created_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

-- 6) Tag (lado 2 de outra N-N: produto <-> tag)
CREATE TABLE tb_tag (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  name TEXT NOT NULL,
  slug TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

-- 7) Tabela de junção N-N: produto <-> tag (muitos para muitos)
CREATE TABLE tb_product_tag (
  product_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

-- 8) Relação N-1: documento pertence a um produto; tipos: binário (BLOB), texto, inteiro
CREATE TABLE tb_document (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  product_id INTEGER NOT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  content BLOB,
  file_size INTEGER DEFAULT 0,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
