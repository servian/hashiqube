#!/bin/bash

function nomad-install() {

  if pgrep -x "consul" >/dev/null
  then
    echo "Consul is running"
  else
    echo -e '\e[38;5;198m'"++++ Ensure Consul is running.."
    sudo bash /vagrant/hashicorp/consul.sh
  fi

  arch=$(lscpu | grep "Architecture" | awk '{print $NF}')
  if [[ $arch == x86_64* ]]; then
    ARCH="amd64"
  elif  [[ $arch == aarch64 ]]; then
    ARCH="arm64"
  fi
  echo -e '\e[38;5;198m'"CPU is $ARCH"

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
  http = "10.9.99.10"
  rpc  = "10.9.99.10"
  serf = "10.9.99.10:5648" # non-default ports may be specified
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled       = true
  # https://github.com/hashicorp/nomad/issues/1282
  network_speed = 100
  servers = ["10.9.99.10:4647"]
  #network_interface = "enp0s8"
  # https://www.nomadproject.io/docs/drivers/docker.html#volumes
  # https://github.com/hashicorp/nomad/issues/5562
  options = {
    "docker.volumes.enabled" = true
  }
  host_volume "waypoint" {
    path      = "/opt/nomad/data/volume/waypoint"
    read_only = false
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address = "10.9.99.10:8500"
}
EOF
  echo -e '\e[38;5;198m'"++++ Creating Waypoint host volume /opt/nomad/data/volume/waypoint"
  sudo mkdir -p /opt/nomad/data/volume/waypoint
  sudo chmod -R 777 /opt/nomad
  # check if nomad is installed, start and exit
  if [ -f /usr/local/bin/nomad ]; then
    echo -e '\e[38;5;198m'"++++ Nomad already installed at /usr/local/bin/nomad"
    echo -e '\e[38;5;198m'"++++ `/usr/local/bin/nomad version`"
    if [ -f /opt/cni/bin/bridge ]; then
      echo -e '\e[38;5;198m'"++++ cni-plugins already installed"
    else
      wget -q https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-$ARCH-v1.1.1.tgz -O /tmp/cni-plugins.tgz
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
    touch /var/log/nomad.log
    nohup nomad agent -config=/etc/nomad/server.conf -dev-connect > /var/log/nomad.log 2>&1 &
    sh -c 'sudo tail -f /var/log/nomad.log | { sed "/node registration complete/ q" && kill $$ ;}'
    nomad server members
    nomad node status
  else
  # if nomad is not installed, download and install
    echo -e '\e[38;5;198m'"++++ Nomad not installed, installing.."
    LATEST_URL=$(curl -sL https://releases.hashicorp.com/nomad/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep "linux.*$ARCH" | sort -V | tail -n1)
    wget -q $LATEST_URL -O /tmp/nomad.zip
    mkdir -p /usr/local/bin
    (cd /usr/local/bin && unzip /tmp/nomad.zip)
    echo -e '\e[38;5;198m'"++++ Installed `/usr/local/bin/nomad version`"
    wget -q https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-$ARCH-v1.1.1.tgz -O /tmp/cni-plugins.tgz
    mkdir -p /opt/cni/bin
    tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-arptables
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
    echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
    pkill nomad
    sleep 10
    pkill nomad
    pkill nomad
    touch /var/log/nomad.log
    
    nohup nomad agent -config=/etc/nomad/server.conf -dev-connect > /var/log/nomad.log 2>&1 &
    sh -c 'sudo tail -f /var/log/nomad.log | { sed "/node registration complete/ q" && kill $$ ;}'
    nomad server members
    nomad node status
  fi
  cd /vagrant/hashicorp/nomad/jobs;
  #nomad plan --address=http://localhost:4646 countdashboard.nomad
  #nomad run --address=http://localhost:4646 countdashboard.nomad
  #nomad plan --address=http://localhost:4646 countdashboardtest.nomad
  #nomad run --address=http://localhost:4646 countdashboardtest.nomad
  nomad plan --address=http://localhost:4646 fabio.nomad
  nomad run --address=http://localhost:4646 fabio.nomad
  nomad plan --address=http://localhost:4646 traefik.nomad
  nomad run --address=http://localhost:4646 traefik.nomad
  nomad plan --address=http://localhost:4646 traefik-whoami.nomad
  nomad run --address=http://localhost:4646 traefik-whoami.nomad
  # curl -v -H 'Host: fabio.service.consul' http://${VAGRANT_IP}:9999/
  echo -e '\e[38;5;198m'"++++ Nomad http://localhost:4646"
  echo -e '\e[38;5;198m'"++++ Nomad Documentation http://localhost:3333/#/hashicorp/README?id=nomad"
  echo -e '\e[38;5;198m'"++++ Fabio Dashboard http://localhost:9998"
  echo -e '\e[38;5;198m'"++++ Fabio Loadbalancer http://localhost:9998"
  echo -e '\e[38;5;198m'"++++ Fabio Documentation http://localhost:3333/#/hashicorp/README?id=fabio-load-balancer-for-nomad"
  echo -e '\e[38;5;198m'"++++ Treafik Dashboard http://localhost:8181"
  echo -e '\e[38;5;198m'"++++ Traefik Loadbalancer: http://localhost:8080"
  echo -e '\e[38;5;198m'"++++ Traefik Documentation: http://localhost:3333/#/hashicorp/README?id=traefik-load-balancer-for-nomad"
}

nomad-install
