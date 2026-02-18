// test/e2e-generator-mock/run.js
const path = require('path');
const fs = require('fs');
const { spawnSync } = require('child_process');

const REPO_ROOT = path.resolve(__dirname, '..', '..');
const GEN_DIR = path.join(REPO_ROOT, 'gen');
const MOCK_DIR = path.join(REPO_ROOT, 'test', 'e2e-generator-mock');
const CONNECTION_DIR = path.join(MOCK_DIR, 'projects', 'todo', 'db');
const MOCK_CREATE = path.join(MOCK_DIR, 'create-db.js');
const DIST_MAIN = path.join(GEN_DIR, 'dist', 'main.js');
const OUT_DIR_BASE = path.join(REPO_ROOT, 'output');
const E2E_APP_NAME = process.env.E2E_APP_NAME || 'e2e-mock-app';
const COMPONENTS = 'entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource';

const CONNECTION_FILE_PATTERN = /^connection\.([a-z0-9]+)\.json$/;

function discoverConnectionFiles() {
  if (!fs.existsSync(CONNECTION_DIR)) {
    return [];
  }
  const entries = fs.readdirSync(CONNECTION_DIR, { withFileTypes: true });
  const out = [];
  for (const e of entries) {
    if (!e.isFile() || !e.name.endsWith('.json')) continue;
    const m = e.name.match(CONNECTION_FILE_PATTERN);
    if (m) {
      out.push({ dbType: m[1], path: path.join(CONNECTION_DIR, e.name) });
    }
  }
  const allowed = process.env.E2E_DB_TYPES;
  const list = allowed
    ? out.filter((c) => allowed.split(',').map((s) => s.trim().toLowerCase()).includes(c.dbType.toLowerCase()))
    : out;
  return list.sort((a, b) => a.dbType.localeCompare(b.dbType));
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
  return conn;
}

const EXPECTED_TABLES = [
  'tb_simple_item', 'tb_category', 'tb_product', 'tb_sale', 'tb_sale_item',
  'tb_tag', 'tb_product_tag', 'tb_document',
];
const EXPECTED_MODULE_NAMES = [
  'simple-item', 'category', 'product', 'sale', 'sale-item',
  'tag', 'product-tag', 'document',
];
const EXPECTED_ENTITY_FILES = [
  'simple_item.ts', 'category.ts', 'product.ts', 'sale.ts', 'sale_item.ts',
  'tag.ts', 'product_tag.ts', 'document.ts',
];

function artifactsFor(dbType, outDir) {
  return [
    path.join(outDir, `db.reader.${dbType}.json`),
    path.join(outDir, 'src', 'app', 'app.module.ts'),
    path.join(outDir, '.env'),
    path.join(outDir, 'package.json'),
    path.join(outDir, 'README.md'),
  ];
}

function ensureMock(conn) {
  if (conn.dbType !== 'sqlite') {
    return true;
  }
  if (fs.existsSync(conn.database)) {
    console.log('[e2e] Mock DB already exists:', conn.database);
    return true;
  }
  if (!fs.existsSync(MOCK_CREATE)) {
    console.error('[e2e] Mock create script not found:', MOCK_CREATE);
    return false;
  }
  console.log('[e2e] Creating mock DB...');
  const r = spawnSync(process.execPath, [MOCK_CREATE], { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e] Failed to create mock DB');
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
        fs.rmSync(p, { recursive: true });
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
    return false;
  }
  return true;
}

function assessResults(dbType, outDir) {
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
    name: `entities (esperado ${EXPECTED_MODULE_NAMES.length}, obtido ${entityFiles.length})`,
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
    name: `nomes das entidades (${EXPECTED_ENTITY_FILES.join(', ')})`,
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
    name: `módulos por tabela (${EXPECTED_MODULE_NAMES.length} dirs com service, controller, module)`,
    pass: modulesOk,
    required: true,
  });

  let schemaOk = false;
  const schemaPath = path.join(outDir, `db.reader.${dbType}.json`);
  if (fs.existsSync(schemaPath)) {
    try {
      const parsed = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));
      const tables = parsed.schema || [];
      schemaOk = tables.length === EXPECTED_TABLES.length;
      if (!schemaOk) requiredFailed = true;
      checks.push({
        name: `schema JSON (${tables.length} tabelas, esperado ${EXPECTED_TABLES.length})`,
        pass: schemaOk,
        required: true,
      });
    } catch (e) {
      checks.push({ name: 'schema JSON (leitura)', pass: false, required: true });
      requiredFailed = true;
    }
  }

  let diagramOk = fs.existsSync(path.join(outDir, 'public', 'diagram.png'));
  checks.push({ name: 'public/diagram.png', pass: diagramOk, required: false });

  let buildOk = false;
  if (fs.existsSync(path.join(outDir, 'package.json'))) {
    const installResult = spawnSync('npm', ['install', '--legacy-peer-deps'], {
      cwd: outDir,
      stdio: 'pipe',
      timeout: 180000,
    });
    if (installResult.status !== 0) {
      buildOk = false;
    } else {
      const buildResult = spawnSync('npm', ['run', 'build'], {
        cwd: outDir,
        stdio: 'pipe',
        timeout: 120000,
      });
      buildOk = buildResult.status === 0;
    }
    checks.push({
      name: 'npm run build no output (opcional)',
      pass: buildOk,
      required: false,
    });
  }

  console.log(`[e2e] --- Aferição dos resultados (${dbType}) ---`);
  for (const c of checks) {
    const badge = c.pass ? 'OK' : 'FALHA';
    const req = c.required ? '' : ' (opcional)';
    console.log(`[e2e]   ${badge}: ${c.name}${req}`);
  }
  const requiredPassed = checks.filter((c) => c.required && c.pass).length;
  const requiredTotal = checks.filter((c) => c.required).length;
  console.log('[e2e] ---');
  console.log(
    `[e2e] Resultado ${dbType}: ${requiredFailed ? 'FALHA' : 'OK'} (obrigatórios ${requiredPassed}/${requiredTotal})`
  );
  return !requiredFailed;
}

function main() {
  const connectionFiles = discoverConnectionFiles();
  if (connectionFiles.length === 0) {
    console.error('[e2e] Nenhum arquivo connection.<dbType>.json em:', CONNECTION_DIR);
    process.exit(1);
  }

  console.log('[e2e] Repo root:', REPO_ROOT);
  console.log('[e2e] Output base:', OUT_DIR_BASE);
  console.log('[e2e] App name:', E2E_APP_NAME);
  console.log('[e2e] Gen dir:', GEN_DIR);
  console.log('[e2e] Conexões encontradas:', connectionFiles.map((c) => c.dbType).join(', '));

  let anyFailed = false;
  for (const { dbType, path: connectionPath } of connectionFiles) {
    console.log('[e2e] ========== dbType:', dbType, '==========');
    let conn;
    try {
      conn = loadMockConnection(connectionPath);
    } catch (e) {
      console.error('[e2e]', e.message);
      anyFailed = true;
      continue;
    }
    console.log('[e2e] Parâmetros (mock): dbType=%s database=%s', conn.dbType, conn.database);
    if (!ensureMock(conn)) {
      anyFailed = true;
      continue;
    }
    const outDir = path.join(OUT_DIR_BASE, E2E_APP_NAME, dbType);
    if (!runGenerator(conn, outDir, E2E_APP_NAME)) {
      anyFailed = true;
      continue;
    }
    if (!assessResults(dbType, outDir)) {
      anyFailed = true;
    }
  }

  if (anyFailed) {
    process.exit(1);
  }
  console.log('[e2e] Done.');
}

main();
