-- test/e2e-generator-mock/projects/todo/db/schema.postgres.ddl
-- Mesmo modelo do schema.sql em sintaxe PostgreSQL (E2E mock).

CREATE TABLE tb_simple_item (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_category (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  code TEXT,
  name TEXT NOT NULL,
  full_description TEXT,
  status TEXT,
  price REAL,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE tb_product (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  unit_price REAL NOT NULL,
  stock_quantity INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);

CREATE TABLE tb_sale (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  total REAL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE tb_sale_item (
  sale_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price REAL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);

CREATE TABLE tb_tag (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  name TEXT NOT NULL,
  slug TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_product_tag (
  product_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);

CREATE TABLE tb_document (
  id SERIAL PRIMARY KEY,
  external_id TEXT,
  product_id INTEGER NOT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  content BYTEA,
  file_size INTEGER DEFAULT 0,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
