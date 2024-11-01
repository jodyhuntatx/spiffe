#!/bin/bash

source ./spire-vars.sh

read -n 1 -s -r -p "Ctrl-C in each tmux window..." foo
tmux a -t spire-agent
tmux a -t spire-server

rm -rf $SPIRE_HOME/$SERVER_DATA_DIR
rm -rf $SPIRE_HOME/$AGENT_DATA_DIR
