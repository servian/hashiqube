#!/bin/bash

function packer-install() {
  grep -q "PACKER_LOG=1" /etc/environment
  if [ $? -eq 1 ]; then
    echo "PACKER_LOG=1" >> /etc/environment
  else
    sudo sed 's/PACKER_LOG=.*/PACKER_LOG=1/g' /etc/environment
  fi
  grep -q "PACKER_LOG_PATH=/var/log/packer.log" /etc/environment
  if [ $? -eq 1 ]; then
    echo "PACKER_LOG_PATH=/var/log/packer.log" >> /etc/environment
  else
    sudo sed 's/PACKER_LOG_PATH=.*/PACKER_LOG_PATH=/var/log/packer.log/g' /etc/environment
  fi
  sudo touch /var/log/packer.log
  sudo chmod 777 /var/log/packer.log
  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
  if [ -f /usr/local/bin/packer ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/packer version` already installed at /usr/local/bin/packer"
  else
    LATEST_URL=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux_amd.*64" | sort -rh | head -1 | awk -F[\"] '{print $4}')
    wget -q $LATEST_URL -O /tmp/packer.zip
    sudo mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/packer.zip)

    echo -e '\e[38;5;198m'"++++ Installed: `/usr/local/bin/packer version`"
  fi
  echo -e '\e[38;5;198m'"++++ Install Ansible to configure Containers/VMs/AMIs/Whatever"
  sudo DEBIAN_FRONTEND=noninteractive apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip
  sudo pip3 install ansible
  if [ -f /usr/local/bin/ansible ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/ansible --version | head -n 1` already installed at /usr/local/bin/ansible"
  else
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip
    sudo pip3 install ansible
  fi
  echo -e '\e[38;5;198m'"++++ Install Docker so we can build Docker Images"
  # https://docs.docker.com/install/linux/docker-ce/ubuntu/
  if [ -f /usr/bin/docker ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/bin/docker -v` already installed at /usr/bin/docker"
  else
    sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo -i
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker vagrant
  fi
  echo -e '\e[38;5;198m'"++++ Packer build Linux Docker container configured with Ansible"
  packer build /vagrant/hashicorp/packer/linux/ubuntu/ubuntu16.04.json
}

packer-install
