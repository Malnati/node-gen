#!/bin/bash
# gen/static-api/entrypoint.sh
set -e

echo "Starting application..."

# Wait for database to be ready
if [ -n "$DATABASE_HOST" ]; then
    echo "Waiting for database..."
    # Add your database wait logic here
fi

# Run migrations if needed
# npm run migration:run

# Start the application
exec npm run start:prod
