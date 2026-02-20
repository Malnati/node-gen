-- test/e2e-generator-mock/projects/reports/db/database.mysql.sql
INSERT INTO consolidated_sales_monthly (tenant, year_month, total_amount, order_count, currency_code, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','2025-01',380.30,2,'BRL',NOW()),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','2025-01',0,0,'BRL',NOW());

INSERT INTO current_warehouse_stock (tenant, warehouse_stock_external_id, snapshot_at, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',NOW(),NOW()),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','w1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02',NOW(),NOW());

INSERT INTO logistics_performance (tenant, period_type, period_key, on_time_rate, avg_delivery_days, updated_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','month','2025-02',95.50,2.30,NOW());
