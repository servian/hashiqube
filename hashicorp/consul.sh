#!/bin/bash
# https://www.nomadproject.io/guides/integrations/consul-connect/index.html

function consul-install() {
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
mkdir -p /etc/consul
mkdir -p /etc/consul.d
cat <<EOF | sudo tee /etc/consul/server.hcl
primary_datacenter = "dc1"
client_addr = "${VAGRANT_IP} 10.0.2.15"
bind_addr = "${VAGRANT_IP}"
advertise_addr = "${VAGRANT_IP}"
data_dir = "/var/lib/consul"
datacenter = "dc1"
disable_host_node_id = true
disable_update_check = true
leave_on_terminate = true
log_level = "INFO"
ports = {
  grpc  = 8502
  dns   = 8600
  https = -1
}
connect {
  enabled = true
}
enable_central_service_config = true
protocol = 3
raft_protocol = 3
recursors = [
  "8.8.8.8",
  "8.8.4.4",
]
server_name = "consul.service.consul"
ui = true
EOF
cat <<EOF | sudo tee /etc/consul.d/vault.json
  {"service":
  {"name": "vault",
  "tags": ["urlprefix-vault.service.consul/"],
  "address": "${VAGRANT_IP}",
  "port": 8200
  }}
EOF
cat <<EOF | sudo tee /etc/consul.d/docsify.json
  {"service":
  {"name": "docsify",
  "tags": ["urlprefix-docsify.service.consul/"],
  "address": "${VAGRANT_IP}",
  "port": 3333
  }}
EOF
# cat <<EOF | sudo tee /etc/consul.d/countdashtest.json
# {"service":
# {"name": "countdashtest",
# "tags": ["urlprefix-countdashtest.service.consul/ strip=/countdashtest"],
# "address": "10.9.99.10",
# "port": 9022
# }
# }
# EOF
# cat <<EOF | sudo tee /etc/consul.d/fabio.json
# {"service":
# {"name": "fabio",
# "tags": ["urlprefix-fabio.service.consul/"],
# "address": "10.9.99.10",
# "port": 9998
# }
# }
# EOF
  # check if consul is installed, start and exit
  if [ -f /usr/local/bin/consul ]; then
    echo -e '\e[38;5;198m'"++++ Consul already installed at /usr/local/bin/consul"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/consul version`"
    sudo pkill -9 consul
    sleep 5
    # die mofo!
    sudo pkill -9 consul
    sudo killall consul
    sudo killall consul
    sudo nohup consul agent -dev -client="0.0.0.0" -bind="0.0.0.0" -enable-script-checks -config-file=/etc/consul/server.hcl -config-dir=/etc/consul.d > /var/log/consul.log 2>&1 &
    sh -c 'sudo tail -f /var/log/consul.log | { sed "/agent: Synced/ q" && kill $$ ;}'
    consul join 10.9.99.10
    consul members
    consul info
  else
  # if consul is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Consul not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|ent|beta' | egrep 'linux.*amd64' | sort -V | tail -1)
    wget -q $LATEST_URL -O /tmp/consul.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/consul.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/consul version`"
    sudo nohup consul agent -dev -client="0.0.0.0" -bind="0.0.0.0" -enable-script-checks -config-file=/etc/consul/server.hcl -config-dir=/etc/consul.d > /var/log/consul.log 2>&1 &
    sh -c 'sudo tail -f /var/log/consul.log | { sed "/agent: Synced/ q" && kill $$ ;}'
    consul join 10.9.99.10
    consul members
    consul info
  fi
echo -e '\e[38;5;198m'"++++ Adding Consul KV data for Fabio Load Balancer Routes"
consul kv put fabio/config/vault1 "route add vault vault.service.consul:9999/ http://${VAGRANT_IP}:8200"
consul kv put fabio/config/vault2 "route add vault fabio.service.consul:9999/vault http://${VAGRANT_IP}:8200 opts \"strip=/vault\""
consul kv put fabio/config/nomad "route add nomad nomad.service.consul:9999/ http://${VAGRANT_IP}:4646"
consul kv put fabio/config/consul "route add consul consul.service.consul:9999/ http://${VAGRANT_IP}:8500"
consul kv put fabio/config/apache2 "route add apache2 fabio.service.consul:9999/apache2 http://${VAGRANT_IP}:8889 opts \"strip=/apache2\""
consul kv put fabio/config/countdashtest1 "route add countdashtest fabio.service.consul:9999/countdashtest http://${VAGRANT_IP}:9022/ opts \"strip=/countdashtest\""
consul kv put fabio/config/docsify "route add docsify docsify.service.consul:9999/ http://${VAGRANT_IP}:3333"
echo -e '\e[38;5;198m'"++++ Consul http://localhost:8500"
}

consul-install
