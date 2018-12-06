#!/bin/bash

# Locally, using Cloud Shell or via ssh running "gcloud alpha cloud-shell ssh"
gcloud config set compute/zone europe-west1-b

# Creation of dedicated VPC
gcloud compute networks create jenkins

# Cluster creation
 # storage-rw to access Google Container inside Google Cloud Storage
 # projecthosting to access Google Cloud Source Repositories
gcloud container clusters create jenkins-cd --network jenkins --machine-type n1-standard-2 --num-nodes 2 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw,cloud-platform"
# Auto-configure cluster correctly
gcloud container clusters get-credentials jenkins-cd

# Add our GCP account as cluster administrator through a new binding
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)

# Creation of a service account in the kube-system namespace
kubectl create -f serviceaccount.yaml
# Add the new service account for Tiller (the Helm server agent) to have the role of cluster admin
kubectl create -f rolebinding.yaml