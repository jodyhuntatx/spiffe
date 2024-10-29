#!/bin/bash

source ./spire-vars.sh

echo
echo "Starting Spire server..."
read -n 1 -s -r -p "Use Ctrl-b d to exit tmux..." foo

rm $SERVER_LOGS_DIR/server.log

cd spire
tmux new-session -A -s spire-server ./spire-server run -config conf/server/server.conf

cat $SERVER_LOGS_DIR/server.log
echo
./spire-server healthcheck
