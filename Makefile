upgrade.workernode:
		@kube/scripts/workernodesupgrade.sh

upgrade.masternode:
		@kube/scripts/upgradecluster.sh

upgrade.longhorn:
		@kube/scripts/longhornupdate.sh

upgrade.kubeprometheus:
		@kube/scripts/kubeprometheusupgrade.sh

upgrade.grafana:
		@kube/scripts/grafanaupgrade.sh

upgrade.argocd:
		@kube/scripts/argocdupgrade.sh
	
upgrade.sonarqube:
        @kube/scripts/sonarqubeupgrade.sh
        
