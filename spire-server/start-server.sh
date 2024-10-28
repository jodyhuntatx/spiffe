#!/bin/bash

echo
echo "Starting Spire server..."

cd spire
tmux new-session -A -s spire-server "bin/spire-server run -config conf/server/server.conf"
./bin/spire-server healthcheck
