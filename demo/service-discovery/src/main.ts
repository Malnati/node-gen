// demo/service-discovery/src/main.ts
import { createServer } from 'node:http';

import { DISCOVERY_APPLICATIONS, buildImportMap } from './mock-data.js';

const PORT = Number(process.env.PORT || 3015);
const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function sendJson(res: import('node:http').ServerResponse, status: number, payload: unknown): void {
  res.writeHead(status, {
    ...CORS_HEADERS,
    'Content-Type': 'application/json; charset=utf-8',
    'Cache-Control': 'no-store',
  });
  res.end(JSON.stringify(payload, null, 2));
}

const server = createServer((req, res) => {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, CORS_HEADERS);
    res.end();
    return;
  }

  const url = req.url || '/';

  if (req.method === 'GET' && url === '/health') {
    sendJson(res, 200, { status: 'ok' });
    return;
  }

  if (req.method === 'GET' && url === '/api/discovery/import-map') {
    sendJson(res, 200, buildImportMap());
    return;
  }

  if (req.method === 'GET' && url === '/api/discovery/applications') {
    sendJson(res, 200, DISCOVERY_APPLICATIONS);
    return;
  }

  sendJson(res, 404, { error: 'not_found', path: url });
});

server.listen(PORT, () => {
  console.log(`[service-discovery] listening on http://localhost:${PORT}`);
});
