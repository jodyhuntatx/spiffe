#!/bin/bash

pushd jwt-cred-composer
rm -rf spire-conjur-jwtauth
popd

pushd spire-cluster
rm -rf spire
popd

du -sh jwt-cred-composer
du -sh spire-cluster
du -sh tornjak
