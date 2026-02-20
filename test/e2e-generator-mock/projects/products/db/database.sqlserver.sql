-- test/e2e-generator-mock/projects/products/db/database.sqlserver.sql
-- currency: cópia idêntica de projects/payments (mesmos external_id, code, name, symbol, region)
INSERT INTO currency (external_id, code, name, symbol, region) VALUES
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','BRL','Real brasileiro','R$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','USD','US Dollar','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','EUR','Euro','€','EUROPE'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a04','GBP','British Pound','£','EUROPE'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a05','MXN','Mexican Peso','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a06','ARS','Argentine Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a07','COP','Colombian Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a08','CLP','Chilean Peso','$','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a09','PEN','Peruvian Sol','S/','SOUTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0a','CAD','Canadian Dollar','$','NORTH_AMERICA'),
('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0b','CHF','Swiss Franc','CHF','EUROPE');

INSERT INTO unit_of_measure (external_id, code, name, symbol, category) VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','UN','Unidade','un','COUNT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','KG','Quilograma','kg','WEIGHT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03','G','Grama','g','WEIGHT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a04','T','Tonelada','t','WEIGHT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a05','LB','Libra','lb','WEIGHT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a06','L','Litro','L','VOLUME'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a07','ML','Mililitro','ml','VOLUME'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a08','M3','Metro cúbico','m³','VOLUME'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a09','M','Metro','m','LENGTH'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0a','CM','Centímetro','cm','LENGTH'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0b','MM','Milímetro','mm','LENGTH'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0c','M2','Metro quadrado','m²','AREA'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0d','CX','Caixa','cx','COUNT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0e','PCT','Pacote','pct','COUNT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a0f','DZ','Dúzia','dz','COUNT'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a10','HR','Hora','h','TIME'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','DIA','Dia','d','TIME'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','MIN','Minuto','min','TIME');

INSERT INTO product (external_id, tenant, account_id, sku, name, description, unit_of_measure_id, currency_id, unit_price) VALUES
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','SKU-001','Produto Alfa','Descrição fictícia do produto Alfa.',(SELECT TOP 1 id FROM unit_of_measure WHERE code='UN'),(SELECT TOP 1 id FROM currency WHERE code='BRL'),29.90),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','SKU-002','Produto Beta','Descrição fictícia do produto Beta.',(SELECT TOP 1 id FROM unit_of_measure WHERE code='UN'),(SELECT TOP 1 id FROM currency WHERE code='BRL'),45.00),
('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','SKU-003','Produto Gama',NULL,(SELECT TOP 1 id FROM unit_of_measure WHERE code='UN'),(SELECT TOP 1 id FROM currency WHERE code='BRL'),99.00);
