#!/bin/bash

# Helm download
echo Installing Helm
HELM_FILE=helm-v2.9.1-linux-amd64.tar.gz
HELM_URL=https://storage.googleapis.com/kubernetes-helm/$HELM_FILE
wget $HELM_URL
tar zxfv $HELM_FILE
cp linux-amd64/helm .
rm $HELM_FILE
rm -r linux-amd64

# Assuming that we have Helm client installed locally, we initialize Heml client to work with the new service account, creating some folders locally
./helm init --service-account=tiller
./helm update
sleep 10
#./helm version
#until ./helm version | grep Server:; do 
#	sleep 10;
#done

# Installs Jenkins on the cluster with a Helm chart taken from
# https://github.com/helm/charts/tree/master/stable/jenkins (with the name "cd") that allows to configure Jenkins from the command line or via yaml file "jenkins-conf"
# We will use our own config file for Jenkins and
# Inside the Chart.yaml we can see the reference to https://github.com/jenkinsci/jenkins where the Jenkins image is hosted
echo Installing Jenkins
./helm install -n cd stable/jenkins -f jenkins-conf.yaml --version 0.25.0

# If you experience some credentials problems with the error message "Error: the server has asked for the client to provide credentials" try reinstalling tiller doing:
# ./reset.sh
until kubectl get pods -l app=cd-jenkins | grep Running; do 
	sleep 10;
	kubectl get deployment cd-jenkins
done

echo "Kubernetes installed on GKE cluster!"