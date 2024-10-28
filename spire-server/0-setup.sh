#!/bin/bash

SPIRE_VERSION=1.10.4
SPIRE_SERVER_HOME=$PWD/spire
JWT_PLUGIN_BINARY=/Users/Jody.Hunt/Conjur/spiffe/jwt-cred-composer/spire-conjur-jwtauth/credentialcomposer-plugin
SERVER_DATA_DIR=$SPIRE_SERVER_HOME/data/server
SERVER_LOGS_DIR=$SPIRE_SERVER_HOME/logs/server

if [ ! -f $JWT_PLUGIN_BINARY ]; then
  echo "Not found:"
  echo "    $JWT_PLUGIN_BINARY"
  echo "Build JWT plugin composer binary before building server."
  exit -1
fi

# Clone repo
if [ ! -d $SPIRE_SERVER_HOME ]; then
  git clone --single-branch --branch v${SPIRE_VERSION} https://github.com/spiffe/spire.git
fi

# Build server if not there
if [ ! -f $SPIRE_SERVER_HOME/spire-server ]; then
  pushd $SPIRE_SERVER_HOME
  go build ./cmd/spire-server 
  popd
fi

# Build server if not there
if [ ! -f $SPIRE_SERVER_HOME/spire-agent ]; then
  pushd $SPIRE_SERVER_HOME
  go build ./cmd/spire-agent
  popd
fi

# Create /data and /logs directories
mkdir -p $SERVER_DATA_DIR
mkdir -p $SERVER_LOGS_DIR

# setup server.conf
mv $SPIRE_SERVER_HOME/conf/server/server.conf $SPIRE_SERVER_HOME/conf/server/server.conf.bak
cat server.conf.template 					\
  | sed -e "s#{{ SERVER_DATA_DIR }}#$SERVER_DATA_DIR#g" 	\
  | sed -e "s#{{ SERVER_LOGS_DIR }}#$SERVER_LOGS_DIR#g" 	\
  | sed -e "s#{{ JWT_PLUGIN_BINARY }}#$JWT_PLUGIN_BINARY#g" 	\
> $SPIRE_SERVER_HOME/conf/server/server.conf
