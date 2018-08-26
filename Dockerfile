FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-transport-https curl wget git
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz &&  tar -xvf helm-v2.10.0-linux-amd64.tar.gz

ADD kube_config /root/.kube/config
ADD create_ci.sh /root
ADD check_ci.sh /root
ADD delete_ci.sh /root
