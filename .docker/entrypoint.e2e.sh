#!/bin/bash
# .docker/entrypoint.e2e.sh
set -e
if [ $# -eq 0 ]; then
  export NODE_PATH=/app/gen/node_modules
  node test/mock/create-db.js 2>/dev/null || true
  exec node test/e2e-generator-mock/run.js
fi
exec "$@"
