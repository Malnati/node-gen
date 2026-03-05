// .docker/sspa/generate-projects-json.js
const fs = require('fs');
const path = require('path');

const root = process.env.SSPA_MFE_OUTPUT_DIR || '/mfe-output';
const projectsFile = process.env.SSPA_PROJECTS_JSON_PATH || '/usr/share/nginx/html/data/projects.json';
const apiPortStart = Number(process.env.SSPA_API_PORT_START || '3001');
const dbFlavor = process.env.SSPA_DB_FLAVOR || 'postgres';

const projects = {};
let port = apiPortStart;

if (fs.existsSync(root)) {
    for (const dir of fs.readdirSync(root).sort()) {
        const reader = path.join(root, dir, dbFlavor, `db.reader.${dbFlavor}.json`);
        if (!fs.existsSync(reader)) {
            continue;
        }

        const db = JSON.parse(fs.readFileSync(reader, 'utf8'));
        const schema = Array.isArray(db.schema) ? db.schema : [];
        const entities = {};

        for (const table of schema) {
            const tableName = table && table.tableName ? String(table.tableName) : '';
            if (!tableName) {
                continue;
            }

            const entityKey = tableName.replace(/^tb_/, '');
            const endpointKey = entityKey.replace(/_/g, '-');
            const columns = {};

            for (const col of Array.isArray(table.columns) ? table.columns : []) {
                if (!col || !col.columnName) {
                    continue;
                }

                columns[col.columnName] = {
                    type: col.dataType || 'unknown',
                    nullable: Boolean(col.isNullable),
                };
            }

            entities[entityKey] = {
                name: entityKey.replace(/_/g, ' '),
                comment: table.tableComment || '',
                columns,
                endpoints: { list: '/' + endpointKey },
            };
        }

        projects[dir] = {
            name: db.projectName || dir,
            description: 'Projeto ' + dir,
            apiPort: port,
            entities,
        };

        port += 1;
    }
}

const projectsDir = path.dirname(projectsFile);
fs.mkdirSync(projectsDir, { recursive: true });
fs.writeFileSync(projectsFile, JSON.stringify(projects, null, 2));
console.log('[sspa] projects.json generated with ' + Object.keys(projects).length + ' project(s)');
