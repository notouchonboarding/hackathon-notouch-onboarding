#!/bin/bash

kubectl config set-credentials gke_core-autobuilds-poc_us-west1-b_sfci --username=${KUBE_USERNAME} --password=${KUBE_PASSWD} > /dev/null 2>&1

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts; > /dev/null 2>&1

/linux-amd64/helm init > /dev/null 2>&1

if [ -z "$ImageName" ]
then
  ImageName = "notouchonboading/jenkins"
fi

if [ -z "$ImageTag" ]
then
  ImageTag = "latest"
fi

/linux-amd64/helm install --set-string Master.Image=${ImageName} --set-string Master.ImageTag=${ImageTag} --name ${CI_NAME} stable/jenkins > /dev/null 2>&1

#printf $(kubectl get secret --namespace default ${CI_NAME}-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
