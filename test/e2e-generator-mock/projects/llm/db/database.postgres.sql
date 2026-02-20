-- test/e2e-generator-mock/projects/llm/db/database.postgres.sql
INSERT INTO llm_log (model_name, prompt, response, tokens_used) VALUES
('gpt-4','O que é SQL?','SQL é uma linguagem de consulta a bancos de dados.',50),
('claude-3','Explique API REST','REST é um estilo arquitetural para APIs HTTP.',45),
('llama-2','Traduza: Hello','Olá.',10);
