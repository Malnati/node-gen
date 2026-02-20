// test/e2e-generator-mock/init-postgres.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, 'projects');

const EXTRA_DBS = [
  { name: 'todo', dbName: 'todo_mock', schemaFile: 'todo/db/database.postgres.ddl', checkTable: 'tb_simple_item' },
  { name: 'selling', dbName: 'selling_mock', schemaFile: 'selling/db/schema.postgres.ddl', checkTable: 'tb_order' },
  { name: 'google-calendar', dbName: 'google_calendar_mock', schemaFile: 'google-calendar/db/database.postgres.ddl', checkTable: 'calendar_integration' },
];

const host = process.env.DB_POSTGRES_HOST || '127.0.0.1';
const port = parseInt(process.env.DB_POSTGRES_PORT || '5432', 10);
const user = process.env.DB_POSTGRES_USER || 'postgres';
const password = process.env.DB_POSTGRES_PASSWORD || 'postgres';

async function main() {
  let pg;
  try {
    pg = require('pg');
  } catch (e) {
    console.error('[init-postgres] pg not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }
  const client = new pg.Client({
    host,
    port,
    user,
    password,
    database: 'postgres',
  });
  try {
    await client.connect();
    for (const { dbName, schemaFile, checkTable } of EXTRA_DBS) {
      const schemaPath = path.join(PROJECTS_DIR, schemaFile);
      if (!fs.existsSync(schemaPath)) {
        console.log('[init-postgres] Skip', dbName, '(no schema file)');
        continue;
      }
      const dbExists = await client.query(`SELECT 1 FROM pg_database WHERE datname = $1`, [dbName]);
      if (dbExists.rows.length === 0) {
        await client.query(`CREATE DATABASE ${dbName}`);
        console.log('[init-postgres] Database', dbName, 'created.');
      }
      const poolDb = new pg.Client({ host, port, user, password, database: dbName });
      await poolDb.connect();
      try {
        const check = await poolDb.query(
          "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = $1",
          [checkTable]
        );
        if (check.rows.length > 0) {
          console.log('[init-postgres] Schema already present in', dbName);
          continue;
        }
        const ddl = fs.readFileSync(schemaPath, 'utf-8');
        await poolDb.query(ddl);
        console.log('[init-postgres] Schema applied to', dbName);
      } finally {
        await poolDb.end();
      }
    }
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[init-postgres]', err.message);
  process.exit(1);
});
