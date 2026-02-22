// test/e2e-generator/init-postgres.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, 'projects');

const FIRST_TABLE_REGEX = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:[\w.]+\.)?(\w+)/i;

function getFirstTableName(ddlContent) {
  const m = ddlContent.match(FIRST_TABLE_REGEX);
  return m ? m[1] : null;
}

function discoverProjects() {
  const projects = [];
  if (!fs.existsSync(PROJECTS_DIR)) return projects;
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const dbDir = path.join(PROJECTS_DIR, d.name, 'db');
    const connPath = path.join(dbDir, 'connection.postgres.json');
    const schemaDdl = path.join(dbDir, 'schema.postgres.ddl');
    const databaseDdl = path.join(dbDir, 'database.postgres.ddl');
    const ddlPath = fs.existsSync(schemaDdl) ? schemaDdl : (fs.existsSync(databaseDdl) ? databaseDdl : null);
    if (!fs.existsSync(connPath) || !ddlPath) continue;
    let conn;
    try {
      conn = JSON.parse(fs.readFileSync(connPath, 'utf-8'));
    } catch (e) {
      console.log('[init-postgres] Skip', d.name, '(invalid connection.postgres.json)');
      continue;
    }
    const dbName = conn.database;
    if (!dbName || typeof dbName !== 'string') {
      console.log('[init-postgres] Skip', d.name, '(no database in connection)');
      continue;
    }
    const ddlContent = fs.readFileSync(ddlPath, 'utf-8');
    const checkTable = getFirstTableName(ddlContent);
    projects.push({
      name: d.name,
      dbName,
      ddlContent,
      checkTable,
    });
  }
  return projects.sort((a, b) => a.name.localeCompare(b.name));
}

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
    const projects = discoverProjects();
    console.log('[init-postgres] Found', projects.length, 'projects with Postgres connection and DDL.');

    for (const { name, dbName, ddlContent, checkTable } of projects) {
      const dbExists = await client.query(`SELECT 1 FROM pg_database WHERE datname = $1`, [dbName]);
      if (dbExists.rows.length === 0) {
        await client.query(`CREATE DATABASE ${dbName}`);
        console.log('[init-postgres] Database', dbName, 'created.');
      }
      const poolDb = new pg.Client({ host, port, user, password, database: dbName });
      await poolDb.connect();
      try {
        if (checkTable) {
          const check = await poolDb.query(
            "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = $1",
            [checkTable]
          );
          if (check.rows.length > 0) {
            console.log('[init-postgres] Schema already present in', dbName);
            continue;
          }
        }
        await poolDb.query(ddlContent);
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
