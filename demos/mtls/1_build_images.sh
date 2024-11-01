#!/bin/bash
set -eu

source ../../spiffe-vars.sh
source ./env/mtls-demo.config

main() {
  docker-compose build client
  rm ./build/client/conjur*
}

main "$@"
