// test/e2e-generator/db.js
const path = require('path');
const fs = require('fs');
const { spawnSync } = require('child_process');

const configPath = path.join(__dirname, 'db.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

const MOCK_DIR = path.resolve(__dirname);
const PROJECTS_DIR = path.join(MOCK_DIR, config.projectsDirName);
const connectionFilePattern = new RegExp(config.connectionFilePattern);
const firstTableRegexPostgres = new RegExp(config.firstTableRegexPostgres, 'i');
const firstTableRegexSqlserver = new RegExp(config.firstTableRegexSqlserver, 'i');
const goLineRegex = new RegExp(config.goLineRegex, 'gi');

function parseArgs() {
  const args = process.argv.slice(2).filter((a) => typeof a === 'string');
  const projects = [];
  let mode = 'full';
  let load = false;
  let applyComments = false;
  for (const a of args) {
    if (a === '--resume' || a === '--incremental') mode = 'incremental';
    else if (a === '--full') mode = 'full';
    else if (a === '--load') load = true;
    else if (a === '--apply-comments') applyComments = true;
    else if (!a.startsWith('--')) projects.push(a);
  }
  return { projects, mode, load, applyComments };
}

function discoverProjectsByEngine(engine) {
  const connFileName = config[engine] && config[engine].connectionFileName;
  if (!connFileName) return [];
  const out = [];
  if (!fs.existsSync(PROJECTS_DIR)) return out;
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const dbDir = path.join(PROJECTS_DIR, d.name, 'db');
    const connPath = path.join(dbDir, connFileName);
    if (!fs.existsSync(connPath)) continue;
    let conn;
    try {
      conn = JSON.parse(fs.readFileSync(connPath, 'utf-8'));
    } catch (e) {
      continue;
    }
    const dbName = conn.database;
    if (!dbName || typeof dbName !== 'string') continue;
    const ddlExts = config[engine].ddlExtensions || [];
    let ddlPath = null;
    for (const ext of ddlExts) {
      const p = path.join(dbDir, ext);
      if (fs.existsSync(p)) {
        ddlPath = p;
        break;
      }
    }
    if (!ddlPath) continue;
    out.push({
      name: d.name,
      dbName,
      dbDir,
      connPath,
      ddlPath,
      conn,
    });
  }
  return out.sort((a, b) => a.name.localeCompare(b.name));
}

function getFirstTableName(ddlContent, engine) {
  const re = engine === 'sqlserver' ? firstTableRegexSqlserver : firstTableRegexPostgres;
  const m = ddlContent.match(re);
  if (!m) return null;
  return m[1] || m[2];
}

async function runSqliteSync(projectList, mode) {
  const sqliteConfig = config.sqlite;
  const todoName = sqliteConfig.todoProjectName;
  const todoMockPath = path.join(MOCK_DIR, sqliteConfig.todoMockFileName);
  const projects = projectList.length > 0
    ? discoverProjectsByEngine('sqlite').filter((p) => projectList.includes(p.name))
    : discoverProjectsByEngine('sqlite');

  for (const p of projects) {
    const isTodo = p.name === todoName;
    const mockPath = isTodo
      ? todoMockPath
      : path.join(MOCK_DIR, sqliteConfig.otherMockPrefix + p.name + sqliteConfig.otherMockSuffix);

    if (mode === 'incremental' && fs.existsSync(mockPath)) {
      console.log('[db] SQLite mock already exists:', mockPath);
      continue;
    }
    if (mode === 'full' && fs.existsSync(mockPath)) {
      try {
        fs.unlinkSync(mockPath);
      } catch (e) {
        console.error('[db] Failed to remove', mockPath, e.message);
        process.exit(1);
      }
    }

    if (isTodo) {
      const ddl = fs.readFileSync(p.ddlPath, 'utf-8');
      const sqlite3 = require('sqlite3');
      await new Promise((resolve, reject) => {
        const db = new sqlite3.Database(mockPath, (err) => {
          if (err) return reject(err);
        });
        db.exec(ddl, (err) => {
          db.close(() => {
            if (err) reject(err);
            else resolve();
          });
        });
      });
      console.log('[db] SQLite mock created:', mockPath);
    } else {
      const fixtureScript = path.join(p.dbDir, sqliteConfig.fixtureScriptName);
      if (!fs.existsSync(fixtureScript)) {
        console.log('[db] Skip', p.name, '(no create-sqlite-fixture.js)');
        continue;
      }
      const r = spawnSync(process.execPath, [fixtureScript, MOCK_DIR], {
        cwd: path.resolve(__dirname, '..', '..'),
        stdio: 'inherit',
      });
      if (r.status !== 0) {
        console.error('[db] create-sqlite-fixture failed for', p.name);
        process.exit(1);
      }
      const fixturePath = path.join(MOCK_DIR, sqliteConfig.fixtureOutputName);
      if (!fs.existsSync(fixturePath)) {
        console.error('[db] Fixture not created at', fixturePath);
        process.exit(1);
      }
      try {
        fs.renameSync(fixturePath, mockPath);
      } catch (e) {
        console.error('[db] Failed to rename fixture:', e.message);
        process.exit(1);
      }
      console.log('[db] SQLite mock created:', mockPath);
    }
  }
}

async function runPostgres(projectList, mode, load) {
  const pgConfig = config.postgres;
  const host = process.env[pgConfig.hostEnv] || pgConfig.hostDefault;
  const port = parseInt(process.env[pgConfig.portEnv] || String(pgConfig.portDefault), 10);
  const user = process.env[pgConfig.userEnv] || pgConfig.userDefault;
  const password = process.env[pgConfig.passwordEnv] || pgConfig.passwordDefault;
  let pg;
  try {
    pg = require('pg');
  } catch (e) {
    console.error('[db] pg not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }
  const projects = projectList.length > 0
    ? discoverProjectsByEngine('postgres').filter((p) => projectList.includes(p.name))
    : discoverProjectsByEngine('postgres');
  if (projects.length === 0) return;

  const client = new pg.Client({
    host,
    port,
    user,
    password,
    database: 'postgres',
  });
  await client.connect();
  try {
    for (const p of projects) {
      const dbExists = await client.query('SELECT 1 FROM pg_database WHERE datname = $1', [p.dbName]);
      if (dbExists.rows.length === 0) {
        await client.query('CREATE DATABASE ' + p.dbName);
        console.log('[db] Postgres database', p.dbName, 'created.');
      } else if (mode === 'full') {
        await client.query('DROP DATABASE IF EXISTS ' + p.dbName);
        await client.query('CREATE DATABASE ' + p.dbName);
        console.log('[db] Postgres database', p.dbName, 'recreated.');
      } else {
        console.log('[db] Postgres database', p.dbName, 'already exists.');
      }

      const poolDb = new pg.Client({ host, port, user, password, database: p.dbName });
      await poolDb.connect();
      try {
        const ddlContent = fs.readFileSync(p.ddlPath, 'utf-8');
        const checkTable = getFirstTableName(ddlContent, 'postgres');
        if (checkTable && mode === 'incremental') {
          const check = await poolDb.query(
            "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = $1",
            [checkTable]
          );
          if (check.rows.length > 0) {
            console.log('[db] Postgres schema already present in', p.dbName);
            if (load) {
              const dataPath = path.join(p.dbDir, 'database.postgres.sql');
              if (fs.existsSync(dataPath)) {
                const data = fs.readFileSync(dataPath, 'utf-8');
                await poolDb.query(data);
                console.log('[db] Postgres data applied to', p.dbName);
              }
            }
            continue;
          }
        }
        await poolDb.query(ddlContent);
        console.log('[db] Postgres schema applied to', p.dbName);
        if (load) {
          const dataPath = path.join(p.dbDir, 'database.postgres.sql');
          if (fs.existsSync(dataPath)) {
            const data = fs.readFileSync(dataPath, 'utf-8');
            await poolDb.query(data);
            console.log('[db] Postgres data applied to', p.dbName);
          }
        }
      } finally {
        await poolDb.end();
      }
    }
  } finally {
    await client.end();
  }
}

async function runMysql(projectList, mode, load) {
  const mysqlConfig = config.mysql;
  const host = process.env[mysqlConfig.hostEnv] || mysqlConfig.hostDefault;
  const port = parseInt(process.env[mysqlConfig.portEnv] || String(mysqlConfig.portDefault), 10);
  const initUser = process.env[mysqlConfig.initUserEnv] || process.env[mysqlConfig.userEnv] || mysqlConfig.initUserDefault;
  const initPassword = process.env[mysqlConfig.initPasswordEnv] || process.env[mysqlConfig.passwordEnv] || mysqlConfig.initPasswordDefault;
  const e2eUser = process.env[mysqlConfig.userEnv] || mysqlConfig.userDefault;
  const e2ePassword = process.env[mysqlConfig.passwordEnv] || mysqlConfig.passwordDefault;
  let mysql;
  try {
    mysql = require('mysql2/promise');
  } catch (e) {
    console.error('[db] mysql2 not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }
  const projects = projectList.length > 0
    ? discoverProjectsByEngine('mysql').filter((p) => projectList.includes(p.name))
    : discoverProjectsByEngine('mysql');
  if (projects.length === 0) return;

  const connConfig = {
    host,
    port,
    user: initUser,
    password: initPassword,
    multipleStatements: true,
  };
  const conn = await mysql.createConnection(connConfig);
  try {
    const e2eUserEsc = e2eUser.replace(/`/g, '``');
    const e2ePasswordEsc = e2ePassword.replace(/'/g, "''");
    await conn.query("CREATE USER IF NOT EXISTS `" + e2eUserEsc + "`@'%' IDENTIFIED BY '" + e2ePasswordEsc + "'");
    await conn.query('FLUSH PRIVILEGES');

    for (const p of projects) {
      if (mode === 'full') {
        await conn.query('DROP DATABASE IF EXISTS `' + p.dbName.replace(/`/g, '``') + '`');
      }
      await conn.query('CREATE DATABASE IF NOT EXISTS `' + p.dbName.replace(/`/g, '``') + '`');
      try {
        await conn.query('GRANT ALL PRIVILEGES ON `' + p.dbName.replace(/`/g, '``') + '`.* TO `' + e2eUser.replace(/`/g, '``') + '`@\'%\'');
      } catch (grantErr) {
        if (grantErr.code !== 'ER_CANNOT_USER') throw grantErr;
      }
      console.log('[db] MySQL database', p.dbName, 'ready.');

      const connDb = await mysql.createConnection({ ...connConfig, database: p.dbName });
      try {
        const ddlContent = fs.readFileSync(p.ddlPath, 'utf-8');
        const checkTable = getFirstTableName(ddlContent, 'postgres');
        let applyDdl = true;
        if (checkTable && mode === 'incremental') {
          const [rows] = await connDb.execute(
            "SELECT 1 AS ok FROM information_schema.tables WHERE table_schema = ? AND table_name = ? LIMIT 1",
            [p.dbName, checkTable]
          );
          if (rows && rows.length > 0) applyDdl = false;
        }
        if (applyDdl) {
          await connDb.query(ddlContent);
          console.log('[db] MySQL schema applied to', p.dbName);
        } else {
          console.log('[db] MySQL schema already present in', p.dbName);
        }
        if (load) {
          const dataPath = path.join(p.dbDir, mysqlConfig.dataExtension);
          if (fs.existsSync(dataPath)) {
            const data = fs.readFileSync(dataPath, 'utf-8');
            await connDb.query(data);
            console.log('[db] MySQL data applied to', p.dbName);
          }
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

async function runSqlserver(projectList, mode, load) {
  const ssConfig = config.sqlserver;
  const host = process.env[ssConfig.hostEnv] || ssConfig.hostDefault;
  const port = parseInt(process.env[ssConfig.portEnv] || String(ssConfig.portDefault), 10);
  const user = process.env[ssConfig.userEnv] || ssConfig.userDefault;
  const password = process.env[ssConfig.passwordEnv] || ssConfig.passwordDefault;
  let mssql;
  try {
    mssql = require('mssql');
  } catch (e) {
    console.error('[db] mssql not found. Set NODE_PATH to gen/node_modules.');
    process.exit(1);
  }
  const projects = projectList.length > 0
    ? discoverProjectsByEngine('sqlserver').filter((p) => projectList.includes(p.name))
    : discoverProjectsByEngine('sqlserver');
  if (projects.length === 0) return;

  function splitBatches(ddlContent) {
    return ddlContent.split(goLineRegex).map((s) => s.trim()).filter(Boolean);
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
  const pool = await new mssql.ConnectionPool(configMaster).connect();
  try {
    for (const p of projects) {
      const dbNameEscaped = p.dbName.replace(/'/g, "''");
      const dbNameBracket = p.dbName.replace(/]/g, ']]');
      if (mode === 'full') {
        await pool.request().query(
          "IF EXISTS (SELECT * FROM sys.databases WHERE name = N'" + dbNameEscaped + "') DROP DATABASE [" + dbNameBracket + "]"
        );
      }
      await pool.request().query(
        "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'" + dbNameEscaped + "') CREATE DATABASE [" + dbNameBracket + "]"
      );
      console.log('[db] SQL Server database', p.dbName, 'ready.');

      const poolDb = await new mssql.ConnectionPool({ ...configMaster, database: p.dbName }).connect();
      try {
        const ddlContent = fs.readFileSync(p.ddlPath, 'utf-8');
        const checkTable = getFirstTableName(ddlContent, 'sqlserver');
        let applyDdl = true;
        if (checkTable && mode === 'incremental') {
          const checkTableEscaped = checkTable.replace(/'/g, "''");
          const check = await poolDb.request().query(
            "SELECT 1 AS ok FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = N'" + checkTableEscaped + "'"
          );
          if (check.recordset && check.recordset.length > 0) applyDdl = false;
        }
        if (applyDdl) {
          const batches = splitBatches(ddlContent);
          for (const batch of batches) {
            await poolDb.request().query(batch);
          }
          console.log('[db] SQL Server schema applied to', p.dbName);
        } else {
          console.log('[db] SQL Server schema already present in', p.dbName);
        }
        if (load) {
          const dataPath = path.join(p.dbDir, 'database.sqlserver.sql');
          if (fs.existsSync(dataPath)) {
            const data = fs.readFileSync(dataPath, 'utf-8');
            const batches = splitBatches(data);
            for (const batch of batches) {
              await poolDb.request().query(batch);
            }
            console.log('[db] SQL Server data applied to', p.dbName);
          }
        }
      } finally {
        await poolDb.close();
      }
    }
  } finally {
    await pool.close();
  }
}

function stripQuotes(s) {
  if (s && s.length >= 2 && s[0] === '"' && s[s.length - 1] === '"') return s.slice(1, -1);
  return s;
}

function parsePostgresComments(content) {
  const tableComments = {};
  const columnComments = {};
  const constraintComments = {};
  const reTable = /COMMENT ON TABLE ("[^"]+"|\w+) IS '([^']*(?:\\'[^']*)*)'/g;
  const reColumn = /COMMENT ON COLUMN ("[^"]+"|\w+)\.(\w+) IS '([^']*(?:\\'[^']*)*)'/g;
  const reConstraint = /COMMENT ON CONSTRAINT (\w+) ON ("[^"]+"|\w+) IS '([^']*(?:\\'[^']*)*)'/g;
  let m;
  while ((m = reTable.exec(content)) !== null) tableComments[stripQuotes(m[1])] = m[2].replace(/\\'/g, "'");
  while ((m = reColumn.exec(content)) !== null) {
    const t = stripQuotes(m[1]);
    if (!columnComments[t]) columnComments[t] = {};
    columnComments[t][m[2]] = m[3].replace(/\\'/g, "'");
  }
  while ((m = reConstraint.exec(content)) !== null) {
    const t = stripQuotes(m[2]);
    if (!constraintComments[t]) constraintComments[t] = {};
    constraintComments[t][m[1]] = m[3].replace(/\\'/g, "'");
  }
  return { tableComments, columnComments, constraintComments };
}

function mergeComments(acc, parsed) {
  Object.assign(acc.tableComments, parsed.tableComments);
  for (const [t, cols] of Object.entries(parsed.columnComments)) {
    if (!acc.columnComments[t]) acc.columnComments[t] = {};
    Object.assign(acc.columnComments[t], cols);
  }
  for (const [t, cons] of Object.entries(parsed.constraintComments)) {
    if (!acc.constraintComments[t]) acc.constraintComments[t] = {};
    Object.assign(acc.constraintComments[t], cons);
  }
}

function extractColumnName(line) {
  const trimmed = line.trim();
  if (trimmed.startsWith('[')) {
    const end = trimmed.indexOf(']');
    if (end !== -1) return trimmed.slice(1, end);
  }
  const first = trimmed.split(/\s+/)[0];
  return first || null;
}

function applyMySQL(content, comments) {
  const out = [];
  const lines = content.split('\n');
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (!line.trim().startsWith('CREATE TABLE')) {
      out.push(line);
      i++;
      continue;
    }
    const tableMatch = line.match(/CREATE TABLE ([`]?\w+[`]?)\s*\(/);
    const tableName = tableMatch ? tableMatch[1].replace(/[`]/g, '') : null;
    out.push(line);
    i++;
    const tableComment = tableName && comments.tableComments[tableName];
    const colComments = tableName && comments.columnComments[tableName] ? comments.columnComments[tableName] : {};
    const blockLines = [];
    for (let j = i; j < lines.length; j++) {
      blockLines.push(lines[j]);
      if (/^\s*\)\s*;?\s*$/.test(lines[j].trim())) {
        i = j + 1;
        break;
      }
    }
    const lastIdx = blockLines.length - 1;
    for (let k = 0; k < blockLines.length; k++) {
      let l = blockLines[k];
      const isClosing = k === lastIdx && /^\s*\)\s*;?\s*$/.test(l.trim());
      if (isClosing && tableComment != null && tableComment !== '') {
        const escaped = String(tableComment).replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        l = l.replace(/\)\s*;?\s*$/, ") COMMENT = '" + escaped + "';");
      } else {
        const colName = extractColumnName(l);
        const colComment = colName && colComments[colName];
        if (colComment && !l.includes("COMMENT '") && !l.includes('COMMENT =')) {
          const escaped = colComment.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
          if (l.trim().endsWith(',')) l = l.replace(/,(\s*)$/, " COMMENT '" + escaped + "',$1");
          else l = l.replace(/\s*\)/, " COMMENT '" + escaped + "' )");
        }
      }
      out.push(l);
    }
  }
  return out.join('\n');
}

function applySQLServer(content, comments) {
  const out = [];
  const lines = content.split('\n');
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const createMatch = line.match(/CREATE TABLE (?:\[(\w+)\]|(\w+))\s*\(/);
    if (!createMatch) {
      if (line.trim().startsWith('EXEC sp_addextendedproperty')) {
        i++;
        continue;
      }
      out.push(line);
      i++;
      continue;
    }
    const tableName = createMatch[1] || createMatch[2];
    out.push(line);
    i++;
    const tableComment = comments.tableComments[tableName];
    const colComments = comments.columnComments[tableName] || {};
    const constraintCommentsTable = comments.constraintComments[tableName] || {};
    const blockLines = [];
    const constraintNames = [];
    for (let j = i; j < lines.length; j++) {
      const l = lines[j];
      const t = l.trim();
      const cMatch = t.match(/CONSTRAINT\s+(\w+)\s+/);
      if (cMatch) constraintNames.push(cMatch[1]);
      blockLines.push(l);
      if (/^\s*\)\s*;?\s*$/.test(t)) {
        i = j + 1;
        break;
      }
    }
    let rewritten = [];
    let hasNamedPk = false;
    for (let k = 0; k < blockLines.length; k++) {
      let l = blockLines[k];
      const trimmed = l.trim();
      if (/^id\s+INT\s+IDENTITY\(1,1\)\s+PRIMARY KEY\s*,?\s*$/i.test(trimmed)) {
        rewritten.push(l.replace(/\s+PRIMARY KEY\s*,?/i, ','));
        hasNamedPk = false;
      } else if (/CONSTRAINT\s+pk_\w+\s+PRIMARY KEY/i.test(trimmed)) {
        hasNamedPk = true;
        rewritten.push(l);
      } else {
        rewritten.push(l);
      }
    }
    const lastLine = rewritten[rewritten.length - 1];
    if (!hasNamedPk && lastLine && /\)\s*;?\s*$/.test(lastLine.trim())) {
      rewritten[rewritten.length - 1] = lastLine.replace(/\s*\)\s*;?\s*$/, ',\n  CONSTRAINT pk_' + tableName + ' PRIMARY KEY (id)\n);');
      constraintNames.push('pk_' + tableName);
    }
    for (const l of rewritten) out.push(l);
    const schema = 'dbo';
    if (tableComment != null && tableComment !== '') {
      out.push("EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'" + String(tableComment).replace(/'/g, "''") + "', @level0type = N'SCHEMA', @level0name = N'" + schema + "', @level1type = N'TABLE', @level1name = N'" + tableName + "';");
    }
    const colNames = [];
    for (const l of rewritten) {
      const c = extractColumnName(l);
      if (c && !['CONSTRAINT', 'PRIMARY', 'UNIQUE', 'FOREIGN', 'CHECK'].includes(c)) colNames.push(c);
    }
    for (const col of colNames) {
      const desc = colComments[col];
      if (desc != null && desc !== '') {
        out.push("EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'" + String(desc).replace(/'/g, "''") + "', @level0type = N'SCHEMA', @level0name = N'" + schema + "', @level1type = N'TABLE', @level1name = N'" + tableName + "', @level2type = N'COLUMN', @level2name = N'" + col + "';");
      }
    }
    for (const cn of constraintNames) {
      const desc = constraintCommentsTable[cn];
      if (desc != null && desc !== '') {
        out.push("EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'" + String(desc).replace(/'/g, "''") + "', @level0type = N'SCHEMA', @level0name = N'" + schema + "', @level1type = N'TABLE', @level1name = N'" + tableName + "', @level2type = N'CONSTRAINT', @level2name = N'" + cn + "';");
      }
    }
  }
  return out.join('\n');
}

function applySQLite(content, comments) {
  const out = [];
  const lines = content.split('\n');
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const tableMatch = line.match(/CREATE TABLE ("[^"]+"|\w+)\s*\(/);
    if (!tableMatch) {
      out.push(line);
      i++;
      continue;
    }
    const tableName = stripQuotes(tableMatch[1]);
    const tableComment = comments.tableComments[tableName];
    if (tableComment !== undefined) {
      out.push('-- ' + (tableComment.endsWith('.') ? tableComment : tableComment + '.'));
    }
    out.push(line);
    i++;
    const colComments = comments.columnComments[tableName] || {};
    for (let j = i; j < lines.length; j++) {
      const l = lines[j];
      const t = l.trim();
      const colName = extractColumnName(l);
      const colComment = colName && colComments[colName];
      const isConstraintLine = t.startsWith('CONSTRAINT') || t.startsWith('PRIMARY') || t.startsWith('UNIQUE') || t.startsWith('FOREIGN') || t.startsWith('CHECK') || /^\s*UNIQUE\s*\(/.test(t) || /^\s*FOREIGN KEY/.test(t);
      if (colComment && !isConstraintLine && !l.includes('-- ') && !l.trim().startsWith(')')) {
        const suffix = colComment.endsWith('.') ? colComment : colComment + '.';
        if (l.trim().endsWith(',')) out.push(l.replace(/,(\s*)$/, ', -- ' + suffix + '$1'));
        else out.push(l.replace(/\s*$/, ' -- ' + suffix));
      } else {
        out.push(l);
      }
      i = j + 1;
      if (/^\s*\)\s*;?\s*$/.test(t)) break;
    }
  }
  return out.join('\n');
}

function processFile(engine, content, comments) {
  if (engine === 'mysql') return applyMySQL(content, comments);
  if (engine === 'sqlserver') return applySQLServer(content, comments);
  if (engine === 'sqlite') return applySQLite(content, comments);
  return content;
}

function runApplyDdlComments(projectList) {
  const list = projectList.length > 0
    ? config.applyCommentsProjects.filter((p) => projectList.includes(p))
    : config.applyCommentsProjects;
  const modified = [];
  for (const projectName of list) {
    const dbDir = path.join(PROJECTS_DIR, projectName, 'db');
    if (!fs.existsSync(dbDir)) continue;
    const postgresDb = path.join(dbDir, 'database.postgres.ddl');
    const postgresSchema = path.join(dbDir, 'schema.postgres.ddl');
    let allComments = { tableComments: {}, columnComments: {}, constraintComments: {} };
    if (fs.existsSync(postgresDb)) {
      mergeComments(allComments, parsePostgresComments(fs.readFileSync(postgresDb, 'utf8')));
    }
    if (fs.existsSync(postgresSchema)) {
      mergeComments(allComments, parsePostgresComments(fs.readFileSync(postgresSchema, 'utf8')));
    }
    const toProcess = [
      { engine: 'mysql', base: 'database' },
      { engine: 'sqlserver', base: 'database' },
      { engine: 'sqlite', base: 'database' },
    ];
    if (fs.existsSync(postgresSchema)) {
      toProcess.push({ engine: 'mysql', base: 'schema' }, { engine: 'sqlserver', base: 'schema' }, { engine: 'sqlite', base: 'schema' });
    }
    for (const { engine, base } of toProcess) {
      const f = path.join(dbDir, base + '.' + engine + '.ddl');
      if (!fs.existsSync(f)) continue;
      let content = fs.readFileSync(f, 'utf8');
      const newContent = processFile(engine, content, allComments);
      if (newContent !== content) {
        fs.writeFileSync(f, newContent, 'utf8');
        modified.push(f);
      }
    }
  }
  if (modified.length > 0) {
    console.log('[db] apply-ddl-comments modified:', modified.join(', '));
  } else {
    console.log('[db] apply-ddl-comments: no files modified.');
  }
}

async function main() {
  const { projects, mode, load, applyComments } = parseArgs();
  const e2eDbTypes = (process.env.E2E_DB_TYPES || 'sqlite,postgres,mysql,sqlserver').split(',').map((s) => s.trim().toLowerCase());

  console.log('[db] Mode:', mode, '| Load:', load, '| Apply-comments:', applyComments, '| Projects:', projects.length ? projects.join(', ') : 'all');

  await runSqliteSync(projects, mode);

  if (e2eDbTypes.includes('postgres')) {
    await runPostgres(projects, mode, load);
  }
  if (e2eDbTypes.includes('mysql')) {
    await runMysql(projects, mode, load);
  }
  if (e2eDbTypes.includes('sqlserver')) {
    await runSqlserver(projects, mode, load);
  }
  if (applyComments) {
    runApplyDdlComments(projects);
  }

  console.log('[db] Done.');
}

main().catch((err) => {
  console.error('[db]', err.message);
  process.exit(1);
});
