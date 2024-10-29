#!/bin/bash

source ./spire-vars.sh

if [ ! -f $JWT_PLUGIN_BINARY ]; then
  echo "Not found:"
  echo "    $JWT_PLUGIN_BINARY"
  echo "Build JWT plugin composer binary before building server."
  exit -1
fi

# Clone repo
if [ ! -d $SPIRE_HOME ]; then
  git clone --single-branch --branch v${SPIRE_VERSION} https://github.com/spiffe/spire.git
fi

# Build server if not there
if [ ! -f $SPIRE_HOME/spire-server ]; then
  pushd $SPIRE_HOME
  echo "Building spire server..."
  go build ./cmd/spire-server 
  popd
fi

# Build server if not there
if [ ! -f $SPIRE_HOME/spire-agent ]; then
  pushd $SPIRE_HOME
  echo "Building spire agent..."
  go build ./cmd/spire-agent
  popd
fi

# Create /data and /logs directories
mkdir -p $SERVER_DATA_DIR
mkdir -p $SERVER_LOGS_DIR
mkdir -p $SERVER_CERTS_DIR
mkdir -p $AGENT_DATA_DIR
mkdir -p $AGENT_LOGS_DIR
mkdir -p $AGENT_CERTS_DIR

# Generate root cert/key for trust domain
openssl req -x509 								\
	-subj "/C=XX/ST=TX/L=AUS/O=CyberArk/OU=SolnsGrp/CN=${TRUST_DOMAIN_ID}"	\
	-addext "subjectAltName=URI:spiffe://${TRUST_DOMAIN_ID}"		\
	-newkey rsa:4096  -nodes  -sha256 -days 365 				\
	-keyout $SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.key 				\
	-out $SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.crt

cp $SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.crt $AGENT_CERTS_DIR

# setup server.conf
mv $SPIRE_HOME/conf/server/server.conf $SPIRE_HOME/conf/server/server.conf.bak
cat server.conf.template 					\
  | sed -e "s#{{ TRUST_DOMAIN_ID }}#$TRUST_DOMAIN_ID#g" 	\
  | sed -e "s#{{ SERVER_DATA_DIR }}#$SERVER_DATA_DIR#g" 	\
  | sed -e "s#{{ SERVER_LOGS_DIR }}#$SERVER_LOGS_DIR#g" 	\
  | sed -e "s#{{ SERVER_CERTS_DIR }}#$SERVER_CERTS_DIR#g" 	\
  | sed -e "s#{{ JWT_PLUGIN_BINARY }}#$JWT_PLUGIN_BINARY#g" 	\
> $SPIRE_HOME/conf/server/server.conf

# setup agent.conf
mv $SPIRE_HOME/conf/agent/agent.conf $SPIRE_HOME/conf/agent/agent.conf.bak
cat agent.conf.template 					\
  | sed -e "s#{{ TRUST_DOMAIN_ID }}#$TRUST_DOMAIN_ID#g" 	\
  | sed -e "s#{{ AGENT_DATA_DIR }}#$AGENT_DATA_DIR#g" 	\
  | sed -e "s#{{ AGENT_LOGS_DIR }}#$AGENT_LOGS_DIR#g" 	\
  | sed -e "s#{{ AGENT_CERTS_DIR }}#$AGENT_CERTS_DIR#g" 	\
> $SPIRE_HOME/conf/agent/agent.conf
