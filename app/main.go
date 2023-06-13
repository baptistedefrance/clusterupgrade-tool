package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)
func main() {
Menu()
}

func Menu() {
	choice := ""
	fmt.Println("Welcome to your cluster upgrade manager !")
	fmt.Println("What do you want to do ?")
	fmt.Println("1/ Upgrade Master node   2/ Upgrade Worker node")
	fmt.Scanln(&choice)
	if(choice == "1") {
		UpgradeMasterNode()
	} else if(choice == "2") {
		UpgradeWorkerNode()
	}
}

func UpgradeMasterNode() {
	node_name := ""
	kubeadm_version := ""
	kubelet_version := ""

	fmt.Println("What is the name of your Master node ?")
	fmt.Scanln(&node_name)
	fmt.Println("Wich version of kubeadm ?")
	fmt.Scanln(&kubeadm_version)
	fmt.Println("Which version of kubelet ?")
	fmt.Scanln(&kubelet_version)

	scriptPath := "/home/baptiste/Bureau/clusterupgrade-tool/scripts/clusterupgrade.sh"
	cmd := exec.Command("sh", scriptPath, node_name, kubeadm_version, kubelet_version)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		log.Fatalf("Failed to execute shell script: %s", err)
	}
}

func UpgradeWorkerNode() {
	node_name := ""
	kubeadm_version := ""
	fmt.Println("What is the name of your Worker node ?")
	fmt.Scanln(&node_name)
	fmt.Println("Wich version of kubeadm ?")
	fmt.Scanln(&kubeadm_version)
	scriptPath := "/home/baptiste/Bureau/clusterupgrade-tool/scripts/workernodesupgrade.sh"
	cmd := exec.Command("sh", scriptPath, node_name, kubeadm_version)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
}