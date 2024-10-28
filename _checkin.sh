#!/bin/bash

pushd jwt-cred-composer
rm -rf spire-conjur-jwtauth
popd

pushd spire-server
rm -rf spire
popd

git add .
git commit -m "checkpoint"
git push origin main
