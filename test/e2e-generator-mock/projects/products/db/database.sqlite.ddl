-- test/e2e-generator-mock/projects/products/db/database.sqlite.ddl
CREATE TABLE currency (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  symbol TEXT,
  region TEXT CHECK (region IS NULL OR region IN ('SOUTH_AMERICA','NORTH_AMERICA','EUROPE')),
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  UNIQUE(code)
);

CREATE TABLE unit_of_measure (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT,
  code TEXT NOT NULL,
  name TEXT,
  symbol TEXT,
  category TEXT CHECK (category IS NULL OR category IN ('COUNT','WEIGHT','VOLUME','LENGTH','AREA','TIME')),
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  UNIQUE(code)
);

CREATE TABLE product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  external_id TEXT NOT NULL,
  tenant TEXT NOT NULL,
  account_id TEXT NOT NULL,
  sku TEXT,
  name TEXT NOT NULL,
  description TEXT,
  unit_of_measure_id INTEGER NOT NULL,
  currency_id INTEGER NOT NULL,
  unit_price REAL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT,
  deleted_at TEXT,
  UNIQUE(external_id),
  FOREIGN KEY (currency_id) REFERENCES currency(id),
  FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(id)
);
