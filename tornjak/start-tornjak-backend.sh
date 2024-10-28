#!/bin/bash

VERSION=1.8.0
cd tornjak-$VERSION/docs/quickstart/

kubectl apply -f spire-namespace.yaml	\
	-f server-account.yaml		\
	-f spire-bundle-configmap.yaml	\
	-f tornjak-configmap.yaml	\
	-f server-cluster-role.yaml	\
	-f server-configmap.yaml	\
	-f server-statefulset.yaml	\
	-f server-service.yaml

echo "Check readiness with:"
echo "    kubectl get statefulset --namespace spire"
read -n 1 -s -r -p "Press any key to continue" foo
echo

kubectl apply -f agent-account.yaml	\
	-f agent-cluster-role.yaml	\
	-f agent-configmap.yaml		\
	-f agent-daemonset.yaml

echo "Check readiness with:"
echo "    kubectl get daemonset --namespace spire"
read -n 1 -s -r -p "Press any key to continue" foo
echo

echo "Creating registration entry for node..."
kubectl exec -n spire -c spire-server spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s_sat:cluster:demo-cluster \
    -selector k8s_sat:agent_ns:spire \
    -selector k8s_sat:agent_sa:spire-agent \
    -node

echo "Creating registration entry for workload..."
kubectl exec -n spire -c spire-server spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -spiffeID spiffe://example.org/ns/default/sa/default \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s:ns:default \
    -selector k8s:sa:default

echo "Deploying client..."
kubectl apply -f client-deployment.yaml
sleep 5
echo

echo "Verify workload access to agent socket..."
kubectl exec -it $(kubectl get pods -o=jsonpath='{.items[0].metadata.name}' \
   -l app=client)  -- /opt/spire/bin/spire-agent api fetch -socketPath /run/spire/sockets/agent.sock

echo "Verify images..."
kubectl -n spire describe pod spire-server-0 | grep "Image:"
echo

echo "Forwarding port. Access at:"
echo "    http://localhost:10000/api/v1/tornjak/serverinfo"
kubectl -n spire port-forward spire-server-0 10000:10000 >/dev/null 2>&1
