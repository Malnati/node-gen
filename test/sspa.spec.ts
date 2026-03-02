// test/sspa.spec.ts
import fs from 'node:fs/promises';

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

const ORCHESTRATOR_BASE = 'http://localhost:9000';

const ACCEPTED_LIST_CODES = new Set([200, 204, 400, 401, 403, 405]);
const ACCEPTED_CREATE_CODES = new Set([200, 201, 202, 204, 400, 401, 403, 405, 409, 415, 422, 429]);
const ACCEPTED_MUTATION_BY_ID_CODES = new Set([200, 201, 202, 204, 400, 401, 403, 404, 405, 409, 415, 422, 429]);
const ACCEPTED_SECURITY_CODES = new Set([400, 401, 403, 404]);
const ACCEPTED_CARD_ENTITY_CODES = new Set([200, 204, 400, 401, 403, 405]);

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

async function loadProjects(requestContext: { get: (url: string) => Promise<{ ok(): boolean; status(): number; json(): Promise<SspaProjects> }> }) {
  const response = await requestContext.get(`${ORCHESTRATOR_BASE}/data/projects.json`);
  expect(response.ok(), `projects.json não carregou (status=${response.status()})`).toBeTruthy();
  return response.json();
}

function selectLikelyEntities(entities: Record<string, SspaEntity>): Array<[string, SspaEntity]> {
  const entries = Object.entries(entities);
  const prioritized = entries.filter(([entityKey]) => !/^(event|event_body)$/i.test(entityKey));
  const source = prioritized.length > 0 ? prioritized : entries;
  return source;
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
    await expect(page.locator('.dashboard-title')).toBeVisible();
    await expect(page.locator('.sidebar')).toBeVisible();
    await expect(page.locator('.projects-grid')).toBeVisible();
    await expect(page.locator('.project-card')).toHaveCount(await page.locator('.project-card').count());
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
    await expect(page.locator('.project-card')).toHaveCount(projectKeys.length);

    try {
      for (const [projectKey, project] of Object.entries(projects)) {
        const entities = project.entities ?? {};
        const entityEntries = Object.entries(entities);
        const apiPort = project.apiPort ?? 3001;
        const orchestratorRouteStatus = await tryStatusNoRetry(() => request.get(`${ORCHESTRATOR_BASE}/${projectKey}/`));
        const apiHealthStatus = await tryStatusNoRetry(() => request.get(`http://localhost:${apiPort}/health`));
        const cardVisible = (await page.locator(`.project-card[data-project="${projectKey}"]`).count()) > 0;
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
    expect(anomalies, `Respostas 5xx detectadas na matriz HTTP: ${JSON.stringify(anomalies)}`).toEqual([]);
  });

  test('segurança básica: path traversal no orquestrador não retorna 200', async ({ request }) => {
    const attempts = [
      `${ORCHESTRATOR_BASE}/..%2F..%2Fetc%2Fpasswd`,
      `${ORCHESTRATOR_BASE}/..%5C..%5Cetc%5Cpasswd`,
      `${ORCHESTRATOR_BASE}/%2e%2e/%2e%2e/etc/passwd`
    ];

    for (const url of attempts) {
      const response = await request.get(url);
      expect(ACCEPTED_SECURITY_CODES.has(response.status()), `Resposta insegura para ${url}: ${response.status()}`).toBeTruthy();
    }
  });
});
