#!/bin/sh
set -e

export $(grep -v '^#' .env | xargs)

while ! pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
  echo "Waiting for database connection..."
  sleep 5
done

go run migrate/migrate.go
exec /app/main