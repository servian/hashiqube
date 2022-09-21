#!/bin/bash

function terraform-install() {
  
  # ensure localstack is running
  # echo -e '\e[38;5;198m'"++++ Ensure Localstack is running.."
  # sudo bash /vagrant/localstack/localstack.sh

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
  sudo -i -u vagrant
  pip3 install --upgrade awscli-local
  rm awscliv2.zip
  # https://aws.amazon.com/blogs/developer/aws-cli-v2-now-available-for-linux-arm/ aarch64
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "awscliv2.zip"
  rm -rf aws
  unzip -q awscliv2.zip
  yes | sudo ./aws/install --update
  echo -e '\e[38;5;198m'"++++ aws --version"
  aws --version
  cd /vagrant/localstack/
  echo -e '\e[38;5;198m'"++++ terraform init.."
  terraform init
  echo -e '\e[38;5;198m'"++++ terraform fmt.."
  terraform fmt
  echo -e '\e[38;5;198m'"++++ terraform validate.."
  terraform validate
  echo -e '\e[38;5;198m'"++++ terraform destroy.."
  terraform destroy --auto-approve
  echo -e '\e[38;5;198m'"++++ terraform plan.."
  terraform plan
  echo -e '\e[38;5;198m'"++++ terraform apply.."
  terraform apply --auto-approve
  echo -e '\e[38;5;198m'"++++ awslocal s3 ls.."
  sudo -i -u vagrant
  cd /vagrant/localstack/
  export PATH=$HOME/.local/bin:$PATH
  awslocal s3 ls || true
}

terraform-install
