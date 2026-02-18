// test/e2e-generator-mock/run.js
const path = require('path');
const fs = require('fs');
const { spawnSync } = require('child_process');

const REPO_ROOT = path.resolve(__dirname, '..', '..');
const GEN_DIR = path.join(REPO_ROOT, 'gen');
const MOCK_DIR = path.join(REPO_ROOT, 'test', 'mock');
const MOCK_CONNECTION_PATH = path.join(MOCK_DIR, 'connection.json');
const MOCK_CREATE = path.join(MOCK_DIR, 'create-db.js');
const DIST_MAIN = path.join(GEN_DIR, 'dist', 'main.js');
const OUT_DIR = path.join(__dirname, 'out');
const COMPONENTS = 'entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram';

function loadMockConnection() {
  if (!fs.existsSync(MOCK_CONNECTION_PATH)) {
    throw new Error('Dados de conexão do mock não encontrados: ' + MOCK_CONNECTION_PATH);
  }
  const raw = JSON.parse(fs.readFileSync(MOCK_CONNECTION_PATH, 'utf-8'));
  const databasePath = path.isAbsolute(raw.database)
    ? raw.database
    : path.join(MOCK_DIR, raw.database);
  return {
    dbType: raw.dbType || 'sqlite',
    database: databasePath,
    user: raw.user != null ? String(raw.user) : 'x',
    password: raw.password != null ? String(raw.password) : 'x',
  };
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

const ARTIFACTS = [
  path.join(OUT_DIR, 'db.reader.sqlite.json'),
  path.join(OUT_DIR, 'src', 'app', 'app.module.ts'),
  path.join(OUT_DIR, '.env'),
  path.join(OUT_DIR, 'package.json'),
  path.join(OUT_DIR, 'README.md'),
];

function ensureMock(conn) {
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

function runGenerator(conn) {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e] Generator not built. Run "npm run build" in gen/ or from repo root.');
    return false;
  }
  if (fs.existsSync(OUT_DIR)) {
    try {
      fs.rmSync(OUT_DIR, { recursive: true });
    } catch (e) {
      console.error('[e2e] Failed to clean out dir:', e.message);
      return false;
    }
  }
  fs.mkdirSync(OUT_DIR, { recursive: true });
  console.log('[e2e] Running generator with mock connection params...');
  const args = [
    DIST_MAIN,
    '-a', 'e2e-mock-app',
    '-d', conn.database,
    '-u', conn.user,
    '-pw', conn.password,
    '-o', OUT_DIR,
    '-t', conn.dbType,
    '-f', COMPONENTS,
  ];
  const r = spawnSync(process.execPath, args, { cwd: GEN_DIR, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e] Generator exited with code', r.status);
    return false;
  }
  return true;
}

function assessResults() {
  const checks = [];
  let requiredFailed = false;

  for (const p of ARTIFACTS) {
    const pass = fs.existsSync(p);
    if (!pass) requiredFailed = true;
    checks.push({ name: path.relative(OUT_DIR, p) || p, pass, required: true });
  }

  const entitiesDir = path.join(OUT_DIR, 'src', 'app', 'entities');
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

  const appDir = path.join(OUT_DIR, 'src', 'app');
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
  const schemaPath = path.join(OUT_DIR, 'db.reader.sqlite.json');
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

  let diagramOk = fs.existsSync(path.join(OUT_DIR, 'public', 'diagram.png'));
  checks.push({ name: 'public/diagram.png', pass: diagramOk, required: false });

  let buildOk = false;
  if (fs.existsSync(path.join(OUT_DIR, 'package.json'))) {
    const buildResult = spawnSync('npm', ['run', 'build'], {
      cwd: OUT_DIR,
      stdio: 'pipe',
      timeout: 120000,
    });
    buildOk = buildResult.status === 0;
    checks.push({
      name: 'npm run build no output (opcional)',
      pass: buildOk,
      required: false,
    });
  }

  console.log('[e2e] --- Aferição dos resultados ---');
  for (const c of checks) {
    const badge = c.pass ? 'OK' : 'FALHA';
    const req = c.required ? '' : ' (opcional)';
    console.log(`[e2e]   ${badge}: ${c.name}${req}`);
  }
  const requiredPassed = checks.filter((c) => c.required && c.pass).length;
  const requiredTotal = checks.filter((c) => c.required).length;
  console.log('[e2e] ---');
  console.log(
    `[e2e] Resultado: ${requiredFailed ? 'FALHA' : 'OK'} (obrigatórios ${requiredPassed}/${requiredTotal})`
  );
  return !requiredFailed;
}

function main() {
  let conn;
  try {
    conn = loadMockConnection();
  } catch (e) {
    console.error('[e2e]', e.message);
    process.exit(1);
  }
  console.log('[e2e] Repo root:', REPO_ROOT);
  console.log('[e2e] Output dir:', OUT_DIR);
  console.log('[e2e] Gen dir:', GEN_DIR);
  console.log('[e2e] Parâmetros de entrada (mock): dbType=%s database=%s', conn.dbType, conn.database);
  if (!ensureMock(conn)) process.exit(1);
  if (!runGenerator(conn)) process.exit(1);
  if (!assessResults()) process.exit(1);
  console.log('[e2e] Done.');
}

main();
