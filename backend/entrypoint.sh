#!/bin/sh
set -e

echo "Running migrations..."
/app/main migrate

echo "Starting application..."
/app/main
