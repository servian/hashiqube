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

arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
fi
echo -e '\e[38;5;198m'"CPU is $ARCH"

# apt-get remove -y replicated replicated-ui replicated-operator
# apt-get purge -y replicated replicated-ui replicated-operator
# rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
# only do if vault is not found
if [ ! -f /usr/local/bin/vault ]; then
  
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Vault not installed, installing.."
  echo -e '\e[38;5;198m'"++++ "

  LATEST_URL=$(curl -sL https://releases.hashicorp.com/vault/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|ent|beta' | egrep "linux.*$ARCH" | sort -V | tail -n 1)
  wget -q $LATEST_URL -O /tmp/vault.zip

  mkdir -p /usr/local/bin
  (cd /usr/local/bin && unzip /tmp/vault.zip)
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/vault --version`"
  echo -e '\e[38;5;198m'"++++ "

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

  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Vault http://localhost:8200/ui and enter the following codes displayed below"
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Auto unseal vault"
  echo -e '\e[38;5;198m'"++++ "
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
    sed -i "s%VAULT_ADDR=.*%VAULT_ADDR=http://127.0.0.1:8200%g" /etc/environment
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
    sed -i "s%VAULT_ADDR=.*%VAULT_ADDR=http://127.0.0.1:8200%g" /etc/environment
  fi
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Vault already installed and running"
  echo -e '\e[38;5;198m'"++++ Vault http://localhost:8200/ui and enter the following codes displayed below"
  echo -e '\e[38;5;198m'"++++ "
  # check vault status
  # vault status
  echo -e '\e[38;5;198m'"++++ "
  echo -e '\e[38;5;198m'"++++ Auto unseal vault"
  echo -e '\e[38;5;198m'"++++ "
  for i in `cat /etc/vault/init.file | grep Unseal | cut -d " " -f4 | head -n 3`; do vault operator unseal $i; done
  vault status
  cat /etc/vault/init.file
  echo -e '\e[38;5;198m'"++++ Vault http://localhost:8200/ui and enter the Root Token displayed above"
  echo -e '\e[38;5;198m'"++++ Vault Documentation http://localhost:3333/#/hashicorp/README?id=vault"
fi

# TODO: FIXME
# https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates
# echo -e '\e[38;5;198m'"++++ Lets use Vault for Signed SSH Certificates"
# echo -e '\e[38;5;198m'"++++ vault secrets enable -path=ssh-client-signer ssh"
# vault secrets enable -path=ssh-client-signer ssh
# echo -e '\e[38;5;198m'"++++ vault write ssh-client-signer/config/ca generate_signing_key=true"
# vault write ssh-client-signer/config/ca generate_signing_key=true
# echo -e '\e[38;5;198m'"++++ vault read -field=public_key ssh-client-signer/config/ca > /etc/ssh/trusted-user-ca-keys.pem"
# vault read -field=public_key ssh-client-signer/config/ca | sudo tee /etc/ssh/trusted-user-ca-keys.pem
# echo -e '\e[38;5;198m'"++++ Add TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem to /etc/ssh/sshd_config and reload SSH"
# grep -q "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" /etc/ssh/sshd_config
# if [ $? -eq 1 ]; then
#   echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" | sudo tee -a /etc/ssh/sshd_config
# else
#   sudo sed -i "s/TrustedUserCAKeys \/etc\/ssh\/trusted-user-ca-keys.pe/TrustedUserCAKeys \/etc\/ssh\/trusted-user-ca-keys.pe/g" /etc/ssh/sshd_config
# fi
# sudo systemctl reload ssh
# echo -e '\e[38;5;198m'"++++ Create a named Vault role for signing client keys"
# vault write ssh-client-signer/roles/my-role -<<EOH
# {
#   "allow_user_certificates": true,
#   "allowed_users": "*",
#   "allowed_extensions": "permit-pty,permit-port-forwarding",
#   "default_extensions": [
#     {
#       "permit-pty": ""
#     }
#   ],
#   "key_type": "ca",
#   "default_user": "ubuntu",
#   "ttl": "30m0s"
# }
#EOH
# echo -e '\e[38;5;198m'"++++ Generate the SSH public key for user ubuntu"
# sudo -H -u ubuntu ssh-keygen -q -t rsa -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
# echo -e '\e[38;5;198m'"++++ Ask Vault to sign this created public key"
# echo -e '\e[38;5;198m'"++++ vault write ssh-client-signer/sign/my-role public_key=@/home/ubuntu/.ssh/id_rsa.pub"
# sudo -H -u ubuntu vault write ssh-client-signer/sign/my-role public_key=@/home/ubuntu/.ssh/id_rsa.pub
# sudo -H -u ubuntu vault write -field=signed_key ssh-client-signer/sign/my-role public_key=@/home/ubuntu/.ssh/id_rsa.pub | sudo -H -u ubuntu tee /home/ubuntu/.ssh/id_rsa-cert.pub
# echo -e '\e[38;5;198m'"++++ View enabled extensions, principals, and metadata of the signed key"
# echo -e '\e[38;5;198m'"++++ ssh-keygen -Lf /home/ubuntu/~/.ssh/id_rsa-cert.pub"
# sudo -H -u ubuntu ssh-keygen -Lf /home/ubuntu/.ssh/id_rsa-cert.pub
# sudo -H -u ubuntu ssh -v -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa-cert.pub -i /home/ubuntu/.ssh/id_rsa ubuntu@localhost || true
# echo $?

# https://www.vaultproject.io/docs/secrets/ssh/dynamic-ssh-keys
#sudo apt-get -y install pwgen
#sudo useradd -m -p $(openssl passwd -1 $(pwgen)) -s /bin/bash ubuntu
#echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
#vault secrets enable ssh
#sudo -H -u ubuntu vault write ssh/keys/vault_key key=@/home/ubuntu/.ssh/id_rsa
#vault write ssh/roles/dynamic_key_role key_type=dynamic key=vault_key admin_user=ubuntu default_user=ubuntu cidr_list=0.0.0.0/0

#echo -e '\e[38;5;198m'"++++ Please run the following on your local computer" 
#echo -e '\e[38;5;198m'"++++ export VAULT_TOKEN=$(grep 'Initial Root Token' /etc/vault/init.file | cut -d ':' -f2 | tr -d ' ')"
#echo -e '\e[38;5;198m'"++++ export VAULT_ADDR=http://10.9.99.10:8200"
#echo -e '\e[38;5;198m'"++++ vagrant ssh -c \"vault write ssh/creds/dynamic_key_role ip=10.9.99.10\""

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
