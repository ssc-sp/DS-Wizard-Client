#!/usr/bin/bash
cd $HOME/DS-Wizard-Client
npm run clean
#npm run test
pwd
npm run build
docker build -t dsw-client-ssc -f engine-wizard/docker/Dockerfile .
cd dsw-deployment-example
docker-compose down
docker-compose up -d