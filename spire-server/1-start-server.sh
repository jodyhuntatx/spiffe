#!/bin/bash

echo
echo "Starting Spire server..."
read -n 1 -s -r -p "Use Ctrl-b d to exit tmux..." foo

cd spire
tmux new-session -A -s spire-server "./spire-server run -config conf/server/server.conf"
./spire-server healthcheck
