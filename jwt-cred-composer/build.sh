#!/bin/bash

#echo "Clone repo..."
#git clone https://github.com/infamousjoeg/spire-conjur-jwtauth.git

cd spire-conjur-jwtauth

echo "Building plugin..."
go build -o credentialcomposer-plugin
