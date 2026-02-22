// test/e2e-generator/projects/selling/db/create-sqlite-fixture.js
const sqlite3 = require('sqlite3');
const path = require('path');
const fs = require('fs');

const outDir = process.argv[2] || path.join(process.cwd(), 'output');
const dbPath = path.join(outDir, 'fixture.sqlite');
const ddlPath = path.join(__dirname, 'database.sqlite.ddl');

if (!fs.existsSync(ddlPath)) {
  console.error('DDL not found:', ddlPath);
  process.exit(1);
}

if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

const ddl = fs.readFileSync(ddlPath, 'utf-8');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error(err.message);
    process.exit(1);
  }
});

db.exec(ddl, (err) => {
  if (err) {
    console.error(err.message);
    db.close();
    process.exit(1);
  }
  db.close((closeErr) => {
    if (closeErr) {
      console.error(closeErr.message);
      process.exit(1);
    }
    console.log(`SQLite fixture created at ${dbPath}`);
  });
});
