// test/e2e-generator/e2e-all.js
// Script para executar API e MFE em paralelo para cada projeto
const path = require('path');
const fs = require('fs');
const { spawnSync, spawn } = require('child_process');
const os = require('os');

const configPath = path.join(__dirname, 'e2e.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

const PROJECT_EXPECTED = config.projectExpected;
const REPO_ROOT = path.resolve(__dirname, ...config.repoRootRelative);
const MOCK_DIR = path.join(REPO_ROOT, ...config.mockDirSegment);
const PROJECTS_DIR = path.join(MOCK_DIR, config.projectsDirName);
const GEN_DIR = path.join(REPO_ROOT, config.genDirSegment);
const DIST_MAIN = path.join(REPO_ROOT, ...config.distMainSegment);
const OUT_DIR_BASE = path.join(REPO_ROOT, config.outDirBaseName);
const CONNECTION_FILE_PATTERN = new RegExp(config.connectionFilePattern);
const E2E_DB_TYPES_ALLOWED = config.e2eDbTypesAllowed;

const NUM_PARALLEL = parseInt(process.env.E2E_PARALLEL || String(os.cpus().length), 10);

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
  }
  if (dbType === 'sqlserver') {
    if (process.env.DB_SQLSERVER_HOST) conn.host = process.env.DB_SQLSERVER_HOST;
    if (process.env.DB_SQLSERVER_PORT != null && process.env.DB_SQLSERVER_PORT !== '') {
      conn.port = parseInt(process.env.DB_SQLSERVER_PORT, 10);
    }
  }
  return conn;
}

function ensureMock(conn, project) {
  if (conn.dbType !== 'sqlite') {
    return true;
  }
  const dbPath = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
  if (fs.existsSync(dbPath)) {
    return true;
  }
  const DB_SCRIPT = path.join(MOCK_DIR, 'db.js');
  if (!fs.existsSync(DB_SCRIPT)) {
    console.error('[e2e-all] db.js not found:', DB_SCRIPT);
    return false;
  }
  console.log('[e2e-all] Creating mock DB (' + project + ') via db.js --resume...');
  const r = spawnSync(process.execPath, [DB_SCRIPT, '--resume', project], { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e-all] db.js --resume failed');
    return false;
  }
  return true;
}

function runApiGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e-all] Generator not built. Run "npm run build" in gen/.');
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
      console.error('[e2e-all] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  console.log('[e2e-all] Running API generator for', appName);
  const args = [
    DIST_MAIN,
    '-a', appName,
    '-d', conn.database,
    '-o', outDir,
    '-t', conn.dbType,
    '-f', 'api',
  ];
  if (conn.host) {
    args.push('-h', conn.host);
  }
  if (conn.port != null && conn.port !== '') {
    args.push('-p', String(conn.port));
  }
  const r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  return r.status === 0;
}

function runMfeGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e-all] Generator not built. Run "npm run build" in gen/.');
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
      console.error('[e2e-all] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  console.log('[e2e-all] Running MFE generator for', appName);
  const args = [
    DIST_MAIN,
    '-a', appName,
    '--mfe',
    '-d', conn.database,
    '-o', outDir,
    '-t', conn.dbType,
  ];
  if (conn.host) {
    args.push('-h', conn.host);
  }
  if (conn.port != null && conn.port !== '') {
    args.push('-p', String(conn.port));
  }
  const r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  return r.status === 0;
}

async function processProjectParallel(project, connectionFiles) {
  return new Promise((resolve) => {
    const results = { project, api: { success: false, error: null }, mfe: { success: false, error: null } };
    const children = [];
    
    // Find sqlite connection
    const sqliteFile = connectionFiles.find((c) => c.dbType === 'sqlite');
    if (!sqliteFile) {
      console.log('[e2e-all] Projeto', project, ': sem conexão sqlite, pulando.');
      resolve({ ...results, skipped: true });
      return;
    }
    
    let conn;
    try {
      conn = loadMockConnection(sqliteFile.path);
    } catch (e) {
      console.error('[e2e-all]', e.message);
      resolve({ ...results, api: { success: false, error: e.message }, mfe: { success: false, error: e.message } });
      return;
    }
    
    conn.database = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
    
    if (!ensureMock(conn, project)) {
      resolve({ ...results, api: { success: false, error: 'mock failed' }, mfe: { success: false, error: 'mock failed' } });
      return;
    }
    
    const apiOutDir = path.join(OUT_DIR_BASE, project, 'api');
    const mfeOutDir = path.join(OUT_DIR_BASE, project, 'mfe');
    
    console.log('[e2e-all] ========== PARALLEL: project:', project, '==========');
    
    // Run API and MFE generators in parallel
    let apiDone = false;
    let mfeDone = false;
    let apiSuccess = false;
    let mfeSuccess = false;
    
    const checkDone = () => {
      if (apiDone && mfeDone) {
        // Kill any remaining children
        children.forEach((c) => {
          try { c.kill('SIGTERM'); } catch (e) { try { c.kill('SIGKILL'); } catch (_) {} }
        });
        resolve({
          project,
          api: { success: apiSuccess },
          mfe: { success: mfeSuccess },
        });
      }
    };
    
    // Start API generation
    const apiPromise = new Promise((res) => {
      const apiResult = runApiGenerator(conn, apiOutDir, project);
      apiDone = true;
      apiSuccess = apiResult;
      console.log('[e2e-all] API generator for', project, apiResult ? 'OK' : 'FAILED');
      res();
    });
    
    // Start MFE generation
    const mfePromise = new Promise((res) => {
      const mfeResult = runMfeGenerator(conn, mfeOutDir, project);
      mfeDone = true;
      mfeSuccess = mfeResult;
      console.log('[e2e-all] MFE generator for', project, mfeResult ? 'OK' : 'FAILED');
      res();
    });
    
    // Wait for both to complete
    Promise.all([apiPromise, mfePromise]).then(() => {
      checkDone();
    });
  });
}

async function main() {
  const args = process.argv.slice(2).filter((a) => typeof a === 'string' && !a.startsWith('--'));
  const rawProjects = args.length > 0 ? args : discoverProjects();
  const projects = rawProjects.filter((p) => PROJECT_EXPECTED[p]);

  if (projects.length === 0) {
    console.error('[e2e-all] Nenhum projeto com connection.<dbType>.json em:', PROJECTS_DIR);
    process.exit(1);
  }

  console.log('[e2e-all] Repo root:', REPO_ROOT);
  console.log('[e2e-all] Output base:', OUT_DIR_BASE);
  console.log('[e2e-all] Projetos:', projects.join(', '));
  console.log('[e2e-all] Paralelismo:', NUM_PARALLEL, 'jobs');

  // Collect connection files for all projects first
  const projectConnections = {};
  for (const project of projects) {
    const connectionDir = path.join(PROJECTS_DIR, project, 'db');
    projectConnections[project] = discoverConnectionFiles(connectionDir);
  }

  // Process projects in parallel batches
  const results = [];
  for (let i = 0; i < projects.length; i += NUM_PARALLEL) {
    const batch = projects.slice(i, i + NUM_PARALLEL);
    console.log('[e2e-all] Batch', Math.floor(i / NUM_PARALLEL) + 1, ':', batch.join(', '));
    
    const batchResults = await Promise.all(
      batch.map((project) => processProjectParallel(project, projectConnections[project]))
    );
    results.push(...batchResults);
  }

  // Summary
  console.log('\n[e2e-all] ========== RESUMO ==========');
  let apiOk = 0, apiFail = 0, mfeOk = 0, mfeFail = 0, skipped = 0;
  for (const r of results) {
    if (r.skipped) {
      skipped++;
      continue;
    }
    if (r.api.success) apiOk++; else apiFail++;
    if (r.mfe.success) mfeOk++; else mfeFail++;
    console.log('[e2e-all] ', r.project, ': API', r.api.success ? 'OK' : 'FAIL', ', MFE', r.mfe.success ? 'OK' : 'FAIL');
  }
  console.log('[e2e-all] ==========');
  console.log('[e2e-all] API:', apiOk, 'OK /', apiFail, 'FAIL');
  console.log('[e2e-all] MFE:', mfeOk, 'OK /', mfeFail, 'FAIL');
  console.log('[e2e-all] Skipped:', skipped);
  console.log('[e2e-all] Done.');

  if (apiFail > 0 || mfeFail > 0) {
    process.exit(1);
  }
}

main();
