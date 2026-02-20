-- test/e2e-generator-mock/projects/llm_integrations/db/database.sqlserver.ddl
CREATE TABLE llm_provider_config (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  account_id UNIQUEIDENTIFIER,
  provider_code NVARCHAR(50) NOT NULL,
  model_id NVARCHAR(100),
  api_key_ref NVARCHAR(255),
  fallback_local_endpoint NVARCHAR(500),
  routing_priority INT,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_llm_provider_config_external_id UNIQUE (external_id)
);

CREATE TABLE prompt_template (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  code NVARCHAR(100) NOT NULL,
  name NVARCHAR(255),
  content NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_prompt_template_external_id UNIQUE (external_id)
);

CREATE TABLE llm_execution_log (
  id INT IDENTITY(1,1) PRIMARY KEY,
  external_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
  tenant UNIQUEIDENTIFIER NOT NULL,
  provider_config_id UNIQUEIDENTIFIER,
  model_id NVARCHAR(100),
  success BIT,
  latency_ms INT,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2,
  deleted_at DATETIME2,
  CONSTRAINT uk_llm_execution_log_external_id UNIQUE (external_id)
);
