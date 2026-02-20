-- test/e2e-generator-mock/projects/addresses/db/database.sqlite.ddl
CREATE TABLE address (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  zip_code TEXT,
  country TEXT DEFAULT 'BR',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  deleted_at DATETIME
);
