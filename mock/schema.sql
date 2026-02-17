-- mock/schema.sql
-- Schema mock para testes de geração node-gen (matriz: simples, relações, tipos, nomes limítrofes).

-- 1) Tabela simples sem relacionamentos
CREATE TABLE tb_simple_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  name TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

-- 2) Tabela com nullable, enum-like (TEXT), decimal (REAL), datas, UUID/external_id
CREATE TABLE tb_category (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  name TEXT NOT NULL,
  status TEXT,
  price REAL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT
);

-- 3) Tabela com FK (relação N:1)
CREATE TABLE tb_product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

-- 4) Tabela de junção: múltiplas relações e chave composta
CREATE TABLE tb_sale (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT,
  total REAL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT
);

CREATE TABLE tb_sale_item (
  sale_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
