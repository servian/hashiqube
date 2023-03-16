#!/bin/bash

function packer-install() {

  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
  elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
  fi
  echo -e '\e[38;5;198m'"CPU is $ARCH"

  if pgrep -x "vault" >/dev/null
  then
    echo "Vault is running"
  else
    echo -e '\e[38;5;198m'"++++ Ensure Vault is running.."
    sudo bash /vagrant/hashicorp/vault.sh
  fi

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
    sudo sed 's/PACKER_LOG_PATH=.*/PACKER_LOG_PATH=\/var\/log\/packer.log/g' /etc/environment
  fi
  sudo touch /var/log/packer.log
  sudo chmod 777 /var/log/packer.log
  sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq python3-hvac
  if [ -f /usr/local/bin/packer ]; then
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/packer version` already installed at /usr/local/bin/packer"
  else
    LATEST_URL=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*$ARCH" | sort -rh | head -1 | awk -F[\"] '{print $4}')
    wget -q $LATEST_URL -O /tmp/packer.zip
    sudo mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/packer.zip)

    echo -e '\e[38;5;198m'"++++ Installed: `/usr/local/bin/packer version`"
  fi
  # Packer will build a Docker container, use the Shell and Ansible provisioners, Ansible will also connect to Vault to retrieve secrets using a Token.
  # https://learn.hashicorp.com/vault/getting-started/secrets-engines
  # https://docs.ansible.com/ansible/latest/plugins/lookup/hashi_vault.html
  # https://learn.hashicorp.com/vault/identity-access-management/iam-authentication
  echo -e '\e[38;5;198m'"++++ https://www.vaultproject.io/docs/auth/approle/"
  echo -e '\e[38;5;198m'"++++ Using the root Vault token, enable the AppRole auth method"
  echo -e '\e[38;5;198m'"++++ vault auth enable approle"
  vault auth enable approle
  echo -e '\e[38;5;198m'"++++ Using the root Vault token, Create an Ansible role"
  echo -e '\e[38;5;198m'"++++ Create an policy named ansible allowing Ansible to read secrets"
  tee ansible-vault-policy.hcl <<"EOF"
  # Read-only permission on 'kv/ansible*' path
  path "kv/ansible*" {
    capabilities = [ "read" ]
  }
EOF
  vault policy write ansible ansible-vault-policy.hcl
  echo -e '\e[38;5;198m'"++++ vault write auth/approle/role/ansible \
    secret_id_ttl=10h \\n
    token_policies=ansible \\n
    token_num_uses=100 \\n
    token_ttl=10h \\n
    token_max_ttl=10h \\n
    secret_id_num_uses=100"
  vault write auth/approle/role/ansible \
    secret_id_ttl=10h \
    token_policies=ansible \
    token_num_uses=100 \
    token_ttl=10h \
    token_max_ttl=10h \
    secret_id_num_uses=100
  echo -e '\e[38;5;198m'"++++ Fetch the RoleID of the Ansible's Role"
  echo -e '\e[38;5;198m'"++++ vault read auth/approle/role/ansible/role-id"
  vault read auth/approle/role/ansible/role-id
  echo -e '\e[38;5;198m'"++++ Using the root Vault token,Get a SecretID issued against the AppRole"
  echo -e '\e[38;5;198m'"++++ vault write -f auth/approle/role/ansible/secret-id"
  vault write -f auth/approle/role/ansible/secret-id
  echo -e '\e[38;5;198m'"++++ Fetch the Token that Ansible will use to lookup secrets"
  ANSIBLE_ROLE_ID=$(vault read auth/approle/role/ansible/role-id | grep role_id | tr -s ' ' | cut -d ' ' -f2)
  echo -e '\e[38;5;198m'"++++ ANSIBLE_ROLE_ID: ${ANSIBLE_ROLE_ID}"
  ANSIBLE_ROLE_SECRET_ID=$(vault write -f auth/approle/role/ansible/secret-id | grep secret_id | head -n 1 | tr -s ' ' | cut -d ' ' -f2)
  echo -e '\e[38;5;198m'"++++ ANSIBLE_ROLE_SECRET_ID: ${ANSIBLE_ROLE_SECRET_ID}"
  echo -e '\e[38;5;198m'"++++ vault write auth/approle/login role_id=\"${ANSIBLE_ROLE_ID}\" secret_id=\"${ANSIBLE_ROLE_ID}\""
  vault write auth/approle/login role_id="${ANSIBLE_ROLE_ID}" secret_id="${ANSIBLE_ROLE_SECRET_ID}"
  echo -e '\e[38;5;198m'"++++ Using the root Vault token, add a Secret in Vault which Ansible will retrieve"
  echo -e '\e[38;5;198m'"++++ vault secrets enable -path=kv kv"
  vault secrets enable -path=kv kv
  echo -e '\e[38;5;198m'"++++ Create a Secret that Ansible will have access too"
  echo -e '\e[38;5;198m'"++++ vault kv put kv/ansible devops=\"all the things\""
  vault kv put kv/ansible devops="all the things"
  ANSIBLE_TOKEN=$(vault write auth/approle/login role_id="${ANSIBLE_ROLE_ID}" secret_id="${ANSIBLE_ROLE_SECRET_ID}" | grep token | head -n1 | tr -s ' ' | cut -d ' ' -f2)
  echo -e '\e[38;5;198m'"++++ ANSIBLE_TOKEN: ${ANSIBLE_TOKEN}"
  # sed -i "s:token=[^ ]*:token=${ANSIBLE_TOKEN}:" /vagrant/hashicorp/packer/linux/ubuntu/playbook.yml
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
    sudo bash /vagrant/docker/docker.sh
  fi
  echo -e '\e[38;5;198m'"++++ Packer build Linux Docker container configured with Ansible"
  # packer build /vagrant/hashicorp/packer/linux/ubuntu/ubuntu-2204.hcl
  cd /vagrant/hashicorp/packer/
  ./run.sh
}

packer-install
