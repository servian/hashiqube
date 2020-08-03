#!/bin/bash

function nomad-install() {
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl unzip jq
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
mkdir -p /etc/nomad
cat <<EOF | sudo tee /etc/nomad/server.conf
data_dir  = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

datacenter = "dc1"

advertise {
  # Defaults to the first private IP address.
  http = "${VAGRANT_IP}"
  rpc  = "${VAGRANT_IP}"
  serf = "${VAGRANT_IP}:5648" # non-default ports may be specified
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled       = true
  # https://github.com/hashicorp/nomad/issues/1282
  network_speed = 100
  servers = ["${VAGRANT_IP}:4647"]
  network_interface = "enp0s8"
  # https://www.nomadproject.io/docs/drivers/docker.html#volumes
  # https://github.com/hashicorp/nomad/issues/5562
  options = {
    "docker.volumes.enabled" = true
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address = "${VAGRANT_IP}:8500"
}
EOF
  # check if nomad is installed, start and exit
  if [ -f /usr/local/bin/nomad ]; then
    echo -e '\e[38;5;198m'"++++ Nomad already installed at /usr/local/bin/nomad"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/nomad version`"
    if [ -f /opt/cni/bin/bridge ]; then
      echo -e '\e[38;5;198m'"++++ cni-plugins already installed"
    else
      wget -q https://github.com/containernetworking/plugins/releases/download/v0.8.1/cni-plugins-linux-amd64-v0.8.1.tgz -O /tmp/cni-plugins.tgz
      mkdir -p /opt/cni/bin
      tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
      echo 1 > /proc/sys/net/bridge/bridge-nf-call-arptables
      echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
      echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
    fi
    pkill nomad
    sleep 10
    pkill nomad
    pkill nomad
    nohup nomad agent -config=/etc/nomad/server.conf -dev-connect > /var/log/nomad.log 2>&1 &
    sh -c 'sudo tail -f /var/log/nomad.log | { sed "/node registration complete/ q" && kill $$ ;}'
    nomad server members
    nomad node status
  else
  # if nomad is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Nomad not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/nomad/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' | sort -V | tail -n 1)
    wget -q $LATEST_URL -O /tmp/nomad.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/nomad.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/nomad version`"
    wget -q https://github.com/containernetworking/plugins/releases/download/v0.8.1/cni-plugins-linux-amd64-v0.8.1.tgz -O /tmp/cni-plugins.tgz
    mkdir -p /opt/cni/bin
    tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-arptables
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
    pkill nomad
    sleep 10
    pkill nomad
    pkill nomad
    nohup nomad agent -config=/etc/nomad/server.conf -dev-connect > /var/log/nomad.log 2>&1 &
    sh -c 'sudo tail -f /var/log/nomad.log | { sed "/node registration complete/ q" && kill $$ ;}'
    nomad server members
    nomad node status
  fi
cd /vagrant/hashicorp/nomad/jobs;
nomad plan --address=http://localhost:4646 countdashboard.nomad
nomad run --address=http://localhost:4646 countdashboard.nomad
nomad plan --address=http://localhost:4646 countdashboardtest.nomad
nomad run --address=http://localhost:4646 countdashboardtest.nomad
nomad plan --address=http://localhost:4646 fabio.nomad
nomad run --address=http://localhost:4646 fabio.nomad
# curl -v -H 'Host: fabio.service.consul' http://${VAGRANT_IP}:9999/
echo -e '\e[38;5;198m'"++++ Nomad http://localhost:4646"
}

nomad-install
