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
    sudo pkill consul
    sudo pkill consul
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

  echo -e '\e[38;5;198m'"++++ Install DNSMasq"
  sudo systemctl disable systemd-resolved
  sudo systemctl stop systemd-resolved
  sleep 10;
  sudo apt-get install -y dnsmasq
  echo -e '\e[38;5;198m'"++++ Adding DNSMasq config for Consul for DNS lookups"
  # https://learn.hashicorp.com/tutorials/consul/dns-forwarding#dnsmasq-setup
  cat <<EOF | sudo tee /etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/10.9.99.10#8600

# Uncomment and modify as appropriate to enable reverse DNS lookups for
# common netblocks found in RFC 1918, 5735, and 6598:
#rev-server=0.0.0.0/8,127.0.0.1#8600
#rev-server=10.0.0.0/8,127.0.0.1#8600
#rev-server=100.64.0.0/10,127.0.0.1#8600
#rev-server=127.0.0.1/8,127.0.0.1#8600
#rev-server=169.254.0.0/16,127.0.0.1#8600
#rev-server=172.16.0.0/12,127.0.0.1#8600
#rev-server=192.168.0.0/16,127.0.0.1#8600
#rev-server=224.0.0.0/4,127.0.0.1#8600
#rev-server=240.0.0.0/4,127.0.0.1#8600
EOF
  sudo systemctl restart dnsmasq

  echo -e '\e[38;5;198m'"++++ Set /etc/resolv.conf configuration"
  cat <<EOF | sudo tee /etc/resolv.conf
nameserver 10.9.99.10
nameserver 8.8.8.8
EOF

  echo -e '\e[38;5;198m'"++++ Consul http://localhost:8500"
  echo -e '\e[38;5;198m'"++++ Consul Documentation http://localhost:3333/#/hashicorp/README?id=consul"
}

consul-install
