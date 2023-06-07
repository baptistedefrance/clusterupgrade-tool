The first thing to do is look at the version of the master node and upgrade it to the next version.

We have to update step by step on this version: 1.22, 1.23, 1.24, 1.25, and 1.26.

You can see the changelog of each version here: [Kubernetes Releases](https://kubernetes.io/releases/).

To do this, we will update `kubeadm` and `kubelets` with this script: `clusterupgrade.sh`.

We can verify if the update worked with the command: `kubectl get nodes`.

After doing this, we need to update each working node with this script: `workdernodesupgrade.sh`.

When we have updated a node, we must also update the tools associated with it.

After switching the cluster to a new version, here is a list of commands to perform to test its proper functioning:

- Use `kubectl get nodes` to display the status of all nodes in the cluster.
- Checking pods: Use the command `kubectl get pods --all-namespaces` to verify that all pods are running and in a healthy state.
- Testing services: Verify that Kubernetes services are working as expected. 
  - Use `kubectl get services --all-namespaces` to view all services and their states.
  - Try accessing the exposed services to make sure they are accessible and responding correctly.
- Running load tests: If you have specific workloads or predefined load tests, run them to verify cluster performance and stability.
  - This can include load testing, resiliency testing, or testing specific to your applications.
- Check logs: Check the logs of pods, nodes, and control plane components for any errors or warnings.
  - Logs can provide valuable insight into potential issues and root causes.


## Update Worker Node

```sh
# Upgrade node
sudo sh workernodesupgrade.sh <node-name> <version>

```

