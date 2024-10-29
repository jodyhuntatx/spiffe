#!/bin/bash

if [ ! -d spire-conjur-jwtauth ]; then
  echo "Cloning repo..."
  git clone https://github.com/infamousjoeg/spire-conjur-jwtauth.git
fi

cd spire-conjur-jwtauth

echo "Building plugin..."
go build -o credentialcomposer-plugin
