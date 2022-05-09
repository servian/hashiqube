#!/bin/bash
# https://www.nomadproject.io/guides/integrations/consul-connect/index.html

function consul-install() {

arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
fi
echo -e '\e[38;5;198m'"CPU is $ARCH"

sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
mkdir -p /etc/consul
mkdir -p /etc/consul.d
cat <<EOF | sudo tee /etc/consul/server.hcl
primary_datacenter = "dc1"
client_addr = "10.9.99.10 10.0.2.15"
bind_addr = "10.9.99.10"
advertise_addr = "10.9.99.10"
data_dir = "/var/lib/consul"
datacenter = "dc1"
disable_host_node_id = true
disable_update_check = true
leave_on_terminate = true
log_level = "INFO"
# ports = {
#   grpc  = 8502
#   dns   = 8600
#   https = -1
# }
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
  "address": "10.9.99.10",
  "port": 8200
  }}
EOF
cat <<EOF | sudo tee /etc/consul.d/docsify.json
  {"service":
  {"name": "docsify",
  "tags": ["urlprefix-docsify.service.consul/"],
  "address": "10.9.99.10",
  "port": 3333
  }}
EOF
cat <<EOF | sudo tee /etc/consul.d/hashiqube.json
  {"service":
  {"name": "hashiqube0",
  "tags": ["urlprefix-hashiqube0.service.consul/"],
  "address": "10.9.99.10",
  "port": 22
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
    touch /var/log/consul.log
    sudo nohup consul agent -dev -client="0.0.0.0" -bind="0.0.0.0" -enable-script-checks -config-file=/etc/consul/server.hcl -config-dir=/etc/consul.d > /var/log/consul.log 2>&1 &
    sh -c 'sudo tail -f /var/log/consul.log | { sed "/agent: Synced/ q" && kill $$ ;}'
    consul members
    consul info
  else
  # if consul is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Consul not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|ent|beta' | egrep "linux.*$ARCH" | sort -V | tail -1)
    wget -q $LATEST_URL -O /tmp/consul.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/consul.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/consul version`"
    touch /var/log/consul.log
    sudo nohup consul agent -dev -client="0.0.0.0" -bind="0.0.0.0" -enable-script-checks -config-file=/etc/consul/server.hcl -config-dir=/etc/consul.d > /var/log/consul.log 2>&1 &
    sh -c 'sudo tail -f /var/log/consul.log | { sed "/agent: Synced/ q" && kill $$ ;}'
    consul members
    consul info
  fi
  echo -e '\e[38;5;198m'"++++ Adding Consul KV data for Fabio Load Balancer Routes"
  consul kv put fabio/config/vault1 "route add vault vault.service.consul:9999/ http://10.9.99.10:8200"
  consul kv put fabio/config/vault2 "route add vault fabio.service.consul:9999/vault http://10.9.99.10:8200 opts \"strip=/vault\""
  consul kv put fabio/config/nomad "route add nomad nomad.service.consul:9999/ http://10.9.99.10:4646"
  consul kv put fabio/config/consul "route add consul consul.service.consul:9999/ http://10.9.99.10:8500"
  consul kv put fabio/config/apache2 "route add apache2 fabio.service.consul:9999/apache2 http://10.9.99.10:8889 opts \"strip=/apache2\""
  consul kv put fabio/config/countdashtest1 "route add countdashtest fabio.service.consul:9999/countdashtest http://10.9.99.10:9022/ opts \"strip=/countdashtest\""
  consul kv put fabio/config/docsify "route add docsify docsify.service.consul:9999/ http://10.9.99.10:3333"

  echo -e '\e[38;5;198m'"++++ Adding Consul for DNS lookups"
  # https://learn.hashicorp.com/tutorials/consul/dns-forwarding#systemd-resolved-setup
  mkdir -p /etc/systemd/resolved.conf.d/
  cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/consul.conf
[Resolve]
DNS=127.0.0.1
DNSSEC=false
Domains=~consul
EOF
  
  iptables --table nat --append OUTPUT --destination localhost --protocol udp --match udp --dport 53 --jump REDIRECT --to-ports 8600
  iptables --table nat --append OUTPUT --destination localhost --protocol tcp --match tcp --dport 53 --jump REDIRECT --to-ports 8600
  iptables -vnL -t nat| grep 8600
  
  echo -e '\e[38;5;198m'"++++ Restart systemd-resolved"
  systemctl restart systemd-resolved

  echo -e '\e[38;5;198m'"++++ Validate the systemd-resolved configuration"
  cat <<EOF | sudo tee /etc/resolv.conf
nameserver 127.0.0.1
nameserver 8.8.8.8
EOF
  systemctl is-active systemd-resolved
  resolvectl domain
  resolvectl query consul.service.consul
  ls -l /etc/resolv.conf
  host consul.service.consul

  echo -e '\e[38;5;198m'"++++ Consul http://localhost:8500"
}

consul-install
