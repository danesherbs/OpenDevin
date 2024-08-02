#!/bin/bash

dockerd > /var/log/dockerd.log 2>&1 &

while (! docker stats --no-stream ); do
  echo "Waiting for Docker to start..."
  sleep 1
done

source /opt/conda/bin/activate opendevin
make build

if [ $# -gt 0 ]; then
  exec "$@"
else
  exec bash --login
fi
