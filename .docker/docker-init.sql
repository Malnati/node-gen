-- docker-init.sql
-- Configurar autenticação como trust para localhost
ALTER SYSTEM SET pg_hba.conf = 'host all all 0.0.0.0/0 trust
host all all ::0/0 trust
local all all trust
host all all 127.0.0.1/32 trust
host all all ::1/128 trust';

SELECT pg_reload_conf();
