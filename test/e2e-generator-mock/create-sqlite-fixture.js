// test/e2e-generator-mock/create-sqlite-fixture.js
const sqlite3 = require('sqlite3');
const path = require('path');
const fs = require('fs');

const outDir = process.argv[2] || path.join(process.cwd(), 'build-cli-test');
const dbPath = path.join(outDir, 'fixture.sqlite');

if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error(err.message);
    process.exit(1);
  }
});

db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS tb_user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      external_id TEXT,
      name TEXT,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now'))
    )
  `);
});

db.close((err) => {
  if (err) {
    console.error(err.message);
    process.exit(1);
  }
  console.log(`SQLite fixture created at ${dbPath}`);
});
