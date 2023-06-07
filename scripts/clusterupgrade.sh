#!/usr/bin/env bash
# Help with https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/

# This script should be running on the Master node

set -eu -o pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <node-name> <kubeadm-version> <kubelet-version>"
  exit 1
fi

NODE_NAME="$1"
KUBEADM_VERSION="$2"
KUBELET_VERSION="$3"
KUBECTL_VERSION=${KUBELET_VERSION}

sudo kubectl cordon "${NODE_NAME}"
sudo kubectl drain "${NODE_NAME}" --ignore-daemonsets

sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y "kubeadm=${KUBEADM_VERSION}" && sudo apt-mark hold kubeadm

sudo kubeadm upgrade plan "v${KUBEADM_VERSION}"

sudo kubeadm upgrade apply "v${KUBEADM_VERSION}" --certificate-renewal=false --yes

sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y "kubelet=${KUBELET_VERSION}" "kubectl=${KUBECTL_VERSION}" && sudo apt-mark hold kubelet kubectl

sudo systemctl daemon-reload && sudo systemctl restart kubelet

kubectl uncordon "${NODE_NAME}"

# Check if the node is correctly updated
IS_UPDATED=$(kubectl get nodes "${NODE_NAME}" -o jsonpath='{.metadata.labels.node\.kubernetes\.io/kubelet-version}' | grep -q "${KUBELET_VERSION}"; echo $?)
if [ "${IS_UPDATED}" -eq 0 ]; then
  echo "Node ${NODE_NAME} successfully updated."
else
  echo "Failed to update node ${NODE_NAME}."
fi
