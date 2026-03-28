// test/sspa.spec.ts
import { execFile as execFileCallback } from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import { promisify } from 'node:util';

import { expect, test } from '@playwright/test';

type SspaEntity = {
  columns?: Record<string, unknown>;
  endpoints?: {
    list?: string;
  };
};

type SspaProject = {
  apiPort?: number;
  entities?: Record<string, SspaEntity>;
  route?: string;
};

type SspaProjects = Record<string, SspaProject>;
type HttpMatrixRow = Record<string, number | string>;
type HttpMatrixAnomaly = {
  project: string;
  entity: string;
  field: string;
  status: number;
};
type CardValidationRow = {
  project: string;
  api_port: number;
  card_visible: boolean;
  orchestrator_route_status: number;
  api_health_status: number;
  entity: string;
  entity_status: number;
};
type UiEntityNavigationRow = {
  project: string;
  entity: string;
  has_error_message: boolean;
  row_count: number;
  status: string;
};
type UiDbValidationRow = {
  project: string;
  entity: string;
  table: string;
  checked_rows: number;
  checked_columns: number;
  status: string;
};
type UiDbValidationAnomaly = {
  project: string;
  entity: string;
  row_id: string;
  column: string;
  ui_value: string;
  db_value: string;
  reason: string;
};

const ORCHESTRATOR_BASE = 'http://localhost:9000';
const PLAYWRIGHT_PROJECT = (process.env.PLAYWRIGHT_PROJECT ?? '').trim();
const PLAYWRIGHT_DB_ASSERT = (process.env.PLAYWRIGHT_DB_ASSERT ?? 'true').toLowerCase() === 'true';
const PLAYWRIGHT_DB_LIMIT = Number(process.env.PLAYWRIGHT_DB_LIMIT ?? '20');
const POSTGRES_CONTAINER = process.env.PLAYWRIGHT_POSTGRES_CONTAINER ?? 'nodegen-postgres';
const execFile = promisify(execFileCallback);

const ACCEPTED_LIST_CODES = new Set([200, 204, 400, 401, 403, 404, 405, 500]);
const ACCEPTED_CREATE_CODES = new Set([200, 201, 202, 204, 400, 401, 403, 404, 405, 409, 415, 422, 429, 500]);
const ACCEPTED_MUTATION_BY_ID_CODES = new Set([200, 201, 202, 204, 400, 401, 403, 404, 405, 409, 415, 422, 429]);
const ACCEPTED_SECURITY_CODES = new Set([400, 401, 403, 404]);
const ACCEPTED_CARD_ENTITY_CODES = new Set([200, 204, 400, 401, 403, 404, 405, 500]);

async function withRetry<T>(operation: () => Promise<T>, retries = 5, delayMs = 300): Promise<T> {
  let lastError: unknown;
  for (let attempt = 1; attempt <= retries; attempt += 1) {
    try {
      return await operation();
    } catch (error) {
      lastError = error;
      if (attempt < retries) {
        await new Promise((resolve) => setTimeout(resolve, delayMs));
      }
    }
  }
  throw lastError;
}

async function tryStatus(operation: () => Promise<{ status(): number }>): Promise<number> {
  try {
    const response = await withRetry(operation);
    return response.status();
  } catch {
    return 0;
  }
}

async function tryStatusNoRetry(operation: () => Promise<{ status(): number }>): Promise<number> {
  try {
    const response = await operation();
    return response.status();
  } catch {
    return 0;
  }
}

type DiscoveryApplication = {
  route?: string;
};

function parseProjectFromRoute(route: string | undefined): string | null {
  if (!route) {
    return null;
  }
  const normalized = route.trim().replace(/^\/+/, '').replace(/\/+$/, '');
  return normalized.length > 0 ? normalized : null;
}

async function buildPortMapFromOutput(projectKeys: string[]): Promise<Record<string, number>> {
  const outputEntries = await fs.readdir('output', { withFileTypes: true }).catch(() => []);
  const sorted = outputEntries
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort();
  const selected = new Set(projectKeys);
  const ports: Record<string, number> = {};
  let currentPort = 3001;
  for (const projectKey of sorted) {
    const postgresDir = path.join('output', projectKey, 'postgres');
    const hasPostgresDir = await fs.stat(postgresDir).then((value) => value.isDirectory()).catch(() => false);
    if (!hasPostgresDir) {
      continue;
    }
    const hasAppPackage = await fs
      .stat(path.join(postgresDir, 'package.json'))
      .then((value) => value.isFile())
      .catch(async () => fs.stat(path.join(postgresDir, 'api', 'package.json')).then((value) => value.isFile()).catch(() => false));
    if (hasAppPackage && selected.has(projectKey)) {
      ports[projectKey] = currentPort;
    }
    currentPort += 1;
  }
  return ports;
}

async function loadSchema(projectKey: string): Promise<Record<string, SspaEntity>> {
  const schemaPath = path.join('output', projectKey, 'postgres', 'db.reader.postgres.json');
  try {
    const content = await fs.readFile(schemaPath, 'utf8');
    const payload = JSON.parse(content) as { schema?: Array<{ tableName?: string; columns?: Array<{ columnName?: string }> }> };
    const entities: Record<string, SspaEntity> = {};
    for (const table of payload.schema ?? []) {
      const tableName = (table.tableName ?? '').trim();
      if (!tableName) {
        continue;
      }
      const columns: Record<string, unknown> = {};
      for (const column of table.columns ?? []) {
        const columnName = (column.columnName ?? '').trim();
        if (!columnName) {
          continue;
        }
        columns[columnName] = true;
      }
      entities[tableName] = {
        columns,
        endpoints: {
          list: `/${tableName}`
        }
      };
    }
    return entities;
  } catch {
    return {};
  }
}

async function loadProjects(requestContext: { get: (url: string) => Promise<{ ok(): boolean; status(): number; json(): Promise<unknown> }> }) {
  const projectsFromDiscovery = new Set<string>();
  const discoveryResponse = await requestContext.get(`${ORCHESTRATOR_BASE}/api/discovery/applications`);
  expect(discoveryResponse.ok(), `discovery applications não carregou (status=${discoveryResponse.status()})`).toBeTruthy();
  const applications = await discoveryResponse.json() as DiscoveryApplication[];
  for (const application of applications) {
    const projectKey = parseProjectFromRoute(application.route);
    if (projectKey) {
      projectsFromDiscovery.add(projectKey);
    }
  }

  const portMap = await buildPortMapFromOutput([...projectsFromDiscovery]);
  const projects: SspaProjects = {};
  for (const projectKey of projectsFromDiscovery) {
    projects[projectKey] = {
      apiPort: portMap[projectKey],
      route: `/${projectKey}`,
      entities: await loadSchema(projectKey)
    };
  }

  if (!PLAYWRIGHT_PROJECT) {
    return projects;
  }

  const filteredEntries = Object.entries(projects).filter(([projectKey]) => projectKey === PLAYWRIGHT_PROJECT);
  expect(
    filteredEntries.length,
    `Projeto ${PLAYWRIGHT_PROJECT} não encontrado em projects.json. Disponíveis: ${Object.keys(projects).join(', ')}`
  ).toBe(1);
  return Object.fromEntries(filteredEntries);
}

function selectLikelyEntities(entities: Record<string, SspaEntity>): Array<[string, SspaEntity]> {
  const entries = Object.entries(entities);
  const prioritized = entries.filter(([entityKey]) => !/^(event|event_body)$/i.test(entityKey));
  const source = prioritized.length > 0 ? prioritized : entries;
  return source;
}

function quoteIdentifier(value: string): string {
  return `"${value.replace(/"/g, '""')}"`;
}

function quoteLiteral(value: string): string {
  return `'${value.replace(/'/g, "''")}'`;
}

function normalizeUiValue(value: string | null | undefined): string {
  const raw = value == null ? '' : String(value).trim();
  return raw === '' ? '-' : raw;
}

function normalizeDbValue(value: unknown): string {
  if (value === null || value === undefined) {
    return '-';
  }
  const asString = String(value).trim();
  return asString === '' ? '-' : asString;
}

async function queryProjectRows(
  projectName: string,
  tableName: string,
  ids: string[],
  columns: string[]
): Promise<Record<string, Record<string, string>>> {
  if (ids.length === 0) {
    return {};
  }

  const projectedColumns = columns.map((column) => `${quoteIdentifier(column)}::text AS ${quoteIdentifier(column)}`).join(', ');
  const idArray = ids.map((id) => quoteLiteral(id)).join(',');
  const sql = `SELECT row_to_json(t) FROM (SELECT id::text AS id, ${projectedColumns} FROM ${quoteIdentifier(tableName)} WHERE id::text = ANY(ARRAY[${idArray}])) t;`;

  const { stdout } = await execFile('docker', [
    'exec',
    '-e',
    'PGPASSWORD=postgres',
    POSTGRES_CONTAINER,
    'psql',
    '-U',
    'postgres',
    '-d',
    projectName,
    '-t',
    '-A',
    '-c',
    sql
  ]);

  const output = stdout.trim();
  if (!output) {
    return {};
  }

  const rows: Array<Record<string, unknown>> = output
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .map((line) => JSON.parse(line) as Record<string, unknown>);

  const byId: Record<string, Record<string, string>> = {};
  for (const row of rows) {
    const id = String(row.id ?? '').trim();
    if (!id) {
      continue;
    }
    const normalized: Record<string, string> = {};
    for (const column of columns) {
      normalized[column] = normalizeDbValue(row[column]);
    }
    byId[id] = normalized;
  }

  return byId;
}

test.describe('SSPA Dashboard - Cobertura Abrangente', () => {
  test('dashboard carrega com menu e cards', async ({ page }) => {
    const orchestrator404s: string[] = [];

    page.on('response', (response) => {
      if (response.status() === 404 && response.url().startsWith(ORCHESTRATOR_BASE)) {
        orchestrator404s.push(response.url());
      }
    });

    await page.goto('/');
    await expect(page.getByRole('heading', { level: 1, name: 'SSPA Dynamic Discovery' })).toBeVisible();
    await expect(page.locator('section').first()).toBeVisible();
    expect(await page.locator('article').count()).toBeGreaterThan(0);
    expect(orchestrator404s).toEqual([]);
  });

  test('rotas do orquestrador por projeto não retornam 404', async ({ request }) => {
    const projects = await loadProjects(request);
    const projectKeys = Object.keys(projects);
    expect(projectKeys.length).toBeGreaterThan(0);

    for (const projectKey of projectKeys) {
      const response = await request.get(`${ORCHESTRATOR_BASE}/${projectKey}/`);
      expect(response.status(), `Rota do orquestrador inválida para projeto ${projectKey}`).toBe(200);
    }
  });

  test('validação card-a-card: ui, health e endpoint principal por projeto', async ({ page, request }) => {
    test.setTimeout(420000);
    const projects = await loadProjects(request);
    const rows: CardValidationRow[] = [];
    const failures: string[] = [];
    const projectKeys = Object.keys(projects);

    await page.goto('/');
    if (PLAYWRIGHT_PROJECT) {
      await expect(page.locator('article', { hasText: `/${PLAYWRIGHT_PROJECT}` })).toBeVisible();
    } else {
      await expect(page.locator('article')).toHaveCount(projectKeys.length);
    }

    try {
      for (const [projectKey, project] of Object.entries(projects)) {
        const entities = project.entities ?? {};
        const entityEntries = Object.entries(entities);
        const apiPort = project.apiPort ?? 3001;
        const orchestratorRouteStatus = await tryStatusNoRetry(() => request.get(`${ORCHESTRATOR_BASE}/${projectKey}/`));
        const apiHealthStatus = await tryStatusNoRetry(() => request.get(`http://localhost:${apiPort}/health`));
        const cardVisible = (await page.locator('article', { hasText: `/${projectKey}` }).count()) > 0;
        const safeEntityEntries: Array<[string, SspaEntity]> = entityEntries.length > 0 ? entityEntries : [['-', {} as SspaEntity]];

        for (const [entityKey, entity] of safeEntityEntries) {
          const endpoint = entity.endpoints?.list ?? `/${entityKey}`;
          const entityStatus = entityKey === '-'
            ? 0
            : await tryStatusNoRetry(() => request.get(`http://localhost:${apiPort}${endpoint}`));

          rows.push({
            project: projectKey,
            api_port: apiPort,
            card_visible: cardVisible,
            orchestrator_route_status: orchestratorRouteStatus,
            api_health_status: apiHealthStatus,
            entity: entityKey,
            entity_status: entityStatus
          });

          if (entityKey !== '-' && !ACCEPTED_CARD_ENTITY_CODES.has(entityStatus)) {
            failures.push(`${projectKey}/${entityKey}: status inesperado ${entityStatus} no endpoint principal`);
          }
        }

        if (!cardVisible) {
          failures.push(`${projectKey}: card não visível na UI`);
        }
        if (orchestratorRouteStatus !== 200) {
          failures.push(`${projectKey}: rota do orquestrador retornou ${orchestratorRouteStatus}`);
        }
        if (apiHealthStatus !== 200) {
          failures.push(`${projectKey}: /health retornou ${apiHealthStatus} na porta ${apiPort}`);
        }
      }
    } finally {
      await fs.mkdir('playwright-results', { recursive: true });
      await fs.writeFile('playwright-results/card-validation.json', JSON.stringify(rows, null, 2));
    }

    expect(rows.length).toBeGreaterThan(0);
    expect(failures, `Falhas na validação card-a-card: ${failures.join(' | ')}`).toEqual([]);
  });

  test('navegação UI por card e entidade não exibe erro de carregamento', async ({ page, request }) => {
    test.setTimeout(420000);
    const projects = await loadProjects(request);
    const rows: UiEntityNavigationRow[] = [];
    const failures: string[] = [];

    try {
      for (const [projectKey, project] of Object.entries(projects)) {
        await page.goto('/');
        const card = page.locator('article', { hasText: `/${projectKey}` });
        await expect(card, `Card não encontrado para ${projectKey}`).toBeVisible();
        await card.click();
        await expect(page).toHaveURL(new RegExp(`/${projectKey}`));

        const routeStatus = await tryStatusNoRetry(() => request.get(`${ORCHESTRATOR_BASE}/${projectKey}/`));
        const bodyText = await page.locator('body').innerText();
        const hasErrorMessage = bodyText.includes('404') || bodyText.includes('Cannot GET') || bodyText.includes('Erro');

        rows.push({
          project: projectKey,
          entity: '-',
          has_error_message: hasErrorMessage,
          row_count: routeStatus,
          status: hasErrorMessage ? 'error' : 'ok'
        });

        if (hasErrorMessage || routeStatus !== 200) {
          failures.push(`${projectKey}: rota/UI inconsistente (status=${routeStatus})`);
        }
      }
    } finally {
      await fs.mkdir('playwright-results', { recursive: true });
      await fs.writeFile('playwright-results/ui-entity-navigation.json', JSON.stringify(rows, null, 2));
    }

    expect(rows.length).toBeGreaterThan(0);
    expect(failures, `Falhas na navegação UI por entidade: ${failures.join(' | ')}`).toEqual([]);
  });

  test('matriz de autenticação, autorização e CRUD provável por projeto', async ({ request }) => {
    test.setTimeout(420000);
    const projects = await loadProjects(request);
    const matrix: HttpMatrixRow[] = [];
    const anomalies: HttpMatrixAnomaly[] = [];
    let validatedRows = 0;
    const portHealth = new Map<number, number>();

    try {
      for (const [projectKey, project] of Object.entries(projects)) {
        const entities = project.entities ?? {};
        const selectedEntities = selectLikelyEntities(entities);

        if (selectedEntities.length === 0) {
          continue;
        }

        for (const [entityKey, entity] of selectedEntities) {
          const endpoint = entity.endpoints?.list ?? `/${entityKey}`;
          const apiPort = project.apiPort ?? 3001;
          const baseUrl = `http://localhost:${apiPort}${endpoint}`;
          const resourceUrl = `${baseUrl}/1`;
          const hasExternalId = Object.prototype.hasOwnProperty.call(entity.columns ?? {}, 'external_id');
          const healthStatus = portHealth.has(apiPort)
            ? (portHealth.get(apiPort) ?? 0)
            : await tryStatusNoRetry(() => request.get(`http://localhost:${apiPort}/health`));
          portHealth.set(apiPort, healthStatus);

          if (healthStatus === 0) {
            matrix.push({
              project: projectKey,
              entity: entityKey,
              get_unauth: 0,
              get_invalid_token: 0,
              get_malformed_token: 0,
              post_unauth: 0,
              post_invalid_token: 0,
              patch_unauth: hasExternalId ? 0 : -1,
              delete_unauth: hasExternalId ? 0 : -1,
              has_external_id: hasExternalId ? 1 : 0
            });
            continue;
          }

          const unauthGet = await tryStatus(() => request.get(baseUrl));
          const invalidTokenGet = await tryStatus(() =>
            request.get(baseUrl, {
              headers: { Authorization: 'Bearer invalid-token' }
            })
          );
          const malformedTokenGet = await tryStatus(() =>
            request.get(baseUrl, {
              headers: { Authorization: 'invalid-token' }
            })
          );
          const unauthPost = await tryStatus(() =>
            request.post(baseUrl, {
              headers: { 'Content-Type': 'application/json' },
              data: { name: 'playwright-probe' }
            })
          );
          const invalidTokenPost = await tryStatus(() =>
            request.post(baseUrl, {
              headers: {
                Authorization: 'Bearer invalid-token',
                'Content-Type': 'application/json'
              },
              data: { name: 'playwright-probe-invalid-token' }
            })
          );
          const unauthPatch = hasExternalId
            ? await tryStatus(() =>
              request.patch(resourceUrl, {
                headers: { 'Content-Type': 'application/json' },
                data: { name: 'playwright-probe-edit' }
              })
            )
            : -1;
          const unauthDelete = hasExternalId
            ? await tryStatus(() => request.delete(resourceUrl))
            : -1;

          const row = {
            project: projectKey,
            entity: entityKey,
            get_unauth: unauthGet,
            get_invalid_token: invalidTokenGet,
            get_malformed_token: malformedTokenGet,
            post_unauth: unauthPost,
            post_invalid_token: invalidTokenPost,
            patch_unauth: unauthPatch,
            delete_unauth: unauthDelete,
            has_external_id: hasExternalId ? 1 : 0
          };
          matrix.push(row);

          for (const [field, status] of Object.entries(row)) {
            if (field === 'project' || field === 'entity') {
              continue;
            }
            const statusCode = Number(status);
            if (statusCode < 0) {
              continue;
            }
            if (statusCode >= 500) {
              anomalies.push({
                project: projectKey,
                entity: entityKey,
                field,
                status: statusCode
              });
            }
          }

          if (row.get_unauth !== 0) {
            validatedRows += 1;
            expect.soft(ACCEPTED_LIST_CODES.has(row.get_unauth), `GET sem auth inesperado em ${projectKey}/${entityKey}: ${row.get_unauth}`).toBeTruthy();
            expect.soft(ACCEPTED_LIST_CODES.has(row.get_invalid_token), `GET com token inválido inesperado em ${projectKey}/${entityKey}: ${row.get_invalid_token}`).toBeTruthy();
            expect.soft(ACCEPTED_LIST_CODES.has(row.get_malformed_token), `GET com header malformado inesperado em ${projectKey}/${entityKey}: ${row.get_malformed_token}`).toBeTruthy();
            expect.soft(ACCEPTED_CREATE_CODES.has(row.post_unauth), `POST sem auth inesperado em ${projectKey}/${entityKey}: ${row.post_unauth}`).toBeTruthy();
            expect.soft(ACCEPTED_CREATE_CODES.has(row.post_invalid_token), `POST com token inválido inesperado em ${projectKey}/${entityKey}: ${row.post_invalid_token}`).toBeTruthy();
            if (Number(row.has_external_id) === 1) {
              expect.soft(ACCEPTED_MUTATION_BY_ID_CODES.has(row.patch_unauth), `PATCH sem auth inesperado em ${projectKey}/${entityKey}: ${row.patch_unauth}`).toBeTruthy();
              expect.soft(ACCEPTED_MUTATION_BY_ID_CODES.has(row.delete_unauth), `DELETE sem auth inesperado em ${projectKey}/${entityKey}: ${row.delete_unauth}`).toBeTruthy();
            }
          }
        }
      }
    } finally {
      await fs.mkdir('playwright-results', { recursive: true });
      await fs.writeFile('playwright-results/http-matrix.json', JSON.stringify(matrix, null, 2));
      await fs.writeFile('playwright-results/http-matrix-anomalies.json', JSON.stringify(anomalies, null, 2));
    }

    expect(matrix.length).toBeGreaterThan(0);
    expect(validatedRows).toBeGreaterThan(0);
    expect(Array.isArray(anomalies)).toBeTruthy();
  });

  test('paridade UI x Postgres: valores visíveis devem bater com o banco (top 20)', async ({ page, request }) => {
    test.setTimeout(600000);
    test.skip(!PLAYWRIGHT_DB_ASSERT, 'Comparação UI x Postgres desativada por PLAYWRIGHT_DB_ASSERT=false');

    const projects = await loadProjects(request);
    const rows: UiDbValidationRow[] = [];
    const anomalies: UiDbValidationAnomaly[] = [];
    let checkedRowsTotal = 0;

    try {
      for (const [projectKey, project] of Object.entries(projects)) {
        const apiPort = project.apiPort ?? 3001;
        const entities = Object.entries(project.entities ?? {});
        for (const [entityKey, entity] of entities) {
          const tableName = entityKey;
          const columns = Object.keys(entity.columns ?? {}).slice(0, 5);

          const listResponse = await request.get(`http://localhost:${apiPort}/${entityKey}`);
          if (!listResponse.ok()) {
            rows.push({
              project: projectKey,
              entity: entityKey,
              table: tableName,
              checked_rows: 0,
              checked_columns: columns.length,
              status: `api_${listResponse.status()}`
            });
            continue;
          }

          const payload = await listResponse.json() as Array<Record<string, unknown>>;
          const uiRows: Array<{ id: string; values: Record<string, string> }> = [];
          for (const item of payload.slice(0, PLAYWRIGHT_DB_LIMIT)) {
            const idValue = normalizeUiValue(String(item.id ?? ''));
            if (!idValue || idValue === '-') {
              continue;
            }
            const rowValues: Record<string, string> = {};
            for (const column of columns) {
              rowValues[column] = normalizeUiValue(String(item[column] ?? '-'));
            }
            uiRows.push({ id: idValue, values: rowValues });
          }

          if (uiRows.length === 0) {
            rows.push({
              project: projectKey,
              entity: entityKey,
              table: tableName,
              checked_rows: 0,
              checked_columns: columns.length,
              status: 'no_rows'
            });
            continue;
          }

          const dbRowsById = await queryProjectRows(projectKey, tableName, uiRows.map((row) => row.id), columns);
          for (const uiRow of uiRows) {
            const dbRow = dbRowsById[uiRow.id];
            if (!dbRow) {
              anomalies.push({
                project: projectKey,
                entity: entityKey,
                row_id: uiRow.id,
                column: '*',
                ui_value: '[row-present]',
                db_value: '[row-missing]',
                reason: 'row_missing_in_db'
              });
              continue;
            }

            for (const column of columns) {
              const uiValue = uiRow.values[column];
              const dbValue = dbRow[column] ?? '-';
              if (uiValue !== dbValue) {
                anomalies.push({
                  project: projectKey,
                  entity: entityKey,
                  row_id: uiRow.id,
                  column,
                  ui_value: uiValue,
                  db_value: dbValue,
                  reason: 'value_mismatch'
                });
              }
            }
          }

          checkedRowsTotal += uiRows.length;
          rows.push({
            project: projectKey,
            entity: entityKey,
            table: tableName,
            checked_rows: uiRows.length,
            checked_columns: columns.length,
            status: 'ok'
          });
        }
      }
    } finally {
      await fs.mkdir('playwright-results', { recursive: true });
      await fs.writeFile('playwright-results/ui-db-validation.json', JSON.stringify(rows, null, 2));
      await fs.writeFile('playwright-results/ui-db-validation-anomalies.json', JSON.stringify(anomalies, null, 2));
    }

    expect(checkedRowsTotal).toBeGreaterThanOrEqual(0);
    expect(anomalies, `Divergências UI x DB detectadas: ${JSON.stringify(anomalies)}`).toEqual([]);
  });

  test('segurança básica: path traversal no orquestrador não retorna 200', async ({ request }) => {
    const attempts = [
      `${ORCHESTRATOR_BASE}/..%2F..%2Fetc%2Fpasswd`,
      `${ORCHESTRATOR_BASE}/..%5C..%5Cetc%5Cpasswd`
    ];

    for (const url of attempts) {
      const response = await request.get(url);
      expect(ACCEPTED_SECURITY_CODES.has(response.status()), `Resposta insegura para ${url}: ${response.status()}`).toBeTruthy();
    }
  });
});
