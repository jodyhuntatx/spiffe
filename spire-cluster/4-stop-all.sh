#!/bin/bash

source ./spire-vars.sh

read -n 1 -s -r -p "Ctrl-C in each tmux window..." foo
tmux a -t spire-agent
tmux a -t spire-server

rm -rf $SERVER_DATA_DIR
rm -rf $AGENT_DATA_DIR
