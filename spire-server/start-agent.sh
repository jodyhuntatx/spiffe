#!/bin/bash -x

cd spire

echo
echo "Generating join token for Agent..."
token_out=$(bin/spire-server token generate -spiffeID spiffe://example.org/myagent)
join_token=$(echo $token_out | cut -d' ' -f2)

echo
echo "Starting agent..."
tmux new -s spire-agent bin/spire-agent run -config conf/agent/agent.conf -joinToken $join_token
bin/spire-agent healthcheck

echo
echo "Generating SVID for agent..."
bin/spire-server entry create -parentID spiffe://example.org/myagent     -spiffeID spiffe://example.org/myservice -selector unix:uid:$(id -u)

echo
echo "Writing SVID to /tmp..."
bin/spire-agent api fetch x509 -write /tmp/
openssl x509 -in /tmp/svid.0.pem -text -noout
