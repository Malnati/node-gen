// demo/service-discovery/src/main.ts
import { createServer } from 'node:http';
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

import type { DiscoveryApplication, DiscoveryImportMap } from './contracts.js';

const PORT = Number(process.env.PORT || 3015);
const DISCOVERY_TIMEOUT_MS = Number(process.env.DISCOVERY_TIMEOUT_MS || 1200);
const DISCOVERY_APPS_DIR = process.env.DISCOVERY_APPS_DIR;
const DISCOVERY_APPS_JSON = process.env.DISCOVERY_APPS_JSON;
const DISCOVERY_USE_LOCALHOST = (process.env.DISCOVERY_USE_LOCALHOST || 'false').toLowerCase() === 'true';
const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};
const BASE_IMPORTS: Record<string, string> = {
  react: 'https://esm.sh/react@18.2.0',
  'react-dom': 'https://esm.sh/react-dom@18.2.0',
  'react-dom/client': 'https://esm.sh/react-dom@18.2.0/client',
  'single-spa': 'https://esm.sh/single-spa@5.9.4',
  'react-router-dom': 'https://esm.sh/react-router-dom@6.20.0',
};

function sendJson(res: import('node:http').ServerResponse, status: number, payload: unknown): void {
  res.writeHead(status, {
    ...CORS_HEADERS,
    'Content-Type': 'application/json; charset=utf-8',
    'Cache-Control': 'no-store',
  });
  res.end(JSON.stringify(payload, null, 2));
}

function parseConfiguredApplications(raw: string | undefined): DiscoveryApplication[] {
  if (!raw) {
    return [];
  }

  try {
    const parsed = JSON.parse(raw) as DiscoveryApplication[];
    return parsed
      .filter((application) => {
        return Boolean(
          application?.name &&
            application?.module &&
            application?.route &&
            application?.title &&
            application?.description &&
            application?.importUrl
        );
      })
      .map(normalizeApplication);
  } catch {
    return [];
  }
}

function resolveEnvTemplate(value: string): string {
  const templateRegex = /\$\{([A-Z0-9_]+)(:-([^}]*))?\}/g;
  return value.replace(templateRegex, (_match, variableName: string, _defaultGroup, defaultValue: string | undefined) => {
    const resolvedValue = process.env[variableName];
    if (resolvedValue !== undefined && resolvedValue !== '') {
      return resolvedValue;
    }
    return defaultValue ?? '';
  });
}

function normalizeApplication(application: DiscoveryApplication): DiscoveryApplication {
  return {
    ...application,
    name: resolveEnvTemplate(application.name),
    module: resolveEnvTemplate(application.module),
    route: resolveEnvTemplate(application.route),
    title: resolveEnvTemplate(application.title),
    description: resolveEnvTemplate(application.description),
    importUrl: resolveEnvTemplate(application.importUrl),
  };
}

function parseManifestApplications(raw: string): DiscoveryApplication[] {
  try {
    const parsed = JSON.parse(raw) as DiscoveryApplication | DiscoveryApplication[];
    const applications = Array.isArray(parsed) ? parsed : [parsed];
    return applications
      .filter((application) => {
        return Boolean(
          application?.name &&
            application?.module &&
            application?.route &&
            application?.title &&
            application?.description &&
            application?.importUrl
        );
      })
      .map(normalizeApplication);
  } catch {
    return [];
  }
}

function readApplicationsFromDirectory(directory: string | undefined): DiscoveryApplication[] {
  if (!directory) {
    return [];
  }

  try {
    const files = readdirSync(directory).filter((fileName) => fileName.endsWith('.json')).sort();
    const applications: DiscoveryApplication[] = [];

    files.forEach((fileName) => {
      const fullPath = join(directory, fileName);
      const content = readFileSync(fullPath, 'utf-8');
      applications.push(...parseManifestApplications(content));
    });

    return applications;
  } catch {
    return [];
  }
}

async function isReachable(importUrl: string): Promise<boolean> {
  const signal = AbortSignal.timeout(DISCOVERY_TIMEOUT_MS);
  try {
    const headResponse = await fetch(importUrl, { method: 'HEAD', signal });
    if (headResponse.ok) {
      return true;
    }

    if (headResponse.status !== 405) {
      return false;
    }

    const getResponse = await fetch(importUrl, { method: 'GET', signal });
    return getResponse.ok;
  } catch {
    return false;
  }
}

async function discoverApplications(): Promise<DiscoveryApplication[]> {
  const configuredApplications = DISCOVERY_APPS_DIR
    ? readApplicationsFromDirectory(DISCOVERY_APPS_DIR)
    : parseConfiguredApplications(DISCOVERY_APPS_JSON);
  if (configuredApplications.length === 0) {
    return [];
  }
  const checks = await Promise.all(
    configuredApplications.map(async (application) => ({
      application,
      available: await isReachable(application.importUrl),
    }))
  );

  const availableApplications = checks
    .filter((entry) => entry.available)
    .map((entry) => entry.application);

  if (availableApplications.length > 0) {
    return availableApplications;
  }

  return configuredApplications;
}

function buildImportMap(applications: DiscoveryApplication[]): DiscoveryImportMap {
  const dynamicImports = applications.reduce<Record<string, string>>((acc, application) => {
    acc[application.module] = application.importUrl;
    return acc;
  }, {});

  return {
    imports: {
      ...BASE_IMPORTS,
      ...dynamicImports,
    },
  };
}

function getHeaderValue(
  headers: import('node:http').IncomingHttpHeaders,
  name: string
): string | undefined {
  const value = headers[name];
  if (Array.isArray(value)) {
    return value[0];
  }
  return value;
}

function getPublicProtocol(headers: import('node:http').IncomingHttpHeaders): string {
  const forwardedProto = getHeaderValue(headers, 'x-forwarded-proto');
  if (forwardedProto) {
    return forwardedProto.split(',')[0]?.trim() || 'http';
  }
  return 'http';
}

function getPublicHostname(headers: import('node:http').IncomingHttpHeaders): string | null {
  const forwardedHost = getHeaderValue(headers, 'x-forwarded-host');
  const hostHeader = forwardedHost || getHeaderValue(headers, 'host');
  if (!hostHeader) {
    return null;
  }
  const firstHost = hostHeader.split(',')[0]?.trim();
  if (!firstHost) {
    return null;
  }
  const normalizedHost = firstHost.replace(/:\d+$/, '');
  return normalizedHost || null;
}

function rewriteImportUrlForRequest(
  importUrl: string,
  headers: import('node:http').IncomingHttpHeaders
): string {
  if (DISCOVERY_USE_LOCALHOST) {
    return importUrl;
  }

  try {
    const url = new URL(importUrl);
    const localHosts = new Set(['localhost', '127.0.0.1', 'host.docker.internal']);
    if (!localHosts.has(url.hostname)) {
      return importUrl;
    }

    const publicHostname = getPublicHostname(headers);
    if (!publicHostname) {
      return importUrl;
    }

    url.hostname = publicHostname;
    url.protocol = `${getPublicProtocol(headers)}:`;
    return url.toString();
  } catch {
    return importUrl;
  }
}

function normalizeApplicationsForRequest(
  applications: DiscoveryApplication[],
  headers: import('node:http').IncomingHttpHeaders
): DiscoveryApplication[] {
  return applications.map((application) => ({
    ...application,
    importUrl: rewriteImportUrlForRequest(application.importUrl, headers),
  }));
}

function decodeApplicationName(urlPath: string): string {
  return decodeURIComponent(urlPath.slice('/api/discovery/applications/'.length));
}

function getPathname(urlValue: string | undefined): string {
  if (!urlValue) {
    return '/';
  }

  try {
    return new URL(urlValue, 'http://localhost').pathname;
  } catch {
    return urlValue;
  }
}

async function handleRequest(
  req: import('node:http').IncomingMessage,
  res: import('node:http').ServerResponse
): Promise<void> {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, CORS_HEADERS);
    res.end();
    return;
  }

  const urlPath = getPathname(req.url);

  if (req.method === 'GET' && urlPath === '/health') {
    sendJson(res, 200, { status: 'ok' });
    return;
  }

  if (req.method === 'GET' && urlPath === '/api/discovery/import-map') {
    const applications = normalizeApplicationsForRequest(await discoverApplications(), req.headers);
    sendJson(res, 200, buildImportMap(applications));
    return;
  }

  if (req.method === 'GET' && urlPath === '/api/discovery/applications') {
    const applications = normalizeApplicationsForRequest(await discoverApplications(), req.headers);
    sendJson(res, 200, applications);
    return;
  }

  if (req.method === 'GET' && urlPath.startsWith('/api/discovery/applications/')) {
    const applicationName = decodeApplicationName(urlPath);
    const applications = normalizeApplicationsForRequest(await discoverApplications(), req.headers);
    const application = applications.find(
      (entry) => entry.name === applicationName || entry.module === applicationName
    );

    if (!application) {
      sendJson(res, 404, { error: 'application_not_found', application: applicationName });
      return;
    }

    sendJson(res, 200, application);
    return;
  }

  sendJson(res, 404, { error: 'not_found', path: urlPath });
}

const server = createServer((req, res) => {
  handleRequest(req, res).catch((error) => {
    sendJson(res, 500, {
      error: 'internal_error',
      message: error instanceof Error ? error.message : String(error),
    });
  });
});

server.listen(PORT, () => {
  console.log(`[service-discovery] listening on http://localhost:${PORT}`);
});
