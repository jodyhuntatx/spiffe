#!/bin/bash 

VERSION=1.8.0
cd tornjak-$VERSION/docs/quickstart/

kubectl delete -f client-deployment.yaml

kubectl delete -f agent-account.yaml	\
	-f agent-cluster-role.yaml	\
	-f agent-configmap.yaml		\
	-f agent-daemonset.yaml

kubectl delete -f spire-namespace.yaml	\
	-f server-account.yaml		\
	-f spire-bundle-configmap.yaml	\
	-f tornjak-configmap.yaml	\
	-f server-cluster-role.yaml	\
	-f server-configmap.yaml	\
	-f server-statefulset.yaml	\
	-f server-service.yaml
