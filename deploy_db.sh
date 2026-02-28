#!/bin/bash
echo "Deploying Database container..."
docker rm -f acada-postgres || true
docker run -d --name acada-postgres -p 5432:5432 \
    -v ~/web-app-db/init-db.sql:/docker-entrypoint-initdb.d/init-db.sql \
    --env-file ~/web-app-db/.db_env \
    postgres:15-alpine|| true