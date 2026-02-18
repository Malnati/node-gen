// test/e2e-generator-mock/init-sqlserver.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const SCHEMA_PATH = path.join(MOCK_DIR, 'projects', 'todo', 'db', 'schema.sqlserver.ddl');
const DB_NAME = 'todo_mock';

const host = process.env.DB_SQLSERVER_HOST || '127.0.0.1';
const port = parseInt(process.env.DB_SQLSERVER_PORT || '1433', 10);
const user = process.env.DB_SQLSERVER_USER || 'sa';
const password = process.env.DB_SQLSERVER_PASSWORD || 'YourStrong@Passw0rd';

async function main() {
  let mssql;
  try {
    mssql = require('mssql');
  } catch (e) {
    console.error('[init-sqlserver] mssql not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }

  const configMaster = {
    user,
    password,
    server: host,
    port,
    database: 'master',
    options: { encrypt: true, trustServerCertificate: true },
    connectionTimeout: 60000,
    requestTimeout: 60000,
  };

  console.log('[init-sqlserver] Connecting to', host + ':' + port, '...');
  const pool = await new mssql.ConnectionPool(configMaster).connect();

  try {
    await pool.request().query(`IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'${DB_NAME}') CREATE DATABASE ${DB_NAME}`);
    console.log('[init-sqlserver] Database', DB_NAME, 'ready.');

    const configDb = { ...configMaster, database: DB_NAME };
    const poolDb = await new mssql.ConnectionPool(configDb).connect();
    try {
      const check = await poolDb.request().query(
        "SELECT 1 AS ok FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_simple_item'"
      );
      if (check.recordset && check.recordset.length > 0) {
        console.log('[init-sqlserver] Schema already present, skipping.');
        return;
      }
      const ddl = fs.readFileSync(SCHEMA_PATH, 'utf-8');
      await poolDb.request().query(ddl);
      console.log('[init-sqlserver] Schema applied.');
    } finally {
      await poolDb.close();
    }
  } finally {
    await pool.close();
  }
}

main().catch((err) => {
  console.error('[init-sqlserver]', err.message);
  process.exit(1);
});
