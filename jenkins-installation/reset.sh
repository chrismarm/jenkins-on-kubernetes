#ª/bin/bash

# Remove incomplete deployment, if exists
kubectl delete deployment cd-jenkins

# Remove Helm Tiller
rm -rf ~/.helm/
./helm delete --purge cd
./helm reset --force