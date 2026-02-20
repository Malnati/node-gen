-- test/e2e-generator-mock/projects/companies/db/database.sqlite.ddl
CREATE TABLE company (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  contact_id TEXT,
  name TEXT NOT NULL,
  legal_name TEXT,
  tax_id TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);
