#!/bin/bash

source ../../spire-vars.sh

if [[ $# != 1 ]]; then
  echo "Usage: $0 <name-of-service-to-register>"
  exit -1
fi
SERVICE_NAME=$1

source $SPIRE_HOME/spire-vars.sh

cd $SPIRE_HOME

echo
echo "Generating SVID for service..."
$SPIRE_HOME/spire-server entry create 				\
	-parentID spiffe://$TRUST_DOMAIN_ID/myagent		\
	-spiffeID spiffe://$TRUST_DOMAIN_ID/$SERVICE_NAME	\
	-selector unix:uid:$(id -u)

echo
echo "Fetching service SVID & writing to /tmp..."
rm -f /tmp/svid*
$SPIRE_HOME/spire-agent api fetch jwt -audience conjur
