-- test/e2e-generator-mock/projects/llm_integrations/db/database.mysql.sql
INSERT INTO llm_provider_config (external_id, tenant, account_id, provider_code, model_id, api_key_ref, fallback_local_endpoint, routing_priority) VALUES
('ac1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','openai','gpt-4','vault:openai:ref','http://localhost:11434',2),
('ac1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ollama','llama2',NULL,'http://localhost:11434',1);

INSERT INTO prompt_template (external_id, tenant, code, name, content) VALUES
('bc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','summarize','Resumo','Resuma o seguinte texto: {{text}}');

INSERT INTO llm_execution_log (external_id, tenant, provider_config_id, model_id, success, latency_ms) VALUES
('cc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ac1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','llama2',1,450);

INSERT INTO llm_usage_summary (external_id, tenant, account_id, provider_config_id, period_start, period_end, total_requests, total_tokens_input, total_tokens_output) VALUES
('dc1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11','ac1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12','2025-02-01','2025-02-28',150,12000,8500);
