-- test/e2e-generator-mock/projects/users/db/database.sqlite.ddl
CREATE TABLE app_user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  address_id TEXT,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);
