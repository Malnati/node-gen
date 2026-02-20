-- test/e2e-generator-mock/projects/todo/db/schema.sql
CREATE TABLE tb_simple_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_category (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  code TEXT,
  name TEXT NOT NULL,
  full_description TEXT,
  status TEXT,
  price REAL,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  unit_price REAL NOT NULL,
  stock_quantity INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_sale (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  total REAL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_sale_item (
  sale_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price REAL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

CREATE TABLE tb_tag (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  slug TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT
);

CREATE TABLE tb_product_tag (
  product_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

CREATE TABLE tb_document (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  product_id INTEGER NOT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  content BLOB,
  file_size INTEGER DEFAULT 0,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
