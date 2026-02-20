-- test/e2e-generator-mock/projects/payments/db/database.mysql.sql
INSERT INTO payment_method (tenant, account_id, code, name, method_type, region) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','debit','Débito','debit','BR'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','credit','Crédito','credit','BR'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','pix','PIX','pix','BR'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','boleto','Boleto','boleto','BR'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','crypto','Criptomoeda','crypto',NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','visa','Visa','international','international'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','mastercard','Mastercard','international','international'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','amex','American Express','international','international'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','paypal','PayPal','international','international'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','sepa','SEPA','international','EU'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','diners','Diners Club','international','international'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','mercadopago','Mercado Pago','international','LATAM');
