#!/bin/bash -x

cd spire

echo
echo "Generating join token for Agent..."
token_out=$(./spire-server token generate -spiffeID spiffe://jodyhuntatx.com/myagent)
join_token=$(echo $token_out | cut -d' ' -f2)

echo
echo "Starting agent..."
read -n 1 -s -r -p "Use Ctrl-b d to exit tmux..." foo
tmux new -s spire-agent ./spire-agent run -config conf/agent/agent.conf -joinToken $join_token
./spire-agent healthcheck

echo
echo "Generating SVID for agent..."
./spire-server entry create -parentID spiffe://jodyhuntatx.com/myagent     -spiffeID spiffe://jodyhuntatx.com/myservice -selector unix:uid:$(id -u)

echo
echo "Writing SVID to /tmp..."
./spire-agent api fetch x509 -write /tmp/
openssl x509 -in /tmp/svid.0.pem -text -noout
