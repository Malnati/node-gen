// test/e2e-generator/init-sqlserver.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, 'projects');

const FIRST_TABLE_REGEX = /CREATE\s+TABLE\s+(?:[\w.]+\.)?(\w+)/i;
const GO_LINE_REGEX = /\r?\n\s*GO\s*\r?\n/i;

function getFirstTableName(ddlContent) {
  const m = ddlContent.match(FIRST_TABLE_REGEX);
  return m ? m[1] : null;
}

function splitSqlServerBatches(ddlContent) {
  return ddlContent.split(GO_LINE_REGEX).map((s) => s.trim()).filter(Boolean);
}

function discoverProjects() {
  const projects = [];
  if (!fs.existsSync(PROJECTS_DIR)) return projects;
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const dbDir = path.join(PROJECTS_DIR, d.name, 'db');
    const connPath = path.join(dbDir, 'connection.sqlserver.json');
    const schemaDdl = path.join(dbDir, 'schema.sqlserver.ddl');
    const databaseDdl = path.join(dbDir, 'database.sqlserver.ddl');
    const ddlPath = fs.existsSync(schemaDdl) ? schemaDdl : (fs.existsSync(databaseDdl) ? databaseDdl : null);
    if (!fs.existsSync(connPath) || !ddlPath) continue;
    let conn;
    try {
      conn = JSON.parse(fs.readFileSync(connPath, 'utf-8'));
    } catch (e) {
      console.log('[init-sqlserver] Skip', d.name, '(invalid connection.sqlserver.json)');
      continue;
    }
    const dbName = conn.database;
    if (!dbName || typeof dbName !== 'string') {
      console.log('[init-sqlserver] Skip', d.name, '(no database in connection)');
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
    const projects = discoverProjects();
    console.log('[init-sqlserver] Found', projects.length, 'projects with SQL Server connection and DDL.');

    for (const { name, dbName, ddlContent, checkTable } of projects) {
      const dbNameEscaped = dbName.replace(/'/g, "''");
      const dbNameBracket = dbName.replace(/\]/g, ']]');
      await pool.request().query(
        `IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'${dbNameEscaped}') CREATE DATABASE [${dbNameBracket}]`
      );
      console.log('[init-sqlserver] Database', dbName, 'ready.');

      const configDb = { ...configMaster, database: dbName };
      const poolDb = await new mssql.ConnectionPool(configDb).connect();
      try {
        if (checkTable) {
          const checkTableEscaped = checkTable.replace(/'/g, "''");
          const check = await poolDb.request().query(
            `SELECT 1 AS ok FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = N'${checkTableEscaped}'`
          );
          if (check.recordset && check.recordset.length > 0) {
            console.log('[init-sqlserver] Schema already present in', dbName, ', skipping.');
            continue;
          }
        }
        const batches = splitSqlServerBatches(ddlContent);
        for (const batch of batches) {
          await poolDb.request().query(batch);
        }
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
