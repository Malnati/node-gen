-- test/e2e-generator-mock/projects/todo/db/schema.postgres.ddl
CREATE TABLE tb_simple_item (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_simple_item IS 'Tabela de itens genéricos para testes básicos.';
COMMENT ON COLUMN tb_simple_item.tenant IS 'Referência UUID para o inquilino isolado no sistema.';

CREATE TABLE tb_category (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  code TEXT,
  name TEXT NOT NULL,
  full_description TEXT,
  status TEXT,
  price REAL,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_category IS 'Tipos e agrupamentos disponíveis para produtos.';

CREATE TABLE tb_product (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  category_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  unit_price REAL NOT NULL,
  stock_quantity INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES tb_category(id)
);
COMMENT ON TABLE tb_product IS 'Itens mantidos no catálogo.';

CREATE TABLE tb_sale (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  total REAL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_sale IS 'Registros consolidados de saída ou compra.';

CREATE TABLE tb_sale_item (
  sale_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price REAL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (sale_id, product_id),
  FOREIGN KEY (sale_id) REFERENCES tb_sale(id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
COMMENT ON TABLE tb_sale_item IS 'Relação física N-N para os itens vendidos e seus valores fracionados.';

CREATE TABLE tb_tag (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  name TEXT NOT NULL,
  slug TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);
COMMENT ON TABLE tb_tag IS 'Etiquetas de classificação adicional.';

CREATE TABLE tb_product_tag (
  product_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES tb_product(id),
  FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);
COMMENT ON TABLE tb_product_tag IS 'Vínculo físico N-N entre produtos e suas tags associadas.';

CREATE TABLE tb_document (
  id SERIAL PRIMARY KEY,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL UNIQUE,
  product_id INTEGER NOT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT,
  content BYTEA,
  file_size INTEGER DEFAULT 0,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES tb_product(id)
);
COMMENT ON TABLE tb_document IS 'Armazenamento de artefatos binários ligados aos produtos.';
