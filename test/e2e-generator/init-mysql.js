// test/e2e-generator/init-mysql.js
const path = require('path');
const fs = require('fs');

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, 'projects');

const host = process.env.DB_MYSQL_HOST || '127.0.0.1';
const port = parseInt(process.env.DB_MYSQL_PORT || '3306', 10);
const initUser = process.env.DB_MYSQL_INIT_USER || process.env.DB_MYSQL_USER || 'root';
const initPassword = process.env.DB_MYSQL_INIT_PASSWORD || process.env.DB_MYSQL_PASSWORD || 'root';
const e2eUser = process.env.DB_MYSQL_USER || 'e2e';
const e2ePassword = process.env.DB_MYSQL_PASSWORD || 'e2e';

function discoverProjects() {
  const projects = [];
  if (!fs.existsSync(PROJECTS_DIR)) return projects;
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const dbDir = path.join(PROJECTS_DIR, d.name, 'db');
    const connPath = path.join(dbDir, 'connection.mysql.json');
    const schemaDdl = path.join(dbDir, 'schema.mysql.ddl');
    const databaseDdl = path.join(dbDir, 'database.mysql.ddl');
    const ddlPath = fs.existsSync(schemaDdl) ? schemaDdl : (fs.existsSync(databaseDdl) ? databaseDdl : null);
    if (!fs.existsSync(connPath) || !ddlPath) continue;
    let conn;
    try {
      conn = JSON.parse(fs.readFileSync(connPath, 'utf-8'));
    } catch (e) {
      console.log('[init-mysql] Skip', d.name, '(invalid connection.mysql.json)');
      continue;
    }
    const dbName = conn.database;
    if (!dbName || typeof dbName !== 'string') {
      console.log('[init-mysql] Skip', d.name, '(no database in connection)');
      continue;
    }
    const dataPath = path.join(dbDir, 'database.mysql.sql');
    projects.push({
      name: d.name,
      dbName,
      ddlPath,
      dataPath: fs.existsSync(dataPath) ? dataPath : null,
    });
  }
  return projects.sort((a, b) => a.name.localeCompare(b.name));
}

async function main() {
  let mysql;
  try {
    mysql = require('mysql2/promise');
  } catch (e) {
    console.error('[init-mysql] mysql2 not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }

  const config = {
    host,
    port,
    user: initUser,
    password: initPassword,
    multipleStatements: true,
  };

  console.log('[init-mysql] Connecting to', host + ':' + port, '...');
  const conn = await mysql.createConnection(config);

  try {
    const projects = discoverProjects();
    console.log('[init-mysql] Found', projects.length, 'projects with MySQL connection and DDL.');

    for (const { name, dbName, ddlPath, dataPath } of projects) {
      await conn.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
      try {
        await conn.query(
          `GRANT ALL PRIVILEGES ON \`${dbName}\`.* TO \`${e2eUser.replace(/`/g, '``')}\`@'%'`
        );
      } catch (grantErr) {
        if (grantErr.code !== 'ER_CANNOT_USER') throw grantErr;
      }
      console.log('[init-mysql] Database', dbName, 'ready.');

      const configDb = { ...config, database: dbName };
      const connDb = await mysql.createConnection(configDb);
      try {
        const ddl = fs.readFileSync(ddlPath, 'utf-8');
        await connDb.query(ddl);
        console.log('[init-mysql] Schema applied to', dbName);
        if (dataPath) {
          const data = fs.readFileSync(dataPath, 'utf-8');
          await connDb.query(data);
          console.log('[init-mysql] Data applied to', dbName);
        }
      } finally {
        await connDb.end();
      }
    }

    await conn.query('FLUSH PRIVILEGES');
  } finally {
    await conn.end();
  }
}

main().catch((err) => {
  console.error('[init-mysql]', err.message);
  process.exit(1);
});
