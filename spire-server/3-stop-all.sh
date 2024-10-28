#!/bin/bash

echo "Ctrl-C in each tmux window..."
read -n 1 -s -r -p "Press any key to continue..." foo
tmux a -t spire-agent
tmux a -t spire-server

