#!/bin/bash

DOCKERFILE_FRONTEND=frontend/Dockerfile.frontend-container

cd tornjak-1.8.0
docker build --no-cache -f $DOCKERFILE_FRONTEND --build-arg version=0.0.1 \
		--build-arg github_sha=BOGUS_GITHUB_SHA -t tornjak-frontend:jody .
