// test/e2e-generator-mock/init-sqlserver.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, 'projects');

const PROJECT_DBS = [
  { name: 'todo', dbName: 'todo_mock', checkTable: 'tb_simple_item' },
  { name: 'selling', dbName: 'selling_mock', checkTable: 'tb_customer' },
  { name: 'schedule', dbName: 'schedule_mock', checkTable: 'tb_resource' },
];

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
    for (const { name: projectName, dbName, checkTable } of PROJECT_DBS) {
      const schemaPath = path.join(PROJECTS_DIR, projectName, 'db', 'schema.sqlserver.ddl');
      if (!fs.existsSync(schemaPath)) {
        console.log('[init-sqlserver] Skip', dbName, '(no schema.sqlserver.ddl)');
        continue;
      }
      await pool.request().query(
        `IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'${dbName}') CREATE DATABASE ${dbName}`
      );
      console.log('[init-sqlserver] Database', dbName, 'ready.');

      const configDb = { ...configMaster, database: dbName };
      const poolDb = await new mssql.ConnectionPool(configDb).connect();
      try {
        const check = await poolDb.request().query(
          `SELECT 1 AS ok FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = '${checkTable}'`
        );
        if (check.recordset && check.recordset.length > 0) {
          console.log('[init-sqlserver] Schema already present in', dbName, ', skipping.');
          continue;
        }
        const ddl = fs.readFileSync(schemaPath, 'utf-8');
        await poolDb.request().query(ddl);
        console.log('[init-sqlserver] Schema applied to', dbName);
      } finally {
        await poolDb.close();
      }
    }
  } finally {
    await pool.close();
  }
}

main().catch((err) => {
  console.error('[init-sqlserver]', err.message);
  process.exit(1);
});
