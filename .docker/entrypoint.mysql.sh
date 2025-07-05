#!/bin/bash
set -e
exec docker-entrypoint.sh mysqld
