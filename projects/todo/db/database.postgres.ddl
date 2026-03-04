-- test/e2e-generator/projects/todo/db/database.postgres.ddl
CREATE TABLE tb_category (
  id SERIAL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  code TEXT,
  name TEXT NOT NULL,
  full_description TEXT,
  status TEXT,
  price REAL,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_category PRIMARY KEY (id),
  CONSTRAINT uk_tb_category_external_id UNIQUE(external_id)
);
COMMENT ON TABLE tb_category IS 'Categorias para classificação local de itens (tarefas/classificação).';
COMMENT ON COLUMN tb_category.id IS 'Chave interna.';
COMMENT ON COLUMN tb_category.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_category.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_category.code IS 'Código da categoria.';
COMMENT ON COLUMN tb_category.name IS 'Nome.';
COMMENT ON COLUMN tb_category.full_description IS 'Descrição completa.';
COMMENT ON COLUMN tb_category.status IS 'Status.';
COMMENT ON COLUMN tb_category.price IS 'Preço (opcional).';
COMMENT ON COLUMN tb_category.sort_order IS 'Ordem de exibição.';
COMMENT ON COLUMN tb_category.is_active IS 'Ativo (1) ou não (0).';
COMMENT ON COLUMN tb_category.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_category.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_category.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_category ON tb_category IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_tb_category_external_id ON tb_category IS 'UUID único.';

CREATE TABLE tb_simple_item (
  id SERIAL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  name TEXT NOT NULL,
  category_id INTEGER,
  product_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_simple_item PRIMARY KEY (id),
  CONSTRAINT uk_tb_simple_item_external_id UNIQUE(external_id),
  CONSTRAINT fk_tb_simple_item_category FOREIGN KEY (category_id) REFERENCES tb_category(id)
);
COMMENT ON TABLE tb_simple_item IS 'Itens genéricos; product_id é referência lógica ao serviço products.';
COMMENT ON COLUMN tb_simple_item.id IS 'Chave interna.';
COMMENT ON COLUMN tb_simple_item.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_simple_item.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_simple_item.name IS 'Nome do item.';
COMMENT ON COLUMN tb_simple_item.category_id IS 'FK local para tb_category.';
COMMENT ON COLUMN tb_simple_item.product_id IS 'Referência lógica ao produto (serviço products), quando aplicável.';
COMMENT ON COLUMN tb_simple_item.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_simple_item.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_simple_item.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_simple_item ON tb_simple_item IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_tb_simple_item_external_id ON tb_simple_item IS 'UUID único.';
COMMENT ON CONSTRAINT fk_tb_simple_item_category ON tb_simple_item IS 'Referência à categoria.';

CREATE TABLE tb_tag (
  id SERIAL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  name TEXT NOT NULL,
  slug TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_tag PRIMARY KEY (id),
  CONSTRAINT uk_tb_tag_external_id UNIQUE(external_id)
);
COMMENT ON TABLE tb_tag IS 'Etiquetas para classificação de itens.';
COMMENT ON COLUMN tb_tag.id IS 'Chave interna.';
COMMENT ON COLUMN tb_tag.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_tag.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_tag.name IS 'Nome da tag.';
COMMENT ON COLUMN tb_tag.slug IS 'Slug para URL.';
COMMENT ON COLUMN tb_tag.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_tag.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_tag.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_tag ON tb_tag IS 'Chave primária.';
COMMENT ON CONSTRAINT uk_tb_tag_external_id ON tb_tag IS 'UUID único.';

CREATE TABLE tb_simple_item_tag (
  simple_item_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  tenant UUID NOT NULL,
  external_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  CONSTRAINT pk_tb_simple_item_tag PRIMARY KEY (simple_item_id, tag_id),
  CONSTRAINT uk_tb_simple_item_tag_external_id UNIQUE(external_id),
  CONSTRAINT fk_tb_simple_item_tag_item FOREIGN KEY (simple_item_id) REFERENCES tb_simple_item(id),
  CONSTRAINT fk_tb_simple_item_tag_tag FOREIGN KEY (tag_id) REFERENCES tb_tag(id)
);
COMMENT ON TABLE tb_simple_item_tag IS 'Junção N-N entre tb_simple_item e tb_tag (ambas locais).';
COMMENT ON COLUMN tb_simple_item_tag.simple_item_id IS 'FK local para tb_simple_item.';
COMMENT ON COLUMN tb_simple_item_tag.tag_id IS 'FK local para tb_tag.';
COMMENT ON COLUMN tb_simple_item_tag.tenant IS 'Referência lógica ao locatário (serviço companies).';
COMMENT ON COLUMN tb_simple_item_tag.external_id IS 'Identificador público para APIs.';
COMMENT ON COLUMN tb_simple_item_tag.created_at IS 'Data/hora de criação.';
COMMENT ON COLUMN tb_simple_item_tag.updated_at IS 'Data/hora da última alteração.';
COMMENT ON COLUMN tb_simple_item_tag.deleted_at IS 'Exclusão lógica (soft delete).';
COMMENT ON CONSTRAINT pk_tb_simple_item_tag ON tb_simple_item_tag IS 'Chave primária composta.';
COMMENT ON CONSTRAINT uk_tb_simple_item_tag_external_id ON tb_simple_item_tag IS 'UUID único.';
COMMENT ON CONSTRAINT fk_tb_simple_item_tag_item ON tb_simple_item_tag IS 'Referência ao item.';
COMMENT ON CONSTRAINT fk_tb_simple_item_tag_tag ON tb_simple_item_tag IS 'Referência à tag.';
