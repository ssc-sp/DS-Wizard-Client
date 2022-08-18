#!/usr/bin/bash
cd $HOME/DS-Wizard-Client
npm run clean
npm run test
npm run build
docker build -t dsw-client-ssc -f engine-wizard/docker/Dockerfile .
cd $HOME/dsw-deployment-example
docker-compose down
docker-compose up -d