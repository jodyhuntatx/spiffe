#!/bin/bash

# Startup:
#  cd /usr/src/app
#  npx react-inject-env set && serve -s build -p $PORT_FE
#	--platform linux/amd64/v8				\

set -x
docker run -d							\
	--name tornjak-frontend					\
	-p 3000:3000 						\
	-p 3001:3001 						\
	-e REACT_APP_API_SERVER_URI='http://localhost:10000'	\
	tornjak-frontend:jody

#	-w /usr/src/app						\
#	--entrypoint "npx react-inject-env set && serve -s build -p \$PORT_FE" \
#	ghcr.io/spiffe/tornjak-frontend:latest
