#!/bin/bash

cd .docker

docker compose -p "node_gen" down --volumes --remove-orphans
docker compose -p "node_gen" build --no-cache
docker compose -p "node_gen" up -d

cd ..
