// test/e2e-generator/e2e-paging.js
// Script para testes E2E de MFE Parcel Paging
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
const CONNECTION_FILE_PATTERN = new RegExp(config.connectionFilePattern);
const E2E_DB_TYPES_ALLOWED = config.e2eDbTypesAllowed;
const E2E_SKIP_API_START_FOR_DB_TYPES = (process.env.E2E_SKIP_API_START_FOR_DB_TYPES || config.e2eSkipApiStartForDbTypes.join(',')).split(',').map((s) => s.trim().toLowerCase());
const MFE_PORT = process.env.MFE_PORT || 7200;
const E2E_PAGING_DB_TYPE = (process.env.E2E_PAGING_DB_TYPE || 'sqlite').trim().toLowerCase();

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
  // Override with environment variables for postgres
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
    console.log('[e2e-paging] Mock DB already exists:', dbPath);
    return true;
  }
  const DB_SCRIPT = path.join(MOCK_DIR, 'db.js');
  if (!fs.existsSync(DB_SCRIPT)) {
    console.error('[e2e-paging] db.js not found:', DB_SCRIPT);
    return false;
  }
  console.log('[e2e-paging] Creating mock DB (' + project + ') via db.js --resume...');
  const r = spawnSync(process.execPath, [DB_SCRIPT, '--resume', project], { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e-paging] db.js --resume failed');
    return false;
  }
  return true;
}

function runApiGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e-paging] Generator not built. Run "npm run build" in gen/ or from repo root.');
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
      console.error('[e2e-paging] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  console.log('[e2e-paging] Running API generator for', appName);
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
  if (conn.user) {
    args.push('-u', conn.user);
  }
  if (conn.password) {
    args.push('-pw', conn.password);
  }
  if (conn.port != null && conn.port !== '') {
    args.push('-p', String(conn.port));
  }
  const r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  return r.status === 0;
}

function runMfePagingGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e-paging] Generator not built. Run "npm run build" in gen/ or from repo root.');
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
      console.error('[e2e-paging] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  const effectiveAppName = appName || E2E_APP_NAME;
  
  // First generate API to get the schema
  console.log('[e2e-paging] Running API generator first to get schema...');
  const apiArgs = [
    DIST_MAIN,
    '-a', effectiveAppName,
    '-d', conn.database,
    '-o', outDir,
    '-t', conn.dbType,
    '-f', 'api',
  ];
  if (conn.host) {
    apiArgs.push('-h', conn.host);
  }
  if (conn.user) {
    apiArgs.push('-u', conn.user);
  }
  if (conn.password) {
    apiArgs.push('-pw', conn.password);
  }
  if (conn.port != null && conn.port !== '') {
    apiArgs.push('-p', String(conn.port));
  }
  let r = spawnSync(process.execPath, apiArgs, { cwd: GEN_DIR, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e-paging] API generator failed with code', r.status);
    return false;
  }
  
  // Then generate MFE Parcel Paging
  console.log('[e2e-paging] Running MFE Parcel Paging generator...');
  const args = [
    DIST_MAIN,
    '-a', effectiveAppName,
    '-f', 'mfe-parcel-paging',
    '-d', conn.database,
    '-o', outDir,
    '-t', conn.dbType,
  ];
  if (conn.host) {
    args.push('-h', conn.host);
  }
  if (conn.user) {
    args.push('-u', conn.user);
  }
  if (conn.password) {
    args.push('-pw', conn.password);
  }
  if (conn.port != null && conn.port !== '') {
    args.push('-p', String(conn.port));
  }
  r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e-paging] MFE Parcel Paging generator exited with code', r.status);
    return false;
  }
  return true;
}

function buildMfe(outDir) {
  if (!fs.existsSync(path.join(outDir, 'package.json'))) {
    console.error('[e2e-paging] package.json not found in', outDir);
    return false;
  }
  const installResult = spawnSync(
    'sh',
    ['-c', 'npm install --legacy-peer-deps --no-audit --ignore-scripts 2>&1'],
    {
      cwd: outDir,
      stdio: 'pipe',
      timeout: 300000,
      env: {
        ...process.env,
        NODE_ENV: 'development',
        npm_config_audit: 'false',
        npm_config_fund: 'false',
        npm_config_production: 'false',
        NPM_CONFIG_PRODUCTION: 'false',
      }
    }
  );
  if (installResult.status !== 0) {
    const out = (installResult.stdout && installResult.stdout.toString()) || '';
    const err = (installResult.stderr && installResult.stderr.toString()) || '';
    console.error('[e2e-paging] npm install falhou. stdout:', out.slice(-1200));
    console.error('[e2e-paging] npm install falhou. stderr:', err.slice(-1200));
    return false;
  }
  const buildResult = spawnSync('npm', ['run', 'build'], {
    cwd: outDir,
    stdio: 'pipe',
    timeout: 120000,
    env: {
      ...process.env,
      NODE_ENV: 'development',
      npm_config_production: 'false',
      NPM_CONFIG_PRODUCTION: 'false',
    }
  });
  if (buildResult.status !== 0) {
    const out = (buildResult.stdout && buildResult.stdout.toString()) || '';
    const err = (buildResult.stderr && buildResult.stderr.toString()) || '';
    console.error('[e2e-paging] npm run build falhou. stdout:', out.slice(-1200));
    console.error('[e2e-paging] npm run build falhou. stderr:', err.slice(-1200));
    return false;
  }
  return true;
}

function discoverGeneratedMfeDirs(outDir) {
  const frontendDir = path.join(outDir, 'frontend');
  if (!fs.existsSync(frontendDir)) {
    return [];
  }
  const entries = fs.readdirSync(frontendDir, { withFileTypes: true });
  return entries
    .filter((e) => e.isDirectory() && e.name.endsWith('-paging-mfe'))
    .map((e) => path.join(frontendDir, e.name))
    .filter((dir) => fs.existsSync(path.join(dir, 'package.json')))
    .sort();
}

function startMfe(outDir, port) {
  const distMain = path.join(outDir, 'dist', 'main.js');
  if (!fs.existsSync(distMain)) {
    console.error('[e2e-paging] dist/main.js não encontrado em', outDir);
    return null;
  }
  const env = { ...process.env, NODE_ENV: 'production', PORT: String(port) };
  const child = spawn(process.execPath, [distMain], {
    cwd: outDir,
    env,
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  return child;
}

function assessResults(outDir, project) {
  const expected = PROJECT_EXPECTED[project];
  if (!expected) {
    console.error('[e2e-paging] Unknown project for assessment:', project);
    return false;
  }
  
  const checks = [];
  let requiredFailed = false;

  // Check for MFE Parcel Paging artifacts
  const artifacts = [
    path.join(outDir, 'package.json'),
    path.join(outDir, 'vite.config.ts'),
    path.join(outDir, 'index.html'),
    path.join(outDir, 'Dockerfile'),
    path.join(outDir, 'src', 'main.tsx'),
    path.join(outDir, 'src', 'App.tsx'),
    path.join(outDir, 'src', 'api', 'client.ts'),
    path.join(outDir, 'src', 'api', 'dataProvider.ts'),
  ];

  for (const p of artifacts) {
    const pass = fs.existsSync(p);
    if (!pass) requiredFailed = true;
    checks.push({ name: path.relative(outDir, p) || p, pass, required: true });
  }

  // Check for App.tsx content
  const appTsxPath = path.join(outDir, 'src', 'App.tsx');
  if (fs.existsSync(appTsxPath)) {
    const content = fs.readFileSync(appTsxPath, 'utf-8');
    const hasPagination = content.includes('Pagination') || content.includes('paging');
    const hasFilter = content.includes('FilterForm') || content.includes('filter');
    checks.push({
      name: 'App.tsx contains pagination logic',
      pass: hasPagination,
      required: true,
    });
    if (!hasPagination) requiredFailed = true;
    checks.push({
      name: 'App.tsx contains filter logic',
      pass: hasFilter,
      required: true,
    });
    if (!hasFilter) requiredFailed = true;
  }

  console.log('[e2e-paging] --- Aferição dos resultados ---');
  for (const c of checks) {
    const badge = c.pass ? 'OK' : 'FALHA';
    const req = c.required ? '' : ' (opcional)';
    console.log('[e2e-paging]   ' + badge + ': ' + c.name + req);
  }
  const requiredPassed = checks.filter((c) => c.required && c.pass).length;
  const requiredTotal = checks.filter((c) => c.required).length;
  console.log('[e2e-paging] ---');
  console.log('[e2e-paging] Resultado: ' + (requiredFailed ? 'FALHA' : 'OK') + ' (obrigatórios ' + requiredPassed + '/' + requiredTotal + ')');
  return !requiredFailed;
}

async function main() {
  const args = process.argv.slice(2).filter((a) => typeof a === 'string' && !a.startsWith('--'));
  const rawProjects = args.length > 0 ? args : discoverProjects();
  const projects = rawProjects.filter((p) => PROJECT_EXPECTED[p]);

  if (projects.length === 0) {
    console.error('[e2e-paging] Nenhum projeto com connection.<dbType>.json em:', PROJECTS_DIR);
    process.exit(1);
  }

  console.log('[e2e-paging] Repo root:', REPO_ROOT);
  console.log('[e2e-paging] Output base:', OUT_DIR_BASE);
  console.log('[e2e-paging] Gen dir:', GEN_DIR);
  console.log('[e2e-paging] DB type alvo:', E2E_PAGING_DB_TYPE);
  console.log('[e2e-paging] Projetos:', projects.join(', '));

  let anyFailed = false;
  for (const project of projects) {
    const connectionDir = path.join(PROJECTS_DIR, project, 'db');
    const connectionFiles = discoverConnectionFiles(connectionDir);
    if (connectionFiles.length === 0) {
      console.log('[e2e-paging] Projeto', project, ': sem conexões, pulando.');
      continue;
    }
    console.log('[e2e-paging] Projeto', project, 'conexões:', connectionFiles.map((c) => c.dbType).join(', '));

    const selectedConnectionFile = connectionFiles.find((c) => c.dbType === E2E_PAGING_DB_TYPE);
    if (!selectedConnectionFile) {
      console.error('[e2e-paging] Projeto', project, ': sem conexão', E2E_PAGING_DB_TYPE + '. Falha.');
      anyFailed = true;
      continue;
    }

    const dbType = selectedConnectionFile.dbType;
    const connectionPath = selectedConnectionFile.path;
    console.log('[e2e-paging] ========== project:', project, 'dbType:', dbType, '==========');
    
    let conn;
    try {
      conn = loadMockConnection(connectionPath);
    } catch (e) {
      console.error('[e2e-paging]', e.message);
      anyFailed = true;
      continue;
    }
    
    if (conn.dbType === 'sqlite') {
      conn.database = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
    }
    
    console.log('[e2e-paging] Parâmetros (mock): dbType=%s database=%s', conn.dbType, conn.database);
    if (!ensureMock(conn, project)) {
      anyFailed = true;
      continue;
    }
    
    const outDir = path.join(OUT_DIR_BASE, project, 'mfe-paging');
    const appName = project;
    
    // Generate MFE Parcel Paging
    if (!runMfePagingGenerator(conn, outDir, appName)) {
      anyFailed = true;
      continue;
    }
    
    const generatedMfeDirs = discoverGeneratedMfeDirs(outDir);
    if (generatedMfeDirs.length === 0) {
      console.error('[e2e-paging] Nenhum diretório frontend/*-paging-mfe encontrado em', outDir);
      anyFailed = true;
      continue;
    }

    for (const generatedMfeDir of generatedMfeDirs) {
      console.log('[e2e-paging] Buildando MFE Parcel Paging em', generatedMfeDir);
      if (!buildMfe(generatedMfeDir)) {
        anyFailed = true;
        continue;
      }

      if (!assessResults(generatedMfeDir, project)) {
        anyFailed = true;
        continue;
      }
    }

    if (anyFailed) {
      continue;
    }

    // Start one generated MFE and check HTTP response
    const healthcheckMfeDir = generatedMfeDirs[0];
    console.log('[e2e-paging] Subindo MFE Parcel Paging e verificando:', healthcheckMfeDir);
    const mfePort = MFE_PORT + Math.floor(Math.random() * 1000);
    const mfeProcess = startMfe(healthcheckMfeDir, mfePort);
    
    if (mfeProcess) {
      await new Promise((resolve) => setTimeout(resolve, 3000));
      
      const healthResult = await curlGet(mfePort, '/', 5000);
      const healthOk = healthResult.statusCode === 200;
      
      if (healthOk) {
        console.log('[e2e-paging] MFE Parcel Paging respondendo na porta', mfePort);
      } else {
        console.error('[e2e-paging] MFE Parcel Paging não respondeu. Status:', healthResult.statusCode);
        anyFailed = true;
      }
      
      try { mfeProcess.kill('SIGTERM'); } catch (e) { try { mfeProcess.kill('SIGKILL'); } catch (_) {} }
    }
  }

  if (anyFailed) {
    process.exit(1);
  }
  console.log('[e2e-paging] Done.');
}

main();
