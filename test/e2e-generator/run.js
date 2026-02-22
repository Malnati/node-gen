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
  const projectList = args.slice(1).filter((a) => !a.startsWith('--'));

  if (mode !== 'db' && mode !== 'e2e') {
    console.error('[run] Uso: node run.js db [project1 project2 ...] | node run.js e2e [project1 project2 ...]');
    process.exit(1);
  }

  const projects = projectList.length > 0 ? projectList : discoverAllProjects();
  if (projects.length === 0) {
    console.error('[run] Nenhum projeto encontrado em:', PROJECTS_DIR);
    process.exit(1);
  }

  const script = mode === 'db' ? scriptDb : scriptE2e;
  if (!fs.existsSync(script)) {
    console.error('[run] Script não encontrado:', script);
    process.exit(1);
  }

  const spawnArgs = [script, ...projects];
  const result = spawnSync(process.execPath, spawnArgs, {
    cwd: REPO_ROOT,
    env: process.env,
    stdio: 'inherit',
  });

  process.exit(result.status != null ? result.status : 1);
}

main();
