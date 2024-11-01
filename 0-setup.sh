#!/bin/bash

source ./spire-vars.sh

# Create directories
mkdir -p $SPIRE_HOME
cd $SPIRE_HOME
mkdir -p $SERVER_DATA_DIR
mkdir -p $SERVER_LOGS_DIR
mkdir -p $SERVER_CERTS_DIR
mkdir -p $AGENT_DATA_DIR
mkdir -p $AGENT_LOGS_DIR
mkdir -p $AGENT_CERTS_DIR
cd ..

if [ ! -f $SPIRE_HOME/$JWT_PLUGIN_BINARY ]; then
  # clone repo if needs be
  if [ ! -d spire-conjur-jwtauth ]; then
    echo "Cloning repo..."
    git clone https://github.com/infamousjoeg/spire-conjur-jwtauth.git
  fi

  echo "Building plugin..."
  cd spire-conjur-jwtauth
  go build -o $JWT_PLUGIN_BINARY
  cd ..
  mv ./spire-conjur-jwtauth/$JWT_PLUGIN_BINARY
fi

# Clone repo
if [ ! -d spire ]; then
  git clone --single-branch --branch v${SPIRE_VERSION} https://github.com/spiffe/spire.git
fi

# Build server if not there
if [ ! -f $SPIRE_HOME/spire-server ]; then
  cd spire
  echo "Building spire server..."
  go build ./cmd/spire-server 
  cd ..
  mv spire/spire-server $SPIRE_HOME
fi

# Build server if not there
if [ ! -f $SPIRE_HOME/spire-agent ]; then
  cd spire
  echo "Building spire agent..."
  go build ./cmd/spire-agent
  cd ..
  mv spire/spire-agent $SPIRE_HOME
fi

# Generate root cert/key for trust domain
openssl req -x509 								\
	-subj "/C=XX/ST=TX/L=AUS/O=CyberArk/OU=SolnsGrp/CN=${TRUST_DOMAIN_ID}"	\
	-addext "subjectAltName=URI:spiffe://${TRUST_DOMAIN_ID}"		\
	-newkey rsa:4096  -nodes  -sha256 -days 365 				\
	-keyout $SPIRE_HOME/$SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.key 		\
	-out $SPIRE_HOME/$SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.crt

cp $SPIRE_HOME/$SERVER_CERTS_DIR/$TRUST_DOMAIN_ID.crt $SPIRE_HOME/$AGENT_CERTS_DIR

# setup server.conf
mv $SPIRE_HOME/conf/server/server.conf $SPIRE_HOME/conf/server/server.conf.bak
cat ./templates/server.conf.template 				\
  | sed -e "s#{{ TRUST_DOMAIN_ID }}#$TRUST_DOMAIN_ID#g" 	\
  | sed -e "s#{{ SERVER_DATA_DIR }}#$SERVER_DATA_DIR#g" 	\
  | sed -e "s#{{ SERVER_LOGS_DIR }}#$SERVER_LOGS_DIR#g" 	\
  | sed -e "s#{{ SERVER_CERTS_DIR }}#$SERVER_CERTS_DIR#g" 	\
  | sed -e "s#{{ JWT_PLUGIN_BINARY }}#$JWT_PLUGIN_BINARY#g" 	\
> $SPIRE_HOME/conf/server/server.conf

# setup agent.conf
mv $SPIRE_HOME/conf/agent/agent.conf $SPIRE_HOME/conf/agent/agent.conf.bak
cat ./templates/agent.conf.template 			\
  | sed -e "s#{{ TRUST_DOMAIN_ID }}#$TRUST_DOMAIN_ID#g"	\
  | sed -e "s#{{ AGENT_DATA_DIR }}#$AGENT_DATA_DIR#g" 	\
  | sed -e "s#{{ AGENT_LOGS_DIR }}#$AGENT_LOGS_DIR#g" 	\
  | sed -e "s#{{ AGENT_CERTS_DIR }}#$AGENT_CERTS_DIR#g"	\
> $SPIRE_HOME/conf/agent/agent.conf
