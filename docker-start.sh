#!/bin/bash

cd .docker

docker-compose -p "node_gen" down --volumes --remove-orphans

docker compose -p "node_gen" up --build -d

cd ..
