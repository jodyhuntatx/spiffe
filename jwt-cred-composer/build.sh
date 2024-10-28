#!/bin/bash

#echo "Clone repo..."
#git clone https://github.com/infamousjoeg/spire-conjur-jwtauth.git

cd spire-conjur-jwtauth

echo "Building plugin..."
go build -o credentialcomposer-plugin

echo 'plugins { \
    CredentialComposer "conjur_jwtauth_composer" { \
        plugin_data { \
            command = "/path/to/credentialcomposer-plugin" \
        } \
    }\ 
}' >> 

tmux a -t spire-server
