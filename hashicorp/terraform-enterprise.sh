#!/bin/bash

# https://www.terraform.io/docs/enterprise/install/automating-the-installer.html
# curl -o terraform-enterprise-install.sh https://install.terraform.io/ptfe/stable
# bash ./install.sh \
#   no-proxy \
#   private-address=1.2.3.4 \
#   public-address=5.6.7.8

function terraform-enterprise-install() {

  service replicated stop
  service replicated-ui stop
  service replicated-operator stop
  docker stop replicated-premkit
  docker stop replicated-statsd
  docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd retraced-api retraced-processor retraced-cron retraced-nsqd retraced-postgres
  docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
  docker images | grep "registry\.replicated\.com/library/retraced" | awk '{print $3}' | xargs sudo docker rmi -f
  yes | sudo docker system prune -a
  yes | sudo docker system prune --volumes

  sudo chown -R vagrant:vagrant /home/vagrant

  # Vault demo cannot run when Terraform Ebterprise, since then you'd have to use this external Vault, out of scope of this demo
  # https://www.terraform.io/docs/enterprise/before-installing/vault.html
  pkill vault
  kill -9 $(ps aux | grep "/usr/local/bin/vault server" | tr -s " " | cut -d " " -f2)

  mkdir -p /etc/ptfe/config

  # set license file
  cp /vagrant/hashicorp/ptfe-license.rli /etc/ptfe/config/ptfe-license.rli

  # write /etc/replicated.conf file
  # license file located here /etc/ptfe/config/ptfe-license.rli
  cat <<EOF > /etc/replicated.conf
  {
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "password",
    "TlsBootstrapType":             "self-signed",
    "BypassPreflightChecks":        true,
    "ImportSettingsFrom":           "/etc/ptfe/config/ptfe-settings.json",
    "LicenseFileLocation":          "/etc/ptfe/config/ptfe-license.rli"
}
EOF
  # write /etc/ptfe/config/ptfe-settings.json file
  cat <<EOF > /etc/ptfe/config/ptfe-settings.json
  {
    "aws_access_key_id": {},
    "aws_instance_profile": {},
    "aws_secret_access_key": {},
    "azure_account_key": {},
    "azure_account_name": {},
    "azure_container": {},
    "azure_endpoint": {},
    "ca_certs": {},
    "capacity_concurrency": {},
    "capacity_memory": {},
    "custom_image_tag": {
        "value": "hashicorp/build-worker:now"
    },
    "disk_path": {},
    "extern_vault_addr": {},
    "extern_vault_enable": {},
    "extern_vault_path": {},
    "extern_vault_role_id": {},
    "extern_vault_secret_id": {},
    "extern_vault_token_renew": {},
    "extra_no_proxy": {},
    "gcs_bucket": {},
    "gcs_credentials": {},
    "gcs_project": {},
    "hostname": {
        "value": "localhost"
    },
    "installation_type": {
        "value": "poc"
    },
    "pg_dbname": {},
    "pg_extra_params": {},
    "pg_netloc": {},
    "pg_password": {},
    "pg_user": {},
    "placement": {},
    "production_type": {},
    "s3_bucket": {},
    "s3_endpoint": {},
    "s3_region": {},
    "s3_sse": {},
    "s3_sse_kms_key_id": {},
    "tbw_image": {
        "value": "default_image"
    },
    "vault_path": {},
    "vault_store_snapshot": {}
}
EOF

# We are running external vault on this vagrant
#https://www.terraform.io/docs/enterprise/before-installing/vault.html

# Install PTFE
curl -sL https://install.terraform.io/ptfe/stable > /tmp/install.sh

# set PROMPTs to yes
sed -i "s/^PROMPT_RESULT=/PROMPT_RESULT=y/g" /tmp/install.sh

echo -e '\e[38;5;198m'"++++ Starting Terraform Enterprise Install"
bash /tmp/install.sh no-proxy private-address=10.9.99.10 public-address=10.9.99.10 > /var/log/terraform-enterprise.log 2>&1 &
sh -c 'sudo tail -f /var/log/terraform-enterprise.log | { sed "/Operator installation successful/ q" && kill $$ ;}'
echo -e '\e[38;5;198m'"++++ Operator Installation successful, continueing.."
sh -c 'sudo docker logs replicated -f | { sed "/Service retraced is ready/ q" && kill $$ ;}'
echo -e '\e[38;5;198m'"++++ Service retraced is ready, all Components started"
echo -e '\e[38;5;198m'"++++ To finish the installation go to http://10.9.99.10:8800"
#systemctl daemon-reload
#systemctl restart docker

# Restart Replicated
# service replicated stop
# service replicated-ui stop
# service replicated-operator stop

# Remove Replicated
# service replicated stop
# service replicated-ui stop
# service replicated-operator stop
# docker stop replicated-premkit
# docker stop replicated-statsd
# docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd retraced-api retraced-processor retraced-cron retraced-nsqd retraced-postgres
# docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
# docker images | grep "registry\.replicated\.com/library/retraced" | awk '{print $3}' | xargs sudo docker rmi -f
# apt-get remove -y replicated replicated-ui replicated-operator
# apt-get purge -y replicated replicated-ui replicated-operator
# rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
}

terraform-enterprise-install
