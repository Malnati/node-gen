// test/e2e-generator/e2e.js
const path = require('path');
const fs = require('fs');
const net = require('net');
const http = require('http');
const crypto = require('crypto');
const { spawnSync, spawn } = require('child_process');

const configPath = path.join(__dirname, 'e2e.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

const PROJECT_EXPECTED = config.projectExpected;
const REPO_ROOT = path.resolve(__dirname, ...config.repoRootRelative);
const MOCK_DIR = path.join(REPO_ROOT, ...config.mockDirSegment);
const PROJECTS_DIR = path.join(MOCK_DIR, config.projectsDirName);
const GEN_DIR = path.join(REPO_ROOT, config.genDirSegment);
const DIST_MAIN = path.join(REPO_ROOT, ...config.distMainSegment);
const OUT_DIR_BASE = path.join(REPO_ROOT, config.outDirBaseName);
const E2E_APP_NAME = process.env.E2E_APP_NAME || config.e2eAppName;
const COMPONENTS = config.components;
const CONNECTION_FILE_PATTERN = new RegExp(config.connectionFilePattern);
const E2E_DB_TYPES_ALLOWED = config.e2eDbTypesAllowed;
const API_START_TIMEOUT_MS = config.apiStartTimeoutMs;
const POLL_INTERVAL_MS = config.pollIntervalMs;
const HEALTH_REQUEST_TIMEOUT_MS = config.healthRequestTimeoutMs;
const DB_CONNECT_CHECK_TIMEOUT_MS = config.dbConnectCheckTimeoutMs;
const E2E_SKIP_API_START_FOR_DB_TYPES = (process.env.E2E_SKIP_API_START_FOR_DB_TYPES || config.e2eSkipApiStartForDbTypes.join(',')).split(',').map((s) => s.trim().toLowerCase());
const DB_SCRIPT = path.join(MOCK_DIR, 'db.js');

function checkPortReachable(host, port, timeoutMs) {
  return new Promise((resolve) => {
    const socket = net.createConnection(port, host, () => {
      socket.destroy();
      resolve(true);
    });
    socket.setTimeout(timeoutMs, () => {
      socket.destroy();
      resolve(false);
    });
    socket.on('error', () => {
      socket.destroy();
      resolve(false);
    });
  });
}

function checkDbContainersReachable() {
  const raw = (process.env.E2E_DB_TYPES || 'sqlite,postgres,mysql,sqlserver').split(',').map((s) => s.trim().toLowerCase());
  const e2eDbTypes = raw.filter((t) => E2E_DB_TYPES_ALLOWED.includes(t));
  const checks = [];
  if (e2eDbTypes.includes('postgres')) {
    const host = process.env.DB_POSTGRES_HOST || '127.0.0.1';
    const port = parseInt(process.env.DB_POSTGRES_PORT || '5432', 10);
    checks.push(checkPortReachable(host, port, DB_CONNECT_CHECK_TIMEOUT_MS).then((ok) => ({ db: 'postgres', ok })));
  }
  if (e2eDbTypes.includes('mysql')) {
    const host = process.env.DB_MYSQL_HOST || '127.0.0.1';
    const port = parseInt(process.env.DB_MYSQL_PORT || '3306', 10);
    checks.push(checkPortReachable(host, port, DB_CONNECT_CHECK_TIMEOUT_MS).then((ok) => ({ db: 'mysql', ok })));
  }
  if (e2eDbTypes.includes('sqlserver')) {
    const host = process.env.DB_SQLSERVER_HOST || '127.0.0.1';
    const port = parseInt(process.env.DB_SQLSERVER_PORT || '1433', 10);
    checks.push(checkPortReachable(host, port, DB_CONNECT_CHECK_TIMEOUT_MS).then((ok) => ({ db: 'sqlserver', ok })));
  }
  return Promise.all(checks);
}

function readPortFromEnv(outDir) {
  const envPath = path.join(outDir, '.env');
  if (!fs.existsSync(envPath)) return 3001;
  const content = fs.readFileSync(envPath, 'utf-8');
  const m = content.match(/(?:^|\n)PORT=['"]?(\d+)['"]?/);
  return m ? parseInt(m[1], 10) : 3001;
}

function waitForPort(port, timeoutMs) {
  return new Promise((resolve) => {
    const deadline = Date.now() + timeoutMs;
    function tryConnect() {
      const socket = net.createConnection(port, '127.0.0.1', () => {
        socket.destroy();
        resolve(true);
      });
      socket.setTimeout(POLL_INTERVAL_MS, () => {
        socket.destroy();
        if (Date.now() >= deadline) {
          resolve(false);
          return;
        }
        setTimeout(tryConnect, POLL_INTERVAL_MS);
      });
      socket.on('error', () => {
        socket.destroy();
        if (Date.now() >= deadline) {
          resolve(false);
          return;
        }
        setTimeout(tryConnect, POLL_INTERVAL_MS);
      });
    }
    tryConnect();
  });
}

function curlGet(port, pathname, timeoutMs) {
  return new Promise((resolve) => {
    const req = http.get(
      'http://127.0.0.1:' + port + pathname,
      { timeout: timeoutMs },
      (res) => {
        let body = '';
        res.on('data', (chunk) => { body += chunk; });
        res.on('end', () => resolve({ statusCode: res.statusCode, body }));
      }
    );
    req.on('error', (err) => resolve({ statusCode: 0, error: err.message }));
    req.on('timeout', () => {
      req.destroy();
      resolve({ statusCode: 0, error: 'timeout' });
    });
  });
}

function curlPost(port, pathname, body, timeoutMs) {
  return new Promise((resolve) => {
    const data = JSON.stringify(body);
    const opts = {
      hostname: '127.0.0.1',
      port,
      path: pathname,
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) },
      timeout: timeoutMs,
    };
    const req = http.request(opts, (res) => {
      let resBody = '';
      res.on('data', (chunk) => { resBody += chunk; });
      res.on('end', () => resolve({ statusCode: res.statusCode, body: resBody }));
    });
    req.on('error', (err) => resolve({ statusCode: 0, error: err.message }));
    req.on('timeout', () => { req.destroy(); resolve({ statusCode: 0, error: 'timeout' }); });
    req.write(data);
    req.end();
  });
}

function curlHealth(port, timeoutMs) {
  return curlGet(port, '/health', timeoutMs);
}

function postAndVerifyInDb(port, project, conn, timeoutMs) {
  const expected = PROJECT_EXPECTED[project];
  const spec = expected && expected.postVerify;
  if (!spec) return Promise.resolve(true);
  let body = spec.body && typeof spec.body === 'object' ? { ...spec.body } : spec.body;
  if (spec.uniqueExternalId && body && body.external_id === null) {
    body.external_id = crypto.randomUUID();
  }
  const timeout = Math.min(timeoutMs, 1500);
  return curlPost(port, spec.path, body, timeout).then((r) => {
    if (r.statusCode !== 201 && r.statusCode !== 200) {
      console.error('[e2e] POST', spec.path, 'retornou', r.statusCode, r.body || r.error);
      return false;
    }
    const dbType = (conn.dbType || 'sqlite').toLowerCase();
    const whereClause = spec.whereColumn + " = '" + String(spec.whereValue).replace(/'/g, "''") + "'";
    const sql = dbType === 'sqlserver'
      ? 'SELECT TOP 1 1 AS ok FROM ' + spec.table + ' WHERE ' + whereClause
      : 'SELECT 1 AS ok FROM ' + spec.table + ' WHERE ' + whereClause + ' LIMIT 1';
    return queryDb(conn, sql).then((rows) => {
      const ok = Array.isArray(rows) && rows.length > 0;
      if (!ok) console.error('[e2e] Nenhuma linha encontrada no banco após POST', spec.path);
      return ok;
    });
  }).catch((e) => {
    console.error('[e2e] postAndVerifyInDb', e.message);
    return false;
  });
}

function queryDb(conn, sql) {
  const dbType = (conn.dbType || 'sqlite').toLowerCase();
  if (dbType === 'sqlite') {
    return new Promise((resolve, reject) => {
      try {
        const sqlite3 = require('sqlite3');
        const db = new sqlite3.Database(conn.database, (err) => {
          if (err) { reject(err); return; }
          db.get(sql, (err, row) => {
            db.close();
            if (err) reject(err);
            else resolve(row ? [row] : []);
          });
        });
      } catch (e) {
        reject(e);
      }
    });
  }
  if (dbType === 'postgres') {
    const pg = require('pg');
    const client = new pg.Client({
      host: conn.host || '127.0.0.1',
      port: conn.port || 5432,
      user: conn.user || 'postgres',
      password: conn.password || 'postgres',
      database: conn.database,
    });
    return client.connect().then(() =>
      client.query(sql).then((res) => {
        client.end();
        return res.rows || [];
      })
    );
  }
  if (dbType === 'mysql') {
    const mysql = require('mysql2/promise');
    const cfg = {
      host: conn.host || '127.0.0.1',
      port: conn.port || 3306,
      user: conn.user || 'e2e',
      password: conn.password || 'e2e',
      database: conn.database,
    };
    return mysql.createConnection(cfg).then((c) =>
      c.execute(sql).then(([rows]) => {
        c.end();
        return Array.isArray(rows) ? rows : [];
      })
    );
  }
  if (dbType === 'sqlserver') {
    const mssql = require('mssql');
    const cfg = {
      user: conn.user || 'sa',
      password: conn.password || 'YourStrong@Passw0rd',
      server: conn.host || '127.0.0.1',
      port: parseInt(conn.port || '1433', 10),
      database: conn.database,
      options: { encrypt: true, trustServerCertificate: true },
      connectionTimeout: 15000,
      requestTimeout: 15000,
    };
    return mssql.connect(cfg).then((pool) =>
      pool.request().query(sql).then((result) => {
        pool.close();
        return result.recordset ? (Array.isArray(result.recordset) ? result.recordset : []) : [];
      })
    );
  }
  return Promise.reject(new Error('queryDb: dbType não suportado ' + dbType));
}

function startAppAndCheckHealth(outDir, dbType, project, conn) {
  const port = readPortFromEnv(outDir);
  const distMain = path.join(outDir, 'dist', 'main.js');
  if (!fs.existsSync(distMain)) {
    console.error('[e2e] dist/main.js não encontrado em', outDir);
    return Promise.resolve(false);
  }
  const env = { ...process.env, NODE_ENV: 'production', E2E_SKIP_JWT: 'true' };
  if (dbType === 'sqlite' && conn && conn.database) {
    env.DATABASE_PATH = conn.database;
  }
  const child = spawn(process.execPath, [distMain], {
    cwd: outDir,
    env,
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  const chunks = { stdout: [], stderr: [] };
  child.stdout.on('data', (c) => chunks.stdout.push(c));
  child.stderr.on('data', (c) => chunks.stderr.push(c));

  let resolved = false;
  const done = (ok, msg) => {
    if (resolved) return;
    resolved = true;
    try {
      child.kill('SIGTERM');
    } catch (e) {
      try { child.kill('SIGKILL'); } catch (_) {}
    }
    if (!ok && (chunks.stdout.length || chunks.stderr.length)) {
      const out = Buffer.concat(chunks.stdout).slice(-2000).toString();
      const err = Buffer.concat(chunks.stderr).slice(-2000).toString();
      console.log('[e2e] Últimos logs (stdout):', out.slice(-500));
      if (err) console.log('[e2e] Últimos logs (stderr):', err.slice(-500));
    }
    if (!ok) console.error('[e2e]', msg);
  };

  return new Promise((resolve) => {
    const t = setTimeout(() => {
      done(false, 'API não respondeu na porta ' + port + ' em ' + API_START_TIMEOUT_MS + 'ms');
      resolve(false);
    }, API_START_TIMEOUT_MS);

    waitForPort(port, API_START_TIMEOUT_MS - 5000).then((listening) => {
      if (!listening) {
        clearTimeout(t);
        done(false, 'Porta ' + port + ' não ficou disponível a tempo');
        resolve(false);
        return;
      }
      const healthAttempts = Math.max(1, Math.floor((API_START_TIMEOUT_MS - 5000) / POLL_INTERVAL_MS));
      waitForHealth(port, healthAttempts).then((result) => {
        if (result.statusCode !== 200) {
          clearTimeout(t);
          done(false, 'Health retornou ' + (result.statusCode || result.error) + ', esperado 200');
          resolve(false);
          return;
        }
        curlAllEndpoints(port, project, HEALTH_REQUEST_TIMEOUT_MS).then((endpointResult) => {
          if (!endpointResult.allOk) {
            clearTimeout(t);
            done(false, 'Cobertura endpoints: falha em ' + endpointResult.failures.join(', '));
            resolve(false);
            return;
          }
          const out = Buffer.concat(chunks.stdout).toString();
          const err = Buffer.concat(chunks.stderr).toString();
          const hasStartupLog = /Nest|Application|listening|started|Listening/.test(out + err);
          if (!hasStartupLog) {
            clearTimeout(t);
            done(false, 'Cobertura logs: logs da API não contêm mensagem de startup (Nest/Application/listening)');
            resolve(false);
            return;
          }
          console.log('[e2e] Cobertura cURL: /health, /version e todos os endpoints GET OK (porta ' + port + '). Cobertura logs: OK. Verificando banco após execução dos endpoints.');
          postAndVerifyInDb(port, project, conn, HEALTH_REQUEST_TIMEOUT_MS)
            .then((dbOk) => {
              clearTimeout(t);
              if (!dbOk) {
                done(false, 'Cobertura banco: verificação no banco de dados após execução do endpoint falhou.');
                resolve(false);
                return;
              }
              try { child.kill('SIGTERM'); } catch (e) { try { child.kill('SIGKILL'); } catch (_) {} }
              resolved = true;
              console.log('[e2e] Cobertura banco: dados confirmados no banco após endpoint (porta ' + port + ').');
              resolve(true);
            })
            .catch((e) => {
              clearTimeout(t);
              done(false, 'Erro ao verificar banco: ' + (e && e.message));
              resolve(false);
            });
        });
      });
    });
  });
}

function curlAllEndpoints(port, project, timeoutMs) {
  const expected = PROJECT_EXPECTED[project];
  if (!expected) return Promise.resolve({ allOk: false, failures: ['projeto desconhecido'] });
  const paths = ['/health', '/version'];
  expected.moduleNames.forEach((m) => paths.push('/' + m));
  const timeout = Math.min(timeoutMs, 1500);
  return Promise.all(
    paths.map((p) =>
      curlGet(port, p, timeout).then((r) => {
        const ok = r.statusCode === 200;
        return { path: p, statusCode: r.statusCode, ok };
      })
    )
  ).then((arr) => {
    const failures = arr.filter((a) => !a.ok).map((a) => a.path + '=' + (a.statusCode || 'err'));
    return { allOk: failures.length === 0, failures };
  });
}

function waitForHealth(port, maxAttempts) {
  const attemptMs = HEALTH_REQUEST_TIMEOUT_MS;
  let attempts = 0;
  function tryOnce() {
    attempts++;
    return curlHealth(port, attemptMs).then((result) => {
      if (result.statusCode === 200) return result;
      if (attempts >= maxAttempts) return result;
      return new Promise((r) => setTimeout(r, POLL_INTERVAL_MS)).then(tryOnce);
    });
  }
  return tryOnce();
}

function discoverProjects() {
  if (!fs.existsSync(PROJECTS_DIR)) {
    return [];
  }
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  const out = [];
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const connectionDir = path.join(PROJECTS_DIR, d.name, 'db');
    if (!fs.existsSync(connectionDir)) continue;
    const hasConnection = fs.readdirSync(connectionDir).some((f) => CONNECTION_FILE_PATTERN.test(f));
    if (hasConnection && PROJECT_EXPECTED[d.name]) {
      out.push(d.name);
    }
  }
  return out.sort();
}

function discoverConnectionFiles(connectionDir) {
  if (!fs.existsSync(connectionDir)) {
    return [];
  }
  const entries = fs.readdirSync(connectionDir, { withFileTypes: true });
  const out = [];
  for (const e of entries) {
    if (!e.isFile() || !e.name.endsWith('.json')) continue;
    const m = e.name.match(CONNECTION_FILE_PATTERN);
    if (m) {
      const dbType = m[1].toLowerCase();
      if (E2E_DB_TYPES_ALLOWED.includes(dbType)) {
        out.push({ dbType, path: path.join(connectionDir, e.name) });
      }
    }
  }
  return out.sort((a, b) => a.dbType.localeCompare(b.dbType));
}

function loadMockConnection(connectionFilePath) {
  if (!fs.existsSync(connectionFilePath)) {
    throw new Error('Arquivo de conexão não encontrado: ' + connectionFilePath);
  }
  const raw = JSON.parse(fs.readFileSync(connectionFilePath, 'utf-8'));
  const baseDir = path.dirname(connectionFilePath);
  const dbType = raw.dbType || 'sqlite';
  const databasePath = dbType === 'sqlite'
    ? (path.isAbsolute(raw.database) ? raw.database : path.resolve(baseDir, raw.database))
    : raw.database;
  const conn = {
    dbType,
    database: databasePath,
    user: raw.user != null ? String(raw.user) : 'x',
    password: raw.password != null ? String(raw.password) : 'x',
    host: raw.host != null ? String(raw.host) : '',
    port: raw.port != null ? Number(raw.port) : null,
  };
  if (dbType === 'postgres') {
    if (process.env.DB_POSTGRES_HOST) conn.host = process.env.DB_POSTGRES_HOST;
    if (process.env.DB_POSTGRES_PORT != null && process.env.DB_POSTGRES_PORT !== '') {
      conn.port = parseInt(process.env.DB_POSTGRES_PORT, 10);
    }
  }
  if (dbType === 'mysql') {
    if (process.env.DB_MYSQL_HOST) conn.host = process.env.DB_MYSQL_HOST;
    if (process.env.DB_MYSQL_PORT != null && process.env.DB_MYSQL_PORT !== '') {
      conn.port = parseInt(process.env.DB_MYSQL_PORT, 10);
    }
    if (process.env.DB_MYSQL_USER) conn.user = process.env.DB_MYSQL_USER;
    if (process.env.DB_MYSQL_PASSWORD) conn.password = process.env.DB_MYSQL_PASSWORD;
  }
  if (dbType === 'sqlserver') {
    if (process.env.DB_SQLSERVER_HOST) conn.host = process.env.DB_SQLSERVER_HOST;
    if (process.env.DB_SQLSERVER_PORT != null && process.env.DB_SQLSERVER_PORT !== '') {
      conn.port = parseInt(process.env.DB_SQLSERVER_PORT, 10);
    }
  }
  return conn;
}

function artifactsFor(dbType, outDir) {
  return [
    path.join(outDir, 'db.reader.' + dbType + '.json'),
    path.join(outDir, 'src', 'app', 'app.module.ts'),
    path.join(outDir, '.env'),
    path.join(outDir, 'package.json'),
    path.join(outDir, 'README.md'),
  ];
}

function ensureMock(conn, project) {
  if (conn.dbType !== 'sqlite') {
    return true;
  }
  const dbPath = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
  if (fs.existsSync(dbPath)) {
    console.log('[e2e] Mock DB already exists:', dbPath);
    return true;
  }
  if (!fs.existsSync(DB_SCRIPT)) {
    console.error('[e2e] db.js not found:', DB_SCRIPT);
    return false;
  }
  console.log('[e2e] Creating mock DB (' + project + ') via db.js --resume...');
  const r = spawnSync(process.execPath, [DB_SCRIPT, '--resume', project], { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e] db.js --resume failed');
    return false;
  }
  return true;
}

function runGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e] Generator not built. Run "npm run build" in gen/ or from repo root.');
    return false;
  }
  if (fs.existsSync(outDir)) {
    try {
      const entries = fs.readdirSync(outDir, { withFileTypes: true });
      for (const e of entries) {
        const p = path.join(outDir, e.name);
        if (fs.existsSync(p)) {
          fs.rmSync(p, { recursive: true });
        }
      }
    } catch (err) {
      console.error('[e2e] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  const effectiveAppName = appName || E2E_APP_NAME;
  console.log('[e2e] Running generator with connection params...');
  const args = [
    DIST_MAIN,
    '-a', effectiveAppName,
    '-d', conn.database,
    '-u', conn.user,
    '-pw', conn.password,
    '-o', outDir,
    '-t', conn.dbType,
    '-f', COMPONENTS,
  ];
  if (conn.host) {
    args.push('-h', conn.host);
  }
  if (conn.port != null && conn.port !== '') {
    args.push('-p', String(conn.port));
  }
  const r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e] Generator exited with code', r.status);
    if (conn.dbType === 'mysql') {
      console.error('[e2e] Se o erro for Access denied no MySQL, execute: make e2e-clean && make e2e');
    }
    return false;
  }
  return true;
}

function assessResults(dbType, outDir, project) {
  const expected = PROJECT_EXPECTED[project];
  if (!expected) {
    console.error('[e2e] Unknown project for assessment:', project);
    return false;
  }
  const EXPECTED_TABLES = expected.tables;
  const EXPECTED_MODULE_NAMES = expected.moduleNames;
  const EXPECTED_ENTITY_FILES = expected.entityFiles;
  const ARTIFACTS = artifactsFor(dbType, outDir);
  const checks = [];
  let requiredFailed = false;

  for (const p of ARTIFACTS) {
    const pass = fs.existsSync(p);
    if (!pass) requiredFailed = true;
    checks.push({ name: path.relative(outDir, p) || p, pass, required: true });
  }

  const entitiesDir = path.join(outDir, 'src', 'app', 'entities');
  const entityFiles = fs.existsSync(entitiesDir)
    ? fs.readdirSync(entitiesDir).filter((f) => f.endsWith('.ts'))
    : [];
  const entityCountOk = entityFiles.length === EXPECTED_MODULE_NAMES.length;
  if (!entityCountOk) requiredFailed = true;
  checks.push({
    name: 'entities (esperado ' + EXPECTED_MODULE_NAMES.length + ', obtido ' + entityFiles.length + ')',
    pass: entityCountOk,
    required: true,
  });

  const expectedEntityNames = EXPECTED_ENTITY_FILES.slice().sort();
  const actualEntityNames = entityFiles.slice().sort();
  const namesOk =
    expectedEntityNames.length === actualEntityNames.length &&
    expectedEntityNames.every((e, i) => actualEntityNames[i] === e);
  if (!namesOk) requiredFailed = true;
  checks.push({
    name: 'nomes das entidades (' + EXPECTED_ENTITY_FILES.join(', ') + ')',
    pass: namesOk,
    required: true,
  });

  const appDir = path.join(outDir, 'src', 'app');
  let modulesOk = true;
  for (const mod of EXPECTED_MODULE_NAMES) {
    const modDir = path.join(appDir, mod);
    const hasService = fs.existsSync(path.join(modDir, mod + '.service.ts'));
    const hasController = fs.existsSync(path.join(modDir, mod + '.controller.ts'));
    const hasModule = fs.existsSync(path.join(modDir, mod + '.module.ts'));
    if (!hasService || !hasController || !hasModule) modulesOk = false;
  }
  if (!modulesOk) requiredFailed = true;
  checks.push({
    name: 'módulos por tabela (' + EXPECTED_MODULE_NAMES.length + ' dirs com service, controller, module)',
    pass: modulesOk,
    required: true,
  });

  let schemaOk = false;
  const schemaPath = path.join(outDir, 'db.reader.' + dbType + '.json');
  if (fs.existsSync(schemaPath)) {
    try {
      const parsed = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));
      const tables = parsed.schema || [];
      schemaOk = tables.length === EXPECTED_TABLES.length;
      if (!schemaOk) requiredFailed = true;
      checks.push({
        name: 'schema JSON (' + tables.length + ' tabelas, esperado ' + EXPECTED_TABLES.length + ')',
        pass: schemaOk,
        required: true,
      });
    } catch (e) {
      checks.push({ name: 'schema JSON (leitura)', pass: false, required: true });
      requiredFailed = true;
    }
  }

  const diagramOk = fs.existsSync(path.join(outDir, 'public', 'diagram.png'));
  checks.push({ name: 'public/diagram.png', pass: diagramOk, required: false });

  let buildOk = false;
  if (fs.existsSync(path.join(outDir, 'package.json'))) {
    const installResult = spawnSync(
      'sh',
      ['-c', 'npm install --legacy-peer-deps --no-audit --ignore-scripts 2>&1'],
      { cwd: outDir, stdio: 'pipe', timeout: 300000, env: { ...process.env, npm_config_audit: 'false', npm_config_fund: 'false' } }
    );
    if (installResult.status !== 0) {
      const out = (installResult.stdout && installResult.stdout.toString()) || '';
      const err = (installResult.stderr && installResult.stderr.toString()) || '';
      console.error('[e2e] npm install falhou. stdout:', out.slice(-2000));
      if (err) console.error('[e2e] npm install falhou. stderr:', err.slice(-2000));
    }
    const buildResult =
      installResult.status === 0
        ? spawnSync('npm', ['run', 'build'], {
            cwd: outDir,
            stdio: 'pipe',
            timeout: 120000,
          })
        : { status: 1, stdout: null, stderr: null };
    buildOk = buildResult.status === 0;
    if (!buildOk) {
      const out = (buildResult.stdout && buildResult.stdout.toString()) || '';
      const err = (buildResult.stderr && buildResult.stderr.toString()) || '';
      console.error('[e2e] npm run build falhou. stdout:', out.slice(-1200));
      console.error('[e2e] npm run build falhou. stderr:', err.slice(-1200));
    }
    checks.push({
      name: 'npm run build no output (obrigatório)',
      pass: buildOk,
      required: true,
    });
    if (!buildOk) requiredFailed = true;
  }

  console.log('[e2e] --- Aferição dos resultados (' + dbType + ') ---');
  for (const c of checks) {
    const badge = c.pass ? 'OK' : 'FALHA';
    const req = c.required ? '' : ' (opcional)';
    console.log('[e2e]   ' + badge + ': ' + c.name + req);
  }
  const requiredPassed = checks.filter((c) => c.required && c.pass).length;
  const requiredTotal = checks.filter((c) => c.required).length;
  console.log('[e2e] ---');
  console.log(
    '[e2e] Resultado ' + dbType + ': ' + (requiredFailed ? 'FALHA' : 'OK') + ' (obrigatórios ' + requiredPassed + '/' + requiredTotal + ')'
  );
  return !requiredFailed;
}

async function main() {
  const args = process.argv.slice(2).filter((a) => typeof a === 'string' && !a.startsWith('--'));
  const rawProjects = args.length > 0 ? args : discoverProjects();
  const projects = rawProjects.filter((p) => PROJECT_EXPECTED[p]);

  if (projects.length === 0) {
    console.error('[e2e] Nenhum projeto com connection.<dbType>.json em:', PROJECTS_DIR);
    process.exit(1);
  }

  console.log('[e2e] Repo root:', REPO_ROOT);
  console.log('[e2e] Output base:', OUT_DIR_BASE);
  console.log('[e2e] Gen dir:', GEN_DIR);
  console.log('[e2e] Projetos:', projects.join(', '));
  console.log('[e2e] DB types (cobertura): todos os connection.<dbType>.json encontrados por projeto (não restrito por E2E_DB_TYPES)');
  console.log('[e2e] Cobertura E2E: verificação de containers, logs das APIs, cURL em todos os endpoints e confirmação no banco após execução.');

  const containerStatus = await checkDbContainersReachable();
  for (const r of containerStatus) {
    console.log('[e2e] Container', r.db + ':', r.ok ? 'reachable' : 'unreachable');
  }
  if (containerStatus.some((r) => !r.ok)) {
    console.error('[e2e] Falha na cobertura: algum container de DB não está acessível.');
    process.exit(1);
  }

  let anyFailed = false;
  for (const project of projects) {
    const connectionDir = path.join(PROJECTS_DIR, project, 'db');
    const connectionFiles = discoverConnectionFiles(connectionDir);
    if (connectionFiles.length === 0) {
      console.log('[e2e] Projeto', project, ': sem conexões, pulando.');
      continue;
    }
    console.log('[e2e] Projeto', project, 'conexões:', connectionFiles.map((c) => c.dbType).join(', '));

    for (const cf of connectionFiles) {
      const dbType = cf.dbType;
      const connectionPath = cf.path;
      console.log('[e2e] ========== project:', project, 'dbType:', dbType, '==========');
      let conn;
      try {
        conn = loadMockConnection(connectionPath);
      } catch (e) {
        console.error('[e2e]', e.message);
        anyFailed = true;
        continue;
      }
      if (conn.dbType === 'sqlite') {
        conn.database = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
        const fixtureScript = path.join(PROJECTS_DIR, project, 'db', 'create-sqlite-fixture.js');
        if (project !== 'todo' && !fs.existsSync(fixtureScript)) {
          console.log('[e2e] Projeto', project, 'sqlite: create-sqlite-fixture.js ausente, pulando.');
          continue;
        }
      }
      console.log('[e2e] Parâmetros (mock): dbType=%s database=%s', conn.dbType, conn.database);
      if (!ensureMock(conn, project)) {
        anyFailed = true;
        continue;
      }
      const outDir = path.join(OUT_DIR_BASE, project, dbType);
      const appName = project;
      if (!runGenerator(conn, outDir, appName)) {
        anyFailed = true;
        continue;
      }
      if (!assessResults(dbType, outDir, project)) {
        anyFailed = true;
        continue;
      }
      if (E2E_SKIP_API_START_FOR_DB_TYPES.includes(dbType)) {
        console.log('[e2e] Pulando subida da API para', dbType, '(apenas aferição; use E2E_SKIP_API_START_FOR_DB_TYPES para alterar).');
        continue;
      }
      console.log('[e2e] Subindo API e verificando /health e todos os endpoints...');
      const healthOk = await startAppAndCheckHealth(outDir, dbType, project, conn);
      if (!healthOk) {
        anyFailed = true;
      }
    }
  }

  if (anyFailed) {
    process.exit(1);
  }
  console.log('[e2e] Done.');
}

main();
