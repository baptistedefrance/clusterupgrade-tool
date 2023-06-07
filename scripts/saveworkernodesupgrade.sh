#!/usr/bin/env bash
# Help with: https://devopssec.fr/article/update-clusters-kubernetes

# This script should be running on the Master node

# Use a loop or getopts to specify the nodes for upgrade

set -eu -o pipefail

while getopts ":n:" opt; do # add argument to choose node name
  case $opt in
    n) NODE_NAME="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "$NODE_NAME" ]; then
  echo "Node name not specified. Please use the -n option to specify the node."
  exit 1
fi

kubectl cordon "${NODE_NAME}"
kubectl drain "${NODE_NAME}" --ignore-daemonsets
ssh root@"${NODE_NAME}" "apt-get update && apt-get upgrade -y kubeadm=1.22.0-00 kubelet=1.22.0-00" # Change version here
kubeadm upgrade "${NODE_NAME}" config --kubelet-version v1.22.0 # Change version here
ssh root@"${NODE_NAME}" "systemctl restart kubelet"
kubectl uncordon "${NODE_NAME}"
kubectl get nodes # Look if the update worked
