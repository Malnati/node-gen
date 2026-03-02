// test/e2e-generator/run.js
const path = require('path');
const fs = require('fs');
const { spawnSync } = require('child_process');

const configPath = path.join(__dirname, 'run.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

const REPO_ROOT = path.resolve(__dirname, ...config.repoRootRelative);
const MOCK_DIR = path.join(REPO_ROOT, ...config.mockDirSegment);
const PROJECTS_DIR = path.join(MOCK_DIR, config.projectsDirName);
const scriptDb = path.join(MOCK_DIR, config.scriptDb);
const scriptE2e = path.join(MOCK_DIR, config.scriptE2e);
const scriptE2eMfe = path.join(MOCK_DIR, 'e2e-mfe.js');
const scriptE2eAll = path.join(MOCK_DIR, 'e2e-all.js');

function discoverAllProjects() {
  if (!fs.existsSync(PROJECTS_DIR)) {
    return [];
  }
  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  const out = [];
  for (const d of dirs) {
    if (!d.isDirectory()) continue;
    const dbDir = path.join(PROJECTS_DIR, d.name, 'db');
    if (fs.existsSync(dbDir)) {
      out.push(d.name);
    }
  }
  return out.sort();
}

function main() {
  const args = process.argv.slice(2);
  const mode = args[0];
  const e2eMode = process.env.E2E_MODE || 'api';
  const projectList = args.slice(1).filter((a) => !a.startsWith('--'));

  // Handle db mode
  if (mode === 'db') {
    if (!fs.existsSync(scriptDb)) {
      console.error('[run] Script não encontrado:', scriptDb);
      process.exit(1);
    }
    const spawnArgs = [scriptDb, ...projectList];
    const result = spawnSync(process.execPath, spawnArgs, {
      cwd: REPO_ROOT,
      env: process.env,
      stdio: 'inherit',
    });
    process.exit(result.status != null ? result.status : 1);
    return;
  }

  // Handle e2e mode with E2E_MODE env var
  if (mode === 'e2e') {
    // Determine which script to run based on E2E_MODE
    let script;
    if (e2eMode === 'mfe') {
      script = scriptE2eMfe;
    } else if (e2eMode === 'all') {
      script = scriptE2eAll;
    } else {
      // Default: API only (original e2e.js)
      script = scriptE2e;
    }

    if (!fs.existsSync(script)) {
      console.error('[run] Script não encontrado:', script);
      console.error('[run] E2E_MODE:', e2eMode);
      process.exit(1);
    }

    const spawnArgs = [script, ...projectList];
    const result = spawnSync(process.execPath, spawnArgs, {
      cwd: REPO_ROOT,
      env: process.env,
      stdio: 'inherit',
    });
    process.exit(result.status != null ? result.status : 1);
    return;
  }

  // Legacy: direct e2e-mfe or e2e-all calls
  if (mode === 'e2e-mfe') {
    if (!fs.existsSync(scriptE2eMfe)) {
      console.error('[run] Script não encontrado:', scriptE2eMfe);
      process.exit(1);
    }
    const spawnArgs = [scriptE2eMfe, ...projectList];
    const result = spawnSync(process.execPath, spawnArgs, {
      cwd: REPO_ROOT,
      env: process.env,
      stdio: 'inherit',
    });
    process.exit(result.status != null ? result.status : 1);
    return;
  }

  if (mode === 'e2e-all') {
    if (!fs.existsSync(scriptE2eAll)) {
      console.error('[run] Script não encontrado:', scriptE2eAll);
      process.exit(1);
    }
    const spawnArgs = [scriptE2eAll, ...projectList];
    const result = spawnSync(process.execPath, spawnArgs, {
      cwd: REPO_ROOT,
      env: process.env,
      stdio: 'inherit',
    });
    process.exit(result.status != null ? result.status : 1);
    return;
  }

  console.error('[run] Uso:');
  console.error('  node run.js db [project1 project2 ...]          - Setup de bancos');
  console.error('  node run.js e2e [project1 project2 ...]        - Testes E2E (API)');
  console.error('  node run.js e2e-mfe [project1 ...]              - Testes E2E (MFE)');
  console.error('  node run.js e2e-all [project1 ...]              - Testes E2E (API + MFE)');
  console.error('');
  console.error('  Ambiente:');
  console.error('    E2E_MODE=api    - Executar apenas API (padrão)');
  console.error('    E2E_MODE=mfe    - Executar apenas MFE');
  console.error('    E2E_MODE=all    - Executar API + MFE em paralelo');
  process.exit(1);
}

main();
