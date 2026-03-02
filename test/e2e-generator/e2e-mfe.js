// test/e2e-generator/e2e-mfe.js
// Script para testes E2E de MFE (Micro-frontends)
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
const MFE_PORT = process.env.MFE_PORT || 4200;

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
  return conn;
}

function ensureMock(conn, project) {
  if (conn.dbType !== 'sqlite') {
    return true;
  }
  const dbPath = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
  if (fs.existsSync(dbPath)) {
    console.log('[e2e-mfe] Mock DB already exists:', dbPath);
    return true;
  }
  const DB_SCRIPT = path.join(MOCK_DIR, 'db.js');
  if (!fs.existsSync(DB_SCRIPT)) {
    console.error('[e2e-mfe] db.js not found:', DB_SCRIPT);
    return false;
  }
  console.log('[e2e-mfe] Creating mock DB (' + project + ') via db.js --resume...');
  const r = spawnSync(process.execPath, [DB_SCRIPT, '--resume', project], { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e-mfe] db.js --resume failed');
    return false;
  }
  return true;
}

function runMfeGenerator(conn, outDir, appName) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e-mfe] Generator not built. Run "npm run build" in gen/ or from repo root.');
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
      console.error('[e2e-mfe] Failed to clean out dir:', err.message);
      return false;
    }
  } else {
    fs.mkdirSync(outDir, { recursive: true });
  }
  const effectiveAppName = appName || E2E_APP_NAME;
  console.log('[e2e-mfe] Running MFE generator...');
  const args = [
    DIST_MAIN,
    '-a', effectiveAppName,
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
  if (r.status !== 0) {
    console.error('[e2e-mfe] Generator exited with code', r.status);
    return false;
  }
  return true;
}

function buildMfe(outDir) {
  if (!fs.existsSync(path.join(outDir, 'package.json'))) {
    console.error('[e2e-mfe] package.json not found in', outDir);
    return false;
  }
  const installResult = spawnSync(
    'sh',
    ['-c', 'npm install --legacy-peer-deps --no-audit --ignore-scripts 2>&1'],
    { cwd: outDir, stdio: 'pipe', timeout: 300000, env: { ...process.env, npm_config_audit: 'false', npm_config_fund: 'false' } }
  );
  const buildResult = spawnSync('npm', ['run', 'build'], {
    cwd: outDir,
    stdio: 'pipe',
    timeout: 120000,
  });
  if (buildResult.status !== 0) {
    const out = (buildResult.stdout && buildResult.stdout.toString()) || '';
    const err = (buildResult.stderr && buildResult.stderr.toString()) || '';
    console.error('[e2e-mfe] npm run build falhou. stdout:', out.slice(-1200));
    console.error('[e2e-mfe] npm run build falhou. stderr:', err.slice(-1200));
    return false;
  }
  return true;
}

function startMfe(outDir, port) {
  const distMain = path.join(outDir, 'dist', 'main.js');
  if (!fs.existsSync(distMain)) {
    console.error('[e2e-mfe] dist/main.js não encontrado em', outDir);
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
    console.error('[e2e-mfe] Unknown project for assessment:', project);
    return false;
  }
  
  const checks = [];
  let requiredFailed = false;

  // Check for MFE artifacts
  const artifacts = [
    path.join(outDir, 'package.json'),
    path.join(outDir, 'vite.config.ts'),
    path.join(outDir, 'index.html'),
    path.join(outDir, 'src', 'main.ts'),
  ];

  for (const p of artifacts) {
    const pass = fs.existsSync(p);
    if (!pass) requiredFailed = true;
    checks.push({ name: path.relative(outDir, p) || p, pass, required: true });
  }

  // Check for entity components
  const componentsDir = path.join(outDir, 'src', 'components');
  if (fs.existsSync(componentsDir)) {
    const componentFiles = fs.readdirSync(componentsDir).filter((f) => f.endsWith('.ts') || f.endsWith('.tsx'));
    checks.push({
      name: 'components (' + componentFiles.length + ' arquivos)',
      pass: componentFiles.length > 0,
      required: true,
    });
    if (componentFiles.length === 0) requiredFailed = true;
  } else {
    checks.push({ name: 'components directory', pass: false, required: true });
    requiredFailed = true;
  }

  console.log('[e2e-mfe] --- Aferição dos resultados ---');
  for (const c of checks) {
    const badge = c.pass ? 'OK' : 'FALHA';
    const req = c.required ? '' : ' (opcional)';
    console.log('[e2e-mfe]   ' + badge + ': ' + c.name + req);
  }
  const requiredPassed = checks.filter((c) => c.required && c.pass).length;
  const requiredTotal = checks.filter((c) => c.required).length;
  console.log('[e2e-mfe] ---');
  console.log('[e2e-mfe] Resultado: ' + (requiredFailed ? 'FALHA' : 'OK') + ' (obrigatórios ' + requiredPassed + '/' + requiredTotal + ')');
  return !requiredFailed;
}

async function main() {
  const args = process.argv.slice(2).filter((a) => typeof a === 'string' && !a.startsWith('--'));
  const rawProjects = args.length > 0 ? args : discoverProjects();
  const projects = rawProjects.filter((p) => PROJECT_EXPECTED[p]);

  if (projects.length === 0) {
    console.error('[e2e-mfe] Nenhum projeto com connection.<dbType>.json em:', PROJECTS_DIR);
    process.exit(1);
  }

  console.log('[e2e-mfe] Repo root:', REPO_ROOT);
  console.log('[e2e-mfe] Output base:', OUT_DIR_BASE);
  console.log('[e2e-mfe] Gen dir:', GEN_DIR);
  console.log('[e2e-mfe] Projetos:', projects.join(', '));

  let anyFailed = false;
  for (const project of projects) {
    const connectionDir = path.join(PROJECTS_DIR, project, 'db');
    const connectionFiles = discoverConnectionFiles(connectionDir);
    if (connectionFiles.length === 0) {
      console.log('[e2e-mfe] Projeto', project, ': sem conexões, pulando.');
      continue;
    }
    console.log('[e2e-mfe] Projeto', project, 'conexões:', connectionFiles.map((c) => c.dbType).join(', '));

    // Use only sqlite for MFE (simpler)
    const sqliteFile = connectionFiles.find((c) => c.dbType === 'sqlite');
    if (!sqliteFile) {
      console.log('[e2e-mfe] Projeto', project, ': sem conexão sqlite, pulando.');
      continue;
    }

    const dbType = sqliteFile.dbType;
    const connectionPath = sqliteFile.path;
    console.log('[e2e-mfe] ========== project:', project, 'dbType:', dbType, '==========');
    
    let conn;
    try {
      conn = loadMockConnection(connectionPath);
    } catch (e) {
      console.error('[e2e-mfe]', e.message);
      anyFailed = true;
      continue;
    }
    
    conn.database = path.join(MOCK_DIR, project === 'todo' ? 'mock.sqlite' : 'mock-' + project + '.sqlite');
    
    console.log('[e2e-mfe] Parâmetros (mock): dbType=%s database=%s', conn.dbType, conn.database);
    if (!ensureMock(conn, project)) {
      anyFailed = true;
      continue;
    }
    
    const outDir = path.join(OUT_DIR_BASE, project, 'mfe');
    const appName = project;
    
    // Generate MFE
    if (!runMfeGenerator(conn, outDir, appName)) {
      anyFailed = true;
      continue;
    }
    
    // Build MFE
    console.log('[e2e-mfe] Buildando MFE...');
    if (!buildMfe(outDir)) {
      anyFailed = true;
      continue;
    }
    
    // Assess results
    if (!assessResults(outDir, project)) {
      anyFailed = true;
      continue;
    }
    
    // Start MFE and test
    console.log('[e2e-mfe] Subindo MFE e verificando...');
    const mfePort = MFE_PORT + Math.floor(Math.random() * 1000);
    const mfeProcess = startMfe(outDir, mfePort);
    
    if (mfeProcess) {
      await new Promise((resolve) => setTimeout(resolve, 3000));
      
      const healthResult = await curlGet(mfePort, '/', 5000);
      const healthOk = healthResult.statusCode === 200;
      
      if (healthOk) {
        console.log('[e2e-mfe] MFE respondendo na porta', mfePort);
      } else {
        console.error('[e2e-mfe] MFE não respondeu. Status:', healthResult.statusCode);
        anyFailed = true;
      }
      
      try { mfeProcess.kill('SIGTERM'); } catch (e) { try { mfeProcess.kill('SIGKILL'); } catch (_) {} }
    }
  }

  if (anyFailed) {
    process.exit(1);
  }
  console.log('[e2e-mfe] Done.');
}

main();
