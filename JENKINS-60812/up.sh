#!/usr/bin/env bash
docker-compose down
docker-compose up --force-recreate --build --remove-orphans
