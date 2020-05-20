#!/bin/zsh

getkubectl(){
  echo "get kubectl latest"
  KUBECTL_BIN=kubectl
  #K8SVERSION = 1.13.7 released 2019-06-11
  #curl -s -o /tmp/$KUBECTL_BIN https://storage.googleapis.com/kubernetes-release/release/$K8SVERSION/bin/linux/amd64/kubectl  
  curl -s -o /tmp/$KUBECTL_BIN https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
}

geteksctl(){
  echo "get eksctl latest"
  EKSCTL_BIN=eksctl
  curl -s --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
}

gethelm(){
  echo "get helm latest"
  HELM_BIN=helm
  #HELM_VERSION=v2.14.0
  #curl -s --location "https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz" | tar xz -C /tmp
  HELM_LATEST=$(curl -sSL https://github.com/kubernetes/helm/releases | sed -n '/Latest release<\/a>/,$p' | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  curl -s --location https://storage.googleapis.com/kubernetes-helm/helm-$HELM_LATEST-linux-amd64.tar.gz | tar xz -C /tmp
}

getiamauthenticator(){
  echo "get aws-iam-authenticator"
  AWS_IAM_AUTHENTICATOR_VERSION=https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
  curl -s -o /tmp/aws-iam-authenticator $AWS_IAM_AUTHENTICATOR_VERSION
}

getterraform(){
  echo "get terraform latest"
  #TF_VERSION=0.12.0
  #curl -s -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TFVERSION/terraform_"$TF_VERSION"_linux_amd64.zip
  TF_LATEST=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep 'terraform_[0-9]\.[0-9]{1,2}\.[0-9]{1,2}_linux.*amd64' | sort -V | tail -1)
  curl -s -o /tmp/terraform.zip $TF_LATEST
  unzip /tmp/terraform.zip -d /tmp/
}

main() {
  echo "=> Installing the tools!"
  getkubectl
  geteksctl
  gethelm
  getiamauthenticator
  getterraform
}

main
