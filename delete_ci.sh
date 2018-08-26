#!/bin/bash

kubectl config set-credentials gke_core-autobuilds-poc_us-west1-b_sfci --username=${KUBE_USERNAME} --password=${KUBE_PASSWD} > /dev/null 2>&1

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts; > /dev/null 2>&1

/linux-amd64/helm init > /dev/null 2>&1

/linux-amd64/helm delete ${CI_NAME} > /dev/null 2>&1
