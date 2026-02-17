// e2e-generator-mock/run.js
const path = require('path');
const fs = require('fs');
const { spawnSync } = require('child_process');

const REPO_ROOT = path.resolve(__dirname, '..');
const MOCK_DB = path.join(REPO_ROOT, 'mock', 'mock.sqlite');
const MOCK_CREATE = path.join(REPO_ROOT, 'mock', 'create-db.js');
const DIST_MAIN = path.join(REPO_ROOT, 'dist', 'main.js');
const OUT_DIR = path.join(__dirname, 'out');
const COMPONENTS = 'entities,services,interfaces,controllers,dtos,modules,app-module,main,env,package.json,readme,datasource,diagram';

const ARTIFACTS = [
  path.join(OUT_DIR, 'db.reader.sqlite.json'),
  path.join(OUT_DIR, 'src', 'app', 'app.module.ts'),
  path.join(OUT_DIR, '.env'),
  path.join(OUT_DIR, 'package.json'),
  path.join(OUT_DIR, 'README.md'),
];

function ensureMock() {
  if (fs.existsSync(MOCK_DB)) {
    console.log('[e2e] Mock DB already exists:', MOCK_DB);
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

function runGenerator() {
  if (!fs.existsSync(DIST_MAIN)) {
    console.error('[e2e] Generator not built. Run "npm run build" at repo root.');
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
  console.log('[e2e] Running generator...');
  const args = [
    DIST_MAIN,
    '-a', 'e2e-mock-app',
    '-d', MOCK_DB,
    '-u', 'x', '-pw', 'x',
    '-o', OUT_DIR,
    '-t', 'sqlite',
    '-f', COMPONENTS,
  ];
  const r = spawnSync(process.execPath, args, { cwd: REPO_ROOT, stdio: 'inherit' });
  if (r.status !== 0) {
    console.error('[e2e] Generator exited with code', r.status);
    return false;
  }
  return true;
}

function validate() {
  const missing = [];
  for (const p of ARTIFACTS) {
    if (!fs.existsSync(p)) missing.push(p);
  }
  const entitiesDir = path.join(OUT_DIR, 'src', 'app', 'entities');
  if (!fs.existsSync(entitiesDir)) {
    missing.push(entitiesDir + '/');
  } else {
    const entities = fs.readdirSync(entitiesDir).filter((f) => f.endsWith('.ts'));
    if (entities.length === 0) missing.push(entitiesDir + '/*.ts');
  }
  if (missing.length > 0) {
    console.error('[e2e] Missing artifacts:', missing);
    return false;
  }
  console.log('[e2e] All required artifacts present.');
  return true;
}

function main() {
  console.log('[e2e] Repo root:', REPO_ROOT);
  console.log('[e2e] Output dir:', OUT_DIR);
  if (!ensureMock()) process.exit(1);
  if (!runGenerator()) process.exit(1);
  if (!validate()) process.exit(1);
  console.log('[e2e] Done. Optional: run "npm run build" inside', OUT_DIR, 'to check compile.');
}

main();
