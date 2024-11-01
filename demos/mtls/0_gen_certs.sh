#!/bin/bash

source ../../spire-vars.sh
source ./mtls-demo.config	# demo variables

main() {

  case $1 in

    init)
	create_client_cert
	create_server_cert
	;;

    client) 
	create_client_cert
	;;
    server)
	create_server_cert
	;;
    *)
	echo "Usage: $0 [ init | client | server ]"
	exit -1
	;;
  esac
}

#############################
function create_client_cert() {
  echo "Creating client certificate..."
  response=$(PKI.createCertificate "$TEMPLATE_NAME" "$CLIENT_CN" $CLIENT_CERT_TTL)
}

#############################
function create_server_cert() {
  echo "Creating server certificate..."
  response=$(PKI.createCertificate "$TEMPLATE_NAME" "$SERVER_CN" $SERVER_CERT_TTL)

  # add certs & key to build directory for image build
  echo "$(echo $response | jq -r .certificate)" > ./build/server/tls-cert
  echo "$(echo $response | jq -r .privateKey)" > ./build/server/tls-private-key
  echo "$(echo $response | jq -r .caCertificate)" > ./build/server/tls-ca-chain
}

main "$@"
