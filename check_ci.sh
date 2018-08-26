#!/bin/bash

kubectl config set-credentials gke_core-autobuilds-poc_us-west1-b_sfci --username=${KUBE_USERNAME} --password=${KUBE_PASSWD} > /dev/null 2>&1

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts; > /dev/null 2>&1

/linux-amd64/helm init > /dev/null 2>&1

/linux-amd64/helm test ${CI_NAME} --cleanup --timeout 5 > /dev/null 2>&1

if [ $? -eq 1 ]
then
  exit 1
fi

export SERVICE_IP=$(kubectl get svc --namespace default ${CI_NAME}-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo http://$SERVICE_IP:8080/login
