#!/bin/bash

# https://computingforgeeks.com/install-and-configure-vault-server-linux/
# https://www.vaultproject.io/

# Terraform Enterprise should not be running, creates conflict since it has it's own vault
ps aux | grep -q "replicated" | grep -v grep
if [ $? -eq 0 ]; then
  service replicated stop
  service replicated-ui stop
  service replicated-operator stop
  docker stop replicated-premkit
  docker stop replicated-statsd
  docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd retraced-api retraced-processor retraced-cron retraced-nsqd retraced-postgres
  docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
  docker images | grep "registry\.replicated\.com/library/retraced" | awk '{print $3}' | xargs sudo docker rmi -f
fi
# apt-get remove -y replicated replicated-ui replicated-operator
# apt-get purge -y replicated replicated-ui replicated-operator
# rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
# only do if vault is not found
if [ ! -f /usr/local/bin/vault ]; then

  echo -e '\e[38;5;198m'"++++ Vault not installed, installing.."

  LATEST_URL=$(curl -sL https://releases.hashicorp.com/vault/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|ent|beta' | egrep 'linux.*amd64' | sort -V | tail -n 1)
  wget -q $LATEST_URL -O /tmp/vault.zip

  mkdir -p /usr/local/bin
  (cd /usr/local/bin && unzip /tmp/vault.zip)
  echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/vault --version`"

  # enable command autocompletion
  vault -autocomplete-install
  complete -C /usr/local/bin/vault vault

  # create Vault data directories
  sudo mkdir /etc/vault
  sudo mkdir -p /var/lib/vault/data

  # create user named vault
  sudo useradd --system --home /etc/vault --shell /bin/false vault
  sudo chown -R vault:vault /etc/vault /var/lib/vault/

  # create a Vault service file at /etc/systemd/system/vault.service
  cat <<EOF | sudo tee /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.hcl

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
ExecReload=/bin/kill --signal HUP
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitBurst=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

  # create Vault /etc/vault/config.hcl file
  touch /etc/vault/config.hcl

  # add basic configuration settings for Vault to /etc/vault/config.hcl file
  cat <<EOF | sudo tee /etc/vault/config.hcl
disable_cache = true
disable_mlock = true
ui = true
listener "tcp" {
   address          = "0.0.0.0:8200"
   tls_disable      = 1
}
storage "file" {
   path  = "/var/lib/vault/data"
 }
# use consul as storage backend
#storage "consul" {
#  address = "127.0.0.1:8500"
#  path    = "vault"
#}
api_addr         = "http://0.0.0.0:8200"
max_lease_ttl         = "10h"
default_lease_ttl    = "10h"
cluster_name         = "vault"
raw_storage_endpoint     = true
disable_sealwrap     = true
disable_printable_check = true
EOF

  # start and enable vault service to start on system boot
  sudo systemctl daemon-reload
  sudo systemctl enable --now vault

  # check vault status
  sudo systemctl status vault

  # initialize vault server
  export VAULT_ADDR=http://127.0.0.1:8200
  echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bashrc

  # start initialization with the default options by running the command below
  sudo rm -rf /var/lib/vault/data/*
  sleep 20
  vault operator init > /etc/vault/init.file

  echo -e '\e[38;5;198m'"++++ Vault http://localhost:8200/ui and enter the following codes displayed below"
  echo -e '\e[38;5;198m'"++++ Auto unseal vault"
  for i in $(cat /etc/vault/init.file | grep Unseal | cut -d " " -f4 | head -n 3); do vault operator unseal $i; done
  vault status
  cat /etc/vault/init.file
  # add vault ENV variables
  VAULT_TOKEN=$(grep 'Initial Root Token' /etc/vault/init.file | cut -d ':' -f2 | tr -d ' ')
  grep -q "${VAULT_TOKEN}" /etc/environment
  if [ $? -eq 1 ]; then
    echo "VAULT_TOKEN=${VAULT_TOKEN}" >> /etc/environment
  else
    sed -i "s/VAULT_TOKEN=.*/VAULT_TOKEN=${VAULT_TOKEN}/g" /etc/environment
  fi
  grep -q "VAULT_ADDR=http://127.0.0.1:8200" /etc/environment
  if [ $? -eq 1 ]; then
    echo "VAULT_ADDR=http://127.0.0.1:8200" >> /etc/environment
  else
    sed -i "s/VAULT_ADDR=.*/VAULT_ADDR=http://127.0.0.1:8200/g" /etc/environment
  fi

else

  grep -q "VAULT_TOKEN=${VAULT_TOKEN}" /etc/environment
  if [ $? -eq 1 ]; then
    echo "VAULT_TOKEN=${VAULT_TOKEN}" >> /etc/environment
  else
    sed -i "s/VAULT_TOKEN=.*/VAULT_TOKEN=${VAULT_TOKEN}/g" /etc/environment
  fi
  grep -q "VAULT_ADDR=http://127.0.0.1:8200" /etc/environment
  if [ $? -eq 1 ]; then
    echo "VAULT_ADDR=http://127.0.0.1:8200" >> /etc/environment
  else
    sed -i "s/VAULT_ADDR=.*/VAULT_ADDR=http://127.0.0.1:8200/g" /etc/environment
  fi
  echo -e '\e[38;5;198m'"++++ Vault already installed and running"
  echo -e '\e[38;5;198m'"++++ Vault http://localhost:8200/ui and enter the following codes displayed below"
  # check vault status
  # vault status
  echo -e '\e[38;5;198m'"++++ Auto unseal vault"
  for i in `cat /etc/vault/init.file | grep Unseal | cut -d " " -f4 | head -n 3`; do vault operator unseal $i; done
  vault status
  cat /etc/vault/init.file
fi
# check vault status
# vault status

# replace “s.BOKlKvEAxyn5OS0LvfhzvBur” with your Initial Root Token stored in the /etc/vault/init.file file
# export VAULT_TOKEN="s.RcW0LuNIyCoTLWxrDPtUDkCw"

# enable approle authentication
# vault auth enable approle
# Success! Enabled approle auth method at: approle/

# same command can be used for other Authentication methods, e.g

# vault auth enable kubernetes
# Success! Enabled kubernetes auth method at: kubernetes/

# vault auth enable userpass
# Success! Enabled userpass auth method at: userpass/

# vault auth enable ldap
# Success! Enabled ldap auth method at: ldap/

# list all Authentication methods using the command
# vault auth list

# get secret engine path:
# vault secrets list

# write a secret to your kv secret engine.
# vault kv put secret/databases/db1 username=DBAdmin
# Success! Data written to: secret/databases/db1

# vault kv put secret/databases/db1 password=StrongPassword
# Success! Data written to: secret/databases/db1

# you can even use single line command to write multiple data.
# vault kv put secret/databases/db1 username=DBAdmin password=StrongPassword
# Success! Data written to: secret/databases/db1

# to get a secret, use vault get command.
# vault kv get secret/databases/db1

# get data in json format:
# vault kv get -format=json secret/databases/db1

# to print only the value of a given field, use:
# vault kv get -field=username  secret/databases/db1

# to delete a Secret, use:
# vault kv delete secret/databases/db1
# Success! Data deleted (if it existed) at: secret/databases/db1

# vault kv get   secret/databases/db1
# No value found at secret/databases/db1
