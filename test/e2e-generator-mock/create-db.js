// test/e2e-generator-mock/create-db.js
const sqlite3 = require('sqlite3');
const path = require('path');
const fs = require('fs');

const schemaPath = path.join(__dirname, 'projects', 'todo', 'db', 'schema.sql');
const dbPath = path.join(__dirname, 'mock.sqlite');

const sql = fs.readFileSync(schemaPath, 'utf-8');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error(err.message);
    process.exit(1);
  }
});

db.exec(sql, (err) => {
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
    console.log(`Mock database created at ${dbPath}`);
  });
});
