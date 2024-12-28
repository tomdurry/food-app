#!/bin/bash
set -e

go run migrate/migrate.go || {
    echo "Migration failed! Exiting."
    exit 1
}
/app/main
