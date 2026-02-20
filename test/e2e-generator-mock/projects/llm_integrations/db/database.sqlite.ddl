-- test/e2e-generator-mock/projects/llm_integrations/db/database.sqlite.ddl
CREATE TABLE llm_provider_config (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT,
  provider_code TEXT NOT NULL,
  model_id TEXT,
  api_key_ref TEXT,
  fallback_local_endpoint TEXT,
  routing_priority INTEGER,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE prompt_template (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  code TEXT NOT NULL,
  name TEXT,
  content TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);

CREATE TABLE llm_execution_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  provider_config_id TEXT,
  model_id TEXT,
  success INTEGER,
  latency_ms INTEGER,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id)
);
