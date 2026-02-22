-- test/e2e-generator/projects/todo/db/schema.sql
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

CREATE TABLE tb_simple_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  category_id INTEGER,
  product_id TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
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

CREATE TABLE tb_simple_item_tag (
  simple_item_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  tenant TEXT NOT NULL,
  external_id TEXT NOT NULL UNIQUE,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  deleted_at TEXT,
  PRIMARY KEY (simple_item_id, tag_id),
  FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);
