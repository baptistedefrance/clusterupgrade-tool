#!/usr/bin/bash
# Help with https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/

# This script should be running on the Master node

set -eu -o pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <node-name> <version>"
  exit 1
fi

NODE_NAME="$1"
VERSION="$2"

apt-mark unhold kubeadm
apt-get update
apt-get install -y "kubeadm=${VERSION}"
apt-mark hold kubeadm

ssh root@"${NODE_NAME}" "kubeadm upgrade node"

kubectl drain "${NODE_NAME}" --ignore-daemonsets

apt-mark unhold kubelet kubectl
apt-get update
apt-get install -y "kubelet=${VERSION}" "kubectl=${VERSION}"
apt-mark hold kubelet kubectl

ssh root@"${NODE_NAME}" "systemctl daemon-reload"
ssh root@"${NODE_NAME}" "systemctl restart kubelet"

kubectl uncordon "${NODE_NAME}"

# Check if the node is correctly updated
IS_UPDATED=$(kubectl get nodes "${NODE_NAME}" -o jsonpath='{.metadata.labels.node\.kubernetes\.io/kubelet-version}' | grep -q "${VERSION}"; echo $?)
if [ "${IS_UPDATED}" -eq 0 ]; then
  echo "Node ${NODE_NAME} successfully updated to version ${VERSION}."
else
  echo "Failed to update node ${NODE_NAME} to version ${VERSION}."
fi
