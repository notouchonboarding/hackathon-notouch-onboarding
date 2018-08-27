#!/bin/bash

kubectl config set-credentials gke_core-autobuilds-poc_us-west1-b_sfci --username=${KUBE_USERNAME} --password=${KUBE_PASSWD} > /dev/null 2>&1

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts; > /dev/null 2>&1

/linux-amd64/helm init > /dev/null 2>&1

if [ -z "$ImageName" ]
then
  ImageName = "somashekar10/jenkins"
fi

if [ -z "$ImageTag" ]
then
  ImageTag = "latest"
fi

echo "
Master:
  Name: jenkins-master
  # Environment variables that get added to the init container (useful for e.g. http_proxy)
  ContainerEnv:
    - name: CLIENT_ID
      value: \"${CLIENT_ID}\"
    - name: CLIENT_SECRET
      value: \"${CLIENT_SECRET}\"
    - name: LB_IP
      value: \"${LB_IP}\"
    - name: GIT_ORG
      value: \"${GIT_ORG}\"
    - name: GIT_USER
      value: \"${GIT_USER}\"
    - name: GIT_TOKEN
      value: \"${GIT_TOKEN}\"
  ServiceType: LoadBalancer
  LoadBalancerIP: \"${LB_IP}\"
  InstallPlugins:
" > /tmp/values.yaml

/linux-amd64/helm install -f /tmp/values.yaml --set-string Master.Image=${ImageName} --set-string Master.ImageTag=${ImageTag} --name ${CI_NAME} stable/jenkins > /dev/null 2>&1

#printf $(kubectl get secret --namespace default ${CI_NAME}-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
