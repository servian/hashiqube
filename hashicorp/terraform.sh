#!/bin/bash

function terraform-install() {

  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
      ARCH="amd64"
  elif  [[ $arch == aarch64 ]]; then
      ARCH="arm64"
  fi
  echo -e '\e[38;5;198m'"CPU is $ARCH"
  
  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  if [ -f /usr/local/bin/terraform ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/terraform version` already installed at /usr/local/bin/terraform"
  else
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep "linux.*$ARCH" | sort -V | tail -n1)
    wget -q $LATEST_URL -O /tmp/terraform.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/terraform.zip)
    echo -e '\e[38;5;198m'"++++ Installed: `/usr/local/bin/terraform version`"
  fi
  pip3 install --upgrade awscli-local
  export PATH=$HOME/.local/bin:$PATH
  sudo rm -rf awscliv2.zip
  # https://aws.amazon.com/blogs/developer/aws-cli-v2-now-available-for-linux-arm/ aarch64
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "awscliv2.zip"
  sudo unzip -q awscliv2.zip
  yes | sudo ./aws/install --update
  echo -e '\e[38;5;198m'"++++ aws --version"
  aws --version

  # ensure localstack is running
  echo -e '\e[38;5;198m'"++++ To Terraform plan, and apply using Localstack, run the following command: vagrant up --provision-with localstack"
  echo -e '\e[38;5;198m'"++++ See Localstack folder for Terraform files"
}

terraform-install
