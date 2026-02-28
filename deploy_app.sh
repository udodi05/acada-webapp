#!/bin/bash
set -e

echo "Deploying webapp containers..."
source /home/ubuntu/web-app/.app_env
echo ${NEXUS_PASSWORD} | docker login 3.96.167.201:90 -u ${NEXUS_USER} --password-stdin
docker pull 3.96.167.201:90/acada-repo/acada-webapp:v1
docker network create acada-network || true

echo "Deploying webapp containers..."
for i in {1..10}; 
do
    docker stop acada-webapp-$i || true ; docker rm -f acada-webapp-$i || true
    docker run -d --name acada-webapp-$i --network acada-network -v ~/web-app/.app_env:/usr/local/tomcat/.env --hostname acada-webapp-$i 3.96.167.201:90/acada-repo/acada-webapp:v1;
    echo "Deploying webapp-$i container done"
done

echo "Deploying HAproxy container..."
docker rm haproxy -f >/dev/null 2>&1 || true
docker run -d --name haproxy --network acada-network -v ~/web-app/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro -p 9095:80 haproxy:latest
docker ps | grep -i haproxy*
echo "Deploying HAproxy container done"