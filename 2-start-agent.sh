#!/bin/bash

source ./spire-vars.sh

cd $SPIRE_HOME

echo
echo "Generating join token for Agent..."
token_out=$(./spire-server token generate -spiffeID spiffe://$TRUST_DOMAIN_ID/myagent)
join_token=$(echo $token_out | cut -d' ' -f2)

echo
echo "Starting agent..."
read -n 1 -s -r -p "Use Ctrl-b d to exit tmux..." foo
tmux new -s spire-agent ./spire-agent run -config conf/agent/agent.conf -joinToken $join_token
./spire-agent healthcheck
