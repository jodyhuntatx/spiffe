#!/bin/bash
#git clone --single-branch --branch v1.10.4 https://github.com/spiffe/spire.git
cd spire
go build ./cmd/spire-server 
go build ./cmd/spire-agent
