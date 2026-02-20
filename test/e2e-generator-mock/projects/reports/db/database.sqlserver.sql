-- test/e2e-generator-mock/projects/reports/db/database.sqlserver.sql
INSERT INTO consolidated_sales_monthly (tenant, year_month, total_amount, order_count, currency_code, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','2025-01',380.30,2,'BRL',GETDATE()),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','2025-01',0,0,'BRL',GETDATE());

INSERT INTO current_inventory_levels (tenant, product_id, address_id, quantity, reserved, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',100,5,GETDATE()),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',50,0,GETDATE());

INSERT INTO logistics_performance (tenant, period_type, period_key, on_time_rate, avg_delivery_days, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','month','2025-02',95.50,2.30,GETDATE());
