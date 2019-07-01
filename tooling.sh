#!/bin/zsh

getkubectl (){
  echo "get kubectl latest"
  KUBECTL_BIN=kubectl
  #K8SVERSION=1.10.3
  #K8SVERSION=1.11.9
  #K8SVERSION=1.12.7
  #curl -s -o /tmp/$KUBECTL_BIN https://amazon-eks.s3-us-west-2.amazonaws.com/$K8SVERSION/2019-03-27/bin/linux/amd64/kubectl
  # K8SVERSION = 1.13.7 released 2019-06-11
  curl -s -o /tmp/$KUBECTL_BIN https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/kubectl
}

geteksctl(){
  echo "get eksctl latest"
  EKSCTL_BIN=eksctl
  curl -s --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
}

gethelm(){
  echo "get helm latest"
  HELM_BIN=helm
  HELM_LATEST=v2.14.0
  curl -s --location "https://storage.googleapis.com/kubernetes-helm/helm-$HELM_LATEST-linux-amd64.tar.gz" | tar xz -C /tmp
}

getiamauthenticator(){
  echo "get heptio authenticator"
  HEPTIO_AUTH=aws-iam-authenticator
  curl -s -o /tmp/$HEPTIO_AUTH https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
}

getterraform(){
  echo "get terraform latest"
  curl -s -o /tmp/terraform_0.12.0_linux_amd64.zip "https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip"
  unzip /tmp/terraform_0.12.0_linux_amd64.zip -d /tmp/
}

main() {
  getkubectl
  geteksctls
  gethelm
  getiamauthenticator
  getterraform
}