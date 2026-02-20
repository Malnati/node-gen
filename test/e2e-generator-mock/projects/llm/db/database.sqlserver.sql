-- test/e2e-generator-mock/projects/llm/db/database.sqlserver.sql
INSERT INTO llm_log (external_id, tenant, account_id, model_name, prompt, response, tokens_used) VALUES
('e01eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','gpt-4','O que é SQL?','SQL é uma linguagem de consulta a bancos de dados.',50),
('e01eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','claude-3','Explique API REST','REST é um estilo arquitetural para APIs HTTP.',45),
('e01eebc99-9c0b-4ef8-bb6d-6bb9bd380a13','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',NULL,'llama-2','Traduza: Hello','Olá.',10);
