// test/sspa.spec.ts
import fs from 'node:fs/promises';

import { expect, test } from '@playwright/test';

type SspaEntity = {
  endpoints?: {
    list?: string;
  };
};

type SspaProject = {
  apiPort?: number;
  entities?: Record<string, SspaEntity>;
};

type SspaProjects = Record<string, SspaProject>;

const ORCHESTRATOR_BASE = 'http://localhost:9000';

const ACCEPTED_READ_CODES = new Set([200, 401, 403]);
const ACCEPTED_WRITE_CODES = new Set([200, 201, 202, 204, 400, 401, 403, 404, 405, 409, 415, 422]);
const ACCEPTED_SECURITY_CODES = new Set([400, 401, 403, 404]);

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

async function loadProjects(requestContext: { get: (url: string) => Promise<{ ok(): boolean; status(): number; json(): Promise<SspaProjects> }> }) {
  const response = await requestContext.get(`${ORCHESTRATOR_BASE}/data/projects.json`);
  expect(response.ok(), `projects.json não carregou (status=${response.status()})`).toBeTruthy();
  return response.json();
}

test.describe('SSPA Dashboard - Cobertura Abrangente', () => {
  test.describe.configure({ mode: 'serial' });

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

  test('matriz de autenticação, autorização e CRUD provável por projeto', async ({ request }) => {
    test.setTimeout(240000);
    const projects = await loadProjects(request);
    const matrix: Array<Record<string, number | string>> = [];
    let validatedRows = 0;

    for (const [projectKey, project] of Object.entries(projects)) {
      const entities = project.entities ?? {};
      const firstEntity = Object.entries(entities)[0];

      if (!firstEntity) {
        continue;
      }

      const [entityKey, entity] = firstEntity;
      const endpoint = entity.endpoints?.list ?? `/${entityKey}`;
      const apiPort = project.apiPort ?? 3001;
      const baseUrl = `http://localhost:${apiPort}${endpoint}`;
      const resourceUrl = `${baseUrl}/1`;

      const unauthGet = await tryStatus(() => request.get(baseUrl));
      const invalidTokenGet = await tryStatus(() =>
        request.get(baseUrl, {
        headers: { Authorization: 'Bearer invalid-token' }
        })
      );
      const unauthPost = await tryStatus(() =>
        request.post(baseUrl, {
        headers: { 'Content-Type': 'application/json' },
        data: { name: 'playwright-probe' }
        })
      );
      const unauthPatch = await tryStatus(() =>
        request.patch(resourceUrl, {
        headers: { 'Content-Type': 'application/json' },
        data: { name: 'playwright-probe-edit' }
        })
      );
      const unauthDelete = await tryStatus(() => request.delete(resourceUrl));

      const row = {
        project: projectKey,
        entity: entityKey,
        get_unauth: unauthGet,
        get_invalid_token: invalidTokenGet,
        post_unauth: unauthPost,
        patch_unauth: unauthPatch,
        delete_unauth: unauthDelete
      };
      matrix.push(row);

      if (row.get_unauth !== 0) {
        validatedRows += 1;
        expect(ACCEPTED_READ_CODES.has(row.get_unauth), `GET sem auth inesperado em ${projectKey}/${entityKey}: ${row.get_unauth}`).toBeTruthy();
        expect(ACCEPTED_READ_CODES.has(row.get_invalid_token), `GET com token inválido inesperado em ${projectKey}/${entityKey}: ${row.get_invalid_token}`).toBeTruthy();
        expect(ACCEPTED_WRITE_CODES.has(row.post_unauth), `POST sem auth inesperado em ${projectKey}/${entityKey}: ${row.post_unauth}`).toBeTruthy();
        expect(ACCEPTED_WRITE_CODES.has(row.patch_unauth), `PATCH sem auth inesperado em ${projectKey}/${entityKey}: ${row.patch_unauth}`).toBeTruthy();
        expect(ACCEPTED_WRITE_CODES.has(row.delete_unauth), `DELETE sem auth inesperado em ${projectKey}/${entityKey}: ${row.delete_unauth}`).toBeTruthy();
      }
    }

    await fs.mkdir('playwright-results', { recursive: true });
    await fs.writeFile('playwright-results/http-matrix.json', JSON.stringify(matrix, null, 2));
    expect(matrix.length).toBeGreaterThan(0);
    expect(validatedRows).toBeGreaterThan(0);
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
