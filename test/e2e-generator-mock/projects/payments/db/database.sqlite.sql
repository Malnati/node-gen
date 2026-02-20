-- test/e2e-generator-mock/projects/payments/db/database.sqlite.sql
INSERT INTO payment (amount, currency_code, status, method) VALUES
(99.90,'BRL','paid','pix'),
(250.00,'BRL','pending','card'),
(50.00,'BRL','refunded','pix');
