// test/e2e-generator-mock/apply-ddl-comments.js
// One-off: read COMMENT ON from Postgres DDL and apply to MySQL, SQL Server, SQLite.
const fs = require('fs');
const path = require('path');

const PROJECTS_DIR = path.join(__dirname, 'projects');
const PROJECTS = [
  'contacts', 'users', 'tenant', 'transactions', 'auth', 'communications',
  'maps', 'config', 'roles', 'notifications', 'orders', 'warehouse', 'reports',
  'google-calendar', 'google-drive', 'llm', 'gmail', 'logistics', 'consents',
  'todo', 'selling', 'schedule'
];

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

function applyMySQL(content, comments, firstLine) {
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
      const l = lines[j];
      const t = l.trim();
      blockLines.push(l);
      if (/^\s*\)\s*;?\s*$/.test(t)) {
        i = j + 1;
        break;
      }
    }
    const lastIdx = blockLines.length - 1;
    for (let k = 0; k < blockLines.length; k++) {
      const l = blockLines[k];
      const isClosing = k === lastIdx && /^\s*\)\s*;?\s*$/.test(l.trim());
      if (isClosing && tableComment != null && tableComment !== '') {
        const escapedTableComment = String(tableComment).replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        const withComment = l.replace(/\)\s*;?\s*$/, ") COMMENT = '" + escapedTableComment + "';");
        out.push(withComment);
        continue;
      }
      const colName = extractColumnName(l);
      const colComment = colName && colComments[colName];
      if (colComment && !l.includes("COMMENT '") && !l.includes('COMMENT =')) {
        const escaped = colComment.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        if (l.trim().endsWith(',')) {
          out.push(l.replace(/,(\s*)$/, " COMMENT '" + escaped + "',$1"));
        } else {
          out.push(l.replace(/\s*\)/, " COMMENT '" + escaped + "' )"));
        }
      } else {
        out.push(l);
      }
    }
  }
  return out.join('\n');
}

function applySQLServer(content, comments, firstLine) {
  const out = [];
  const lines = content.split('\n');
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const createMatch = line.match(/CREATE TABLE (?:\[(\w+)\]|(\w+))\s*\(/);
    if (!createMatch) {
      const execMatch = line.trim().startsWith('EXEC sp_addextendedproperty');
      if (execMatch) {
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
    let depth = 0;
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
      const insertPk = '  CONSTRAINT pk_' + tableName + ' PRIMARY KEY (id)';
      const newLast = lastLine.replace(/\s*\)\s*;?\s*$/, ',\n' + insertPk + '\n);');
      rewritten[rewritten.length - 1] = newLast;
      constraintNames.push('pk_' + tableName);
    }
    for (const l of rewritten) out.push(l);
    const schema = 'dbo';
    const tableN = tableName;
    if (tableComment != null && tableComment !== '') {
      out.push(`EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'${String(tableComment).replace(/'/g, "''")}', @level0type = N'SCHEMA', @level0name = N'${schema}', @level1type = N'TABLE', @level1name = N'${tableN}';`);
    }
    const colNames = [];
    for (const l of rewritten) {
      const c = extractColumnName(l);
      if (c && !['CONSTRAINT', 'PRIMARY', 'UNIQUE', 'FOREIGN', 'CHECK'].includes(c)) colNames.push(c);
    }
    for (const col of colNames) {
      const desc = colComments[col];
      if (desc != null && desc !== '') {
        out.push(`EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'${String(desc).replace(/'/g, "''")}', @level0type = N'SCHEMA', @level0name = N'${schema}', @level1type = N'TABLE', @level1name = N'${tableN}', @level2type = N'COLUMN', @level2name = N'${col}';`);
      }
    }
    for (const cn of constraintNames) {
      const desc = constraintCommentsTable[cn];
      if (desc != null && desc !== '') {
        out.push(`EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'${String(desc).replace(/'/g, "''")}', @level0type = N'SCHEMA', @level0name = N'${schema}', @level1type = N'TABLE', @level1name = N'${tableN}', @level2type = N'CONSTRAINT', @level2name = N'${cn}';`);
      }
    }
  }
  return out.join('\n');
}

function applySQLite(content, comments, firstLine) {
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
        if (l.trim().endsWith(',')) {
          out.push(l.replace(/,(\s*)$/, ", -- " + suffix + "$1"));
        } else {
          out.push(l.replace(/\s*$/, " -- " + suffix));
        }
      } else {
        out.push(l);
      }
      i = j + 1;
      if (/^\s*\)\s*;?\s*$/.test(t)) break;
    }
  }
  return out.join('\n');
}

function processFile(engine, content, comments, firstLine) {
  if (engine === 'mysql') return applyMySQL(content, comments, firstLine);
  if (engine === 'sqlserver') return applySQLServer(content, comments, firstLine);
  if (engine === 'sqlite') return applySQLite(content, comments, firstLine);
  return content;
}

function processProject(projectName) {
  const dbDir = path.join(PROJECTS_DIR, projectName, 'db');
  const files = [];
  const postgresDb = path.join(dbDir, 'database.postgres.ddl');
  const postgresSchema = path.join(dbDir, 'schema.postgres.ddl');
  let allComments = { tableComments: {}, columnComments: {}, constraintComments: {} };
  if (fs.existsSync(postgresDb)) {
    const c = fs.readFileSync(postgresDb, 'utf8');
    mergeComments(allComments, parsePostgresComments(c));
  }
  if (fs.existsSync(postgresSchema)) {
    const c = fs.readFileSync(postgresSchema, 'utf8');
    mergeComments(allComments, parsePostgresComments(c));
  }
  const toProcess = [
    { engine: 'mysql', base: 'database' },
    { engine: 'sqlserver', base: 'database' },
    { engine: 'sqlite', base: 'database' }
  ];
  const schemaEngines = ['mysql', 'sqlserver', 'sqlite'];
  if (fs.existsSync(postgresSchema)) {
    toProcess.push(...schemaEngines.map(e => ({ engine: e, base: 'schema' })));
  }
  const modified = [];
  for (const { engine, base } of toProcess) {
    const f = path.join(dbDir, `${base}.${engine}.ddl`);
    if (!fs.existsSync(f)) continue;
    let content = fs.readFileSync(f, 'utf8');
    const firstLine = content.split('\n')[0];
    const newContent = processFile(engine, content, allComments, firstLine);
    if (newContent !== content) {
      fs.writeFileSync(f, newContent, 'utf8');
      modified.push(f);
    }
  }
  return modified;
}

function main() {
  const modified = [];
  for (const proj of PROJECTS) {
    try {
      const m = processProject(proj);
      modified.push(...m);
    } catch (e) {
      console.error(proj, e.message);
    }
  }
  console.log(modified.length ? modified.join('\n') : 'No files modified.');
}

main();
